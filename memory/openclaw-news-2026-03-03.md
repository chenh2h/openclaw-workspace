# OpenClaw 每日进展报告 (2026-03-03)

> 自动生成的每日进展追踪报告
> 数据来源：GitHub Releases, Changelog, 社区动态

---

## 🚀 最新版本

**v2026.3.2** - 2026-03-03 发布
https://github.com/openclaw/openclaw/releases/tag/v2026.3.2

### 📦 主要更新

#### 🔐 Secrets/SecretRef 全面支持
- 扩展 SecretRef 支持至 64 个用户凭证目标
- 支持运行时收集器、`openclaw secrets` 规划/应用/审计流程
- 未解析引用现在在活跃表面快速失败

#### 📄 PDF 分析工具
- 新增原生 `pdf` 工具
- 支持 Anthropic 和 Google PDF 提供商
- 非原生模型自动降级处理
- 可配置：`agents.defaults.pdfModel`, `pdfMaxBytesMb`, `pdfMaxPages`

#### 📎 Sessions/Attachments 内联附件
- 支持 `sessions_spawn` 内联文件附件（仅子代理运行时）
- Base64/utf8 编码支持
- 可配置限制：`tools.sessions_spawn.attachments`

#### 📱 Telegram 改进
- 默认启用 `partial` 流式传输（原为 `off`）
- DM 草稿流式传输优化
- 可选 `disableAudioPreflight` 跳过语音提及检测

#### 🔧 其他新增
- **CLI 配置验证**：`openclaw config validate` 命令
- **Memory/Ollama 嵌入**：支持 Ollama 嵌入提供商
- **Zalo Personal 插件**：原生 `zca-js` 集成
- **Plugin SDK 扩展**：`channelRuntime`, `stt.transcribeAudioFile`
- **Hooks 增强**：`message:transcribed`, `message:preprocessed`

### ⚠️ Breaking Changes

1. **Onboarding 默认工具**：新安装默认 `tools.profile = "messaging"`
2. **ACP 分派默认启用**：默认启用，需显式禁用
3. **Plugin SDK**：移除 `api.registerHttpHandler`，改用 `api.registerHttpRoute`
4. **Zalo Personal**：不再依赖外部 CLI 二进制文件

### 🔧 重要修复

- **Feishu**：提及检测、多应用路由、会话内存钩子
- **Telegram**：重复令牌检查、令牌规范化
- **Discord**：生命周期启动状态
- **安全强化**：Webhook 认证、插件 HTTP 路由、浏览器输出边界
- **浏览器**：CDP 启动诊断、扩展中继重连
- **沙盒**：工作区挂载权限、fsPolicy 传播

---

## 📊 今日 Commit 动态

### 最新提交（前5条）

1. **fix(telegram): prevent duplicate messages in DM draft streaming mode**
   - 修复 DM 流式传输中的重复消息问题
   - 作者：OpenCils

2. **fix(heartbeat): scope exec wake dispatch to session key**
   - 限制 exec 触发的心跳唤醒到代理会话键
   - 作者：altaywtf

3. **fix: guard malformed Telegram replies and pass hook accountId**
   - 防护格式错误的 Telegram 回复
   - 作者：Ayaan Zaidi

4. **docs: update changelog for telegram message_sent fix**
   - 更新 changelog
   - 作者：Ayaan Zaidi

---

## 💡 值得关注

### 高优先级更新
- ✅ **PDF 工具** - 原生支持，提升文档处理能力
- ✅ **SecretRef 扩展** - 更安全的凭证管理
- ✅ **Telegram 流式传输默认启用** - 更好的用户体验

### 安全修复
- 🔒 Webhook 请求硬化
- 🔒 浏览器输出边界检查
- 🔒 插件 HTTP 路由安全
- 🔒 配置备份权限修复

---

## 📁 历史报告

- 2026-03-03 - 当前报告

---

*报告生成时间：2026-03-03 20:30*
*下次更新：每天 12:00*
