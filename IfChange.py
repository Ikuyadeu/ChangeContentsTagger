"""
Get If Changes kind
"""
import csv
import os
import re
import sys
import time
from collections import OrderedDict

ARGV = sys.argv
ARGC = len(ARGV)

if ARGC > 3:
    INPUT_PATH = ARGV[1] + "/"
    OUTPUT_PATH = ARGV[2]
    if ARGC > 6:
        MAX_PULL_NO = int(ARGV[3])
        MIN_PULL_NO = int(ARGV[4])
        EXTENSION = ARGV[5]
    else:
        MIN_PULL_NO = 1
        MAX_PULL_NO = 100
        EXTENSION = ".txt"
else:
    print """Usage: python %s INPUT_PATH OUTPUT_PATH
    MAX_PULL MIN_PULL EXTENSION [--per_patch]""" % ARGV[0]
    sys.exit()

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
Regex to identify diff file's column
"""
RE_TO_FILE_DIFF = re.compile(r"^\+{3} (.+)$\n?| - .* ={4}$\n?")
RE_FROM_FILE_DIFF = re.compile(r"^-{3} (.+)$\n?| - .* ={4}$\n?")

RE_DIFF_INSERTED = re.compile(r"^(((&gt;)( .*)?)|((\+).*))$\n?")
RE_DIFF_DELETED = re.compile(r"^(((&lt;)( .*)?)|((-).*))$\n?")
RE_DIFF_FIRST = re.compile(r"""(?x)^
            (===\ modified\ file
            |==== \s* // .+ \s - \s .+ \s+ ====
            |Index:\ 
            |---\ [^%\n]
            |\*\*\*.*\d{4}\s*$
            |\d+(,\d+)* (a|d|c) \d+(,\d+)* $
            |diff\ --git\ 
            |commit\ [0-9a-f]{40}$
            )""")
RE_DIFF_RANGE_UNIFIED = re.compile(r"^(@@)\s*(.+?)\s*(@@)($\n?)?")
RE_DIFF_FILE_END = re.compile(r"^--\s")
RE_DIFF_DATE = re.compile(r"^Date:\s(.*)\n?")
FILE_END = re.compile(r"^--\s")
RE_DATE = re.compile(r"^Date:\s(.*)\n?")

REG_DICT = OrderedDict([(END, FILE_END),
                        (FIRST, RE_DIFF_FIRST),
                        (DIFF_RANGE, RE_DIFF_RANGE_UNIFIED),
                        (TO_FILE_DIFF, RE_TO_FILE_DIFF),
                        (INSERTED, RE_DIFF_INSERTED),
                        (DELETED, RE_DIFF_DELETED)])

def get_line_kind(line):
    """
    Get Line's kind value
    @return integer
    """
    for key, reg in REG_DICT.items():
        if reg.match(line):
            return key
    return EQUAL

"""
Regex to identify if column
"""
RE_IS_IF_OR_ELSE = re.compile(r"^(\+|-)(\s|\t)*#?\s*(if|else)(.*)($\n?)?")

""" Addition of Precondition Check with Jump """
RE_IF_APCJ = re.compile(r"^(\+|-)(\s|\t)*#?\s*if(.*)(return|continue|break|goto)")
""" Addition of Post-condition Check """
RE_IF_APTC = re.compile(r"^(\+|-)(\s|\t)*#?\s*if\s*\((.*NULL.*)\)(.*)($\n?)?")

OTHER = 0
""" Addition of Precondition Check """
IF_APC = 11
""" Addition of Precondition Check with Jump """
IF_APCJ = 12
""" Addition of Post-condition Check """
IF_APTC = 13
""" Removal of an If Predicate """
IF_ABR = 14
""" Addition of an Else Branch """
IF_RMV = 15
""" Removal of an Else Branch """
IF_RBR = 16
""" Change of If Condition Expression """
IF_CC = 17

IFS = [IF_APC, IF_APCJ, IF_APTC, IF_ABR, IF_RMV, IF_RBR, IF_CC]

def get_if_kind(line, prevline):
    """
    get if-related
    """
    if not RE_IS_IF_OR_ELSE.match(line):
        return OTHER
    if "else" in line:
        if line.startswith("+"):
            return IF_ABR
        elif line.startswith("-"):
            return IF_RBR
    elif "if" in line:
        if RE_IF_APCJ.match(line):
            return IF_APCJ
        elif RE_IF_APTC.match(line):
            return IF_APTC
        elif RE_IS_IF_OR_ELSE.match(prevline):
            return IF_CC
        elif line.startswith("+"):
            return IF_APC
        elif line.startswith("-"):
            return IF_RMV
    return OTHER

"""
Get start time 
"""
START = time.time()
print time.strftime("START: %a, %d %b %Y %H:%M:%S", time.localtime())

"""
Find File list
"""
# FILE_LIST = [(pull_no, patch_no) for pull_no in range(MIN_PULL_NO, MAX_PULL_NO + 1)
#              for patch_no in range(1, 10)
#              if os.path.isfile(INPUT_PATH + str(pull_no) + "_" + str(patch_no) + EXTENSION)]
FILE_LIST = [(pull_no, 1) for pull_no in range(MIN_PULL_NO, MAX_PULL_NO + 1)
             if os.path.isfile(INPUT_PATH + str(pull_no) + "_" + "1" + EXTENSION)]

FILE_NUM = len(FILE_LIST)

with open(OUTPUT_PATH, "w") as output_diff:
    # Setting csv writer
    DIFF_WRITER = csv.writer(output_diff, lineterminator="\n")
    DIFF_WRITER.writerow(("PullNo", "PatchNo",
                          "IF_APC", "IF_APCJ", "IF_APTC", "IF_ABR", "IF_RMV", "IF_RBR", "IF_CC"))
    INSERTED_DOC = ""
    for i, FILE in enumerate(FILE_LIST, 1):
        pull_no = FILE[0]
        patch_no = FILE[1]

        if patch_no > 1:
            OLD_INSERTED_DOC = INSERTED_DOC
        sys.stdout.write("\rFILE:%d/%d, Pull No:%d/%d, Patch No:%d" % \
                        (i, FILE_NUM, pull_no, MAX_PULL_NO, patch_no))

        DIFF_FILE_PATH = INPUT_PATH + str(pull_no) + "_" + str(patch_no) + EXTENSION

        isIf = any(RE_IS_IF_OR_ELSE.match(x) for x in open(DIFF_FILE_PATH, "r"))

        CHANGE_LINE = False
        with open(DIFF_FILE_PATH, "r") as diff_file:
            ifkind = {}
            prevline = ""
            for _line in diff_file:
                line_kind = get_line_kind(_line)
                if line_kind == END:
                    break
                elif line_kind == FIRST:
                    CHANGE_LINE = False
                elif line_kind == DIFF_RANGE:
                    CHANGE_LINE = True
                elif line_kind == TO_FILE_DIFF:
                    file_name = RE_TO_FILE_DIFF.match(_line).group(1)
                elif CHANGE_LINE:
                    ifkind[get_if_kind(_line, prevline)] = True
                prevline = _line
            # # Get diffs
            # INSERTED_DOC = ''.join(INSERTEDS)
            # DELETED_DOC = ''.join(DELETEDS)
            # if PER_PATCH and patch_no > 1:
            #     DELETED_DOC = OLD_INSERTED_DOC
            # try:
            #     DIFF_CONTENTS = DIFF_OBJ.diff_main(DELETED_DOC, INSERTED_DOC)
            # except ValueError:
            #     continue

        DIFF_WRITER.writerow([pull_no, patch_no] + [x in ifkind for x in IFS])
        # if ifkind == ADDITION:
        #     pass
        # elif ifkind == REMOVAL:
        #     pass
        # elif ifkind == CHANGE:
        #     pass

        # if elsekind == ADDITION:
        #     pass
        # elif elsekind == REMOVAL:
        #     pass


"""
Get elapsed time
"""
M, S = divmod(time.time() - START, 60)
H, M = divmod(M, 60)
print "\nELAPSED_TIME:%d:%02d:%02d" % (H, M, S)
