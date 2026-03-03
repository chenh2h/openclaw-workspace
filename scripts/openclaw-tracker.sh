#!/bin/bash
# OpenClaw 每日进展追踪脚本
# 每天 12:00 执行，搜索最新信息并整理文档

TODAY=$(date +%Y-%m-%d)
REPORT_DIR="$HOME/.openclaw/workspace/memory"
REPORT_FILE="${REPORT_DIR}/openclaw-news-${TODAY}.md"
FEISHU_USER_ID="ou_528630cfd2f874a72fb86eb9f99dc138"
LOG_FILE="$HOME/.openclaw/openclaw-tracker.log"

echo "=== OpenClaw 进展追踪 (${TODAY} $(date +%H:%M)) ===" >> "$LOG_FILE"

# 获取最新 release 信息
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/openclaw/openclaw/releases/latest" 2>/dev/null)
TAG_NAME=$(echo "$LATEST_RELEASE" | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": "\([^"]*\)".*/\1/')
PUBLISHED_AT=$(echo "$LATEST_RELEASE" | grep '"published_at"' | head -1 | sed 's/.*"published_at": "\([^"]*\)".*/\1/' | cut -d'T' -f1)

# 获取最新 commits
RECENT_COMMITS=$(curl -s "https://api.github.com/repos/openclaw/openclaw/commits?per_page=5" 2>/dev/null)

# 创建报告
cat > "$REPORT_FILE" << EOF
# OpenClaw 每日进展报告 (${TODAY})

> 自动生成的每日进展追踪报告
> 数据来源：GitHub Releases, Changelog

---

## 🚀 最新版本

**${TAG_NAME}** - ${PUBLISHED_AT} 发布
https://github.com/openclaw/openclaw/releases/tag/${TAG_NAME}

## 📝 今日动态

### 最新提交

EOF

# 添加 commits 到报告
echo "$RECENT_COMMITS" | grep -E '"message"|"name"|"date"' | head -30 | while read -r line; do
  if [[ "$line" == *'"message"'* ]]; then
    msg=$(echo "$line" | sed 's/.*"message": "\([^"]*\)".*/\1/' | head -1)
    echo "- **${msg}**" >> "$REPORT_FILE"
  elif [[ "$line" == *'"name"'* ]]; then
    author=$(echo "$line" | sed 's/.*"name": "\([^"]*\)".*/\1/')
    echo "  - 作者：${author}" >> "$REPORT_FILE"
  fi
done

# 添加历史链接
cat >> "$REPORT_FILE" << EOF

---

## 📁 历史报告

EOF

ls -1t ${REPORT_DIR}/openclaw-news-*.md 2>/dev/null | head -7 | while read f; do
  date_str=$(basename "$f" | sed 's/openclaw-news-//;s/.md//')
  if [[ "$date_str" != "$TODAY" ]]; then
    echo "- [${date_str}]($f)" >> "$REPORT_FILE"
  fi
done

cat >> "$REPORT_FILE" << EOF

---

*报告生成时间：$(date "+%Y-%m-%d %H:%M")*
*下次更新：每天 12:00*
EOF

echo "报告已生成: $REPORT_FILE" >> "$LOG_FILE"

# 发送飞书通知
{
  echo "<at user_id=\"$FEISHU_USER_ID\"></at>"
  echo ""
  echo "📰 OpenClaw 每日进展报告 (${TODAY})"
  echo ""
  echo "最新版本：${TAG_NAME}"
  echo ""
  echo "📄 完整报告：${REPORT_FILE}"
  echo ""
  echo "🔍 关键更新："
  echo "- 查看最新 release 详情"
  echo "- 查看今日 commits"
  echo "- 关注 breaking changes"
} > /tmp/openclaw-report-notify.txt

# 输出到日志
cat /tmp/openclaw-report-notify.txt >> "$LOG_FILE"
