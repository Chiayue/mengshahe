import sys
import os
def kv2table(filename,newfilename):
    
    fo = open(filename,'r')
    mainKey = ""
    startList = False;
    strList = [];
    for line in fo.readlines():
        lines = line.split()
        if startList == True and lines[0] == "}":
            startList == False;
            break
        if line[0:1] == "/" or len(line[0:2]) < 2:
            continue
        if len(mainKey) == 0 and (line[0:1] == '"' or line[0:1] == "'"):
            mainKey = line.replace("\n","")
            continue
        
        if startList == False and lines[0] == "{":
            startList = True;
            continue
        if startList == True:
            if lines[0] != '"npc_dota_hero_crystal_maiden"':
                strList.append(lines[0])
            continue
        
   
    newStr = mainKey.replace('"',"") +" = { \n  " + ",\n  ".join(strList) +" \n}"
    fo.close()
    fo = open(newfilename,"w+")
    fo.write(newStr)
    fo.close()
if __name__ == "__main__":
    current_dir = os.path.abspath(os.path.dirname(__file__))
    f1 = current_dir+"/npc/herolist.txt"
    f2 = current_dir+"/vscripts/herolist.lua"
    kv2table(f1,f2)