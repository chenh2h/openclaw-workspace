# 飞书汇报应用对接方案

## 📋 飞书汇报应用简介

飞书「汇报」应用支持：
- 创建自定义汇报模板
- API 提交汇报内容
- 定时提醒和汇总

## 🔧 对接步骤

### 步骤 1：创建汇报模板（飞书管理后台）

1. 打开飞书管理后台 → 应用管理 → 汇报
2. 创建新模板：「工作日报」
3. 添加字段：
   - 今日完成（多行文本）
   - 进行中（多行文本）
   - 遇到的问题（多行文本）
   - 明日计划（多行文本）

### 步骤 2：获取模板 ID

创建后，从 URL 获取模板 ID：
```
https://open.feishu.cn/open-apis/report/v1/templates/{TEMPLATE_ID}
```

### 步骤 3：申请 API 权限

需要以下权限：
- `report:report:write` - 创建汇报
- `report:report:read` - 读取汇报

### 步骤 4：配置 OpenClaw

在 `~/.openclaw/config.yaml` 中添加：

```yaml
feishu:
  report:
    enabled: true
    templateId: "your-template-id"
    autoSubmit: true  # 自动提交或仅生成预览
    submitTime: "21:00"  # 自动提交时间
```

## 📡 API 调用示例

### 创建汇报

```bash
curl -X POST "https://open.feishu.cn/open-apis/report/v1/reports" \
  -H "Authorization: Bearer ${FEISHU_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "template_id": "your-template-id",
    "content": {
      "今日完成": "• 完成了 API 对接\n• 修复了登录 bug",
      "进行中": "• 正在写技术文档",
      "遇到的问题": "• 权限申请还在审批中",
      "明日计划": "• 优化性能\n• 完成文档"
    }
  }'
```

## 🔄 数据流转设计

```
白天随时输入
    ↓
/done /do /plan /block
    ↓
记录到 daily-records-YYYY-MM-DD.json
    ↓
21:00 自动触发
    ↓
读取记录文件
    ↓
生成飞书汇报格式
    ↓
调用飞书汇报 API
    ↓
提交到飞书汇报应用
    ↓
发送确认消息给您
```

## 📝 快捷指令使用

### 指令列表

| 指令 | 说明 | 示例 |
|------|------|------|
| `/done` | 已完成 | `/done 完成了 API 对接` |
| `/do` | 进行中 | `/do 正在写技术文档` |
| `/plan` | 明日计划 | `/plan 优化系统性能` |
| `/block` | 阻塞问题 | `/block 权限申请未通过` |

### 使用场景

**早上**:
```
您：/plan 完成用户模块开发
我：✅ 已记录 [plan] 完成用户模块开发
```

**白天**:
```
您：/done 完成了登录接口
您：/do 正在写单元测试
您：/block 遇到数据库连接问题
```

**晚上 21:00**:
```
我：📋 已生成日报并提交到飞书汇报

今日完成：
• 完成了登录接口

进行中：
• 正在写单元测试

遇到问题：
• 数据库连接问题

明日计划：
• 完成用户模块开发
```

## 🛠️ 实施状态

### 已完成 ✅
- [x] 快捷记录脚本 `daily-record.sh`
- [x] 支持 /done /do /plan /block
- [x] JSON 记录存储

### 待完成 ⏳
- [ ] 飞书汇报模板创建
- [ ] 获取模板 ID
- [ ] 申请 API 权限
- [ ] 对接脚本开发
- [ ] 21:00 自动提交定时任务

## 🎯 下一步行动

需要您完成：

1. **创建飞书汇报模板**
   - 打开飞书管理后台
   - 创建「工作日报」模板
   - 记录模板 ID

2. **提供 API 权限**
   - 开通 `report:report:write` 权限
   - 或提供飞书应用的 `app_id` 和 `app_secret`

3. **我来完成对接脚本**
   - 读取记录文件
   - 生成汇报内容
   - 调用飞书 API
   - 设置 21:00 自动提交

---

*文档创建: 2026-03-03*
*状态: 框架完成，等待飞书配置*
