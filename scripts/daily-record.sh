#!/bin/bash
# 快捷日报记录系统
# 支持: /done /plan /block /do

ACTION=$1
CONTENT=$2
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M)
RECORD_FILE="$HOME/.openclaw/workspace/memory/daily-records-${DATE}.json"

# 初始化记录文件
if [[ ! -f "$RECORD_FILE" ]]; then
  echo '{
  "date": "'${DATE}'",
  "records": [],
  "summary": {
    "done": 0,
    "plan": 0,
    "block": 0,
    "doing": 0
  }
}' > "$RECORD_FILE"
fi

# 添加记录
add_record() {
  local type=$1
  local content=$2
  
  # 使用 Python 处理 JSON（避免依赖 jq）
  python3 << EOF
import json
import sys

with open('$RECORD_FILE', 'r') as f:
    data = json.load(f)

data['records'].append({
    'time': '$TIME',
    'type': '$type',
    'content': '$content',
    'timestamp': '$(date -Iseconds)'
})

data['summary']['$type'] = data['summary'].get('$type', 0) + 1

with open('$RECORD_FILE', 'w') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print(f'✅ 已记录 [{type}] {content}')
EOF
}

case "$ACTION" in
  done)
    add_record "done" "$CONTENT"
    ;;
  plan)
    add_record "plan" "$CONTENT"
    ;;
  block)
    add_record "block" "$CONTENT"
    ;;
  do|doing)
    add_record "doing" "$CONTENT"
    ;;
  list)
    cat "$RECORD_FILE" 2>/dev/null || echo "今日暂无记录"
    ;;
  report)
    # 生成日报（供 21:00 调用）
    python3 << EOF
import json
from datetime import datetime

with open('$RECORD_FILE', 'r') as f:
    data = json.load(f)

print(f"📅 {data['date']} 工作日报")
print()

if data['records']:
    print("📝 今日记录")
    for r in data['records']:
        icon = {'done': '✅', 'plan': '📋', 'block': '🚧', 'doing': '🔄'}
        print(f"{icon.get(r['type'], '•')} [{r['time']}] {r['content']}")
    print()

print("📊 统计")
for k, v in data['summary'].items():
    if v > 0:
        print(f"  {k}: {v} 项")
EOF
    ;;
  *)
    echo "用法: daily-record [done|plan|block|do|list|report] '内容'"
    echo ""
    echo "示例:"
    echo "  daily-record done '完成了 API 对接'"
    echo "  daily-record plan '明天优化性能'"
    echo "  daily-record block '遇到权限问题'"
    echo "  daily-record do '正在写文档'"
    echo "  daily-record list    # 查看今日记录"
    echo "  daily-record report  # 生成日报"
    ;;
esac
