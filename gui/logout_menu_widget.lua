local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")

local HOME = os.getenv('HOME')
local ICON_DIR = HOME .. '/.config/awesome/gui/images/logoff/'
local coffee_icon_path = "coffein.svg"
local active_coffee_icon_path = "coffein-active.svg"

local active_coffee_boolean = false

local popup = {}

local function toggleCaffeinate()
    awful.spawn.easy_async("pidof caffeinate",
        function(stdout, stderr, reason, exit_code)
            if exit_code == 0 then
                awful.util.spawn("pkill caffeinate", false)
                active_coffee_boolean = false
            else
                awful.util.spawn(HOME .. "/.cargo/bin/caffeinate", false)
                active_coffee_boolean = true
            end
        end
    )
end

local button_list = {
    {
        id = "Suspend",
        text = "Suspend",
        icon_path = "suspend.svg",
        on_click = function()
            awful.util.spawn("systemctl suspend", false)
        end,
    },
    {
        id = "Shutdown",
        text = "Shutdown",
        icon_path = "shutdown.svg",
        on_click = function()
            awful.util.spawn("systemctl shutdown", false)
        end,
    },
    {
        id = "Reboot",
        text = "Reboot",
        icon_path = "reboot.svg",
        on_click = function()
            awful.util.spawn("systemctl reboot", false)
        end,
    },
    {
        id = "Log",
        text = "Log out",
        icon_path = "log-out.svg",
        on_click = function()
            awesome.quit()
        end,
    },
    {
        id = "Lock",
        text = "Lock",
        icon_path = "lock.svg",
        on_click = function()
            awful.util.spawn("i3lock-fancy -gpfn Comic-Sans-MS -- scrot -z", false)
        end,
    },
    {
        id = "Caffein",
        text = "Caffein",
        icon_path = coffee_icon_path,
        on_click = function(button)
            toggleCaffeinate()
        end,
    },
}

local buttons_container = wibox.layout.fixed.vertical()

local function createButton(button_info)
    local button = wibox.widget {
        {
            {
                {
                    id = button_info.id,
                    image = ICON_DIR .. button_info.icon_path,
                    resize = false,
                    widget = wibox.widget.imagebox
                },
                {
                    text = button_info.text,
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            margins = 1,
            widget = wibox.container.margin,
        },
        bg = beautiful.bg_normal,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 6)
        end,
        widget = wibox.container.background,
        buttons = awful.button({}, 1, function()
            if button_info.id == "Caffein" then
                if active_coffee_boolean == false then
                    button_list[6].icon_path = active_coffee_icon_path
                else
                    button_list[6].icon_path = coffee_icon_path
                end
            end
            button_info.on_click()
            popup.visible = false
        end),
    }

    button:connect_signal("mouse::enter", function()
        button.bg = beautiful.bg_focus
    end)

    button:connect_signal("mouse::leave", function()
        button.bg = beautiful.bg_normal
    end)

    return button
end

local function createButtons()

    buttons_container:reset()

    for _, button_info in ipairs(button_list) do
        local button = createButton(button_info)
        buttons_container:add(button)
    end
end

local function createPopup()
    popup = awful.popup {
        widget = {
            buttons_container,
            margins = 1,
            widget = wibox.container.margin
        },
        ontop = true,
        visible = false,
    }
end


local function show_popup()
    local mouse_coords = mouse.coords()
    if popup.visible then
        popup.visible = not popup.visible
    else
        createButtons()
        popup:move_next_to(mouse.current_widget_geometry)
    end
end

createButtons()
createPopup()

return {
    show_popup = show_popup,
    toggleCaffeinate =toggleCaffeinate,
}
