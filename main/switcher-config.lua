local switcher = require("addons.awesome-switcher")


    switcher.settings.preview_box = true                                -- display preview-box
    switcher.settings.preview_box_bg = "#222222"                      -- background color
    switcher.settings.preview_box_border = "#22222200"                   -- border-color
    switcher.settings.preview_box_fps = 30                               -- refresh framerate
    switcher.settings.preview_box_delay = 150                            -- delay in ms
    switcher.settings.preview_box_title_font = {"sans","italic","normal"}-- the font for cairo
    switcher.settings.preview_box_title_font_size_factor = 0.8           -- the font sizing factor
    switcher.settings.preview_box_title_color = {1,1,1,1}                -- the font color

    switcher.settings.client_opacity = false                             -- opacity for unselected clients
    switcher.settings.client_opacity_value = 0.5                         -- alpha-value for any client
    switcher.settings.client_opacity_value_in_focus = 0.5                -- alpha-value for the client currently in focus
    switcher.settings.client_opacity_value_selected = 1                  -- alpha-value for the selected client

    switcher.settings.cycle_raise_client = true                          -- raise clients on cycle
    switcher.settings.cycle_all_clients  = false
