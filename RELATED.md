* 平尾さんおすすめの有名な論文
    * [x] Will My Patch Make It? And How Fast?
        * いくつのパッチがマージされるか:33%ただし，１〜６ヶ月，だんだんレビューのスピードは下がる
        * どんなパッチがマージされるか：コメント，サブコミット
        * どんなパッチが早くアクセプトされるか：コメント，サブコミット，コミッターのパッチ
    * [ ] Code Review Quality: How Developers See It
    * [x] Writing Acceptable Patches: An Empirical Study of Open Source Project Patches
        * なんでリジェクトされるか
            * もっといい方法がある
            * 完全に直ってない
            * いらん変更がある
            * コーディングスタイルがダメ 
        * どんな理由でよくリジェクトされるか
            * ダメ絶対
                * コンパイルエラー
                * テスト失敗
                * 新しいバグが入ってる
            * ほぼダメ
                * ドキュメントが間違ってる
                * もっといい方法がある
                * ダブり
                * イラン変更がある
                * 完全に直ってない
                * コーディングスタイルがダメ 
            * まあまあダメ
                * ネーミングスタイルがダサい
                * ドキュメントが間違ってるとは言わないがミスってる
                * パッチサイズデカすぎ
        * どんな理由が判定が難しいか
            * もっといい方法がある
            * 新しいバグがある
            * 完全に直ってない 
    * [ ] Understanding Broadcast Based Peer Review on Open Source Software Projects
* [ ] 伊原先生査読中
    * [x] How Security Bugs Are Fixed and What Can Be Improved: An Empirical Study with Mozilla
    Mozillaのセキュリティバグを調査
    自動で検出できるようなバグがたくさんあった．
* ICPC2017
    * [ ]  How Developers Document Pull Requests with External References 
    プルリクエストでは，何をリファーしているのか？
    * [ ]  Meaningful Identifier Names: The Case of Single-Letter Variables
    “I”以外にもsingle letterで頻繁に使われるものがあるので調査してみた．
    * [ ] Effects of Variable Names on Comprehension: An Empirical Study
    Variable namesの使われ方を調査している？
    * [ ] Binary Code Clone Detection across Architectures and Compiling Configurations
    * [ ] Identifying Code Clones having High Possibilities of Containing Bugs
    * [ ] Smells are sensitive to developers! On the efficiency of (un)guided customized detection
    * [ ] On the Uniqueness of Code Redundancies
    * [ ] An Exploratory Study on the Relationship between Changes and Refactoring
    コミットに含まれるリファクタリングがどのぐらいソースコードの Readability （可読性）メトリックを変化させるか，みたいな議論をしてました．
    可読性の値そのものが信用できるかはともかく，レビューがどのぐらい可読性に影響するか，という議論には影響しそうです
    * [ ] Detecting User Story Information in Developer-Client Conversations to Generate Extractive Summaries
    開発者の会話をサマライズする研究．昔バグレポートの内容をサマライズする研究があったけど，それの応用っぽい．コードレビューの会話をサマライズすることができそう．
    * [x] Characterizing and Detecting Anti-Patterns in the Logging Code
    アンチパターンの研究でFindBugsやPodなど様々な静的解析ツールを利用している？
    LCAnalyzerを使っている
    System.out.println()を使ってテストをするのは良くないねって話
* MSR2017
    * [ ] Predicting Usefulness of Code Review Comments using Textual Features and Developer Experience
    コードレビューコメントがUseful かどうかを自動判定しようという話．Useful かどうかという開発者向けのインタビュー研究を下敷きにしたもの．Raula先生も著者に入ってる
    * [x] Characterizing and Detecting Anti-paterns in the Logging Code
    * [x] An Empirical Analysis of Build Failures in the Continuous Integration Workflows of Java-Based Open-Source Software
        * どんなエラーがCIに引っかかるか
            * testの失敗
            * コーディングルールの違反
            * コンパイルエラー
            *  VCSの問題
            * buildできない

* ICSE
    * [x] Process Aspects and Social Dynamics of Contemporary Code Review: Insights from Open Source Development and Industrial Practice at Microsoft
        * MicrosoftとOSSでコードレビューの方針に違いがあるのか？
        * どうやってコードのauthorを決めるか
            * OSS:評判，関連性
            * Microsoft:時間効率，専門の守備範囲
        * どんなメトリクスがコードの品質に影響を与えるか
            * OSS；個人特性
            * Microsoft：関連性，コラボレーション？
        * コードレビューで重要だとされるもの
            * メンテナンス可能
            * 知識の共有：モダンコードレビューっぽい！
            * 機能の欠陥
            * コミュニティの形成
            * マイナーなエラー，タイポ：Minorって言葉がSmall Changeよりも良さそう！