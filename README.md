
<img width="990" alt="スクリーンショット 2022-01-16 20 47 03" src="https://user-images.githubusercontent.com/41273823/150776895-278428f4-c242-44e8-96d7-7e81cca971ae.png">
<img width="996" alt="スクリーンショット 2022-03-01 22 49 41" src="https://user-images.githubusercontent.com/41273823/156181920-d1ec44be-fd52-43a3-b968-852e7bdec2d2.png">
<img width="998" alt="スクリーンショット 2022-03-01 22 51 53" src="https://user-images.githubusercontent.com/41273823/156182035-cdf80eaa-b75e-4b0e-91ca-ad3e8e1295b2.png">
<img width="989" alt="スクリーンショット 2022-03-01 22 54 33" src="https://user-images.githubusercontent.com/41273823/156182049-690e3ad5-9f5d-4b53-8797-844c7a883803.png">

# 0,プレイ方法
下のリリースのリンクから対応する実行環境の実行ファイルを選択してダウンロードしてください。
ただし、動作確認が充分に行われていないため、環境によっては動作しない可能性がございます。
まだ制作途中なので、どうかご容赦ください。
https://github.com/sushiyoshi/WesternSoul/releases

Processingの開発環境がある場合は、ソースコードをダウンロードしてProcessing上で直接動かした方が確実に動作すると思います。

# 1,タイトル  
西魂（ウエスタンソウル）

# 2,ストーリー  
  **いかなる時でも、一丁の銃と、一発の弾丸だけで勝負を決するべし――。**  
  それが西部の荒野を生きるガンマンにとっての流儀、**ウエスタンソウル**であった。  
  そこに、東洋からの侵略者たちが来訪する！　彼らは、美しい弾幕こそが正義であるという流儀――イースタンソウルの持ち主であった！  
  彼らは、自分たちの流儀に反するウエスタンソウルを根絶やしにするために、この西部の荒野にやってきたのである。  
  相反する文化と文化の衝突！　ガンマンたちは西部の誇りを守ることができるのか？  
  互いの誇りをかけた東西対抗戦が今、幕をあける！  
 
# 3,ゲームシステム
  このゲームでは、一般的なシューティングゲームでいう「道中」が存在せず、ボスキャラとプレイヤー1対1の状態で、弾幕を一つずつ攻略していくという形をとっている。
  プレイヤーは、ガンマンを操作し、ボスから放たれる弾幕を避けながら、ボスのソウル（当たり判定）に照準を合わせて弾を発射する。見事ボスのソウルを撃ち抜くことができたら、ボスは次の攻撃へと移行する。
  これを規定回数(2~3回)繰り返すとボス撃破となり、ステージクリアとなる。

# 4,用語説明  
 ### ソウル
   当たり判定。精神集中モード発動中、プレイヤーや敵のグラフィックの中央に表示される。  
 ### ショット
   プレイヤーは、a,dキーで照準を移動し、wキーで敵のソウル（当たり判定）に向かって銃弾を撃つ。
   銃弾は１発撃つごとにリロードされる。リロード中はショットを行うことができない。リロードは毎回100フレームで行われる。
 ### 精神集中
   スペースキーを押している間、精神集中モードに入る。  
   精神集中モードに入ると、画面上にある全てのオブジェクトの動きが遅くなり、ボスに照準を合わせやすくなる。  
   精神集中モードに入る時間には限りがあり、スペースキーを離すか、自機の真下に表示されている精神集中ゲージが0になったら、精神集中モードは解除される。  
   精神集中ゲージは、解除後に自動で回復し始める。  
 ### イースタンソウル（東魂）
  敵側の当たり判定。銃弾を当てることで撃破できる。  
  イースタンソウル一つにつき弾幕を一つ放つことができるという設定。  
  敵側のイースタンソウルを全て撃破すれば、ステージクリアとなる。  
  （東方Projectのスペルカードシステムに近い）  
 ### ウエスタンソウル（西魂）
  プレイヤー側の当たり判定。敵側の弾幕に被弾した瞬間、ゲームオーバーとなる。  

# 5,操作方法
 - 十字キー：プレイヤー移動、カーソル移動
 - shiftキー：低速移動
 - wキー：ショット、決定、会話を進める
 - a,dキー：照準移動
 - スペースキー：精神集中
 - controlキー: 会話スキップ
 - optionキー：ポーズ

# 6,動作環境
Processing 3.0、及び4.0で正しく動作することを確認。

# 7,トラブルシューティング  
Q. ソースコードをダウンロードして,Processing上で動かそうとしたのですが、エラーが出て動きません.  
A.　ディレクトリの名前は「western_soul」になっていますか？ Processingの仕様で,「western_soul-main」のままだと動きません.  

Q. ReleaseからダウンロードしたMacの実行ファイルを実行しようとしたら,「アプリケーション“western_soul”を開くためのアクセス権がありません」と言われて動きませんでした.  
A. ターミナルで,「open -a western_soul.app」を実行してみて下さい.  

# 8,現在報告されているバグ・解決すべき問題点  
以下に挙げるバグは全て認知しておりますので,報告は不要です.時間がある時に直します.  
- ポーズ関連のバグ  
> 例：ゲームオーバーイベント、及びクリアイベント発生時にポーズボタンを押すと,二重にポーズ画面が生成される.  
- 操作性が悪い
> 左手の指を全部使わないといけない弾幕STGヤバすぎる。クソゲーでは?  
> 僕も作っている途中にそれを悟りましたが、学校の課題なので完成させる他ありませんでした.  
- 照準、及び自機の弾の視認性が悪い
- リロードが分かりにくい
# 9,使用素材
 ・自機  
 シルエットAC様  
 https://www.silhouette-ac.com/detail.html?id=172912&ct=  
 ・ガンマンの立ち絵  
 シルエットAC様  
 https://www.silhouette-ac.com/detail.html?id=170421&ct=  
 ・ボスの立ち絵  
 シルエットAC様  
 https://www.silhouette-ac.com/detail.html?id=172903&ct=  
 https://www.silhouette-ac.com/detail.html?id=172848&ct=  
 ・タイトルロゴ  
 シルエットAC様  
 https://www.silhouette-ac.com/detail.html?id=170405&ct= 
 ぬれよん様  
 https://nureyon.com/revolver-1?pattern=12  
 ・ポーズ画面、ゲームオーバー画面、クリア画面  
 ぬれよん様  
 https://nureyon.com/revolver-1?pattern=12  
 Fot ライラ std  
 https://fontplus.jp/font-list/lyrastd-db  
 VF-Whitehall  
 https://www.fontsquirrel.com/fonts/whitehall  
 ・敵の弾グラフィック  
 http://anystorage.blog53.fc2.com/blog-category-3.html  
 ・スコア表示枠  
 素材ページ | メディバンペイント(MediBang Paint)  
 https://medibangpaint.com/cloud_material/ms000359/  
 ・ボスの魔法陣  
 daisy spread imageによる自動生成  
 https://github.com/MichinariNukazawa/daisy_spread_image  
 ・ポーズメニューの選択肢  
 Fot 豊隷 Std   
 https://fontplus.jp/font-list/houreistd-eb  
 VF-Whitehall  
 https://www.fontsquirrel.com/fonts/whitehall  

# 10,参考にさせていただいたサイト様  
## 当たり判定  
その８ 4分木空間分割を最適化する！（理屈編）  
http://marupeke296.com/COL_2D_No8_QuadTree.html  

## ベジェ曲線  
Processing - 6. 曲線の描画 - コンピュータ基礎II  
https://cc.musabi.ac.jp/kenkyu/cf/renew/program/processing/processing06.html  

・線分と円の当たり判定  
【当たり判定】線分と円の当たり - yttm-work  
https://yttm-work.jp/collision/collision_0006.html#:~:text=%E4%BB%A5%E4%B8%8B%E3%81%AE%E3%82%88%E3%81%86%E3%81%AB%E7%B7%9A,%E5%B0%8F%E3%81%95%E3%81%8B%E3%81%A3%E3%81%9F%E3%82%89%E5%BD%93%E3%81%9F%E3%82%8A%E3%81%A8%E3%81%97%E3%81%BE%E3%81%99%E3%80%82  

## GLSL  
ゼロから始めるレイマーチング  
https://qiita.com/jpnykw/items/7096fe59d1edf3ef3aa3  

シェーダー芸人になりたかった6か月前の自分に教えてあげたいリンク集  
https://qiita.com/kaneta1992/items/7fe9b47cc6c0836222af  

GLSLについてのメモ  
https://qiita.com/edo_m18/items/71f6064f3355be7e4f45  

シェーダだけで世界を創る！three.jsによるレイマーチング  
https://www.slideshare.net/shohosoda9/threejs-58238484  

[連載]やってみれば超簡単！ WebGL と GLSL で始める、はじめてのシェーダコーディング（４）  
https://qiita.com/doxas/items/f3f8bf868f12851ea143  
【GLSL(シェーダー)】立体的に見せる方法〜光の反射は『内積』で〜『レイマーチング』入門(2)  
https://coinbaby8.com/raymarching2.html  

砂丘の地形生成のコード  
https://www.shadertoy.com/view/MlccDf  

砂丘の模様のコード  
https://glslsandbox.com/e#78448.0  
フラクタルブラウン運動とドメインワープ  
https://qiita.com/edo_m18/items/e4d7a084cdbbfdc7863c  

[コードリーディング vol.1] レイマーチングによる波表現を読み解く  
https://qiita.com/edo_m18/items/a575606a60b21f0d2c57  

レイマーチングでHeight Map Distance Field  
https://qiita.com/edo_m18/items/af7fa86541634b59466f  

平行光源によるライティング - WebGL 開発支援サイト wgld.org  
https://wgld.org/d/webgl/w021.html  

反射光によるライティング- WebGL 開発支援サイト wgld.org  
https://wgld.org/d/webgl/w023.html  

距離フォグ- WebGL 開発支援サイト wgld.org  
https://wgld.org/d/webgl/w060.html  

GLSLでsmoothstepみたいな線形補間  
https://qiita.com/aa_debdeb/items/1165b98ec596ee20b519  


