    local gears = require("gears")
    local awful = require("awful")
    local naughty = require("naughty")
    local wallpaper = require("gui.wallpaper")
    local counter = 0

    --local screens = awful.screen.get_connected_screens()

    function set_timer(number)
        counter=number
    end


    local global_timer = gears.timer {
        timeout = 60,
        autostart = true,
        callback = function()
        set_timer(counter + 1)
        if counter==30 then
            set_timer(0)
            wallpaper.set_wallpaper(screen)
        end
        collectgarbage(“collect”)
        end
    }


