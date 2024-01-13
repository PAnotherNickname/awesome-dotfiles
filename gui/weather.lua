local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")
local config = require("main.global-variables")

local HOME = os.getenv('HOME')

local location = config.location
location = "'" .. location .. "'"


function parse_weather_output(output)
    local day_list = {}

    local output = string.gsub(output, '^.+forecast: ', '')

    local days = {}
    for day_str in output:gmatch("(%a+ %a+ %d+: %S+ °C %a+)") do
        table.insert(days, day_str)
    end

    for _, line in ipairs(days) do
        local week_day, month, num_day, temp_max, temp_min, symbol = line:match("(%a+) (%a+) (%d+): (%S+)/(%S+) °C (%a+)")
        if temp_max == "-0" then
        temp_max = "0"
       elseif temp_min == "-0" then
        temp_min = "0"
        end

        table.insert(day_list, {
            week_day = week_day,
            month = month,
            num_day = num_day,
            temp_max = temp_max,
            temp_min = temp_min,
            symbol = symbol,
        })
    end

    return day_list
end

-- Function to update the weather information
function update_weather_info()
    local weather_widget = wibox.widget {
        layout = wibox.layout.flex.horizontal,
        spacing = 10,
        forced_height = 55,
        margins = 200,
    }

    awful.spawn.easy_async("ansiweather -l " .. location .. " -u metric -s true -f 5 -d true -a false -H true", function(stdout)
        local day_list = parse_weather_output(stdout)

        for _, day in ipairs(day_list) do
            local day_widget = wibox.widget {
                layout = wibox.layout.fixed.vertical,
                {
                    {
                        widget = wibox.widget.imagebox,
                        forced_width = 28,
                        forced_height = 48,
                        resize = true,
                        align = "center",
                        image = HOME .. "/.config/awesome/gui/images/weather/" .. day.symbol .. ".svg", -- Replace with the actual path
                    },
                align = 'center',
                widget = wibox.container.place
                },
                {
                    widget = wibox.container.margin,
                    margins = { top = -30 },  -- Adjust the top margin to move the content up
                    {
                        widget = wibox.widget.textbox,
                        text = day.month ..  " " .. day.num_day,
                        align = "center",
                    },
                },
                {
                    widget = wibox.container.margin,
                    margins = { top = -9 },  -- Adjust the top margin to move the content up
                    {
                        widget = wibox.widget.textbox,
                        text = day.temp_max ..  "/" .. day.temp_min .. " °C",
                        align = "center",
                    },
                },            }

            weather_widget:add(day_widget)
        end
    end)

    return weather_widget
end

return {
    parse_weather_output = parse_weather_output,
    update_weather_info = update_weather_info,
}
