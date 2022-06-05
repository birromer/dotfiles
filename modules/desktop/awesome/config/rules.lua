local awful = require("awful")
local beautiful = require("beautiful")
local capi = {
  screen = screen
}
local dpi = beautiful.xresources.apply_dpi


local function apply_delayed_rule(c)
  if not c.class and not c.name then
    local begin_message = {"begin", c.class, c.name}
    local f
    f = function(_c)
        _c:disconnect_signal("property::class", f)
        if _c.class == "Spotify" then
            awful.rules.apply(_c)
        else
          nlog(begin_message)
          nlog({"end", _c.class, _c.name})
        end
    end
    c:connect_signal("property::class", f)
  end
end


local rules = {}

function rules.init(awesome_context)

  awful.rules.rules = {

      { rule = { },
        properties = {
          --border_width = beautiful.border_width,
          --border_color = beautiful.border_normal,
          focus = awful.client.focus.filter,
          raise = true,
          keys = awesome_context.clientkeys,
          buttons = awesome_context.clientbuttons,
          placement =
            awful.placement.centered +
            awful.placement.no_overlap +
            awful.placement.no_offscreen,
          size_hints_honor = false,
          screen = awful.screen.preferred,
          --slave = true,
          --slave = awesome_context.DEVEL_DYNAMIC_LAYOUTS,
        },
        --callback = apply_delayed_rule,
        callback = function(c)
          --if not awesome_context.DEVEL_DYNAMIC_LAYOUTS then
            awful.client.setslave(c)
          --end
          apply_delayed_rule(c)
        end
      },
      { rule = {type = "dialog"},
        properties = {
          titlebars_enabled = true,
          ontop = true
        },
      },
      { rule = {class = "Nemo", instance = "file_progress"},
        properties = {
          titlebars_enabled = true,
          ontop = true,
        },
      },

      -- Applications:

      { rule = { class = "Firefox" },
        properties = {
          tag=capi.screen.primary.tags[2],
          raise=false
        }
      },

      { rule = { class = "Emacs" },
        properties = {
          tag=capi.screen.primary.tags[3],
          raise=false
        }
      },

      { rule = { class = "Sublime_text" },
        properties = {
          tag=capi.screen.primary.tags[3],
          raise=false
        }
      },

      { rule = { class = "code-oss" },
        properties = {
          tag=capi.screen.primary.tags[3],
          raise=false
        }
      },

      { rule = { class = "Spyder" },
        properties = {
          tag=capi.screen.primary.tags[3],
          raise=false
        }
      },

      { rule = { class = "Vlc" },
        properties = {
          tag=capi.screen.primary.tags[7],
          raise=false
        }
      },

      { rule = { class = "Zotero" },
        properties = {
          tag=capi.screen.primary.tags[9],
          raise=false
        }
      },

      { rule = { class = "Evince" },
        properties = {
          tag=capi.screen.primary.tags[8],
          raise=false
        }
      },

      { rule = { class = "Typora" },
        properties = {
          tag=capi.screen.primary.tags[4],
          raise=false
        }
      },

      { rule = { class = "Tusk" },
        properties = {
          tag=capi.screen.primary.tags[5],
          raise=false
        }
      },

      { rule = { class = "Mcomix" },
        properties = {
          tag=capi.screen.primary.tags[8],
          raise=false
        }
      },

      { rule = { class = "Steam" },
        properties = {
          tag=capi.screen.primary.tags[11],
          raise=false
        }
      },

      { rule = { class = "calibre" },
        properties = {
          tag=capi.screen.primary.tags[8],
          raise=false
        }
      },

      { rule = { class = "Thunderbird" },
        properties = {
          tag=capi.screen.primary.tags[10],
          raise=false
        }
      },

      { rule = { class = "TelegramDesktop" },
        properties = {
          tag=capi.screen.primary.tags[11],
          raise=false
        }
      },

      { rule = { class = "discord" },
        properties = {
          tag=capi.screen.primary.tags[11],
          raise=false
        }
      },

      { rule = { class = "Google-chrome" },
        properties = {
          tag=capi.screen.primary.tags[2],
          raise=false
        }
      },

      { rule = { class = "Org.gnome.Nautilus" },
        properties = {
          tag=capi.screen.primary.tags[6],
          raise=false
        }
      },

      { rule = { class = "Spotify" },
        properties = {
          tag=capi.screen.primary.tags[12],
          raise=false
        }
      },

      { rule = { class = "Transmission-gtk"},
        properties = {
          tag=capi.screen.primary.tags[6],
      }, },
      { rule = { class = "Transmission-gtk", role = "tr-info" },
        properties = {
          floating = false,
          ontop = false,
      }, },
      { rule = { class = "Transmission-gtk", name = "Torrent Options" },
        properties = {
          width = dpi(700),
      },},

      { rule = { class = "qBittorent"},
        properties = {
          tag=capi.screen.primary.tags[6],
        },
      },

      { rule = { name = "xfce4-panel"},
        properties = {
          valid=false,
        },
        callback = function(c)
          c.valid = false
          c.focusable = false
        end,
      },

      { rule = { class = "Pidgin"},
        properties = {
          tag=capi.screen.primary.tags[10],
        },
      },
      { rule = { class = "Pidgin", role = "buddy_list"},
        properties = {
          placement = awful.placement.top_right,
        },
        callback = function(c)
          local wa = c.screen.workarea
          local g = c:geometry()
          g.x = wa.x + wa.width - g.width - (beautiful.useless_gap*9) - (beautiful.border_width*2)
          g.y = wa.y + (beautiful.useless_gap*6)
          c:geometry(g)
        end
      },
      { rule = { class = "Pidgin", role = "smiley_dialog"},
        properties = {
          placement = awful.placement.centered,
        },
      },

      { rule = { class = "ghostwriter", type = "dialog"},
        properties = {
          titlebars_enabled = false,
        },
        callback = function(c)
          c.titlebars_enabled = false
        end,
      },

      { rule = { class = "mpv" },
        properties = {
          size_hints_honor = true,
        }
      },

  }

  --awful.ewmh.add_activate_filter(function(c, source)
      --nlog({source, c.class})
      --if source=="rules" and c.class == "Firefox-developer-edition" then
        --return false
      --end
  --end)
  --
end

return rules
