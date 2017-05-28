"""
Get missper miss exp
"""
import csv


KINDS = ["NewLine", "If", "Comment", "L_SpaceOrTab",
         "L_UpperOrLower", "L_Symbol", "L_Renamed", "Moved", "RenameFile", "Test"]

MISSES = [(x + ".miss") for x in KINDS]

FIELD_NAMES = ["PullNo", "exp", "devId", "Date", "project"]
# FIELD_NAMES = ["PullNo", "Date"]

FIELD_NAMES.extend(MISSES)
FIELD_NAMES.extend(KINDS)

with open('csv/devs22.csv', "r") as diff_file:
    with open('csv/miss.csv', "w") as outfile:
        writer = csv.DictWriter(outfile, FIELD_NAMES)
        writer.writeheader()  

        PULLS = csv.DictReader(diff_file)
        DEVELOPERS = {}
        for i, pull in enumerate(PULLS):
            devId = int(pull["devId"])
            developer = pull

            if devId not in DEVELOPERS:
                DEVELOPERS[devId] = developer
                for kind in KINDS:
                    developer[kind + ".miss"] =  1 if int(developer[kind]) > 0 else 0
            else:
                for kind in KINDS:
                    developer[kind + ".miss"] =  1 if int(developer[kind]) > int(DEVELOPERS[devId][kind]) else 0
            writer.writerow(developer)
            DEVELOPERS[devId] = developer
