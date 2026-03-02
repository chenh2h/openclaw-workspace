#!/bin/bash
# Todo Manager - 添加待办脚本
# 用法: ./add-todo.sh "待办内容" "截止日期(可选)" "来源消息"

set -e

TODO_CONTENT="$1"
DEADLINE="${2:-$(date -v+1d +%Y-%m-%d)}"  # 默认明天
SOURCE_MESSAGE="$3"
WORKSPACE="$HOME/.openclaw/workspace"
MEMORY_FILE="$WORKSPACE/memory/$(date +%Y-%m-%d).md"

echo "=== 添加待办 ==="
echo "内容: $TODO_CONTENT"
echo "截止日期: $DEADLINE"
echo "来源: $SOURCE_MESSAGE"
echo ""

# 1. 检查或创建今日记忆文件
if [ ! -f "$MEMORY_FILE" ]; then
    echo "# $(date +%Y-%m-%d) - 工作日志" > "$MEMORY_FILE"
    echo "" >> "$MEMORY_FILE"
    echo "## 📅 明日待办 ($DEADLINE)" >> "$MEMORY_FILE"
    echo "" >> "$MEMORY_FILE"
fi

# 2. 添加待办到记忆文件
if ! grep -q "## 📅 明日待办" "$MEMORY_FILE"; then
    echo "" >> "$MEMORY_FILE"
    echo "## 📅 明日待办 ($DEADLINE)" >> "$MEMORY_FILE"
    echo "" >> "$MEMORY_FILE"
fi

cat >> "$MEMORY_FILE" << EOF
- [ ] $TODO_CONTENT
  - **来源**: $SOURCE_MESSAGE
  - **截止日期**: $DEADLINE
EOF

# 3. 更新 MEMORY.md
cd "$WORKSPACE"

# 检查是否已有待办表格，没有则创建
if ! grep -q "## 📋 待跟进事项" MEMORY.md; then
    echo "" >> MEMORY.md
    echo "## 📋 待跟进事项" >> MEMORY.md
    echo "" >> MEMORY.md
    echo "| 事项 | 截止日期 | 状态 | 来源消息 |" >> MEMORY.md
    echo "|------|----------|------|----------|" >> MEMORY.md
fi

# 添加到表格
sed -i '' "/^|------|----------|------|----------|$/a\\
| $TODO_CONTENT | $DEADLINE | ⏳ 待办 | $SOURCE_MESSAGE |" MEMORY.md

# 4. Git 提交并推送
git add -A
git commit -m "todo: $TODO_CONTENT

- 截止日期: $DEADLINE
- 来源: $SOURCE_MESSAGE"
git push origin master

echo ""
echo "✅ 待办已添加并推送到 GitHub"
