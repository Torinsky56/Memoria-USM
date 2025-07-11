#!/bin/bash

toTune=$1
seed=$2

nSeeds=5
maxM=20
maxEvaluations=5000
maxTime=0
minimize=1
candidatesFile=candidatas.config
algo=SPSO11

logFile=EVOCA.log
outFile=EVOCA.params

respaldos=respaldos${algo}
mkdir ${respaldos}

#maxSeeds=1
for set in ${toTune} ; do
        echo "entre"
	#crear archivo scenario y archivo parametros
        params=conf-PSO.config
        instance=${set}
        for name in $(cat ${instance}) ; do
                nomb=${name}
                echo "${name}"
        done

	echo "${instance}"
        cp ${instance} .

	#while [ ${seed} -lt ${maxSeeds} ]; do
                outputTuner=EVOCA_${algo}_${nomb}_S${seed}.out
                echo "outputTuner=EVOCA_${algo}_${instance}_S${seed}.out"
                echo "time ./EVOCA PSO.sh ${params} ${instance} ${seed} ${nSeeds} ${maxM} ${maxEvaluations} ${maxTime} ${minimize} ${candidatesFile}> ${outputTuner}"
                time ./EVOCA PSO.sh ${params} ${instance} ${seed} ${nSeeds} ${maxM} ${maxEvaluations} ${maxTime} ${minimize} ${candidatesFile}> ${outputTuner}
                echo "mv ${logFile} ${respaldos}/${logFile}_${algo}_${instance}_S${seed}"
                mv ${logFile} ${respaldos}/${logFile}_${algo}_${nomb}_S${seed}
                echo "mv ${outFile} ${respaldos}/${outFile}_${algo}_${instance}_S${seed}"
                mv ${outFile} ${respaldos}/${outFile}_${algo}_${nomb}_S${seed}
		tar -cvzf ${outputTuner}.tar.gz ${outputTuner}
		rm -rf ${outputTuner}

		#seed=$[$seed+1]
	#done
        mv ${instance} ${respaldos}
done

