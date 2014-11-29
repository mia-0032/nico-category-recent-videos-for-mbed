nico-category-recent-videos-for-mbed
====================

ニコニコ新検索βの検索APIをラップしてカテゴリごとの新着動画を取得する。

mbedで表示するためにフォーマットした文字列を返す。

## 作品例

[http://mia-0032.hatenablog.jp/entry/2014/07/30/234711](http://mia-0032.hatenablog.jp/entry/2014/07/30/234711)

## 使用方法

### Herokuへデプロイ

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/mia-0032/nicovideo_category_recent_videos_api/tree/master)

## URL

### /

サンプル表示。

ニコニコのAPIへアクセスしないのでmbedの表示デバッグに使う。

#### レスポンス

以下のレスポンスが必ず返る。

```javascript
{"cmsid":"sm0", "category":"ｻﾝﾌﾟﾙ", "title":"サンプルリクエスト"}
```

### /recent/\<category\>

指定したカテゴリの新着動画を表示する。

#### パラメータと対応カテゴリ

`<category>`に指定する文字列とニコニコ動画のカテゴリタグの対応。

- ent : エンターテイメント
- music : 音楽
- sing : 歌ってみた
- play : 演奏してみた
- dance : 踊ってみた
- vocaloid : VOCALOID
- nicoindies : ニコニコインディーズ
- animal : 動物
- cooking : 料理
- nature : 自然
- travel : 旅行
- sport : スポーツ
- lecture : ニコニコ動画講座
- drive : 車載動画
- history : 歴史
- science : 科学
- tech : ニコニコ技術部
- handcraft : ニコニコ手芸部
- make : 作ってみた
- politics : 政治
- anime : アニメ
- game : ゲーム
- toho : 東方
- imas : アイドルマスター
- radio : ラジオ
- draw : 描いてみた
- are : 例のアレ
- other : その他
- diary : 日記
- r18 : R-18

#### レスポンス

レスポンスのフォーマット

```javascript
{"cmsid":"動画ID", "category":"ｶﾃｺﾞﾘ", "title":"動画タイトル(32文字)"}
```

### /thumbnail/\<video_id\>

`<video_id>`に動画IDを渡すと128*128のサイズに補正した動画サムネイル画像を返す。

フォーマットはbmp3になる。
