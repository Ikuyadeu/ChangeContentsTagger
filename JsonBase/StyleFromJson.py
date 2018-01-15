"""
Get Style missing from diff file
Style misses list
* Rename identifier
* Large to Small (ex:"Style" to "style")
* only make new line
* Space or Tab
* Don't changed AST
"""
import csv
import os
import re
import sys
import json
# import time
# from collections import OrderedDict


OUT_METRICSES = ["ch_id",
                 "ch_change_id",
                 "ch_author_account_id",
                 "rev_id",
                 "rev_change_id",
                 "f_file_name",
                 "rev_patchSetNum"]


def main():
    """
    The main
    """

    jsondir_path = """/Users/yuki-ud/Documents/Source/GitHub/CollectReviewData/revision_files/gm_openstack2/"""
    # jsondir_path = """/Users/yuki-ud/Documents/Source/dev-growth/json/gm_openstack/"""
    if len(sys.argv) > 3:
        min_pull_no = int(sys.argv[1])
        max_pull_no = int(sys.argv[2])
        in_csv_path = sys.argv[3]
    else:
        print("""Usage: python %s max_pull_no min_pull_no in_csv_path""" % sys.argv[0])
        sys.exit()

    with open(in_csv_path, "r") as in_csv_file:
        reader = csv.DictReader(in_csv_file)
        # reader = [i for i in reader if int(i["rev_change_id"]) in range(min_pull_no, max_pull_no)]

        with open("result.csv", "w") as out_csv_file:
            writer = csv.DictWriter(out_csv_file, OUT_METRICSES + CHANGE_METRICSES, lineterminator="\n")
            writer.writeheader()

            for i, line in enumerate(reader, start=1):
                if i >= min_pull_no:
                    break

            for i, line in enumerate(reader, start=min_pull_no):
                if i > max_pull_no:
                    break

                json_path = jsondir_path + line["rev_id"] + "/" + line["f_file_name"] + ".json"
                if not os.path.isfile(json_path):
                    continue
                with open(json_path, "r") as target:
                    sys.stdout.write("\rChange: %d / %d: %s" % (i, max_pull_no, json_path))
                    try:
                        data = json.load(target)
                    except json.decoder.JSONDecodeError:
                        continue

                    if data["change_type"] != "MODIFIED":
                        continue
                    content = data["content"]
                    if any([("skip" in i) for i in content]):
                        continue
                    content = [(i["a"], i["b"]) for i in content if "a" in i and "b" in i]

                out_metricses = {}
                for metric in OUT_METRICSES:
                    out_metricses[metric] = line[metric]

                for (j, (content_a, content_b)) in enumerate(content):
                    original_a = get_original_content(content_a)
                    original_b = get_original_content(content_b)

                    out_metricses["chunk_id"] = j
                    out_metricses["space"] = is_space_or_tab(original_a, original_b)
                    out_metricses["comment"] = is_comment(content_a, content_b)
                    out_metricses["new_line"] = is_new_line(content_a, content_b, out_metricses["space"])
                    out_metricses["upper_lower"] = is_upper_or_lower(original_a, original_b)
                    out_metricses["alphabet"] = is_alphabet(original_a, original_b)
                    out_metricses["symbol"] = is_symbol(original_a, original_b)
                    out_metricses["number"] = is_number(original_a, original_b)
                    out_metricses["cls_self"] = is_cls_self(original_a, original_b)
                    out_metricses["isnot"] = is_isnot(original_a, original_b)
                    out_metricses["string"] = is_string(original_a, original_b)

                    writer.writerow(out_metricses)

def get_original_content(content):
    """
    Return original string
    """
    return "\n".join(content)


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
    "isnot"
]

RE_STRING = re.compile(r"\".*\"|\'.*\'")
def is_string(original_a, original_b):
    """
    Specigy content_a is just changed newline
    """
    return RE_STRING.sub("", original_a) == RE_STRING.sub("", original_b)

RE_CLS_SELF = re.compile(r"cls\.|self\.")
def is_cls_self(original_a, original_b):
    """
    Specigy content_a is just changed newline
    """
    return RE_CLS_SELF.sub("", original_a) == RE_CLS_SELF.sub("", original_b)

RE_IS_NOT = re.compile(r"is|not")
def is_isnot(original_a, original_b):
    """
    Specigy content_a is just changed newline
    """
    return RE_IS_NOT.sub("", original_a) == RE_IS_NOT.sub("", original_b)

RE_COMMENT = re.compile(r"^#.*$")
def is_comment(content_a, content_b):
    """
    Specigy content_a is just changed newline
    """
    return all([i.lstrip().startswith("#") for i in content_a + content_b])

def is_new_line(content_a, content_b, space):
    """
    Specigy content_a is just changed newline
    """
    return space and len(content_a) != len(content_b)

RE_SPACE_TAB = re.compile(r"\s")
def is_space_or_tab(original_a, original_b):
    """
    Specigy original_a is just changed space
    """
    return RE_SPACE_TAB.sub("", original_a) == RE_SPACE_TAB.sub("", original_b)

def is_upper_or_lower(original_a, original_b):
    """
    Specigy original_a is just changed upper, lower alphabet
    """
    return original_a.lower() == original_b.lower()

RE_ALPHABET = re.compile(r"[a-zA-Z]")
def is_alphabet(original_a, original_b):
    """
    Specigy original_a is just changed alphabet
    """
    return RE_ALPHABET.sub("", original_a) == RE_ALPHABET.sub("", original_b)

RE_SYMBOL = re.compile(r"\W")
def is_symbol(original_a, original_b):
    """
    Specigy original_a is just changed non alphabet
    """
    return RE_SYMBOL.sub("", original_a) == RE_SYMBOL.sub("", original_b)

RE_NUMBER = re.compile(r"\d")
def is_number(original_a, original_b):
    """
    Specigy original_a is just changed number
    """
    return RE_NUMBER.sub("", original_a) == RE_NUMBER.sub("", original_b)

if __name__ == '__main__':
    main()
