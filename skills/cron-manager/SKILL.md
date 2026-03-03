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

### Critical: Avoid Race Conditions

**Problem**: Task runs at 10:00, Heartbeat checks at 10:00, but task takes 5 minutes

**Solution**: Time offset + Status file

```
Cron Schedule        Heartbeat Check
    10:00  ───────┐      10:05  ───────┐
    (execute)     │      (detect)      │
                  ▼                    ▼
            Generate file      Read file + status
                  │                    │
                  └────────┬───────────┘
                           │
                    5-minute buffer
```

### Step 1: Create the Task Script

```bash
#!/bin/bash
# task-name.sh

# 1. Mark as running (prevent race condition)
echo '{"status": "running", "startedAt": "'$(date -Iseconds)'"}' \
  > ~/.openclaw/task-status.json

# 2. Execute task
# ... 任务逻辑 ...

# 3. Generate result file
echo "结果" > /path/to/result.txt

# 4. Mark as completed
echo '{
  "status": "completed",
  "startedAt": "'$(date -Iseconds)'",
  "completedAt": "'$(date -Iseconds)'",
  "resultFile": "/path/to/result.txt"
}' > ~/.openclaw/task-status.json
```

### Step 2: Schedule with Offset

```bash
# Crontab: Task at :00, Heartbeat at :05
0 10 * * * /Users/username/.openclaw/workspace/scripts/task-name.sh
```

### Step 3: Add Heartbeat Check Point

In `HEARTBEAT.md`:

```markdown
## 📋 10:05 [任务名称] 检查

**检测窗口**: 10:05 - 10:30

**检查逻辑**:
1. 读取 `task-status.json`
2. If status = "completed" → 立即汇报
3. If status = "running" → 等待 2 分钟重试
4. If no status file → 检查昨日文件作为 fallback

**重试策略**:
- 最多重试 3 次
- 每次间隔 2 分钟
- 超过 10:30 未检测到 → 发送异常警告
```

### Step 4: Heartbeat Detection Logic

```javascript
// Pseudocode for Heartbeat check
function checkTask() {
  const status = readStatusFile();
  
  if (status.status === 'completed') {
    return generateReport(status);
  }
  
  if (status.status === 'running') {
    if (retryCount < 3) {
      retryCount++;
      setTimeout(checkTask, 2 * 60 * 1000); // 2分钟后重试
      return null; // 暂不汇报
    }
  }
  
  // Timeout or error
  return sendWarning('Task may have failed');
}
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
