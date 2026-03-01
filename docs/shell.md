# Shell aliases и функции

## Навигация (`.aliases`)

| Alias | Команда | Описание |
|-------|---------|----------|
| `..` | `cd ..` | На уровень вверх |
| `...` | `cd ../..` | На два уровня вверх |
| `....` | `cd ../../..` | На три уровня вверх |
| `dl` | `cd ~/Downloads` | Перейти в Downloads |
| `dt` | `cd ~/Desktop` | Перейти на Desktop |

## Утилиты (`.aliases`)

| Alias | Команда | Описание |
|-------|---------|----------|
| `ll` | `eza --color=always --long --git --no-filesize --icons=always --all` | Подробный список файлов (eza) |
| `e` | `$EDITOR` | Открыть редактор |
| `c` | `claude` | Claude CLI |
| `ip` | `dig +short myip.opendns.com @resolver1.opendns.com` | Внешний IP |
| `localip` | `ipconfig getifaddr en1` | Локальный IP |
| `ips` | `ifconfig -a \| grep ...` | Все IP-адреса |
| `urlencode` | `python -c "..."` | URL-кодирование строки |
| `mine` | `sudo chown -R $USER .` | Забрать права на текущую директорию |
| `python` | `python3` | Python 3 по умолчанию |

## Sed (`.aliases`)

| Alias | Команда | Описание |
|-------|---------|----------|
| `SED` | `sed -E` (macOS) / `sed -r` (Linux) | Sed с расширенными регулярками |
| `SEDI` | `sed -E -i '' -e` (macOS) / `sed -ri` (Linux) | Inplace sed с расширенными регулярками |
| `GSED` | `gsed` / `sed` | GNU sed |

## Grep (`.aliases`)

| Alias | Команда | Описание |
|-------|---------|----------|
| `grep` | `grep --color=auto` | Grep с цветом |
| `fgrep` | `fgrep --color=auto` | Fgrep с цветом |
| `egrep` | `egrep --color=auto` | Egrep с цветом |

## Tmux (`.aliases`)

| Alias | Команда | Описание |
|-------|---------|----------|
| `tm` | `tmux -2 -S /tmp/tm-$(whoami)` | Запуск tmux (256 цветов, именованный сокет) |
| `tma` | `tm a -t` | Подключиться к сессии |
| `tm-pair` | функция | Pair-programming сессия (см. ниже) |

### `tm-pair` — pair-programming

```bash
tm-pair feature_name            # Создать сессию
tm-pair user_name feature_name  # Подключиться к чужой сессии
```

## Функции (`.functions`)

| Функция | Описание |
|---------|----------|
| `mkd` | Создать директорию и перейти в неё |
| `cdf` | Перейти в директорию текущего окна Finder |
| `targz` | Создать `.tar.gz` архив (zopfli/pigz/gzip) |
| `fs` | Размер файла или директории |
| `diff` | Цветной diff через git |
| `dataurl` | Создать data URL из файла |
| `server` | Запустить HTTP-сервер (порт по умолчанию: 8000) |
| `gz` | Сравнить размер файла до и после gzip |
| `digga` | Запустить `dig` с полезными параметрами |
| `o` | Открыть файл/директорию (без аргументов — текущую) |
| `tre` | `tree` с цветом, без `.git`/`node_modules`, через `less` |

## Прочее (`.aliases`)

| Alias | Команда | Описание |
|-------|---------|----------|
| `fuck` | thefuck | Исправить предыдущую команду |
| `fk` | thefuck | Короткий alias для thefuck |

---

Источники: `.aliases`, `.functions`
