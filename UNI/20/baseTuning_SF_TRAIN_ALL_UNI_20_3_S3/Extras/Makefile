MaxM=10
MaxEval=5000
semilla=23
flags=-Wno-deprecated -O3 -g -ggdb
prog=EVOCA
comp=g++
archivo_configuracion=conf-PSO.config
directorio=instancias
ejecutable=PSO.sh
NSeeds=5
MaxTime=0
Min=0 #1=minimizar, 0=maximizar
#180119
archivo_candidatas=candidatas.config

$(prog): main.o globales.o
	$(comp) globales.o main.o -o $(prog) $(flags)
	
globales.o: globales.cpp includes.h globales.h 
	$(comp) -c globales.cpp $(flags)	
	
main.o: main.cpp includes.h globales.h 
	$(comp) -c main.cpp $(flags)

clean:
	rm -f *~
	rm -f *.o
	rm -f *.conv

exe:$(prog)
	time ./$(prog) $(ejecutable) $(archivo_configuracion) $(directorio) $(semilla) $(NSeeds) $(MaxM) $(MaxEval) $(MaxTime) $(Min) $(archivo_candidatas)
