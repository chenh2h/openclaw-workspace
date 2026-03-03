#!/bin/bash
# 待办提醒脚本
# 每天早上 10:00 检查今日待办和持续待办并发送提醒

TODAY=$(date +%Y-%m-%d)
MEMORY_FILE="$HOME/.openclaw/workspace/memory/$TODAY.md"
PERSISTENT_FILE="$HOME/.openclaw/workspace/memory/persistent-todos.md"
FEISHU_USER_ID="ou_528630cfd2f874a72fb86eb9f99dc138"

LOG_FILE="$HOME/.openclaw/todo-reminder.log"
echo "=== 待办提醒检查 ($(date)) ===" >> "$LOG_FILE"

# 生成提醒内容
REMINDER_CONTENT=""
HAS_TODOS=false

# 1. 检查今日待办 (Daily Todos)
if [[ -f "$MEMORY_FILE" ]]; then
    DAILY_TODOS=$(grep "^- \[ \]" "$MEMORY_FILE" 2>/dev/null || echo "")
    if [[ -n "$DAILY_TODOS" ]]; then
        HAS_TODOS=true
        REMINDER_CONTENT+="📅 今日待办 ($TODAY)"$'\n\n'
        REMINDER_CONTENT+=$(echo "$DAILY_TODOS" | sed 's/^- \[ \] /• /')$'\n\n'
    fi
fi

# 2. 检查持续待办 (Persistent Todos)
if [[ -f "$PERSISTENT_FILE" ]]; then
    # 提取 ## 📌 活跃待办 和 ## ✅ 已完成 之间的内容
    PERSISTENT_TODOS=$(sed -n '/## 📌 活跃待办/,/## ✅ 已完成/p' "$PERSISTENT_FILE" | grep "^- \[ \]" || echo "")
    if [[ -n "$PERSISTENT_TODOS" ]]; then
        HAS_TODOS=true
        REMINDER_CONTENT+="📌 持续跟进"$'\n\n'
        # 提取任务标题和详细信息
        while IFS= read -r line; do
            if [[ "$line" =~ ^- \[ \] ]]; then
                # 提取任务标题
                task_title=$(echo "$line" | sed 's/^- \[ \] \*\*//;s/\*\*$//')
                REMINDER_CONTENT+="• $task_title"$'\n'
            elif [[ "$line" =~ ^[[:space:]]+- ]]; then
                # 提取详细信息 (缩进的子项)
                detail=$(echo "$line" | sed 's/^[[:space:]]*- /  /')
                REMINDER_CONTENT+="$detail"$'\n'
            fi
        done < <(sed -n '/## 📌 活跃待办/,/## ✅ 已完成/p' "$PERSISTENT_FILE" | grep -E "(^- \[ \]|^[[:space:]]+-)")
        REMINDER_CONTENT+=$'\n'
    fi
fi

# 如果没有待办，退出
if [[ "$HAS_TODOS" == false ]]; then
    echo "$(date): 今日无待办事项" >> "$LOG_FILE"
    exit 0
fi

# 生成完整提醒消息
{
    echo "<at user_id=\"$FEISHU_USER_ID\"></at>"
    echo ""
    echo "$REMINDER_CONTENT"
    echo "💡 完成后记得标记 ✅"
} > /tmp/todo-reminder.txt

# 输出到控制台和日志
cat /tmp/todo-reminder.txt
echo "$(date): 提醒内容已生成" >> "$LOG_FILE"

# 发送飞书消息 (使用 openclaw message 命令)
# 注意：需要在 openclaw 环境中运行此脚本
