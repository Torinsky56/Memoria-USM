#!/bin/bash

# Define el nombre del archivo final que contendrá la unión de todos los logs
archivoFinal="all_hyb_3_50.out"

# Elimina el archivo final si ya existe
[ -f "$archivoFinal" ] && rm "$archivoFinal"

# Recorre las carpetas baseTuning_S0 a baseTuning_S9
for i in {0..9}; do
    carpetaActual="./baseTuninghyb_SF_TRAIN_ALL_HYB_50_3_S$i/respaldosSPSO11"
    logFile="$carpetaActual/EVOCA.log_SPSO11_train_ALL_hyb.inst_S$i"

    # Verifica si el archivo existe
    if [ -f "$logFile" ]; then
        echo "Procesando archivo: $logFile"

        # Usa el número de seed (i) como prefijo en cada línea y procesa solo configuración y valor
        while IFS= read -r linea; do
            # Usar patrones específicos para leer partes necesarias
            configuracion=$(echo "$linea" | grep -oP '(?<=\().*(?=\) [0-9eE.+-]+$)') # Extraer configuración
            valor=$(echo "$linea" | grep -oP '[0-9eE.+-]+$')                        # Extraer valor

            # Escribe en el archivo final solo si ambas partes se extraen correctamente
            if [[ -n $configuracion && -n $valor ]]; then
                echo "$i ($configuracion) $valor" >> "$archivoFinal"
            fi
        done < "$logFile"

        echo "Archivo completado: $(basename "$logFile")"
    else
        echo "Archivo no encontrado: $logFile"
    fi
done

echo "Unión completada. Archivo final: $archivoFinal"

