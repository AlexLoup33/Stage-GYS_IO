# Experiment 2: BeeGFS Stripe Count Study with IOPS on another target folder

This experiment uses [IOPS](https://iops.gitlabpages.inria.fr/) to benchmark `gys_io` (the I/O mini-app of Gysela) across different BeeGFS stripe counts (1 to 8). Each stripe count maps to a dedicated PDI configuration file (`pdi_sc1.yaml` ... `pdi_sc8.yaml`).

The main difference with Experiment 1 is that the writing folder set in the PDI configuration files are different (`/beegfs/aloupoue/ost_<stripe_count>`), due to the fact that my BeeGFS workspace was not initially configured with dedicated subfolders for each stripe count (and chunk size) when Experiment 1 was conducted.

This experiment was performed after observing significantly lower performance results compared to those obtained in Experiment 1. As a consequence, a new batch of experiments was launched and a comparaison between BeeGFS folder config as be done but there is no difference.

A third Experiment will be launched with 16 pdi config files who target both mine's and Luan's in a same collective batch to check if there is a real difference or a coincidence.

## Installing IOPS

```bash
pip install iops-benchmark
```

Some features require optional dependencies:

```bash
pip install iops-benchmark[watch]      # iops find --watch (rich)
pip install iops-benchmark[bayesian]   # Bayesian optimization (scikit-optimize)
pip install iops-benchmark[plots]      # Plot export to PDF/PNG (kaleido)
pip install iops-benchmark[parquet]    # Parquet output format (pyarrow)
```

Or install everything at once:

```bash
pip install iops-benchmark[watch,bayesian,plots,parquet]
```

For other installation methods (Spack, offline, from source), see the [Installation Guide](https://iops.gitlabpages.inria.fr/getting-started/installation/).

## IOPS Configuration Overview

The benchmark is defined in `iops_config.yaml`. Below is a breakdown of each section. For full details, see the [YAML Schema Reference](https://iops.gitlabpages.inria.fr/user-guide/yaml-schema/).

> **Important:** YAML is indentation-sensitive. Use **spaces only** (no tabs) and keep consistent indentation (2 spaces recommended). A misplaced space will cause parsing errors.

### `benchmark`

```yaml
benchmark:
  name: "Gys_io Benchmark - Stripe Count Study"
  workdir: "/beegfs/aloupoue/iops_runs"
  repetitions: 5
  search_method: "exhaustive"
  executor: "slurm"
  cache_file: "/beegfs/aloupoue/iops_cache.db"
```

Global settings: working directory for execution artifacts, number of repetitions per configuration, search strategy (`exhaustive` tests all combinations), execution backend (`slurm` submits jobs via SBATCH), and an optional SQLite cache file to avoid re-running identical configurations.

### `benchmark.probes` (Resource Tracing)

```yaml
benchmark:
  probes:
    resource_sampling: true
    sampling_interval: 1
```

Enables CPU and memory monitoring during benchmark execution. A lightweight background sampler reads `/proc/stat` and `/proc/meminfo` at the configured interval (in seconds). For multi-node SLURM jobs, samplers are automatically launched on all nodes.

Each node produces a trace file (`__iops_trace_<hostname>.csv`) with per-sample CPU and memory data. IOPS aggregates these into `__iops_resource_summary.csv` with metrics like peak memory, average CPU usage, and load imbalance across cores.

> **Note:** For I/O-sensitive benchmarks, consider running a baseline without tracing first, as the sampler introduces a small I/O overhead (one CSV row per sample per node). See [Resource Tracing](https://iops.gitlabpages.inria.fr/user-guide/resource-tracing/).

### `vars`

```yaml
vars:
  sc_suffix:
    type: int
    sweep:
      mode: list
      values: [1, 2, 3, 4, 5, 6, 7, 8]

  pdi_config:
    type: str
    expr: "pdi_sc{{ sc_suffix }}.yaml"
```

Defines the parameter space. `sc_suffix` is a **swept variable** that takes each value in the list. `pdi_config` is a **derived variable** built with a Jinja2 expression. Fixed values like `nodes: 8` are constant across all runs. See [Templating and Context](https://iops.gitlabpages.inria.fr/user-guide/templating-and-context/) for the full template syntax.

### `command`

```yaml
command:
  template: "gys_io gys_io.yaml {{ pdi_config }}"
```

The benchmark command template. Jinja2 placeholders are replaced with variable values for each configuration point.

### `scripts`

```yaml
scripts:
  - name: "gys_io benchmark"
    script_template: |
      #!/bin/bash
      #SBATCH --nodes=8
      #SBATCH --ntasks-per-node=8
      ...
      srun -n $SLURM_NTASKS {{ command.template }}
    parser:
      file: "{{ execution_dir }}/slurm.out"
      parser_script: |
        def parse(file_path):
          ...
          return {"time_write": ..., "time_total": ..., "bandwidth": ...}
```

Contains the SLURM job script and a Python **parser** that extracts metrics from the output. The parser must define a `parse(file_path)` function returning a dict of metric names to values. See [Writing Parsers](https://iops.gitlabpages.inria.fr/user-guide/writing-parsers/).

### `output`

```yaml
output:
  sink:
    type: csv
    path: "{{ workdir }}/results_gys_io_bora.csv"
```

Where results are stored. Supported formats: `csv`, `parquet`, `sqlite`.

## Running the Benchmark

```bash
iops run iops_config.yaml
```

Use `--dry-run` to validate the configuration without submitting jobs:

```bash
iops run iops_config.yaml --dry-run
```

See the [CLI Reference](https://iops.gitlabpages.inria.fr/user-guide/cli/) for all available options.

## Workdir Structure

After running a benchmark, IOPS organizes results in a hierarchical directory structure inside the `workdir`:

```
iops_runs/
└── run_001/
    ├── __iops_run_metadata.json      # Full benchmark metadata (config, timing, variables)
    ├── __iops_index.json             # Index of all executions (used by iops find)
    ├── __iops_resource_summary.csv   # Aggregated CPU/memory metrics (if probes enabled)
    ├── exec_0001/                    # One directory per parameter combination
    │   ├── __iops_params.json        # Parameter values for this execution
    │   ├── repetition_1/
    │   │   ├── __iops_status.json    # Status (SUCCEEDED/FAILED/...) and parsed metrics
    │   │   ├── __iops_sysinfo.json   # Hardware/environment info (CPU, memory, OS)
    │   │   ├── stdout, stderr        # Script output
    │   │   ├── parser_stdout         # Parser script output
    │   │   └── __iops_trace_*.csv    # Per-node resource traces (if probes enabled)
    │   └── repetition_2/
    │       └── ...
    ├── exec_0002/
    │   └── ...
    └── ...
```

- **Run level** (`run_XXX/`): one per `iops run` invocation. Contains global metadata and the execution index.
- **Execution level** (`exec_XXXX/`): one per parameter combination. Stores the parameter snapshot.
- **Repetition level** (`repetition_X/`): one per repetition. Contains the actual output, status, and traces.

The `__iops_run_metadata.json` file is required for report generation. The `__iops_index.json` enables fast filtering with `iops find`. See [Metadata Files](https://iops.gitlabpages.inria.fr/user-guide/metadata-files/) for details.

## Useful IOPS Features

### Monitoring with `iops find --watch`

Monitor running benchmarks in real time with a live table, progress bar, and keyboard navigation. Requires the `watch` optional dependency (`pip install iops-benchmark[watch]`).

```bash
iops find /beegfs/aloupoue/iops_runs/run_001 --watch
```

See [Exploring Executions](https://iops.gitlabpages.inria.fr/user-guide/exploring-executions/).

### Archiving Results

Create portable compressed archives of a benchmark run for sharing or backup:

```bash
iops archive create /beegfs/aloupoue/iops_runs/run_001
```

See [Archiving Workdirs](https://iops.gitlabpages.inria.fr/user-guide/exploring-executions/#archiving-workdirs).

### Result Caching

When `cache_file` is set, IOPS stores results in a SQLite database. Re-running the same configuration skips already-cached executions. Use `--use-cache` to enable and `--cache-only` to only retrieve cached results without running anything new:

```bash
iops run iops_config.yaml --use-cache
```

See [Result Caching](https://iops.gitlabpages.inria.fr/user-guide/caching/).

### Reports and Visualization

Generate interactive HTML reports with charts (scatter, bar, heatmaps, parallel coordinates, etc.):

```bash
iops report /beegfs/aloupoue/iops_runs/run_001
```

Reports can also be generated automatically after each run by adding a `reporting` section to the YAML config. To export plots as images, install the `plots` optional dependency (`pip install iops-benchmark[plots]`). See [Custom Reports & Visualization](https://iops.gitlabpages.inria.fr/user-guide/reporting/).

### Machine Overrides

Use a single configuration file across different clusters or environments. Define per-machine overrides in the `machines` section and select at runtime:

```bash
iops run iops_config.yaml --machine plafrim
```

This is useful for running the same benchmark on different HPC systems (e.g., PlaFRIM vs local BeeGFS) without duplicating the configuration. See [Machine Overrides](https://iops.gitlabpages.inria.fr/user-guide/machines/).

### Bayesian Optimization

For large parameter spaces, switch from `exhaustive` to `bayesian` search to find optimal configurations with fewer evaluations. IOPS builds a surrogate model and focuses on the most promising regions. Requires the `bayesian` optional dependency (`pip install iops-benchmark[bayesian]`).

```yaml
benchmark:
  search_method: "bayesian"
```

See [Bayesian Optimization](https://iops.gitlabpages.inria.fr/user-guide/bayesian-optimization/).

### Regression Testing Across Commits

IOPS can be used to compare performance between code versions. A typical workflow:

1. Run the benchmark on the reference commit and cache the results.
2. Switch to the new commit/branch and re-run the same configuration.
3. Compare the output CSV/reports side by side.

Combined with `machines` overrides and CI integration, this enables automated performance regression testing when new features are added to Gysela.
