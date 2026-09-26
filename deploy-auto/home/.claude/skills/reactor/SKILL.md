---
name: reactor
description: >-
  Reactor (reactor.yandex-team.ru) — событийная оркестрация: неймспейсы, артефакты и
  инстансы, реакции и их запуски, триггеры, очереди, подписки YT/Arc, права, Reactor DSL,
  миграция с Hitman. Живые данные и изменения — через инструменты mcp__reactor__*, если
  они есть в сессии (проект hyperenv), иначе шелл-командой `reactor-call`. Используй, как только вопрос про неймспейс,
  реакцию, артефакт или запуск в Reactor — даже если в репозитории есть похожие конфиги:
  файлы в Аркадии не отражают состояние Reactor.
---

# Reactor

Если в сессии есть инструменты `mcp__reactor__*` (MCP reactor подключён пресетом hyperenv
analytics), вызывай их. Иначе — `reactor-call`: Reactor нет на шлюзе mcp.yandex.net, поэтому
`ya tool mcp cli` до него не достаёт, а `reactor-call` поднимает локальный `~/.mcp_servers/reactor/reactor_mcp` (токен
`~/.nirvana/token`), делает один запрос и завершается; вызов занимает ~4 с.

```bash
reactor-call --list                        # имя и первая строка описания каждого инструмента
reactor-call --help list_reaction_instances    # описание и JSON-схема аргументов
reactor-call get_namespace namespace_path=/infra/devtools/hyperenv
reactor-call list_reaction_instances reaction_id=123 limit:=10    # := — значение как JSON
reactor-call create_reaction --json '{"namespace_path": "...", "operation_type": "..."}'
```

Предметные знания (понятия, DSL, форматы URL, миграция с Hitman) — в
`~/arcadia/ai/artifacts/skills/infra/reactor/SKILL.md` и его `references/`; там же
упоминаются инструменты `mcp__reactor__*` — это те же инструменты `reactor-call`.

Перед первым вызовом незнакомого инструмента смотри `--help`: имена аргументов в
схемах (`namespace_path`, `namespace_id`, …) не всегда совпадают с документацией.
Ответ — текст (обычно JSON) в stdout; ошибка сервера — строка `Error ...`.

Меняющие вызовы (`create_*`, `update_*`, `delete_*`, `start_reaction`,
`cancel_reaction_instance`, `change_namespace_permissions`, `*_history*`) — только
по явной просьбе пользователя, с показом аргументов перед вызовом.

## Инструменты

- `get_artifact` — Get artifact info by ID or namespace path.
- `create_artifact` — Create a new artifact definition.
- `list_artifact_types` — List all available artifact types.
- `instantiate_artifact` — Create a new artifact instance (version). This is the primary way to publish data and trigger reactions.
- `get_last_artifact_instance` — Get the most recent instance (version) of an artifact.
- `list_artifact_instances` — List artifact instances (versions) with filtering.
- `get_artifact_instance_status_history` — Get status transition history of an artifact instance.
- `deprecate_artifact_instances` — Mark artifact instances as deprecated.
- `get_reaction` — Get reaction info by ID or namespace path.
- `create_reaction` — Create a new reaction in Reactor. Specify operation_type and type-specific fields.
- `update_reaction` — Activate, deactivate or deprecate a reaction.
- `delete_reaction` — Delete a reaction by its ID.
- `list_reaction_versions` — List all versions of a reaction.
- `list_reaction_instances` — List reaction launches (instances) with optional status filtering.
- `get_reaction_instance` — Get detailed info about a specific reaction launch (instance).
- `cancel_reaction_instance` — Cancel a running reaction launch (instance).
- `get_reaction_instance_status_history` — Get status transition history of a reaction launch (instance).
- `get_namespace` — Get namespace info by ID or path.
- `create_namespace` — Create a new namespace.
- `list_namespaces` — List child namespaces of a given namespace.
- `resolve_namespace_path` — Resolve a namespace identifier to its full path.
- `list_triggers` — List dynamic triggers for a reaction.
- `add_trigger` — Add dynamic triggers to a reaction.
- `remove_trigger` — Remove dynamic triggers from a reaction by trigger IDs.
- `get_queue` — Get queue info by ID or namespace path.
- `update_queue` — Update queue parameters: capacity, limits, and reactions.
- `list_namespace_entities` — List all entities (artifacts, reactions, queues) in a namespace and its children.
- `delete_namespace` — Delete a namespace and all entities (artifacts, reactions, queues) attached to it.
- `update_reaction_config` — Create a new version of a reaction with updated configuration.
- `start_reaction` — Manually start (restart) a reaction. Useful for testing after migration from Hitman.
- `update_trigger` — Activate or deactivate a trigger. Triggers are INACTIVE after creation and must be explicitly activated.
- `switch_trigger` — Atomically switch one trigger to another preserving active history.
- `get_trigger_active_history` — Get current active history of a reaction.
- `insert_trigger_active_history` — Insert artifact instances into reaction's active history.
- `list_trigger_history_buffer` — List buffer history for a trigger.
- `add_trigger_history_buffer` — Add artifact instances to trigger's buffer history.
- `remove_trigger_history_buffer` — Remove artifact instances from trigger's buffer history.
- `create_queue` — Create a new queue in Reactor. Queues limit concurrent reaction instances.
- `search_artifact` — Search for artifacts by YT path pattern. Useful for finding existing artifacts that monitor specific YT directories.
- `delete_artifact_instance` — Delete artifact instances by instance ID or by artifact + time range.
- `create_artifact_source` — Create a YT or Arc subscription (source) for an artifact.
- `list_artifact_sources` — List all sources (YT/Arc subscriptions) for an artifact.
- `update_artifact_source` — Activate or deactivate an artifact source (subscription).
- `delete_artifact_source` — Delete an artifact source (subscription). Source must be INACTIVE before deletion.
- `list_namespace_permissions` — List permissions (ACL) for a namespace.
- `change_namespace_permissions` — Grant or revoke permissions on a namespace.
