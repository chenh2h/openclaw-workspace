# 💰 Token 优化速查手册

## 🚨 立即执行

| 场景 | 行动 |
|------|------|
| 对话 >20 轮 | 运行 `session_status` 检查 |
| Context >70% | 立即 flush 重要信息到文件 |
| 开始新任务 | 先写待办到 memory/今日日期.md |
| 任务完成 | 更新 MEMORY.md 项目状态 |

## 📋 文件写入优先级

```
紧急决策/行动项    →  memory/YYYY-MM-DD.md
项目状态更新       →  MEMORY.md (项目表格)
系统配置变更       →  AGENTS.md / TOOLS.md
技能学习          →  对应 SKILL.md
```

## 🎯 执行优先级

```
1️⃣ API/CLI    → 最高效
2️⃣ Skill      → 检查 available_skills
3️⃣ 社区搜索    → npx skills find
4️⃣ 浏览器      → 最后手段
```

## 📝 Heartbeat 精简原则

```yaml
# HEARTBEAT.md - 保持这样
- 检查邮件
- 检查日历
- 检查天气

# ❌ 不要写长段落
# ✅ 用关键词触发检查
```

## 🧠 Memory Flush Protocol

| Context | 行动 |
|---------|------|
| <50%   | 正常操作 |
| 50-70%  | 提高警惕，重要信息后写入 |
| 70-85%  | **立即 flush 所有关键信息** |
| >85%   | **紧急刷新，先写总结再回复** |

## 💡 快速检查清单

- [ ] 重要信息已写入文件（非依赖对话）
- [ ] Heartbeat.md 保持精简
- [ ] 使用 Skill 代替长提示
- [ ] 复杂任务使用子代理分担
- [ ] 定期运行 `session_status` 监控

---

**原则: 少说话，多写文件**
