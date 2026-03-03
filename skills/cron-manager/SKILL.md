---
name: cron-manager
description: Manage macOS/Linux cron jobs with automatic path resolution and testing. Use when creating, fixing, or debugging scheduled tasks, especially on macOS where path and permission issues are common.
---

# Cron Manager

Manage macOS/Linux cron jobs with automatic path resolution and testing.

## When to Use

- Creating new scheduled tasks
- Fixing broken cron jobs
- Testing cron job functionality
- Converting ~ to absolute paths
- Setting executable permissions

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

## Common Issues Fixed

| Issue | Solution |
|-------|----------|
| `~` not recognized | Auto-convert to `/Users/username` |
| Missing execute permission | Auto `chmod +x` |
| Cron not running | Check service status |
| Path not found | Verify absolute paths |

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

4. **Prefer launchd on macOS**
   - More reliable than cron
   - Supports startup launch
   - Better logging

## macOS Notes

- macOS 10.15+ may restrict cron
- User-level cron needs proper config
- Scripts must have execute permission
- Environment differs from shell

## Dependencies

- bash
- crontab (macOS/Linux)
- launchctl (macOS optional)
