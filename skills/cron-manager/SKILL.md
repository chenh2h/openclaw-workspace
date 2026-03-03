---
name: cron-manager
description: Manage macOS/Linux cron jobs with automatic path resolution, testing, and Heartbeat integration. Use when creating, fixing, or debugging scheduled tasks, especially on macOS where path and permission issues are common. Includes best practices for AI-agent coordinated task execution.
---

# Cron Manager

Manage macOS/Linux cron jobs with automatic path resolution, testing, and Heartbeat integration.

## When to Use

- Creating new scheduled tasks
- Fixing broken cron jobs
- Testing cron job functionality
- Converting ~ to absolute paths
- Setting executable permissions
- **Coordinating with Heartbeat for AI-agent task reporting**

---

## Quick Start

### Create Task

```bash
./cron-manager.sh add \
  --name "daily-backup" \
  --schedule "0 12 * * *" \
  --command "/path/to/backup.sh" \
  --test
```

### Fix Existing Task

```bash
./cron-manager.sh fix \
  --check-path \
  --check-perm \
  --check-service
```

### List All Tasks

```bash
./cron-manager.sh list
```

### Remove Task

```bash
./cron-manager.sh remove --name "task-name"
```

---

## 🎯 Heartbeat Integration Pattern

**Every cron task that needs AI-agent reporting MUST follow this pattern:**

### Step 1: Create the Task Script

```bash
#!/bin/bash
# task-name.sh

# 1. 执行任务
# ... 任务逻辑 ...

# 2. 生成结果文件
echo "结果" > /path/to/result.txt

# 3. 记录状态（供 Heartbeat 检查）
echo '{"lastRun": "'$(date -Iseconds)'", "status": "success"}' \
  > ~/.openclaw/heartbeat-state.json
```

### Step 2: Add to Crontab

```bash
0 10 * * * /Users/username/.openclaw/workspace/scripts/task-name.sh
```

### Step 3: Add Heartbeat Check Point

在 `HEARTBEAT.md` 中添加：

```markdown
## 📋 XX:00 [任务名称] 检查

**触发条件**: Heartbeat 在 XX:00-XX+1:00 之间执行

**检查清单**:
- [ ] 检查 [结果文件] 是否存在
- [ ] 检查文件时间戳是否为今日
- [ ] 读取任务执行状态

**执行动作**:
```
[汇报内容模板]
```

**完成后操作**:
- [ ] [后续操作1]
- [ ] [后续操作2]
```

### Step 4: Complete the Loop

```
Cron 定时触发
    ↓
脚本执行任务
    ↓
生成结果文件
    ↓
Heartbeat 检查发现
    ↓
AI 生成汇报
    ↓
发送消息给用户
    ↓
执行后续操作
```

---

## Common Issues Fixed

| Issue | Solution |
|-------|----------|
| `~` not recognized | Auto-convert to `/Users/username` |
| Missing execute permission | Auto `chmod +x` |
| Cron not running | Check service status |
| Path not found | Verify absolute paths |
| **No AI reporting** | Add Heartbeat check point |

---

## Best Practices

1. **Always use absolute paths**
   ```
   ❌ ~/.openclaw/script.sh
   ✅ /Users/username/.openclaw/script.sh
   ```

2. **Test immediately after creation**
   - Use `--test` flag
   - Or add per-minute test job

3. **Check logs**
   - Redirect output to log file
   - Review logs regularly

4. **Heartbeat Integration**
   - Every task needs a check point
   - Generate machine-readable status
   - Include timestamps for verification

5. **Prefer launchd on macOS**
   - More reliable than cron
   - Supports startup launch
   - Better logging

---

## Example: Complete Task with Heartbeat

### 1. Create Script

```bash
#!/bin/bash
# daily-report.sh

TODAY=$(date +%Y-%m-%d)
REPORT_FILE="$HOME/.openclaw/workspace/memory/daily-$TODAY.md"

# Generate report
cat > "$REPORT_FILE" << EOF
# Daily Report ($TODAY)

## Summary
Generated at $(date)

## Details
...
EOF

# Update state for Heartbeat
cat > "$HOME/.openclaw/heartbeat-state.json" << EOF
{
  "dailyReport": {
    "lastRun": "$TODAY",
    "file": "$REPORT_FILE",
    "status": "completed"
  }
}
EOF

echo "Report generated: $REPORT_FILE"
```

### 2. Add to Crontab

```bash
0 21 * * * /Users/username/.openclaw/workspace/scripts/daily-report.sh
```

### 3. Add to HEARTBEAT.md

```markdown
## 📋 21:00 日报检查

**检查清单**:
- [ ] 检查 `heartbeat-state.json` 中的 `dailyReport`
- [ ] 确认 `lastRun` 为今日
- [ ] 读取报告文件内容

**执行动作**:
发送工作日报给用户

**完成后**:
- [ ] 提交到 GitHub
```

---

## macOS Notes

- macOS 10.15+ may restrict cron
- User-level cron needs proper config
- Scripts must have execute permission
- Environment differs from shell

## Dependencies

- bash
- crontab (macOS/Linux)
- launchctl (macOS optional)

---

## Related Files

- `HEARTBEAT.md` - Check point definitions
- `memory/heartbeat-state.json` - Task status tracking
- `scripts/*.sh` - Task scripts

---

*Version: 2.0 - With Heartbeat Integration*
