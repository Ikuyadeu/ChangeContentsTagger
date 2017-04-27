import csv

readers = []
filelist = ["diff.csv", "diff2.csv", "diff3.csv", "diff4.csv", "diff5.csv"]
# filelist = ["diff.csv", "diff2.csv"]
for filename in filelist:
    with open(filename) as csvfile:
        reader = list(csv.DictReader(csvfile))
        readers = readers + reader
PullNos = set([int(x['PullNo']) for x in readers])
ALL = len(PullNos)
print ALL, max(PullNos)
