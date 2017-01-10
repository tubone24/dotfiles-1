local function keyCode(key, modifiers)
   modifiers = modifiers or {}
   return function()
      hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), true):post()
      hs.timer.usleep(1000)
      hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), false):post()
   end
end

local function remapKey(modifiers, key, keyCode)
   hs.hotkey.bind(modifiers, key, keyCode, nil, keyCode)
end

local function disableAllHotkeys()
   for k, v in pairs(hs.hotkey.getHotkeys()) do
      v['_hk']:disable()
   end
end

local function enableAllHotkeys()
   for k, v in pairs(hs.hotkey.getHotkeys()) do
      v['_hk']:enable()
   end
end

local function handleGlobalAppEvent(name, event, app)
   if event == hs.application.watcher.activated then
      -- hs.alert.show(name)
      if name ~= "iTerm2" then
         enableAllHotkeys()
      else
         disableAllHotkeys()
      end
   end
end

appsWatcher = hs.application.watcher.new(handleGlobalAppEvent)
appsWatcher:start()

remapKey({'ctrl'}, 'p', keyCode('up'))
remapKey({'ctrl'}, 'n', keyCode('down'))
remapKey({'ctrl'}, 'h', keyCode('delete'))
remapKey({'ctrl'}, 'u', keyCode('delete', {'cmd'}))

-- Ctrl-J でリターン
remapKey({'ctrl'}, 'j', keyCode('return'))
remapKey({'ctrl', 'cmd'}, 'j', keyCode('return', {'cmd'}))
remapKey({'ctrl', 'alt'}, 'j', keyCode('return', {'alt'}))
remapKey({'ctrl', 'shift'}, 'j', keyCode('return', {'shift'}))
remapKey({'cmd'}, 'm', keyCode('f20')) -- ⌘Mの誤打が多いので無効化する
