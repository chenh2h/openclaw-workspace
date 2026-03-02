# Todo Manager Skill

## 描述
管理待办事项的 Skill，用于添加、查看和完成待办。

## 使用方法

### 添加待办

当用户要求添加待办时：

1. **提取信息**：
   - 待办内容
   - 截止日期（默认为明天）
   - 来源消息（引用/回复的消息内容）

2. **更新文件**：
   - `memory/YYYY-MM-DD.md` - 在对应日期添加待办
   - `MEMORY.md` - 添加到待跟进事项表格

3. **提交并推送**：
   - git add -A
   - git commit -m "todo: [内容]"
   - git push origin master

### 提醒待办（Heartbeat）

每天早上 10:00 检查：

1. **检查今日待办**：
   - 读取 `memory/YYYY-MM-DD.md`
   - 读取 `MEMORY.md` 中的待跟进事项

2. **发送提醒**：
   ```
   📅 今日待办 (YYYY-MM-DD)
   
   1. [待办内容]
      来源: [引用的原始消息]
   ```

3. **清理已提醒待办**：
   - 从 `MEMORY.md` 中删除
   - 在 `memory/YYYY-MM-DD.md` 中标记 ✅ 已完成
   - git commit & push

### 完成待办

当用户完成待办时：

1. 在 `memory/YYYY-MM-DD.md` 中标记 ✅
2. 从 `MEMORY.md` 中删除
3. git commit & push

## 文件格式

### memory/YYYY-MM-DD.md
```markdown
## 📅 明日待办 (YYYY-MM-DD)

- [ ] 待办内容
  - **来源**: [引用的消息内容]
  - **截止日期**: YYYY-MM-DD
```

### MEMORY.md
```markdown
## 📋 待跟进事项

| 事项 | 截止日期 | 状态 | 来源消息 |
|------|----------|------|----------|
| 待办内容 | YYYY-MM-DD | ⏳ 待办 | [引用的消息] |
```

## 规则

1. **来源必须准确**：使用用户引用的消息作为来源
2. **提醒后删除**：避免重复提醒
3. **及时推送**：每次修改后立即 git push
4. **验证推送**：git status 确认 "up to date"
