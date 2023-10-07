dotfiles
========

Конфиги для разработчика на typescript.

Собрано на основе:
* https://github.com/ecosse3/nvim
* https://github.com/mathiasbynens/dotfiles
* https://github.com/NvChad/NvChad

### Установка

```bash
git clone git://github.com/cherninely/dotfiles ~/dotfiles && ~/dotfiles/bootstrap.sh
``````

# MailMate keybindings

* Navigation within a mail spool
  * **j** Move to the next row
  * **k** Move to the previous row
  * **l** Expand a thread
  * **h** Collapse a thread
  * **g** Jump to the first message
  * **G** Jump to the last message
  * **;** Jump to the next unread message
* Navigation between folders
  * **J** Next folder (shift-j)
  * **K** Previous folder (shift-k)
  * **option-J** Next folder with unread messages (option-shift-j)
  * **option-K** Previous folder with unread messages (option-shift-k)
* Messages Actions
  * **space** Scroll a page down in the currently displayed message
  * **shift-space** Scroll a page up in the currently displayed message
  * **u** Toggle the read state
  * **e** Archive
  * **s** Toggle flag (star)
  * **r** Reply
  * **a** Reply-all
  * **f** Forward
  * **#** Delete
  * **!** Move to junk
  * **\`\`** Mark all messages in a mailbox as read. This is like a bomb in a mailbox and it's activated by pressing the backtick key twice.  Careful! 
* General
  * **/** Search
  * **z** Undo
  * **Z** Redo
