import csv


kinds = ["NewLine", "If", "Comment", "L_SpaceOrTab", 
         "L_UpperOrLower", "L_Symbol", "L_Renamed"]

fieldnames = ["PullNo","PatchNo","Date","CHANGED_CONTENTS","SpaceOrTab",
              "NewLine","UpperOrLower","Symbol","Renamed",
              "CHANGED_LINES","If","Comment","Moved",
              "CHANGED_FILES","Test","Fig","BinaryDoc","RenameFile",
              "IsInserted","IsDeleted","VCS","FewChange",
              "L_SpaceOrTab","L_UpperOrLower","L_Symbol","L_Renamed","L_OtherPer","OtherPer","devId", "exp"]

with open('newdiffs.csv', "r") as diff_file:
    patchs = csv.DictReader(diff_file)
    with open('devs.csv', "wb") as devfile:
        developers = {}
        writer = csv.DictWriter(devfile, fieldnames)
        writer.writeheader()
        for patch in patchs:
            dev_id = patch["devId"]
            if int(patch["CHANGED_LINES"]) == 0:
                continue


            if dev_id in developers:
                developers[dev_id]["exp"] += 1
                for kind in kinds:
                    if int(patch[kind]) > 0:
                        developers[dev_id][kind] += 1
            else:
                developers[dev_id] = {}
                developers[dev_id]["exp"] = 1
                for kind in kinds:
                    developers[dev_id][kind] = 1 if int(patch[kind]) > 0 else 0

            patch.update(developers[dev_id])
            writer.writerow(patch)