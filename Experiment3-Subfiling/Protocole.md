<h1>Rapport Subfiling</h1>
Dernière mise à jour: 20/03/26
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

#### HDF5
HDF5 - Version 1.14.3

```bash
cmake ..
```