AcceptKey     = ['<Enter>', '<C-j>', '<C-m>']
CancelKey     = ['<Esc>', '<C-[>']
CtrlAcceptKey = ['<C-Enter>']
CtrlEscapeKey = ['<C-Esc>']

window.isControlKey = (key) ->
  key in ['Control', 'Shift', 'Alt', 'Win']

window.isCtrlAcceptKey = (key) ->
  key in CtrlAcceptKey

window.isAcceptKey = (key) ->
  key in AcceptKey

window.isEscapeKey = (key) ->
  key in CancelKey

window.isCtrlEscapeKey = (key) ->
  return true if Option.get('enable_vrome_key') is key
  key in CtrlEscapeKey

window.AcceptKeyFunction = ->
  Search.onAcceptKeyPressed()
  Dialog.openCurrent()
  Buffer.gotoFirstMatchHandle()
  Buffer.deleteMatchHandle()
  Buffer.deleteNoteMatchHandle()

window.CancelKeyFunction = ->
  Hint.remove()
  Search.stop()
  Dialog.stop true
  Buffer.reset()
  InsertMode.blurFocus()
  KeyEvent.reset()
  CmdBox.remove()
  Help.hide true
desc window.CancelKeyFunction, 'Cancel Actions'

window.CtrlAcceptKeyFunction = ->
  Dialog.openCurrentNewTab()
  Search.openCurrentNewTab()

extractFunction = (functionName) ->
  func = (func ? window)[action] for action in functionName.split('.')
  func

imapFunc = (key, func, virtualKey) ->
  keys = if $.isArray key then key else [key]
  extractedFunc = extractFunction func
  KeyEvent.add k, extractedFunc, true for k in keys
  Help.add (virtualKey ? key), func, extractedFunc, 'i'

nmapFunc = (key, func, virtualKey) ->
  keys = if $.isArray key then key else [key]
  extractedFunc = extractFunction func
  KeyEvent.add k, extractedFunc, false for k in keys
  Help.add (virtualKey ? key), func, extractedFunc, 'n'

cmapFunc = (key, func, virtualKey) ->
  keys = if $.isArray key then key else [key]
  extractedFunc = extractFunction func
  CmdLine.add k, extractedFunc for k in keys
  Help.add (virtualKey ? key), func, extractedFunc, 'c'

mapFunc = (key, func, virtualKey) ->
  nmapFunc key, func, virtualKey
  imapFunc key, func, virtualKey

nmapFunc '<F1>', 'Help.show'
nmapFunc ':',    'CmdLine.start'

mapFunc AcceptKey,     'AcceptKeyFunction'
mapFunc CancelKey,     'CancelKeyFunction'
mapFunc CtrlAcceptKey, 'CtrlAcceptKeyFunction'

nmapFunc '<C-z>', 'KeyEvent.disable'
nmapFunc '<C-v>', 'KeyEvent.passNextKey'

nmapFunc '.', 'KeyEvent.runLast' # count

## ZOOM
nmapFunc 'zi', 'Zoom.current_in' # count
nmapFunc 'zo', 'Zoom.current_out' # count
nmapFunc 'zm', 'Zoom.current_more' # count
nmapFunc 'zr', 'Zoom.current_reduce' # count
nmapFunc 'zz', 'Zoom.current_reset'

nmapFunc 'zI', 'Zoom.zoomIn' # count
nmapFunc 'zO', 'Zoom.out' # count
nmapFunc 'zM', 'Zoom.more' # count
nmapFunc 'zR', 'Zoom.reduce' # count
nmapFunc 'zZ', 'Zoom.reset' # count

## Scroll
nmapFunc 'gg',    'Scroll.top'
nmapFunc 'G',     'Scroll.bottom'
nmapFunc '0',     'Scroll.first'
nmapFunc '$',     'Scroll.last'
nmapFunc '%',     'Scroll.toPercent' #count
nmapFunc 'k',     'Scroll.up' #count
nmapFunc 'j',     'Scroll.down' #count
nmapFunc 'h',     'Scroll.left' #count
nmapFunc 'l',     'Scroll.right' #count
nmapFunc '<C-f>', 'Scroll.nextPage' #count
nmapFunc '<C-b>', 'Scroll.prevPage' #count
nmapFunc '<C-d>', 'Scroll.nextHalfPage' #count
nmapFunc '<C-u>', 'Scroll.prevHalfPage' #count

## Page
nmapFunc 'gi', 'InsertMode.focusFirstTextInput' #count
nmapFunc ']]', 'Page.next'
nmapFunc '[[', 'Page.prev'

nmapFunc 'Y',     'Page.copySelected'
nmapFunc '<C-g>', 'Page.showInfo'

## Frame
nmapFunc ']f', 'Frame.next'
nmapFunc '[f', 'Frame.prev'

## URL
nmapFunc 'gf', 'Url.viewSource'
nmapFunc 'gF', 'Url.viewSourceNewTab'

nmapFunc 'y',     'Tab.copyUrl'
nmapFunc 'p',     'Url.openFromClipboard'
nmapFunc 'P',     'Url.openFromClipboardNewTab'
nmapFunc '<M-p>', 'Url.openFromClipboardAndFocusNewTab'

nmapFunc '<C-a>', 'Url.increment' # count
nmapFunc '<C-x>', 'Url.decrement' # count

nmapFunc 'gu', 'Url.parent' # count
nmapFunc 'gU', 'Url.root'
nmapFunc 'gr', 'Url.referer'
nmapFunc 'gR', 'Url.tabReferer'

nmapFunc 'o', 'Url.open'
nmapFunc 'O', 'Url.openWithDefault'
nmapFunc 't', 'Url.tabopen'
nmapFunc 'T', 'Url.tabopenWithDefault'

nmapFunc '<C-y>', 'Url.shortUrl'

## Tab
nmapFunc 'r',     'Tab.reload'
nmapFunc '<C-r>', 'Tab.reloadWithoutCache'
nmapFunc 'R',     'Tab.reloadAll'

nmapFunc ['<C-p>', 'gT'], 'Tab.prev' #count
nmapFunc ['<C-n>', 'gt'], 'Tab.next' #count

nmapFunc 'gq', 'Tab.moveLeft' #count
nmapFunc 'ge', 'Tab.moveRight' #count

## Buffer
nmapFunc 'b',         'Buffer.gotoFirstMatch' #count
nmapFunc ['dm', 'B'], 'Buffer.deleteMatch' #count
nmapFunc '<M-b>',     'Buffer.deleteNotMatch'

## Tab
nmapFunc ['g0', 'g^'],       'Tab.first'
nmapFunc 'g$',               'Tab.last'
nmapFunc 'gl',               'Tab.selectLastOpen'
nmapFunc ['<C-6>', '<C-^>'], 'Tab.selectPrevious'

nmapFunc 'dc',    'Tab.close'
nmapFunc 'D',     'Tab.closeAndFoucsLeft'
nmapFunc '<M-d>', 'Tab.closeAndFoucsLast'
nmapFunc 'do',    'Tab.closeOtherTabs'
nmapFunc 'dl',    'Tab.closeLeftTabs'
nmapFunc 'dr',    'Tab.closeRightTabs'

nmapFunc 'u', 'Tab.reopen'

nmapFunc 'gd', 'Tab.duplicate'
nmapFunc 'gD', 'Tab.detach'

nmapFunc 'dp',  'Tab.closeUnPinnedTabs'
nmapFunc 'dP',  'Tab.closePinnedTabs'
nmapFunc 'gp',  'Tab.togglePin'
nmapFunc 'gP',  'Tab.unpinAllTabsInCurrentWindow'
nmapFunc 'gwP', 'Tab.unpinAllTabsInAllWindows'

nmapFunc 'gI', 'Tab.toggleIncognito'

nmapFunc 'gm', 'Tab.markForMerging'
nmapFunc 'gM', 'Tab.markAllForMerging'
nmapFunc 'gv', 'Tab.mergeMarkedTabs'

## History & Bookmark
nmapFunc ['H', '<C-o>'], 'History.back'
nmapFunc ['L', '<C-i>'], 'History.forward'
nmapFunc 'gh',           'History.start'
nmapFunc 'gH',           'History.newTabStart'
nmapFunc 'gb',           'Bookmark.start'
nmapFunc 'gB',           'Bookmark.newTabStart'

## Hint
nmapFunc 'f',     'Hint.start'
nmapFunc 'F',     'Hint.newTabStart'
nmapFunc '<M-f>', 'Hint.multiModeStart'

## Search
nmapFunc ['/', '*'],  'Search.start'
nmapFunc ['?', '#'],  'Search.backward'
nmapFunc 'n',         'Search.next'
nmapFunc 'N',         'Search.prev'
imapFunc '<M-Enter>', 'Search.next'
imapFunc '<S-Enter>', 'Search.prev'

## Marks
markKeys = ('m' + String.fromCharCode(num) for num in [65..122] when num not in [91..96])
nmapFunc markKeys, 'Marks.addLocalMark', 'm[a-z][0-9]'

jumpKeys = ("'" + String.fromCharCode(num) for num in [65..122] when num not in [91..96])
nmapFunc jumpKeys, 'Marks.addLocalMark', "'[a-z][0-9]"

nmapFunc 'M',  'Marks.addQuickMark'
nmapFunc 'go', 'Marks.gotoQuickMark'
nmapFunc 'gn', 'Marks.gotoQuickMarkNewTab'

## Insert Mode
imapFunc '<C-i>', 'InsertMode.externalEditor'
imapFunc '<C-u>', 'InsertMode.deleteToBeginCurrentLine'
imapFunc '<C-k>', 'InsertMode.deleteToEndCurrentLine'

imapFunc '<C-a>', 'InsertMode.moveToFirstOrSelectAll'
imapFunc '<C-e>', 'InsertMode.moveToEnd'
imapFunc '<M-a>', 'InsertMode.moveToBeginCurrentLine'
imapFunc '<M-e>', 'InsertMode.moveToEndCurrentLine'

imapFunc ['<M-y>', '<M-w>'], 'InsertMode.deleteBackwardWord'
imapFunc '<M-o>',            'InsertMode.deleteForwardWord'
imapFunc '<M-u>',            'InsertMode.deleteBackwardChar'
imapFunc '<M-i>',            'InsertMode.deleteForwardChar'

imapFunc '<M-h>', 'InsertMode.moveBackwardWord'
imapFunc '<M-l>', 'InsertMode.moveForwardWord'
imapFunc '<M-j>', 'InsertMode.moveBackwardChar'
imapFunc '<M-k>', 'InsertMode.moveForwardChar'

imapFunc '<M-n>', 'InsertMode.moveForwardLine'
imapFunc '<M-m>', 'InsertMode.moveBackwardLine'

imapFunc '<M-z>', 'InsertMode.restoreLastValue'

## CmdLine
cmapFunc 'help',                  'Help.show'
cmapFunc 'buffer_delete_matched', 'Buffer.deleteMatchHandle'
cmapFunc 'buffer_keep_matched',   'Buffer.deleteNoteMatchHandle'
cmapFunc 'make_links',            'AutoLink.makeLink'
cmapFunc 'images_toggle',         'Command.imagesToggle'
cmapFunc 'images_only',           'Command.imagesOnly'
cmapFunc 'javascript',            'Command.javascript'
cmapFunc 'css',                   'Command.css'
cmapFunc 'source',                'Command.source'
cmapFunc 'reload_extension',      'Command.reloadExtension'
cmapFunc 'print',                 'Command.print'
cmapFunc 'capture',               'Window.capture'
cmapFunc 'save_as',               'Window.saveAs'

cmapFunc 'quit',            'Tab.close'
cmapFunc 'window_open',     'Window.create'
cmapFunc 'window_only',     'Window.only'
cmapFunc 'window_close',    'Window.close'
cmapFunc 'window_closeall', 'Window.closeAll'

# CmdLine.add 'mdelete', 'Delete matched marks', Marks.deleteQuickMark

for url in ['downloads', 'bookmarks', 'history', 'chrome_help', 'settings', 'extensions', 'github', 'issues', 'options']
  cmapFunc ["open_#{url}!", "open_#{url}"], "Links.#{url}"
