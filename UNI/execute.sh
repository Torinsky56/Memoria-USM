l#/bin/bash

seed=$1
baseDir="baseTuning"
newDir="${baseDir}_SF_TRAIN_ALL_UNI_10_3_SEx${seed}"

# Copiar el directorio base
echo "Copiando ${baseDir} a ${newDir}..."
rsync -a ${baseDir}/ ${newDir}/ || { echo "Error al copiar ${baseDir}"; exit 1; }

# Cambiar al nuevo directorio
cd ${newDir} || { echo "Error al cambiar al directorio ${newDir}"; exit 1; }

# Ejecutar el script
echo "Ejecutando toDoEVOCA.sh con seed ${seed}..."
nohup bash toDoEVOCA.sh Scenario1 ${seed} > OUT &
echo "Proceso lanzado en segundo plano."
