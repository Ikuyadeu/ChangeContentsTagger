"""
Get Style missing from diff file
Style misses list
* only space
* Large to Small (ex:"Style" to "style")
* only make new line
"""
import csv
import os
import re
import sys
import diff_match_patch

ARGV = sys.argv
ARGC = len(ARGV)

if ARGC > 2:
    DIFF_DIR_PATH = ARGV[1] + "/"
    OUTPUT_PATH = ARGV[2]
else:
    print "Usage: python %s DIFF_DIR_PATH OUTPUT_PATH [--per_patch]" % ARGV[0]
    sys.exit()

""""
--per_patch: Get diff from before patch,
if non Get diff from base code
"""
OPTIONS = [option for option in ARGV if option.startswith('--')]

PER_PATCH = '--per_patch' in OPTIONS


"""
Reseach Patch range
"""
MIM_PULL_NO = 1
MAX_PULL_NO = 500


"""
Flag value
@equal: nochange line
@inserted: inserted line
@deleted: deleted line

@FIRST: first line per changed file
@DIFF_RANGE: inform changed line between @ mark
@END: end line per diff file
"""
EQUAL = 0
INSERTED = 1
DELETED = -1
FIRST = 2
DIFF_RANGE = 3
END = 4

TO_FILE_DIFF = 5

"""
Regex to identify diff column
RE_FIRST:
"""
RE_TO_FILE_DIFF = re.compile(r"^(\+{3}) (.+)$\n?| (-) .* (={4})$\n?")
# FROM_FILE_DIFF = re.compile(r"(^(((-{3}) .+)|((\*{3}) .+))$\n?|^(={4}) .+(?= - ))")

RE_INSERTED = re.compile(r"^(((&gt;)( .*)?)|((\+).*))$\n?")
RE_DELETED = re.compile(r"^(((&lt;)( .*)?)|((-).*))$\n?")
RE_FIRST = re.compile(r"""(?x)^
            (===\ modified\ file
            |==== \s* // .+ \s - \s .+ \s+ ====
            |Index:\ 
            |---\ [^%\n]
            |\*\*\*.*\d{4}\s*$
            |\d+(,\d+)* (a|d|c) \d+(,\d+)* $
            |diff\ --git\ 
            |commit\ [0-9a-f]{40}$
            )""")
DIFF_RANGE_UNIFIED = re.compile(r"^(@@)\s*(.+?)\s*(@@)($\n?)?")
FILE_END = re.compile(r"^--\s")

"""
Regex to Style fix
"""
RE_SPACE_TAB = re.compile(r"^(\s|\t)+$")
RE_RENAME = re.compile(r"^\w+$")
IMAGE = ["png", "gif", "jpg", "jpeg", "vg", "svgx"]

"""
Diff object from diff-match-patch
"""
DIFF_OBJ = diff_match_patch.diff_match_patch()

def get_line_kind(line):
    """
    noCHANGE_LINE 0
    inserted line 1
    deleted line -1
    """
    if FILE_END.match(line):
        return END
    elif RE_FIRST.match(line):
        return FIRST
    elif DIFF_RANGE_UNIFIED.match(line):
        return DIFF_RANGE
    elif RE_TO_FILE_DIFF.match(line):
        return TO_FILE_DIFF
    elif RE_INSERTED.match(line):
        return INSERTED
    elif RE_DELETED.match(line):
        return DELETED
    else:
        return EQUAL

FILE_LIST = [(pull_no, patch_no) for pull_no in range(MIM_PULL_NO, MAX_PULL_NO + 1)
             for patch_no in range(1, 10)
             if os.path.isfile(DIFF_DIR_PATH + str(pull_no) + "_" + str(patch_no) + ".diff")]
FILE_NUM = len(FILE_LIST)

with open(OUTPUT_PATH, "w") as output_diff:
    # Setting csv writer
    DIFF_WRITER = csv.writer(output_diff, lineterminator="\n")
    # Output column Name
    DIFF_WRITER.writerow(("PullNo", "PatchNo", "CHANGED_CONTENTS",
                          "SpaceOrTab", "NewLine", "UpperOrLower",
                          "Renamed", "Test", "Fig",
                          "IsInserted", "IsDeleted", "Moved"))

    INSERTED_DOC = ""
    for i, FILE in enumerate(FILE_LIST):
        pull_no = FILE[0]
        patch_no = FILE[1]

        # sys.stdout.write("FILE:%d/%d, Pull No:%d/%d, Patch No:%d" % \
        #                 (i, FILE_NUM, pull_no, MAX_PULL_NO, patch_no))
        print "FILE:%d/%d, Pull No:%d/%d, Patch No:%d" % \
        (i, FILE_NUM, pull_no, MAX_PULL_NO, patch_no)

        DIFF_FILE_PATH = DIFF_DIR_PATH + str(pull_no) + "_" + str(patch_no) + ".diff"
        with open(DIFF_FILE_PATH, "r") as diff_file:
            # Get Inserted doc and Deleted doc
            if patch_no > 1:
                OLD_INSERTED_DOC = INSERTED_DOC

            CHANGE_LINE = False
            TEST_FILE = 0
            FIG_FILE = 0
            INSERTEDS = []
            DELETEDS = []
            ONLY_IN = []
            ONLY_DE = []
            for _line in diff_file:
                line_kind = get_line_kind(_line)
                if line_kind == END:
                    break
                elif line_kind == FIRST:
                    CHANGE_LINE = False
                elif line_kind == DIFF_RANGE:
                    CHANGE_LINE = True
                elif line_kind == TO_FILE_DIFF:
                    file_name = RE_TO_FILE_DIFF.match(_line).group(2)
                    if "test" in file_name:
                        TEST_FILE += 1
                    if any(x in file_name for x in IMAGE):
                        FIG_FILE += 1
                elif CHANGE_LINE:
                    if line_kind == INSERTED:
                        INSERTEDS.append(re.sub(r'\+', ' ', _line, 1))
                        ONLY_IN.append(re.sub(r'\+', ' ', _line, 1))
                    elif line_kind == DELETED:
                        DELETEDS.append(re.sub(r'-', ' ', _line, 1))
                        ONLY_DE.append(re.sub(r'-', ' ', _line, 1))
                    elif line_kind == EQUAL:
                        INSERTEDS.append(_line)
                        DELETEDS.append(_line)

            # Get diffs
            INSERTED_DOC = ''.join(INSERTEDS)
            DELETED_DOC = ''.join(DELETEDS)
            if PER_PATCH and patch_no > 1:
                DIFF_CONTENTS = DIFF_OBJ.diff_main(OLD_INSERTED_DOC, INSERTED_DOC)
            else:
                DIFF_CONTENTS = DIFF_OBJ.diff_main(DELETED_DOC, INSERTED_DOC)

            INSERTED_CONTENTS = [x[1] for x in DIFF_CONTENTS if x[0] == INSERTED]
            DELETED_CONTENTS = [x[1] for x in DIFF_CONTENTS if x[0] == DELETED]
            # DIFF_CONTENTS = [x[1] for x in DIFF_CONTENTS]

            MOVED = len(set(ONLY_IN) & set(ONLY_DE))
            if len(ONLY_DE) + len(ONLY_IN) - MOVED > 0:
                MOVED = float(MOVED) / (len(ONLY_DE) + len(ONLY_IN) - MOVED)

            # Get tags
            IS_INSERTED = len(INSERTED_CONTENTS) > 0
            IS_DELETED = len(DELETED_CONTENTS) > 0

            NEW_LINE = [x[1] for x in DIFF_CONTENTS if x[1] == "\n"]
            SPACE_OR_TAB = [x[1] for x in DIFF_CONTENTS if RE_SPACE_TAB.match(x[1])]

            UPPER_OR_LOWER = 0
            RENAME = 0
            for j, x in enumerate(DIFF_CONTENTS):
                if j > 0:
                    before_diff = DIFF_CONTENTS[j - 1]
                    if x[0] == before_diff[0] * -1:
                        if  x[1].upper() == before_diff[1].upper():
                            UPPER_OR_LOWER += 1
                        if x[1].isalnum() and before_diff[1].isalnum():
                            RENAME += 1

            # Out put result
            DIFF_WRITER.writerow((pull_no, patch_no, len(DIFF_CONTENTS),
                                  len(SPACE_OR_TAB), len(NEW_LINE), UPPER_OR_LOWER,
                                  RENAME, TEST_FILE, FIG_FILE,
                                  IS_INSERTED, IS_DELETED, MOVED))
