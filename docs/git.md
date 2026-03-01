# Git

## Git aliases (`.gitconfig`)

| Alias | Команда | Описание |
|-------|---------|----------|
| `st` | `status` | Статус |
| `br` | `branch` | Ветки |
| `co` | `checkout` | Переключение |
| `di` | `diff` | Diff |
| `dc` | `diff --cached` | Diff закэшированных изменений |
| `ds` | `diff --staged` | Diff staged изменений |
| `ci` | `commit` | Коммит |
| `am` | `commit --amend` | Amend коммит (с редактированием сообщения) |
| `amend` | `commit --amend -C HEAD` | Amend коммит (без редактирования сообщения) |
| `undo` | `reset --soft HEAD^` | Отменить последний коммит (сохранить изменения) |
| `cp` | `cherry-pick` | Cherry-pick |
| `lg` | `log -p` | Лог с патчами |
| `rb` | `rebase` | Rebase |
| `lod` | `log --graph --decorate ...` | Граф коммитов (дата + сообщение) |
| `lol` | `log --graph --decorate --pretty=oneline --abbrev-commit` | Граф коммитов (однострочный) |
| `lola` | `lol --all` | Граф коммитов (все ветки) |
| `hist` | `log --pretty=format:... --graph --date=short --branches --all` | История всех веток с графом |
| `standup` | `log --since '1 day ago' --oneline --author $USER` | Коммиты за последний день |
| `ign` | `ls-files -o -i --exclude-standard` | Показать игнорируемые файлы |
| `search` | `log --all --grep=$1` | Поиск коммитов по сообщению |
| `fm` | `show $(rev-list --ancestry-path $0..dev --merges \| tail -f)` | Найти мерж-коммит, с которым был влит коммит |

## Bash aliases для git (`.aliases`)

| Alias | Команда | Описание |
|-------|---------|----------|
| `ga` | `git add` | Добавить в индекс |
| `gb` | `git branch -a` | Все ветки |
| `gbd` | `git fetch -p && ...` | Удалить локальные ветки, удалённые на remote |
| `gc` | `git commit -am` | Коммит всех изменений |
| `gca` | `git commit --amend` | Amend коммит |
| `gd` | `git di` | Diff |
| `gdc` | `git di --cached` | Diff cached |
| `gds` | `git di --staged` | Diff staged |
| `gf` | `git fetch --prune` | Fetch с очисткой |
| `gh` | `git hist` | История (граф) |
| `gl` | `git lol` | Лог (однострочный граф) |
| `gm` | `git merge --no-ff` | Merge без fast-forward |
| `gp` | `git push` | Push |
| `gr` | `git remote -v` | Список remote |
| `gs` | `git st` | Статус |
| `gt` | `git tag` | Теги |
| `gst` | `git status -sb` | Краткий статус |
| `grd` | `git rb origin/dev` | Rebase на origin/dev |
| `grm` | `git rb origin/master` | Rebase на origin/master |
| `diff-diff` | `git-diff-diff` | Diff между diff'ами |
| `g1` | `git log -1` | Последний коммит |
| `g9` | `git lol -9` | Последние 9 коммитов (граф) |
| `gmt` | `git mergetool && find -name '*.orig' -delete` | Запустить mergetool и удалить `.orig` файлы |
| `gse` | `e $(git status --porcelain \| sed ...)` | Открыть все изменённые файлы в редакторе |

## Bisect helpers

| Alias | Команда | Описание |
|-------|---------|----------|
| `gb-bad` | `git bisect bad && npm run build` | Пометить коммит как bad + собрать |
| `gb-good` | `git bisect good && npm run build` | Пометить коммит как good + собрать |

## Настройки

| Настройка | Значение | Описание |
|-----------|----------|----------|
| `core.pager` | `delta` | Пейджер с подсветкой синтаксиса (side-by-side) |
| `core.editor` | `nvim` | Редактор |
| `help.autocorrect` | `1` | Автоисправление команд |
| `rebase.autosquash` | `true` | Автоматический autosquash при rebase |
| `branch.autosetuprebase` | `always` | Rebase вместо merge при pull |
| `push.default` | `current` | Push в ветку с тем же именем |
| `fetch.prune` | `true` | Удалять неактуальные remote-ветки при fetch |

## URL shorthands

| Shorthand | URL | Описание |
|-----------|-----|----------|
| `gh:` | `git@github.com:` | GitHub SSH |
| `github:` | `git://github.com/` | GitHub readonly |
| `gst:` | `git@gist.github.com:` | Gist SSH |
| `gist:` | `git://gist.github.com/` | Gist readonly |

---

Источники: `.gitconfig`, `.aliases`
