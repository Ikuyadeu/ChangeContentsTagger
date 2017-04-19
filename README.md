# Get Change Contents per patch from diff file
## feature
* [x] Date
* [x] Style
    * [x] Space
    * [x] Tab
    * [x] New Line
    * [x] Upper or Lower
    * [x] Rename(Only alphabet)
        * [x] File rename
* [x] Inserted
* [x] Deleted
* [x] Moved
    * [ ] Abstract
* [x] Test
* [ ] Document
    * [x] Binaly
    * [ ] Source
* [x] Figure
* [ ] Mistake
* [ ] Version Control System

## Usage
Please use python 2.7
`python .\StyleFromDiff.py DIFF_DIR_PATH OUTPUT_PATH [--per_patch]`
`DIFF_DIR_PATH`: Directory have diff file
`OUTPUT_PATH`: OutPut file name

## TODO
* VCS

* abstract