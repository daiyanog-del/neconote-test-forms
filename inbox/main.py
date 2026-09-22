"""
neconote-test-forms 受信サーバー（テスト用）

フォーム営業の検証用ダミーサイト（thanks.html）から送信された内容を
メモリ上に一時保存し、Render のログにも出力する。

- POST /submissions : 送信内容を1件受け取り保存する
- GET  /submissions : 保存中の一覧を新しい順で返す
- GET  /health      : ヘルスチェック

認証なし・テスト用の公開データのみを扱う想定。
"""

import json
from datetime import datetime, timezone

from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# CORS: GitHub Pages の公開元のみ許可する
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://daiyanog-del.github.io"],
    allow_methods=["POST", "GET"],
    allow_headers=["Content-Type"],
)

# メモリ上の保存領域（再起動で消える）。最大200件、古いものから捨てる。
MAX_RECORDS = 200
MAX_FIELDS = 50
MAX_FIELD_VALUE_LEN = 5000
MAX_BODY_BYTES = 64 * 1024

_records: list[dict] = []
_next_id = 1


@app.get("/health")
async def health():
    return {"ok": True}


@app.post("/submissions")
async def create_submission(request: Request):
    global _next_id

    raw_body = await request.body()
    if len(raw_body) > MAX_BODY_BYTES:
        raise HTTPException(status_code=413, detail="request body too large")

    try:
        payload = json.loads(raw_body)
    except json.JSONDecodeError:
        raise HTTPException(status_code=400, detail="invalid JSON body")

    if not isinstance(payload, dict):
        raise HTTPException(status_code=400, detail="invalid JSON body")

    page = payload.get("page")
    received_at = payload.get("received_at")
    fields = payload.get("fields")

    if not isinstance(fields, dict):
        raise HTTPException(status_code=400, detail="fields must be an object")

    # fields の件数・各値の長さを上限で切り詰める
    truncated_fields = {}
    for i, (key, value) in enumerate(fields.items()):
        if i >= MAX_FIELDS:
            break
        value_str = str(value)
        truncated_fields[str(key)] = value_str[:MAX_FIELD_VALUE_LEN]

    record = {
        "id": _next_id,
        "page": page,
        "received_at": received_at,
        "fields": truncated_fields,
        "server_received_at": datetime.now(timezone.utc).isoformat(),
    }
    _next_id += 1

    _records.append(record)
    if len(_records) > MAX_RECORDS:
        # 古いものから捨てる
        del _records[: len(_records) - MAX_RECORDS]

    # Render のログで確認できるよう標準出力にも1行で出す
    print(json.dumps(record, ensure_ascii=False), flush=True)

    return {"ok": True, "id": record["id"]}


@app.get("/submissions")
async def list_submissions():
    return list(reversed(_records))
