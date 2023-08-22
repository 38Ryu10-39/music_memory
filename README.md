# music_memory

## サービス概要
music_memoryはこれまで聴いてきた音楽から思い出を振り返ることや、
他のユーザーの投稿を通して新しい曲やそれを通してコミュニケーションが取れるサービスです。

##　想定されるユーザー層
音楽が好きな人
音楽に思い出がある人
新しい音楽との出会いを探している人

## サービスコンセプト
幼少の頃家族の好きな音楽を聞いて育ったことから始まり、
成長するにつれて様々な音楽に触れ、毎日のように音楽を聞いてきました。
新しい音楽は友人や家族からお薦めされたり、
楽器をやっていたことからその関係の音楽を聞くようになったりとさまざまな出会いがありました。
最近ではYouTubeやapple musicでも新しい音楽と出会うことはできますが、
同じような系統に偏ったりなかなかピンとくる曲に出会えないことが多く、
新しい音楽に出会うことが少なくなり、いい方法がないかを探していました。
そこで今までの成長とともに聴いた音楽を聴いた場所・思い出を添えて投稿することで
自身の思い出を振り返ることができ、他のユーザーの投稿から新しい音楽と出会えるサービスが欲しいと思い、
このサービスを考案しました。
YouTubeやapple musicでも音楽を探すことはできておすすめも出てきますが、
music_memoryでは今まで聴いた音楽を年齢・地域と思い出を添えて投稿することで、
自身の音楽の歴史を作成して音楽を聞いていた当時の思い出を具体的に時系列で思い出ごと可視化できることや、
他のユーザーの聞いてきた音楽を知ることができるので新しい音楽への出会いが期待できます。
音楽から人同士のつながりが作れるようなサービスが見込めます。

## 実装を予定している機能
### MVP
* 会員登録
* ログイン
* 投稿機能(曲名、埋め込み(YouTube,apple music)、曲を聴いた年代(幼少期から大体5年刻み)、
  地域(聴いていた場所で県)、思い出、(必要であれば性別))
* 検索機能
* My音楽史(自身の今まで聴いた曲の年表をマイページに表示)
* 日本地図(投稿した音楽を聴いた地域に配置し、ピンで見れるようにする(LIKE数か新しい順かでいくつかのみ見れるようにするものでトップページにすることを予定)、
  日本地図の県またはピンの部分をクリックすると県のページへ行き他の人の曲が見れる)
* コメント機能
* チャット機能(WebSocket通信・ActionCable)
* 通知機能(WebSocket通信・ActionCable)

### その後の機能
* LIKE機能(LIKEした曲)
* おすすめ機能(自身の好きな曲の中で特におすすめなものをおすすめ曲とすることで、
  他の人のマイページにランダムでおすすめ曲が出る機能)
* タグ機能
* profile編集
* フォロー機能
* マルチ検索機能

### 使用技術・バージョン
- ruby：2.7.0以上
- rails ：7系
- postgresql
- heroku：デプロイ先
- JavaScript
- jQuery
- Jmapまたは、Japan Map ( jQuery plugin )
以降必要であれば追記します。