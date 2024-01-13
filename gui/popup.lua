local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")


local popup = {}
local progressbar = wibox.widget {
    max_value = 100,
    value = 0,
    forced_height = 10,
    forced_width = 100,
    color = "#616d7e",  -- Set the color to green (adjust the color code as needed)
    background_color = "#CCCCCC",  -- Set the background color (adjust the color code as needed)
    widget = wibox.widget.progressbar
}

local popup = awful.popup {
    widget = {
        {
            progressbar,
            margins = 8,
            widget = wibox.container.margin
        },
        bg = beautiful.bg_normal,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 6)
        end,
        widget = wibox.container.background
    },
    ontop = true,
    visible = false,
        placement = function(c)
        awful.placement.bottom(c, { margins = { bottom = 20 } }) -- Adjust the bottom margin here
    end
}




local function execute_and_show_output(command)
    awful.spawn.easy_async_with_shell(command, function(out)
        local progress_value = tonumber(out) or 0
        progress_value = math.min(100, math.max(0, progress_value)) -- Ensure the value is between 0 and 100

        progressbar.value = progress_value

        popup.visible = true

        if timer_running then
            -- If the timer is running, prolong it by one more second
            timer:again(2)
        else
            -- If the timer is not running, start a new timer
            timer_running = true
            timer = gears.timer.start_new(1, function()
                popup.visible = false
                timer_running = false  -- Reset the timer state
                return false
            end)
        end
    end)
end
return {
    execute_and_show_output = execute_and_show_output,
}
