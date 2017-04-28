# Fri, 13 May 2011 17:41:02 +0200
import datetime
import csv

# diff = pd.read_csv("diff.csv")
# diff['Date'] = [x for x in diff]

# date_str = "Fri, 13 May 2011 17:41:02 +0200"
# naive_date_str, _, offset_str = date_str.rpartition(' ')
# print datetime.datetime.strptime("Fri, 13 May 2011 17:41:02 +0200"[0:16], "%a, %d %b %Y %H:%M:%S")
with open("diff.csv", "r") as diff:
    with open("date.csv", "w") as outdate: 
        reader = csv.DictReader(diff)
        outdate.write("Date\n")
        for row in reader:
            naive_date_str, _, offset_str = row['Date'].rpartition(' ')
            if naive_date_str:
                Cdate = datetime.datetime.strptime(naive_date_str, "%a, %d %b %Y %H:%M:%S").strftime("%Y-%m-%d")
                outdate.write(Cdate)
            else:
                outdate.write(Cdate)
            outdate.write("\n")
            # print ndate