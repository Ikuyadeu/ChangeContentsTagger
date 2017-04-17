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
    print "Usage: %s DIFF_FILE_PATH OUTPUT_PATH [--per_patch]" % ARGV[0]
    sys.exit()

OPTIONS = [option for option in ARGV if option.startswith('--')]

if '--per_patch' in OPTIONS:
    PER_PATCH = True
else:
    PER_PATCH = False


"""
Reseach Patch range
"""
MIM_PULL_NO = 1
MAX_PULL_NO = 500


"""
flag value
"""
DIFF_RANGE = 2
INSERTED = 1
DELETED = -1
NO_CHANGE = 0
FIRST = 3
END = 4

"""
Regex from diff file
"""
FIRST_LINE = re.compile(r"""(?x)^
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
FROM_FILE_DIFF = re.compile(r"(^(((-{3}) .+)|((\*{3}) .+))$\n?|^(={4}) .+(?= - ))")
TO_FILE_DIFF = re.compile(r"(^(\+{3}) .+$\n?| (-) .* (={4})$\n?)")
INSERTED_DIFF = re.compile(r"^(((&gt;)( .*)?)|((\+).*))$\n?")
DELETED_DIFF = re.compile(r"^(((&lt;)( .*)?)|((-).*))$\n?")
FILE_END = re.compile(r"^--\s")

def get_line_kind(line):
    """
    noCHANGE_LINE 0
    inserted line 1
    deleted line -1
    """
    if FILE_END.match(line):
        return END
    elif FIRST_LINE.match(line):
        return FIRST
    elif DIFF_RANGE_UNIFIED.match(line):
        return DIFF_RANGE
    elif INSERTED_DIFF.match(line):
        return INSERTED
    elif DELETED_DIFF.match(line):
        return DELETED
    else:
        return NO_CHANGE

FILE_LIST = [(pull_no, patch_no) for pull_no in range(MIM_PULL_NO, MAX_PULL_NO)
             for patch_no in range(1, 10)
             if os.path.isfile(DIFF_DIR_PATH + str(pull_no) + "_" + str(patch_no) + ".diff")]
FILE_NUM = len(FILE_LIST)

with open(OUTPUT_PATH, "w") as output_diff:
    DIFF_WRITER = csv.writer(output_diff, lineterminator="\n")
    DIFF_WRITER.writerow(("PullNo", "PatchNo", "Style", "CHANGED_CONTENTS",
                          "OnlyInserted", "OnlyDeleted"))

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
            if patch_no > 1:
                OLD_INSERTED_DOC = INSERTED_DOC

            INSERTED_DOC = ""
            DELETED_DOC = ""
            CHANGE_LINE = False
            for _line in diff_file:
                line_kind = get_line_kind(_line)
                if line_kind == END:
                    break
                elif line_kind == FIRST:
                    CHANGE_LINE = False
                elif line_kind == DIFF_RANGE:
                    CHANGE_LINE = True
                elif CHANGE_LINE:
                    if line_kind == INSERTED:
                        INSERTED_DOC += re.sub(r'\+', ' ', _line, 1)
                    elif line_kind == DELETED:
                        DELETED_DOC += re.sub(r'-', ' ', _line, 1)
                    elif line_kind == NO_CHANGE:
                        INSERTED_DOC += _line
                        DELETED_DOC += _line

            DIFF_OBJ = diff_match_patch.diff_match_patch()
            if PER_PATCH and patch_no > 1:
                DIFFS = DIFF_OBJ.diff_main(OLD_INSERTED_DOC, INSERTED_DOC)
            else:
                DIFFS = DIFF_OBJ.diff_main(DELETED_DOC, INSERTED_DOC)

            INSERTED_CONTENTS = [x[1] for x in DIFFS if x[0] == INSERTED]
            DELETED_CONTENTS = [x[1] for x in DIFFS if x[0] == DELETED]
            CHANGED_CONTENTS = INSERTED_CONTENTS + DELETED_CONTENTS

            # TODO: Define style be more detail
            STYLE = [x for x in CHANGED_CONTENTS if x in (" ", "\n")]
            ONLY_INSERTED = len(DELETED_CONTENTS) == 0
            ONLY_DELETED = len(INSERTED_CONTENTS) == 0

            DIFF_WRITER.writerow((pull_no, patch_no, len(STYLE),
                                  len(CHANGED_CONTENTS), ONLY_INSERTED, ONLY_DELETED))
