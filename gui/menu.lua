local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")
local debian = require("main.menu")
--local has_fdo = pcall(require, "addons.awesome-freedesktop")
local freedesktop = require("addons.awesome-freedesktop.menu")
local hotkeys_popup = require("awful.hotkeys_popup")
--[[
freedesktop.desktop.add_icons(args)

for s in screen do
    freedesktop.desktop.add_icons({
    screen = s,
    baseicons = {
    [1] = {
        label = "This PC",
        icon  = "computer",
        onclick = "computer://"
    },
    [2] = {
       label = "Home",
       icon  = "user-home",
       onclick = os.getenv("HOME")
    },
    [3] = {
       label = "Trash",
       icon  = "user-trash",
       onclick = "trash://"
    }
}
    })
end
--]]
-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

--if has_fdo then
    mymainmenu = freedesktop.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
    --[[
else
    mymainmenu = awful.menu({
        items = {
                  menu_awesome,
                  { "Debian", debian.menu.Debian_menu.Debian },
                  menu_terminal,
                }
    })
end
--]]

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}
