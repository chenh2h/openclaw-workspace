#!/bin/bash
# 用户工作日报记录系统
# 记录您的工作成果，生成给领导看的日报
# 
# ⚠️ 注意区分：
# - 您的日报 → 记录您的工作 → 给领导看 → 用这个脚本
# - AI日报 → 记录 AI 助手工作 → 给您看 → 另一个系统

ACTION=$1
CONTENT=$2
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M)
# 用户日报存储路径（区分于 AI 工作日志）
RECORD_FILE="$HOME/.openclaw/workspace/memory/user-daily-records-${DATE}.json"
REPORT_FILE="$HOME/.openclaw/workspace/memory/user-daily-report-${DATE}.md"

# 初始化记录文件
if [[ ! -f "$RECORD_FILE" ]]; then
  echo '{
  "date": "'${DATE}'",
  "user": "'$(whoami)'",
  "records": [],
  "summary": {
    "done": 0,
    "doing": 0,
    "block": 0,
    "plan": 0
  }
}' > "$RECORD_FILE"
fi

# 添加记录
add_record() {
  local type=$1
  local content=$2
  
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

# 生成给领导的日报
generate_report() {
  python3 << EOF
import json
from datetime import datetime

with open('$RECORD_FILE', 'r') as f:
    data = json.load(f)

report = f"""# 工作日报 ({data['date']})

## 今日总结

"""

# 分类输出
sections = {
    'done': ('✅ 今日完成', []),
    'doing': ('🔄 进行中', []),
    'block': ('🚧 需要协调', [])
}

for r in data['records']:
    if r['type'] in sections:
        sections[r['type']][1].append(f"• {r['content']}")

for type_key, (title, items) in sections.items():
    if items:
        report += f"\n{title}\n"
        for item in items:
            report += f"{item}\n"

# 明日计划
plans = [r for r in data['records'] if r['type'] == 'plan']
if plans:
    report += "\n## 明日计划\n\n"
    for p in plans:
        report += f"• {p['content']}\n"

report += f"""
---
*生成时间: {datetime.now().strftime('%H:%M')}*
*记录方式: 快捷指令系统*
"""

with open('$REPORT_FILE', 'w') as f:
    f.write(report)

print(report)
print(f"\n📄 日报已保存: $REPORT_FILE")
EOF
}

case "$ACTION" in
  done)
    add_record "done" "$CONTENT"
    ;;
  do|doing)
    add_record "doing" "$CONTENT"
    ;;
  plan)
    add_record "plan" "$CONTENT"
    ;;
  block)
    add_record "block" "$CONTENT"
    ;;
  list)
    cat "$RECORD_FILE" 2>/dev/null || echo "今日暂无记录"
    ;;
  report)
    generate_report
    ;;
  *)
    echo "用户工作日报记录系统"
    echo ""
    echo "用法: daily-record [done|do|plan|block|list|report] '内容'"
    echo ""
    echo "示例:"
    echo "  daily-record done '完成了用户模块开发'    # 记录已完成"
    echo "  daily-record do '正在写测试用例'          # 记录进行中"
    echo "  daily-record plan '明天优化性能'          # 记录计划"
    echo "  daily-record block '需要产品确认'         # 记录阻塞"
    echo "  daily-record list                         # 查看今日记录"
    echo "  daily-record report                       # 生成给领导的日报"
    echo ""
    echo "⚠️  注意: 这是记录您的工作，不是 AI 助手的工作"
    ;;
esac
