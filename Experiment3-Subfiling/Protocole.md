<h1>Rapport Subfiling</h1>
Dernière mise à jour: 27/03/26
<hr/>

Page de suivi des expérimentations 

### Contexte
- Application: Gysela
- Environnement: Plafrim
- Outils clés: PDI, HDF5

### Objectif
Le but de cet expérimentation est de compiler Gysela avec une nouvelle version de PDI, comprenant maintenant le support du subfiling via HDF5.

### Approche
Pour y parvenir, le but est de compiler gysela à partir du commit `c79d7448e6eaac01a57686cc7d31ab956a790e29` de PDI comprennant le subfiling.
Toutes les dépendances ont été compilées à la main.

Pour la compilation de PDI, la compilation pré-requise de HDF5 avec le flag `ENABLE_SUBFILING=ON` est nécessaire pour que cela fonctionne sur Gysela.

### Modules chargés

Les modules proviennent de ModulesFiles, ceux ci se chargent via la commande `module load <type/module/version>`

gcc : 15.1.0 </br>
cmake : 3.27.0 </br>
python : 3.10 </br>
openmpi : 5.0.1 </br>
openblas : 0.3.9 </br>
lapacke : 3.9.1 </br>

### Dépendances

Les dépendances nécessaires et choisient pour la compilation de Gysela sont : 

#### Variable d'environnement

export PREFIX=$HOME/gysela-deps/install

export PATH=$PREFIX/bin:$PATH
export LD_LIBRARY_PATH=$PREFIX/lib:$PREFIX/lib64:$LD_LIBRARY_PATH

#### ZLIB
Zlib : Version 1.3.1

```bash
./configure --prefix=$PREFIX
make -j $(nproc)
make install
```

#### SZIP
Szip : Version 2.1.1

```bash
./configure --prefix=$PREFIX
make -j $(nproc)
make install
```

#### HDF5
HDF5 - Version 1.14.3

```bash
CC=mpicc ./configure \
  --prefix=$PREFIX \
  --enable-parallel \
  --enable-shared \
  --enable-build-mode=production \
  --with-zlib=$PREFIX \
  --with-szlib=$PREFIX \
  --enable-subfiling-vfd

make -j $(nproc)
make install
```

! ATTENTION ! Verifiez que le flag `SUBFILING VDF` soit à `YES` en exécutant : 
`h5pcc -showconfig | grep Subfiling`

#### NetCDF
NetCDF : Version 4.9.1

```bash
CC=mpicc \
CPPFLAGS="-I$PREFIX/include" \
LDFLAGS="-L$PREFIX/lib" \
./configure \
  --prefix=$PREFIX \
  --enable-netcdf-4 \
  --enable-shared \
  --disable-dap \
  --disable-byterange

make -j $(nproc)
make install
```

#### Paraconf
Paraconf est une dépendance de PDI et doit être compilé avant de ce fait.

```bash
mkdir build && cd build

cmake .. \
    -DCMAKE_INSTALL_PREFIX=~/gysela-deps/install \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_TESTING=OFF

make -j $(nproc)
make install
```

#### PDI
PDI - commit : c79d7448e6eaac01a57686cc7d31ab956a790e29

```bash
mkdir build && cd build

cmake .. \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DHDF5_ROOT=$PREFIX \
  -DCMAKE_PREFIX_PATH=$PREFIX

make -j $(nproc)
make install
```

#### Kokkos
Kokkos : Version 4.7.02

```bash
mkdir build && cd build

cmake .. \
  -DCMAKE_INSTALL_PREFIX=$HOME/gysela-deps/install \
  -DKokkos_ENABLE_SERIAL=ON \
  -DKokkos_ENABLE_OPENMP=ON \
  -DKokkos_ENABLE_CUDA=OFF \
  -DCMAKE_BUILD_TYPE=Release

make -j $(nproc)
make install
```

#### Kokkos-Kernel
Kokkos-Kernel : Version 4.5.01

```bash
mkdir build && cd build

cmake .. \
  -DCMAKE_INSTALL_PREFIX=$HOME/gysela-deps/install \
  -DKokkos_DIR=$HOME/gysela-deps/install/lib64/cmake/Kokkos \
  -DKokkosKernels_ENABLE_TESTS=OFF \
  -DKokkosKernels_ENABLE_EXAMPLES=OFF \
  -DKokkosKernels_ENABLE_SERIAL=ON \
  -DKokkosKernels_ENABLE_OPENMP=ON \
  -DCMAKE_BUILD_TYPE=Release

make -j $(nproc)
make install
```

#### Ginkgo
Ginkgo : Version 

```bash
mkdir -p build && cd build

cmake .. \
  -DCMAKE_INSTALL_PREFIX=$HOME/gysela-deps/install \
  -DGINKGO_BUILD_TESTS=OFF \
  -DGINKGO_BUILD_BENCHMARKS=OFF \
  -DGINKGO_BUILD_EXAMPLES=OFF \
  -DGINKGO_BUILD_REFERENCE=ON \
  -DGINKGO_BUILD_CPU=ON \
  -DGINKGO_BUILD_CUDA=OFF \
  -DCMAKE_BUILD_TYPE=Release

make -j $(nproc) install
```

#### Lapacke
Lapacke : Version 3.11

```bash
mkdir build && cd build

cmake .. \
  -DCMAKE_INSTALL_PREFIX=$HOME/gysela-deps/install \
  -DCMAKE_PREFIX_PATH=$HOME/gysela-deps/install \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=$(which gcc) \
  -DCMAKE_CXX_COMPILER=$(which g++)

make -j $(nproc)
make install
```

### Gysela

Compilation: 

```bash
mkdir -p build && cd build

cmake .. \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_PREFIX_PATH="$PREFIX" \
  -DCMAKE_C_COMPILER=mpicc \
  -DCMAKE_CXX_COMPILER=mpicxx \

make -j $(nproc)
```

Exécution : 
```bash
salloc -n 64 -C bora --exclusive

srun -n 64 -C bora --exclusive ~/gysela-mini-app_io/build/apps/gys_io /beegfs/aloupoue/gys_io.yaml /beegfs/aloupoue/pdi_scX.yaml
```



A faire : 

- Finir compil Gysela au propre (en passant par Bora pour la compil)
- Exp subfiling (avec stripe size en multiple de 4MB)
- Tester sur OST_8
- Lancer TOTO avec subfiling pour vérifier la variable d'aggregateur.


- Demander accès à Adastra / Irène
-> faire reset la machine par la DSI