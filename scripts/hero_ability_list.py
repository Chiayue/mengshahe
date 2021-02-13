import sys
import os
def kv2table(filename,newfilename):
    
    fo = open(filename,'r',encoding="utf-8")
    mainKey = "CustomHeroAbilityList"
    startList = False;
    strList = [];
    temp = {};
    key = "";
    for line in fo.readlines():
        lines = line.split()
        if lines:
            #print(lines[0])
            if lines[0] == '"override_hero"':
                if lines[1] == '"npc_dota_hero_crystal_maiden"':
                    continue
                if key != "":
                    strList.append(key+" = "+"{"+temp[key]+"}")
                key = "["+lines[1]+"]"
                temp = {}
            if lines[0] == '"Ability1"':
                val = lines[1]
                if temp != {}:
                    temp[key] = temp[key] + "["+lines[0]+"]" + "=" + val + ","
                else:
                    temp[key] = "["+lines[0]+"]" + "=" + val + ","
            if lines[0] == '"AttributeBaseIntelligence"':
                val = lines[1]
                if temp != {}:
                    temp[key] = temp[key] + "["+lines[0]+"]" + "=" + val + ","
                else:
                    temp[key] = "["+lines[0]+"]" + "=" + val + ","
            if lines[0] == '"AttributeBaseAgility"':
                val = lines[1]
                if temp != {}:
                    temp[key] = temp[key] + "["+lines[0]+"]" + "=" + val + ","
                else:
                    temp[key] = "["+lines[0]+"]" + "=" + val + ","
            if lines[0] == '"AttributeBaseStrength"':
                val = lines[1]
                if temp != {}:
                    temp[key] = temp[key] + "["+lines[0]+"]" + "=" + val + ","
                else:
                    temp[key] = "["+lines[0]+"]" + "=" + val + ","
        # if startList == True and lines[0] == "}":
            # startList == False;
            # break
        # if line[0:1] == "/" or len(line[0:2]) < 2:
            # continue
        # if len(mainKey) == 0 and (line[0:1] == '"' or line[0:1] == "'"):
            # mainKey = line.replace("\n","")
            # continue
        
        # if startList == False and lines[0] == "{":
            # startList = True;
            # continue
        # if startList == True:
            # strList.append(lines[0])
            # continue
    strList.append(key+" = "+"{"+temp[key]+"},")
    newStr = mainKey.replace('"',"") +" = { \n  " + ",\n  ".join(strList) +" \n}"
    fo.close()
    fo = open(newfilename,"w+")
    fo.write(newStr)
    fo.close()
if __name__ == "__main__":
    current_dir = os.path.abspath(os.path.dirname(__file__))
    f1 = current_dir+"/npc/npc_heroes_custom.txt"
    f2 = current_dir+"/vscripts/heroabilitylist.lua"
    kv2table(f1,f2)