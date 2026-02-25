TaDaaM Internship - Improving I/O performances of the HPC Application Gysela
-----------------------

## 1. Project Overview

This repository contains the work carried out during my research internship at the University of Bordeaux, in the TaDaaM team, from February 2026 to July 2026, focused on improving the I/O performance of the HPC application Gysela.

The main objective of this internship is to analyse, benchmark, and improve the I/O performance during the checkpointing phase of the Gysela application, which is crucial for long-running simulations to save their state and recover from potential failures.

The work includes: 
- Profiling the I/O performance of Gysela to identify bottlenecks.
- Benchmark campaigns on HPC Clusters:
    - Plafrim
- Exploration of different I/O strategies (MPI-IO, HDF5, PDI, striping strategies, toto, etc.)

Gysela is a global gyrokinetic semi-Lagrangian code used for plasma turbulence simulations in fusion research. The application is computationally intensive and generates large amounts of data, making efficient I/O performance critical for its usability and scalability on HPC systems.

## 2. Internship Context

This work is conducted as part of my Master's degree in Computer Science, with a focus on High-Performance Computing (HPC). The internship is supervised by Dr. Francieli Zanon-Boito, a researcher in the TaDaaM team and teacher at the University of Bordeaux;  Meline Trochon, PhD student in DataDirect Networks and Luan Teyla, researcher in the TaDaaM team. TaDaaM (Tools and Algorithms for Data-Intensive Applications in Memory) is a research team that focuses on developing tools and algorithms to optimize data management and processing in memory, particularly in the context of HPC applications.

- Internship duration: 6 months (February 2026 - July 2026)
- Research field: Exacale computing, I/O optimization
- Project : Exa-Dost (part of the NumPex project)
- HPC Environment: Plafrim, a national HPC cluster in France, provided by GENCI (Grand Equipement National de Calcul Intensif), which offers high-performance computing resources for research purposes.

## 3. Technical Environment

### Programming Languages:
- C++
- Yaml
- Python

### Libraries & Technologies:
- MPI & MPI-IO
- HDF5
- Parallel I/O
- BeegFS
- PDI
- Slurm
- Git
- IOPS
- TOTO
- Darshan

### Analysis Tools: 
- Darshan
- IOPS
- Custom profiling scripts

## 4. Repository Structure

The repository is organized as follows: 

- `README.md`: This file provides an overview of the internship project, including the context, objectives, and technical environment.
- `Experiment<X>_<Details>/`: Each experiment conducted during the internship is documented in a separate directory, containing: 
    - `results/`: Contains the raw data and visualizations generated from the experiment.
    - `<tool>_confs/`: Contains the configuration files used for the experiment, such as pdi, gys_io, etc.
    - `index.html`: A report summarizing the experiment, used for the github pages site.
    - `diverses files`: Any additional files relevant to the experiment, such as scripts, logs, etc.
- `index.html`: The main page for the GitHub Pages site, providing an overview of the internship and links to the individual experiment reports.

## 5. Methodology

The workflow generally follows these steps for each experiment: 

1. Target a specific aspect or strategy for the I/O test.
2. Configure the environment and the necessaray tools for the experiment.
3. Run benchmark campaigns with controlled variables to isolate the impact of the targeted aspect.
4. Collect raw data and generate visualizations to analyze the results.
5. Analyze the results to identify performance bottlenecks and potential improvements.
6. Compare configurations and identify optimal settings for the I/O performance of Gysela.

## 6. Results (Work in Progress)

This section will be updated progressively.

Current investigations include:
- Impact of stripe count on write performance with BeegFS.

Preliminary observations :
- Increasing the stripe count can improve write performance up to a certain point, after which it may lead to diminishing returns or even performance degradation due to increased overhead and contention.
- The actual usage of the bandwidth can be significantly upgraded, since actually the average bandwidth usage is around 3GB/s, while the theoretical maximum is around 6GB/s. This suggest that there is still room for improvement in the I/O performance of Gysela, and that optimizing the stripe count could be a key factor in achieving better performance.

## 7. How to reproduce Experiments

Each experiment directory contains the necessary configuration files and scripts to reproduce the results. 
To reproduce an experiment, follow these steps:
1. Clone the repository and navigate to the desired experiment directory.
2. Review the configuration files in the `<tool>_confs/` directory to understand the settings used for the experiment.
3. Use the provided scripts to set up the environment and run the benchmarks on the HPC cluster.
4. Collect the results and compare them with the original results in the `results/` directory to verify the reproduction.

## 8. Contact


<p align="center">
  <img src="https://avatars.githubusercontent.com/AlexLoup33" 
       width="140" 
       style="border-radius: 50%;" 
       alt="Alexandre L-P"/>
</p>

<p align="center">
  <strong>Alexandre L-P</strong><br>
  Master's Student – High Performance Computing<br>
  I/O Performance Optimization – Gysela
</p>

<p align="center">
  <a href="https://github.com/AlexLoup33" target="_blank">
    <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white"/>
  </a>
  <a href="https://www.linkedin.com/in/alexandre-lp/" target="_blank">
    <img src="https://img.shields.io/badge/LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white"/>
  </a>
  <a href="mailto:alexandre.lou-poueyou@inria.fr" target="_blank">
    <img src="https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white"/>
  </a>
</p>