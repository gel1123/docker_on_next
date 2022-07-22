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

元記事の手順だと、(環境によっては) コンテナ外から見て `./app/myapp/myapp` に Next.jsアプリケーションが構築されてしまう。
（末尾のmyappは create next app 時のプロジェクト名）

そのため WORKDIR である コンテナ内の `/app`直下 には Next.jsアプリケーションが存在せず、
frontコンテナ立ち上げ時の yarn dev に失敗してしまっていた。

そのため、WORKDIR を /app/myapp に変更し、
volumes ./app:/app とすることで、コンテナ内外のディレクトリ階層を調整した。

この状態ならfrontコンテナ立ち上げ時に自動で yarn dev が成功し、すぐに localhost:3000 での動作確認が可能となる。
