## これは何？
Docker + Next.js のスターターキットです。
下記の記事をベースにさせていただいています。
https://zenn.dev/yuki_tu/articles/01c7963eeb2876

## 元記事との差分

```diff
# Dockerfile
FROM node:16.14.2-alpine
- WORKDIR /app/
+ WORKDIR /app/myapp
```

```diff
# docker-compose.yml
version: "3"
services:
  front:
    build: .
    tty: true
    ports:
      - "3000:3000" # 開発用
      - "4000:4000" # 本番用
    volumes:
-     - ./app/myapp:/app
+     - ./app:/app
    command: yarn dev
```

元記事の手順だと、 **コンテナ外から見て** `./app/myapp/myapp` に Next.jsアプリケーションが構築されてしまう。
（末尾のmyappは create next app 時のプロジェクト名）

そのため WORKDIR である コンテナ内の `/app`直下 には Next.jsアプリケーションが存在せず、
frontコンテナ立ち上げ時の yarn dev に失敗してしまっていた。

そのため、WORKDIR を /app/myapp に変更し、
volumes ./app:/app とすることで、コンテナ内外のディレクトリ階層を調整した。

この状態ならfrontコンテナ立ち上げ時に自動で yarn dev が成功し、すぐに localhost:3000 での動作確認が可能となる。

## コンテナに入った初回でやるべきこと （ただしこのリポジトリでは実施済み。やり直したければ、appディレクトリを丸ごと削除してください）
`docker-compose run --rm front sh` で frontコンテナに入ったとき、
最初にいるディレクトリは、WORKDIR の設定に従い `/app/myapp` になっている。

Nextアプリケーション（プロジェクト名：myapp）は、この myapp ディレクトリに中身を丸ごと展開したいので、
下記の手順で階層を一つ上に移動した上で、create next-app する必要がある。

```bash
# /app/myappにいる状態から下記を実行
cd ../
yarn create next-app --typescript # プロジェクト名は myapp で入力
```

## 余談

なお、例えば frontコンテナ内に `docker-compose run --rm front sh` で入った上で、
自分自身で `yarn dev` したとしても、コンテナ外からアクセスすることはできない。
これは、上記コマンドでは `docker-compose up -d` のように docker-compose.yml の port の設定を読んでくれないことが原因である。

参考：
https://bake0937.hatenablog.com/entry/2020/08/31/205125


