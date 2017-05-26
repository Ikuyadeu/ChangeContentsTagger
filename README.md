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

## Done
* 指揮されることで注意をするか？
    　　* ３〜４回目までは少しだけよくなるがそれ以上は開き直る．

## Deadline
* [x] [SES2017](http://ses.sigse.jp/2017/)(May 12)(7/7)
* [ ] [FOSE2017](http://fose.jssst.or.jp/fose2017/)(7/7)
* [ ] [ICSE2017](http://www.icse2018.org/track/icse-2018-Important-dates)(8/25)

## TODO
* survey ICSE

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
FindBugs, Pod, LCAnalyzer, Checkstyle, coverity
### OpenStack project
[Githubのサーチでスターが多い順](https://github.com/search?o=desc&q=org%3Aopenstack+&s=stars&type=Repositories&utf8=%E2%9C%93)
#### lintあり
* [cinder](https://github.com/openstack/cinder/blob/master/pylintrc)(pylint(2011))(2012)
* [horizon](https://github.com/openstack/horizon)(eslint(2015),pylint(2011))(2011)
* [neuton](https://github.com/openstack/neutron)(pylint(2013))(2010)
* [openstack-ansible](https://github.com/openstack/openstack-ansible/blob/master/tox.ini)
* [bandig](https://github.com/openstack/bandit)(pylint(2016))(2015)

#### lintなし
* [nova](https://github.com/openstack/nova)
* [swift](https://github.com/openstack/swift)
* [kolla](https://github.com/openstack/kolla)

### Static Analysis
[list](https://en.wikipedia.org/wiki/List_of_tools_for_static_code_analysis)
* [Java](https://en.wikipedia.org/wiki/List_of_tools_for_static_code_analysis#Java)
    * [FindBugs](http://findbugs.sourceforge.net/):Javaのバグっぽいところを指摘する
    * [CheckStyle](https://ja.wikipedia.org/wiki/Checkstyle):Javaのスタイルをチェックする（詳細設定可能）
    * [coverity](http://www.coverity.com/html_ja/products/code-advisor/index.html):エラーを検出する


### Idea：lintを導入することでどのような利益があるか？
* 時間の経過で受ける影響とlintの導入で受ける影響を区別するために開発期間を３つに分ける
    * lintを導入した時の前後半年
    * lintが導入されなかった１年間
    * lint導入後の１年間
* メトリクス
    * コミット数
    * PR数
    * レビュー期間
    * 再修正の数
    * lintに引っかかる変更の数
    * pythonの変更数 / 全体の変更数
* 期待する結果
    1. 条件１：lintが導入されなかった１年間，lint導入後の１年間では徐々にコミット数が増える
    2. 条件２：lintを導入した時の前後半年ではコミット数が急に減った
    3. 結果：lintを導入すればコミットしにくくなる