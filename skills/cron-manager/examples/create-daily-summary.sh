#!/bin/bash
# 定时任务创建示例
# 使用 cron-manager skill 创建每日总结任务

cd "$(dirname "$0")"

# 设置变量
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
USER_HOME="$HOME"
SUMMARY_SCRIPT="$USER_HOME/.openclaw/workspace/scripts/daily-summary.sh"

# 确保脚本存在且有执行权限
if [[ ! -f "$SUMMARY_SCRIPT" ]]; then
    echo "❌ 找不到脚本: $SUMMARY_SCRIPT"
    exit 1
fi

chmod +x "$SUMMARY_SCRIPT"

# 使用绝对路径
echo "创建定时任务..."
echo "  脚本路径: $SUMMARY_SCRIPT"
echo "  周一、周二、周四: 21:00"
echo "  周三、周五: 18:00"

# 先修复现有问题（如果有）
echo ""
echo "步骤 1: 修复路径问题..."
./cron-manager.sh fix --check-path

# 添加任务（使用绝对路径）
echo ""
echo "步骤 2: 添加周一、周二、周四任务 (21:00)..."
./cron-manager.sh add \
    --name "daily-summary-late" \
    --schedule "0 21 * * 1,2,4" \
    --command "$SUMMARY_SCRIPT"

echo ""
echo "步骤 3: 添加周三、周五任务 (18:00)..."
./cron-manager.sh add \
    --name "daily-summary-early" \
    --schedule "0 18 * * 3,5" \
    --command "$SUMMARY_SCRIPT"

echo ""
echo "步骤 4: 验证所有任务..."
./cron-manager.sh list

echo ""
echo "✅ 定时任务创建完成！"
echo ""
echo "注意:"
echo "  - 使用绝对路径: $SUMMARY_SCRIPT"
echo "  - 避免使用 ~ 符号"
echo "  - 脚本已设置可执行权限"
echo ""
echo "明天 (周二) 21:00 将首次触发！"
