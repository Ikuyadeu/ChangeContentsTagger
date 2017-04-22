# Change Contents Tagger
Get Change Contents per patch from diff file

## feature
* [x] Date:date
* [x] Style:integer(in ChangeContents)
    * [x] Space
    * [x] Tab
    * [x] New Line
    * [x] Upper or Lower
    * [x] Rename(Only alphabet?)
        * [x] File rename(Identify line num?)
* [x] Inserted:bool
* [x] Deleted:bool
* [x] Moved:integer
    * [ ] Abstract
* [x] Test:integer
* [ ] Document
    * [x] Binaly("doc", "docx"):integer
    * [ ] Source
* [x] Figure("png", "gif", "jpg", "jpeg", "vg", "svgx"):integer
* [ ] Mistake
* [x] Version Control System(Git, Merge, Revert):bool

## Usage
Please use python 2.7.x
And, 

`pip install diff_match_patch`

`python .\StyleFromDiff.py DIFF_DIR_PATH OUTPUT_PATH [--per_patch]`

* `DIFF_DIR_PATH`: Directory have diff file
* `OUTPUT_PATH`: OutPut file name

## TODO
* visualize :Yoshigami
* reseach tag coverage
* per date

## On Deck
* Be tool?

## Backlog(Work not yet planned)
* abstract tag(blue)
* if(yellow)
* only kigou(green)
* one line(orange)
* comments(gray)
* all same change(chairo)

## Deadline
[SES](http://ses.sigse.jp/2017/)(May 12)

## Done
### April
* Get tag from 500 patch