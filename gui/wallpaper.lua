    local beautiful = require("beautiful")
    local gears = require("gears")
    local awful = require("awful")
    local naughty = require("naughty")


    local path = os.getenv("HOME") .."/rclone/onedrivePupkinpupsm.local/PCTools/Wallpapers/"
    local num_files = 0
    local wp_all = {}
    local wp_selected = {}
    local num_tags = 0


    local function selectedPropertyHandler(tag)
    if not tag.selected then return end
    awesome.emit_signal("wallpaper::change", path .. wp_selected[t])
    gears.wallpaper.maximized(path .. wp_selected[t], scr, true)
    end


    function parseOutput(str)
    local linesWallpaper = {}
    for line in str:gmatch("[^\r\n]+") do
    if(not(line == "." or line == "..")) then
        num_files = num_files + 1
        linesWallpaper[num_files] = line
    end
    end
    return linesWallpaper
    end

    function selectWallpaper(wp,files,tabs)
        local selected = {}
        for i=1,tabs do
            position = math.random(1,files)
            selected[i] = wp[position]
            wp[position] = wp[files]
            files = files - 1
        end
        return selected
    end

    --{{

    local wallpaper = {}
    local function set_wallpaper(screen)
    awful.spawn.easy_async_with_shell('ls -a "'..path..'"', function(out)
    local linesTable = parseOutput(out)

    local screens = awful.screen.focused()
    num_tabs = #screens.tags

    math.randomseed(os.time());
    for i = 1,10 do
        math.random()
    end
    wp_selected = selectWallpaper(linesTable,num_files,num_tabs)
    num_files = 0
    for  scr in screen do
        awesome.emit_signal("wallpaper::change", path .. wp_selected[1])
        gears.wallpaper.maximized(path .. wp_selected[1], scr, true)

        for t = 1,#scr.tags do
        local tag = scr.tags[t]
            tag:connect_signal("property::selected", function (tag)
                if not tag.selected then return end
                    awesome.emit_signal("wallpaper::change", path .. wp_selected[t])
                    gears.wallpaper.maximized(path .. wp_selected[t], scr, true)
            end)
            tag:disconnect_signal("property::selected",function () end)
            collectgarbage(“collect”)
        end
    end
    collectgarbage(“collect”)
    end)
    end
    return {
        set_wallpaper = set_wallpaper,
        selectWallpaper = selectWallpaper,
        parseOutput = parseOutput,
    }
