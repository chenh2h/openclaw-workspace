---
name: daily-report
description: Quick daily report recording system with /done /do /plan /block commands. Use when the user wants to quickly log work progress throughout the day, and automatically generate daily reports at 21:00 with Feishu integration.
allowed-tools: Bash(daily-record:*)
---

# Daily Report Quick Record System

快速日报记录系统，支持全天随时记录，21:00 自动生成并提交。

## Quick Commands

| Command | Icon | Meaning | Example |
|---------|------|---------|---------|
| `/done` | ✅ | 已完成 | `/done 完成了 API 对接` |
| `/do` | 🔄 | 进行中 | `/do 正在写技术文档` |
| `/plan` | 📋 | 明日计划 | `/plan 优化系统性能` |
| `/block` | 🚧 | 阻塞问题 | `/block 权限申请未通过` |

## Usage

### Record Throughout the Day

**Morning - Plan the day:**
```
User: /plan 完成用户模块开发
Agent: ✅ 已记录 [plan] 完成用户模块开发
```

**During the day - Log progress:**
```
User: /done 完成了登录接口
Agent: ✅ 已记录 [done] 完成了登录接口

User: /do 正在写单元测试
Agent: ✅ 已记录 [doing] 正在写单元测试

User: /block 遇到数据库连接问题
Agent: ✅ 已记录 [block] 遇到数据库连接问题
```

### View Today's Records

```
User: /list
Agent: 📋 今日记录 (2026-03-03)
      
      ✅ [09:00] 完成了登录接口
      🔄 [14:00] 正在写单元测试
      🚧 [16:00] 遇到数据库连接问题
      📋 [08:30] 完成用户模块开发
```

### Generate Report

```
User: /report
Agent: 📅 2026-03-03 工作日报
      
      📊 统计
        done: 1 项
        doing: 1 项
        block: 1 项
        plan: 1 项
      
      ✅ 今日完成
      • 完成了登录接口
      
      🔄 进行中
      • 正在写单元测试
      
      🚧 遇到问题
      • 遇到数据库连接问题
      
      📋 明日计划
      • 完成用户模块开发
```

## Auto-Generation at 21:00

At 21:00, the system will:

1. Read all records from `daily-records-YYYY-MM-DD.json`
2. Generate formatted daily report
3. **Submit to Feishu Report App** (if configured)
4. Send confirmation to user

### Feishu Integration

If Feishu report integration is enabled:

```
21:00 Auto-trigger:
  ↓
Read records
  ↓
Generate report
  ↓
Call Feishu API
  ↓
Submit to Report App
  ↓
Send confirmation:
  "📋 日报已生成并提交到飞书汇报
   
   今日完成: X 项
   进行中: X 项
   遇到问题: X 项
   
   查看详情: [飞书汇报链接]"
```

## Data Storage

Records are stored in:
```
memory/daily-records-YYYY-MM-DD.json
```

Format:
```json
{
  "date": "2026-03-03",
  "records": [
    {
      "time": "09:00",
      "type": "done",
      "content": "完成了登录接口",
      "timestamp": "2026-03-03T09:00:00+08:00"
    }
  ],
  "summary": {
    "done": 1,
    "doing": 1,
    "block": 1,
    "plan": 1
  }
}
```

## Implementation

### Backend Script

`scripts/daily-record.sh`:
- Handles all commands
- Manages JSON storage
- Generates reports

### Heartbeat Integration

Added to `HEARTBEAT.md`:
```markdown
## 📋 21:05 Daily Report Generation

**Check**:
- [ ] Read `daily-records-YYYY-MM-DD.json`
- [ ] Generate formatted report
- [ ] Submit to Feishu (if enabled)
- [ ] Send confirmation to user
```

## Feishu Report Setup

See: `docs/feishu-report-integration.md`

### Required Configuration

1. Create report template in Feishu Admin
2. Get template ID
3. Apply for API permissions:
   - `report:report:write`
4. Add to OpenClaw config:
   ```yaml
   feishu:
     report:
       enabled: true
       templateId: "your-template-id"
   ```

## Benefits

| Before | After |
|--------|-------|
| 15 min writing daily report | 30 sec quick notes throughout day |
| Manual formatting | Auto-generated |
| Manual submission to Feishu | Auto-submitted at 21:00 |
| Easy to forget details | Captured in real-time |

## Related Files

- `scripts/daily-record.sh` - Core script
- `memory/daily-records-*.json` - Daily records
- `docs/feishu-report-integration.md` - Feishu setup guide
- `HEARTBEAT.md` - Auto-generation trigger

---

*Version: 1.0 - With Feishu Integration*
