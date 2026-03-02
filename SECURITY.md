# 🔒 安全配置说明

> 本文档记录 OpenClaw Workspace 的安全设置和备份配置

## ✅ 已配置的安全措施

### 1. 文件权限

| 路径 | 权限 | 说明 |
|------|------|------|
| `~/.openclaw/workspace/` | `700` (drwx------) | 仅所有者可读写执行 |
| `*.md` 文件 | `600` (-rw-------) | 仅所有者可读写 |
| `backup.sh` | `755` (-rwxr-xr-x) | 可执行脚本 |

### 2. Git 版本控制

- **仓库位置**: `~/.openclaw/workspace/.git`
- **初始提交**: `21f48e1` - OpenClaw workspace with security setup
- **当前分支**: master
- **状态**: 干净（无未提交更改）

### 3. .gitignore 配置

排除以下文件：
- 敏感信息: `*.key`, `*.secret`, `.env`, `credentials.json`
- 临时文件: `*.tmp`, `*.log`, `.DS_Store`
- 编辑器配置: `.vscode/`, `.idea/`
- 依赖: `node_modules/`
- 大文件: `*.mp4`, `*.zip`, `*.tar.gz`

### 4. 自动备份系统

**备份脚本**: `~/.openclaw/backup.sh`

**功能**:
- Git 自动提交更改
- 创建压缩备份 (tar.gz)
- 保留最近30个备份
- 记录备份日志

**定时任务**: 每天中午12:00
```
0 12 * * * /Users/chenliang0307/.openclaw/backup.sh >> /Users/chenliang0307/.openclaw/backup.log 2>&1
```

**备份位置**: `~/Backups/openclaw/`

**日志文件**: `~/.openclaw/backup.log`

## 📋 日常操作指南

### 手动备份
```bash
~/.openclaw/backup.sh
```

### 查看备份历史
```bash
ls -lh ~/Backups/openclaw/
tail ~/.openclaw/backup.log
```

### 恢复文件（从 Git）
```bash
cd ~/.openclaw/workspace
git checkout HEAD -- filename
```

### 恢复整个 Workspace（从备份）
```bash
# 解压备份
tar xzf ~/Backups/openclaw/workspace_YYYYMMDD_HHMMSS.tar.gz -C ~/.openclaw/
```

## ⚠️ 安全提醒

1. **敏感信息**: 绝不将密码、密钥写入任何文件
2. **外部共享**: 私聊内容不泄露到群聊
3. **删除操作**: 使用 `trash` 而非 `rm`
4. **权限变更**: 修改权限后需检查是否影响功能

## 🔄 备份策略

- **频率**: 每天1次（中午12点）
- **保留**: 最近30个压缩备份
- **Git**: 每次更改自动提交
- **日志**: 保留最近100条记录

---

*配置完成时间: 2026-03-02*
*备份脚本: ~/.openclaw/backup.sh*
