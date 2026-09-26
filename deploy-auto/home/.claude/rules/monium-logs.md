# Monium: агрегаты по логам

Топ сообщений, количество по сервису или уровню и другие агрегаты по логам — через `query_logs_stats`, а не перебором `read_logs`:
```bash
ya tool mcp connect monium_mcp --tool query_logs_stats \
  'selectors:{project="hyperenv", service="*", level="ERROR"}' 'aggregates:["count()"]' \
  group_by_field:message group_by_limit:10 max_points:1 from:2026-01-01T00:00:00Z to:2026-01-02T00:00:00Z
```
