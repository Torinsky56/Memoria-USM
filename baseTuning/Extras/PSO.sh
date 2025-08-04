#!/bin/bash

cnf_filename=$1
competition=$3
problem=$5
dimensions=$7
outfile=$8
seed=$9
shift 9


echo "Recibido instancia" ${cnf_filename} ${competition} ${problem} ${dimensions} ${outfile} ${seed}

salidatest=salida.txt
# Límite de evaluaciones
tSchedule=2
branching=4
particles=10
phi1=0.000
phi2=0.000
inertia=0.00
topology=0
modInfluence=0
populationCS=0
pIntitType=0
accelCoeffCS=0
omega1CS=0
omega2CS=2
omega3CS=1
DNPP=1
perturbation1=0
perturbation2=0
randomMatrix=1
evaluations=-3
iterations=-1
# Leer parámetros dinámicos desde la línea de comandos
while [ $# != 0 ]; do
    flag="$1"
    case "$flag" in
        -particles) if [ $# -gt 1 ]; then
                        arg="$2"
                        shift
                        particles=$arg
                    fi
                    ;;
        -phi1) if [ $# -gt 1 ]; then
                   arg="$2"
                   shift
                   phi1=$arg
               fi
               ;;
        -phi2) if [ $# -gt 1 ]; then
                   arg="$2"
                   shift
                   phi2=$arg
               fi
               ;;
        -inertia) if [ $# -gt 1 ]; then
                      arg="$2"
                      shift
                      inertia=$arg
                  fi
                  ;;
        -topology) if [ $# -gt 1 ]; then
                       arg="$2"
                       shift
                       topology=$arg
                   fi
                   ;;
        -modInfluence) if [ $# -gt 1 ]; then
                          arg="$2"
                          shift
                          modInfluence=$arg
                      fi
                      ;;
        *) echo "Unrecognized flag or argument: $flag"
           ;;
    esac
    shift
done

if [ -z "$particles" ] || [ -z "$phi1" ] || [ -z "$phi2" ] || [ -z "$inertia" ] || [ -z "$topology" ] || [ -z "$modInfluence" ]; then
    echo "Error: Parámetros faltantes. Verifique que todos los valores estén configurados." >&2
    exit 1
fi


# Archivo temporal
temp=$(mktemp)
echo "./ParticleSwarmOptimization/Release/ParticleSwarmOptimization \
    #--seed ${seed} \ --particles ${particles} --phi1 ${phi1} --phi2 ${phi2} --inertia ${inertia} --topology ${topology} --modInfluence ${modInfluence} --branching ${branching} --tSchedule ${tSchedule} --populationCS ${populationCS} --evaluations ${evaluations} --iterations ${iterations} --DNPP ${DNPP} --competition ${competition} --problem ${problem} --dimensions ${dimensions}"

./ParticleSwarmOptimization/Release/ParticleSwarmOptimization \
    --seed ${seed} \
    --particles ${particles} \
    --phi1 ${phi1} \
    --phi2 ${phi2} \
    --inertia ${inertia} \
    --topology ${topology} \
    --modInfluence ${modInfluence} \
    --branching ${branching} \
    --tSchedule ${tSchedule} \
    --populationCS ${populationCS} \
    --evaluations ${evaluations} \
    --iterations ${iterations} \
    --DNPP ${DNPP} \
    --competition ${competition} \
    --problem ${problem} \
    --noLogs \
    --quiet \
    --dimensions ${dimensions} > ${temp}

    # Verificar que el archivo temporal se generó correctamente
    if [ ! -s ${temp} ]; then
        echo "Error: No se generó salida en el archivo temporal." >&2
        exit 1
    fi

    # Procesar la salida del archivo temporal
    evals=$(grep "Best" ${temp} | awk '{print $2}')

    if [ -z "${evals}" ]; then
        echo "Error: No se encontró 'Best' en la salida." >&2
        cat "${temp}" >&2
        exit 1
    fi
    # Convertir notación científica a decimal usando awk
    evals_decimal=$(echo "$evals" | awk '{printf "%.15f\n", $1}')

    # Verificar si evals_decimal es igual a 0
    if (( $(echo "$evals_decimal == 0" | bc -l) )); then
        echo "Problema da 0.00, aplicando penalizacion de 5000"
        evals="50000.00"
    fi


    echo ${evals} > ${outfile}
    echo ${particles} ${topology} ${modInfluence} ${phi1} ${phi2} ${inertia} ${evals} >> ${salidatest} 

# done


# Limpieza
rm -f ${temp}

echo "Ejecución completada. Resultados guardados en ${outfile}."
