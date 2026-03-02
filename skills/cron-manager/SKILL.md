# Cron Manager Skill

## 描述
管理 macOS/Linux 定时任务的 Skill，解决常见 crontab 问题。

## 功能

### 1. 创建定时任务

自动处理：
- 路径转换为绝对路径（解决 `~` 不认问题）
- 权限设置
- 测试验证

### 2. 修复定时任务

常见修复：
- 路径问题（`~` → `/Users/xxx`）
- 权限问题（+x 执行权限）
- 服务状态（cron 是否运行）

### 3. 测试验证

创建后立即测试：
- 添加测试任务（每分钟执行）
- 等待 70 秒验证
- 查看日志输出

## 使用方法

### 创建新任务

```bash
./cron-manager.sh add \
  --name "daily-backup" \
  --schedule "0 12 * * *" \
  --command "/path/to/backup.sh" \
  --test
```

### 修复现有任务

```bash
./cron-manager.sh fix \
  --check-path \
  --check-perm \
  --check-service
```

### 查看所有任务

```bash
./cron-manager.sh list
```

### 删除任务

```bash
./cron-manager.sh remove --name "task-name"
```

## 最佳实践

1. **始终使用绝对路径**
   ```
   ❌ ~/.openclaw/script.sh
   ✅ /Users/username/.openclaw/script.sh
   ```

2. **创建后立即测试**
   - 使用 `--test` 参数
   - 或手动添加每分钟测试任务

3. **检查日志**
   - 输出重定向到日志文件
   - 定期检查日志是否存在

4. **macOS 推荐使用 launchd**
   - 比 cron 更可靠
   - 支持开机启动
   - 更好的日志管理

## 注意事项

- macOS 10.15+ 中 cron 可能受限
- 用户级 cron 需要正确配置
- 脚本必须有可执行权限
- 环境变量可能与 shell 不同

## 依赖

- bash
- crontab (macOS/Linux)
- launchctl (macOS 可选)
