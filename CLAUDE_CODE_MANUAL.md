# Claude Code 使用手册

> Anthropic 推出的 AI 编程助手，可直接在终端中与 Claude 对话并操作代码

---

## 📋 目录

1. [安装与配置](#安装与配置)
2. [快速开始](#快速开始)
3. [核心命令](#核心命令)
4. [工作流示例](#工作流示例)
5. [与 OpenClaw 集成](#与-openclaw-集成)
6. [常见问题](#常见问题)

---

## 安装与配置

### 系统要求
- macOS 10.15+ / Linux / Windows (WSL)
- Node.js 18+
- Git

### 安装方式

**方式 1: npm 全局安装 (推荐)**
```bash
npm install -g @anthropic-ai/claude-code
```

**方式 2: Homebrew (macOS)**
```bash
brew install anthropic-ai/tap/claude-code
```

**方式 3: 本地项目安装**
```bash
npm install --save-dev @anthropic-ai/claude-code
npx claude
```

### 首次登录
```bash
claude auth login
```
按提示在浏览器中完成授权。

---

## 快速开始

### 启动 Claude Code

```bash
# 在当前目录启动
claude

# 指定项目目录
claude /path/to/project

# 非交互模式执行命令
claude -p "解释这段代码" file.js
```

### 基本交互

```
$ claude
╭────────────────────────────────────────╮
│  Welcome to Claude Code v2.1.29        │
╰────────────────────────────────────────╯

> 你的问题或指令

Claude 会分析代码、执行操作并回复。
```

---

## 核心命令

### 文件操作

| 命令 | 说明 | 示例 |
|------|------|------|
| `/add <file>` | 添加文件到上下文 | `/add src/main.js` |
| `/remove <file>` | 移除文件 | `/remove test.js` |
| `/ls` | 列出项目文件 | `/ls src/` |
| `/cat <file>` | 查看文件内容 | `/cat README.md` |

### 代码操作

| 命令 | 说明 | 示例 |
|------|------|------|
| `/edit <file>` | 编辑文件 | `/edit index.js` |
| `/test` | 运行测试 | `/test` |
| `/lint` | 运行代码检查 | `/lint` |
| `/git <cmd>` | 执行 git 命令 | `/git status` |

### 会话控制

| 命令 | 说明 |
|------|------|
| `/clear` | 清空上下文 |
| `/reset` | 重置会话 |
| `/theme` | 切换主题 |
| `/help` | 显示帮助 |
| `/exit` | 退出 |

### 特殊指令

```bash
# 直接执行代码
!node script.js

# 搜索文件
/find "function name"

# 查看差异
/diff

# 撤销更改
/undo
```

---

## 工作流示例

### 示例 1: 分析代码

```bash
$ claude
> /add src/
> 解释这个项目的主要功能

Claude: 这个项目是一个用户管理系统，包含...
```

### 示例 2: 重构代码

```bash
$ claude src/utils.js
> 将这段回调函数重构为 async/await

Claude: 我来帮你重构...
[显示修改后的代码]
```

### 示例 3: 编写测试

```bash
$ claude
> /add src/calculator.js
> 为这个模块编写单元测试

Claude: 我将创建 calculator.test.js...
```

### 示例 4: 批量修改

```bash
$ claude
> /add src/
> 将所有 console.log 替换为 logger.info

Claude: 找到 15 处需要修改的地方，确认执行吗？
> 确认
[批量修改完成]
```

---

## 与 OpenClaw 集成

### 方式 1: 直接命令行调用

```bash
# OpenClaw 中使用 exec 调用 Claude Code
exec: claude -p "解释代码" file.js
```

### 方式 2: 配置为 ACP 子代理

**步骤 1: 配置 OpenClaw**
```json
// ~/.openclaw/openclaw.json
{
  "agents": {
    "acp": {
      "allowedAgents": ["claude-code"]
    }
  }
}
```

**步骤 2: 创建 Claude Code 子会话**
```yaml
# 在 OpenClaw 中
sessions_spawn:
  task: "实现用户登录功能"
  runtime: "acp"
  agentId: "claude-code"
  label: "auth-module"
```

### 方式 3: 在特定目录启动

```bash
# OpenClaw 中导航到项目目录后
exec: cd /project && claude
```

---

## 高级用法

### 非交互模式 (Scripting)

```bash
# 执行单个命令
claude -p "分析依赖" package.json

# 批量处理
claude -p "修复所有 ESLint 错误" .

# 输出到文件
claude -p "生成 API 文档" src/ > api.md
```

### 配置文件

```json
// ~/.claude/config.json
{
  "theme": "dark",
  "editor": "vscode",
  "autoComplete": true,
  "maxContextFiles": 20
}
```

### 环境变量

```bash
export CLAUDE_CODE_DEBUG=1      # 调试模式
export CLAUDE_CODE_THEME=dark   # 主题
export CLAUDE_API_KEY=xxx       # API Key
```

---

## 常见问题

### Q: Claude Code 和 OpenClaw 有什么区别？

| 特性 | Claude Code | OpenClaw |
|------|-------------|----------|
| 主要用途 | 终端代码助手 | AI 网关/协调器 |
| 交互方式 | 命令行对话 | 多平台消息 |
| 工具调用 | 文件/代码编辑 | 浏览器/文件/各种工具 |
| 最佳场景 | 深度代码工作 | 任务协调/多工具集成 |

**协作方式**: OpenClaw 可以调用 Claude Code 作为子代理处理复杂编码任务。

### Q: 如何更新 Claude Code？

```bash
npm update -g @anthropic-ai/claude-code
# 或
brew upgrade claude-code
```

### Q: 遇到权限错误怎么办？

```bash
# 检查权限
ls -la $(which claude)

# 修复权限
sudo chown -R $(whoami) ~/.claude
```

### Q: 如何清理上下文？

```bash
# 会话中
/clear

# 重置所有
/reset

# 退出重进
/exit
claude
```

---

## 命令速查表

```
启动:     claude [目录]
登录:     claude auth login
退出:     /exit 或 Ctrl+C

文件:     /add, /remove, /ls, /cat
代码:     /edit, /test, /lint, /diff
Git:      /git status, /git commit, /git push
搜索:     /find "关键词"
执行:     !命令

帮助:     /help
主题:     /theme
重置:     /reset
```

---

## 相关链接

- 官方文档: https://docs.anthropic.com/claude-code
- GitHub: https://github.com/anthropics/claude-code
- OpenClaw + Claude Code 集成: https://docs.openclaw.ai

---

*手册版本: 2026-03-02*
*Claude Code 版本: 2.1.29*
