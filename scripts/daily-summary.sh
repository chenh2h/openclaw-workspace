#!/bin/bash
# Daily Summary Script for OpenClaw
# 读取今日工作日志并生成总结（带 @ 用户功能）

TODAY=$(date +%Y-%m-%d)
MEMORY_FILE="$HOME/.openclaw/workspace/memory/$TODAY.md"

# 用户飞书 ID（用于 @）
FEISHU_USER_ID="ou_528630cfd2f874a72fb86eb9f99dc138"

# 检查日志文件是否存在
if [ ! -f "$MEMORY_FILE" ]; then
    # 控制台输出
    echo "📅 今日工作总结 ($TODAY)"
    echo ""
    echo "⚠️ 今日未记录工作日志"
    
    # 飞书格式输出（带 @）
    echo ""
    echo "FEISHU_FORMAT:"
    echo "<at user_id=\"$FEISHU_USER_ID\"></at>"
    echo "📅 今日工作总结 ($TODAY)"
    echo ""
    echo "⚠️ 今日未记录工作日志"
    exit 0
fi

# 生成总结内容
COMPLETED=$(grep "^### " "$MEMORY_FILE" | sed 's/^### /• /' | head -10)
TODO_COUNT=$(grep -c "^- \[ \]" "$MEMORY_FILE" 2>/dev/null || echo "0")
TODOS=$(grep "^- \[ \]" "$MEMORY_FILE" | sed 's/^- \[ \] /• /' | head -5)
LESSONS=$(grep "^\d\+\. \*\*" "$MEMORY_FILE" | sed 's/^\d\+\. /• /' | head -3)

# 控制台输出
echo "📅 今日工作总结 ($TODAY)"
echo ""
echo "✅ 已完成:"
echo "$COMPLETED"
echo ""

if [ "$TODO_COUNT" -gt 0 ]; then
    echo "📝 待办事项 ($TODO_COUNT):"
    echo "$TODOS"
else
    echo "📝 待办事项: 无"
fi

echo ""

if [ -n "$LESSONS" ]; then
    echo "💡 今日经验:"
    echo "$LESSONS"
fi

echo ""
echo "---"
echo "📊 详细日志: https://github.com/chenh2h/openclaw-workspace/blob/master/memory/$TODAY.md"

# 飞书格式输出（带 @）
echo ""
echo "FEISHU_FORMAT:"
echo "<at user_id=\"$FEISHU_USER_ID\"></at>"
echo "📅 今日工作总结 ($TODAY)"
echo ""
echo "✅ 已完成:"
echo "$COMPLETED"
echo ""

if [ "$TODO_COUNT" -gt 0 ]; then
    echo "📝 待办事项 ($TODO_COUNT):"
    echo "$TODOS"
else
    echo "📝 待办事项: 无"
fi

if [ -n "$LESSONS" ]; then
    echo ""
    echo "💡 今日经验:"
    echo "$LESSONS"
fi

echo ""
echo "📊 详细日志: https://github.com/chenh2h/openclaw-workspace/blob/master/memory/$TODAY.md"
