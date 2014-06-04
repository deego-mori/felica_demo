#Gruntデモの流れ

参考→ <http://hyper-text.org/archives/2014/01/grunt_quick_start_for_web_designer.shtml>

###導入手順

- ####ドットインストールを参照
- ####簡単な導入手順	 
	1. `node.js`のインストール
	2. terminal / command prompt で `grunt` をインストール
	3. `npm install grunt --save-dev`
	4. package.json（パッケージ情報） / grunt.coffee（命令などの記述） の編集
	5. タスクの実行

###gruntを用いた開発の流れ
- lessを使用したcssの記述（less）
- cssの結合（concat）
- cssの圧縮（cssmin）
- 画像の圧縮（imagemin）
- 開発用から本番用に、ファイルの書き換え(replace)
- 不要なファイルの削除(clean)
- watchによる監視で自動的にビルド
- 開発用のタスクを設定
- 本番アップ用のタスクを設定
