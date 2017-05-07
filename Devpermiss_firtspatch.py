import csv


kinds = ["NewLine", "If", "Comment", "L_SpaceOrTab", 
         "L_UpperOrLower", "L_Symbol", "L_Renamed", "Moved", "Test", "RenameFile"]

fieldnames = ["PullNo","patchNo","Date","CHANGED_CONTENTS","SpaceOrTab",
              "NewLine","UpperOrLower","Symbol","Renamed",
              "CHANGED_LINES","If","Comment","Moved",
              "CHANGED_FILES","Test","Fig","BinaryDoc","RenameFile",
              "IsInserted","IsDeleted","VCS","FewChange",
              "L_SpaceOrTab","L_UpperOrLower","L_Symbol","L_Renamed","L_OtherPer","OtherPer","devId", "exp"]

fieldnames = ["PullNo", "exp", "devId", "Date"]
fieldnames = ["PullNo", "Date"]
fieldnames.extend(kinds)

with open('csv/newdiffs.csv', "r") as diff_file:
    pulls = csv.DictReader(diff_file)
    with open('csv/devs3f.csv', "wb") as devfile:
        developers = {}
        writer = csv.DictWriter(devfile, fieldnames)
        writer.writeheader()
        patchs = []
        kinds_flag = {}
        outpull = {}
        for i, pull in enumerate(pulls):
            patchNo =int(pull["PatchNo"]) 
            if  patchNo == 1:
                if i > 1:
                    # outpull.update(developers[dev_id])
                    outpull.update(kinds_flag)
                    writer.writerow(outpull)

                dev_id = pull["devId"]
                outpull = {}
                kinds_flag = {}
                outpull["Date"] = pull["Date"]
                outpull["PullNo"] = int(pull["PullNo"])
                if dev_id in developers:
                    developers[dev_id]["exp"] += 1
                    for kind in kinds:
                        if float(pull[kind]) > 0:
                            developers[dev_id][kind] += 1
                            kinds_flag[kind] = 1
                        else:
                            kinds_flag[kind] = 0 
                else:
                    developers[dev_id] = {}
                    developers[dev_id]["devId"] = dev_id
                    developers[dev_id]["exp"] = 1
                    for kind in kinds:
                        if float(pull[kind]) > 0:
                            developers[dev_id][kind] = 1
                            kinds_flag[kind] = 1
                        else:
                            developers[dev_id][kind] = 0
                            kinds_flag[kind] = 0
                
            