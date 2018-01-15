"""
Get miss percentage by developers
"""
import csv
# import sys

CHANGE_METRICSES = [
    "chunk_id",
    "new_line",
    "space",
    "upper_lower",
    "alphabet",
    "number",
    "symbol",
    "comment",
    "string",
    "cls_self",
    "isnot"]

CHANGE_METRICSES_NUM = [i + "_num" for i in CHANGE_METRICSES]

def main():
    """
    Main method
    """
    developers = {}

    with open("result.csv", "r") as csv_file:
        chunks = csv.DictReader(csv_file)
        with open("developers.csv", "w") as out_csv_file:
            writer = csv.DictWriter(out_csv_file,
                                    chunks.fieldnames
                                    + CHANGE_METRICSES
                                    + CHANGE_METRICSES_NUM
                                    + ["exp"])
            writer.writeheader()

            for chunk in chunks:
                ch_author_account_id = chunk["ch_author_account_id"]

                if ch_author_account_id in developers:
                    developer = developers[ch_author_account_id]
                else:
                    developer = make_new_developer()

                developer["exp"] += 1
                for change in CHANGE_METRICSES:
                    if chunk[change] == "True":
                        developer[change + "_num"] += 1

                developers[ch_author_account_id] = developer
                # sys.stdout.write("\rChunks: %d / %d" % (i, chunks_num))

                chunk.update(developer)
                writer.writerow(chunk)

def make_new_developer():
    """
    Make initial developer state
    """
    developer = {}
    developer["exp"] = 0
    for change_metrics in CHANGE_METRICSES_NUM:
        developer[change_metrics] = 0
    return developer

if __name__ == '__main__':
    main()
