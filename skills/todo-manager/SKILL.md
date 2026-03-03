---
name: todo-manager
description: Manage daily and persistent todos with automatic reminders. Use when the user needs to add, track, or complete todo items, set up daily reminders, or manage recurring tasks that need daily follow-up until completion.
---

# Todo Manager

Manage daily and persistent todos with automatic reminders.

## When to Use

- Adding new todo items with deadlines
- Setting up daily todo reminders (10:00 AM)
- Managing persistent todos (daily reminders until completed)
- Marking todos as complete

## Quick Start

### Add Daily Todo

Updates both daily memory file and MEMORY.md tracking table.

### Add Persistent Todo

Adds to `memory/persistent-todos.md` for daily reminders until marked complete.

### Complete Todo

Marks as done and removes from active tracking.

## File Structure

```
memory/
├── YYYY-MM-DD.md          # Daily todos
├── persistent-todos.md    # Recurring todos
└── MEMORY.md              # Summary table
```

## Daily Format

```markdown
## 📅 明日待办 (YYYY-MM-DD)

- [ ] Todo content
  - **来源**: [Original message]
  - **截止日期**: YYYY-MM-DD
```

## Persistent Format

```markdown
## 📌 活跃待办

- [ ] **Task name** (YYYY-MM-DD added)
  - Detail 1
  - Detail 2

## ✅ 已完成
```

## Rules

1. **Source must be accurate**: Use user's referenced message
2. **Delete after reminder**: Avoid duplicate reminders
3. **Push immediately**: Git commit & push after each change
4. **Verify push**: Confirm `git status` shows "up to date"

## Reminder Schedule

- **Time**: Daily 10:00 AM (cron)
- **Content**: Today's todos + active persistent todos
- **Action**: Send Feishu message with @mention
