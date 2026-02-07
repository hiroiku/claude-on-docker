# Claude on Docker

Docker コンテナ内で Claude Code を `--dangerously-skip-permissions` 付きで安全に実行するための環境。

## セットアップ

```bash
# workspace/ に作業対象のプロジェクトを配置
cp -r /path/to/my-project ./workspace/my-project

# ビルド＆起動
docker compose run --rm claude

# Claude Code が起動したら対話的に API キーを設定
```

## コマンド

```bash
# イメージをビルド
docker compose build

# Claude Code をインタラクティブに起動
docker compose run --rm claude

# 起動中のコンテナに bash で入る
docker compose exec claude bash

# イメージとボリュームを削除
docker compose down --rmi all --volumes
```
