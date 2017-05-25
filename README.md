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
    * [x] Symbol
* [x] If
* [x] Oneline Change
* [x] Inserted:bool
* [x] Deleted:bool
* [x] Moved:integer
    * [ ] Abstract
* [x] Test:integer
* [ ] Document
    * [x] Binaly("doc", "docx"):integer
    * [x] Comment(Only oneline)
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
* Fix Rename
* Fix Comment

* 自分で注意するのだから注意されにくい？

## On Deck
* Be tool?

## Backlog(Work not yet planned)
* abstract tag(blue)

## Deadline
* [x] [SES2017](http://ses.sigse.jp/2017/)(May 12)
* [ ] [FOSE2017](http://fose.jssst.or.jp/fose2017/)(7/7)
* [ ] [ICSE2017](http://www.icse2018.org/track/icse-2018-Important-dates)(8/25)

## TODO
### bot
* 要求
* プラットホーム
* survey to wiki
### CCTagger
* Renameの修正
* コメントの修正
* 注意されればされるほどミスをしなくなる
* ミスをしてから次のパッチでもやらかす確率
* Ifの発生割合 / Ifの指摘回数
    * 最後にIfを修正してからのパッチ数

* ifのどの部分を修正するか？
* Renameをどう変えるか？