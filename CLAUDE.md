# Claude on Docker

Docker コンテナ内で Claude Code を `--dangerously-skip-permissions` 付きで安全に実行するための環境。

## クイックスタート

```bash
cp .env.example .env
# .env に ANTHROPIC_API_KEY を設定
make run
```

## コマンド

- `make build` — Docker イメージをビルド
- `make run` — Claude Code をインタラクティブに起動（ファイアウォール有効）
- `make run-no-firewall` — ファイアウォール無しで起動
- `make shell` — コンテナ内の bash シェルに入る
- `make clean` — イメージとボリュームを削除

## アーキテクチャ

- **Dockerfile**: Node.js 20 ベース、Claude Code CLI + システムツールをインストール
- **init-firewall.sh**: iptables で許可ドメイン以外へのアウトバウンド通信をブロック
- **entrypoint.sh**: ファイアウォール初期化後、Claude Code を起動
- **workspace/**: ここにプロジェクトを配置。ホストとコンテナで双方向に同期される

## ファイアウォール

デフォルトで有効。以下のドメインのみ HTTPS 通信を許可:
- api.anthropic.com
- registry.npmjs.org
- github.com / api.github.com
- sentry.io
- statsig.anthropic.com

`make run-no-firewall` で無効化可能。
