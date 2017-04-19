# Get Change Contents per patch from diff file
## feature
* [x] Style
    * [x] Space
    * [x] Tab
    * [x] New Line
    * [x] Upper or Lower
    * [x] Rename(Only alphabet)
        * [ ] File rename
* [x] Inserted
* [x] Deleted
* [x] Moved
    * [ ] Abstract
* [x] Test
* [ ] Document
    * [ ] Binaly
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
* file rename
* binaly doc
* VCS

* abstract