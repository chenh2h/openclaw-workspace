#!/bin/bash
# Daily Summary Script for OpenClaw
# 读取今日工作日志并生成总结

TODAY=$(date +%Y-%m-%d)
MEMORY_FILE="$HOME/.openclaw/workspace/memory/$TODAY.md"

# 检查日志文件是否存在
if [ ! -f "$MEMORY_FILE" ]; then
    echo "📅 今日工作总结 ($TODAY)"
    echo ""
    echo "⚠️ 今日未记录工作日志"
    exit 0
fi

# 生成总结
echo "📅 今日工作总结 ($TODAY)"
echo ""

# 提取完成的任务
echo "✅ 已完成:"
grep "^### " "$MEMORY_FILE" | sed 's/^### /• /' | head -10

echo ""

# 提取待办
TODO_COUNT=$(grep -c "^- \[ \]" "$MEMORY_FILE" 2>/dev/null || echo "0")
if [ "$TODO_COUNT" -gt 0 ]; then
    echo "📝 待办事项 ($TODO_COUNT):"
    grep "^- \[ \]" "$MEMORY_FILE" | sed 's/^- \[ \] /• /' | head -5
else
    echo "📝 待办事项: 无"
fi

echo ""

# 提取经验教训
if grep -q "^## 💡 经验教训" "$MEMORY_FILE"; then
    echo "💡 今日经验:"
    grep "^\d\+\. \*\*" "$MEMORY_FILE" | sed 's/^\d\+\. /• /' | head -3
fi

echo ""
echo "---"
echo "📊 详细日志: https://github.com/chenh2h/openclaw-workspace/blob/master/memory/$TODAY.md"
