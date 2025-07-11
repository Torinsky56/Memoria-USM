import os, re


confile='/conf-AK.config'
nameFile='/Salida'
nameEnd='/FinSalida'
DirConf='Configs'
NumConf=20

Nevals=1000
Tmin=0.01
flag = False
count = 0
dirs=[]
npars=9

def Pop_Finder(file):
    global flag
    for line in file:
        if flag == True:
            count = count+1
            if "------------------------------------------------------------------------" in line:
                pass
            else:
                if "-----------------AGREGANDO NUEVAS CALiBRACIONES ------------------------" in line:
                    pass
                else:
                    if "--------------Conjunto 1 ("+str(NumConf)+")-----------------------" in line:
                        pass
                    else:
                        yield line
            
            if count > 24:
                flag = False
        if "ITERACION" in line:
            yield line
            flag = True
            count = 0
        if "-->Van " in line:
            yield line



for f in os.listdir('.'):
    if re.match('Ev', f):
        dirs.append(f)


if not os.path.exists(DirConf):
    os.makedirs(DirConf)

for directory in dirs:
    filepath = directory+confile
    #Number of decimals per parameter - Used to divide each read value from Salida
    with open(filepath) as fp:
        lines = fp.readlines()
        dec = []
        i = 0
        j = npars + 1
        for line in lines:
            line = line.split(' ')
            if line:
                if i == 0 or i >= j:
                    i = i + 1
                else:
                    dec.append(int(line[3]))
                    i = i + 1
    path = directory+nameFile
    pathEnd=directory+nameEnd
    os.system('tail -n 100 ' + path + ' > ' +pathEnd)
    source = open(pathEnd,'r')
    Values=[]
    print(path)
    #print(dec)

    PathConfigFile=DirConf+"/"+directory+".par"
    ar = open(PathConfigFile,"w")


    for line in Pop_Finder(source):
        if "-->Van " in line:
            mylist = line.split(" ")
            x = (float(mylist[1]))
        #destiny.writelines(str(line))
        else:
            if "(" in line:
                mylist = line.split(" ")
                print(mylist)
                i = 2
                for den in dec: #hay algo raro en Evoca que divide todo por 100 (valor final en conf)
                        if den > 1:
                            val = (float(mylist[i])/100)
                        else:
                            val = (int(mylist[i]))
                        Values.append(val)
                        i = i+1
                print(Values)
                ar.write(str(Values[4]) + " " + str(Nevals) + " " + str(Values[0]) + " " + str(Values[1]) + " " + str(Values[3]) + " " + str(Tmin) + " " + str(Values[2])+"\n")
                Values=[]
    ar.close()
