# ALMAM Player

[ALMAMPlayer](https://github.com/almam72/ALMAMPlayer) をベースに開発した MIDI ビジュアライザです。

Godot 4.6 を使用して制作しました。

不具合は [GitHub Issues](https://github.com/icysamon/almam-player/issues) または[メール](mailto:me@icysamon.com)に報告してください。

## ダウンロード

https://github.com/icysamon/almam-player/releases

初めて起動した場合 MIDI トラックがおかしくなる可能性があります。その場合アプリを**再起動**してください。

> MIDI とオーディオファイルをインポート後 `プレビューをリセット` ボタンを押してください。

## 確認した不具合と対応方法

以下の対応方法は必ず解決できるとは言いえません。

### 右上のMIDIが途中から始まっている

プレビューとエクスポート機能はそのまま正常だと思うが、以下の手順で修復されるかもしれません。

1. プレビューボタンを押して新しい画面を開く
2. 新しい画面を閉じる
3. `プレビューをリセット` ボタンを押す
4. アプリを再起動

### 途中からリズムに合わせていない

- 再生の場合アプリ外部を操作したらプログラムの動作が遅くなる
- テンポが変わる曲に対応していない

### "ノート押下"テキスチャーのインポートが失敗

別の画像をインポートし、そしてもう一回元の画像をインポートし試してください。

## ユーザーデータを削除する方法

設定ファイルの問題でアプリが起動できない場合があります。

ユーザーデータを削除したら解決できるかもしれません。

> 事前にアプリを終了してください。

### Windows

1. `スタートアイコン` を右クリック（または Win + R）して `ファイル名を指定して実行` を選択
2. `%APPDATA%` を入力し実行
3. `ALMAMPlayer`フォルダを削除

### Mac

ターミナルで以下のコマンドを実行してください。

```
rm -rf ~/Library/Application\ Support/ALMAMPlayer/
```

## MP4 の出力ができますか

このツールはゲームエンジン Godot で作成されたものです。公式の[ドキュメント](https://docs.godotengine.org/en/stable/tutorials/animation/creating_movies.html)によると現時点 AVI 形式のみサポートされています。
