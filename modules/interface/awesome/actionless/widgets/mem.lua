--[[
     Licensed under GNU General Public License v2
      * (c) 2013-2015, Yauheni Kirylau
      * (c) 2013,      Luke Bonham
      * (c) 2010-2012, Peter Hofmann
--]]

local naughty = require("naughty")
local beautiful = require("beautiful")
local awful = require("awful")
local gears_timer = require("gears.timer")

local h_table = require("actionless.util.table")
local h_string = require("actionless.util.string")
local parse = require("actionless.util.parse")
local common_widgets = require("actionless.widgets.common")

-- Memory usage (ignoring caches)
local mem = {
  now = {},
  notification = nil,
  show_percents = true,
}

local function worker(args)
  args   = args or {}
  local update_interval  = args.update_interval or 5
  mem.timeout = args.timeout or 0

  local widget = common_widgets.text_progressbar(args)
  mem.widget = common_widgets.decorated{widget=widget}
  mem.widget.textbox = widget.textbox
  mem.widget.progressbar = widget.progressbar

  --mem.widget:set_image(beautiful.widget_mem)
  mem.widget:connect_signal(
    "mouse::enter", function () mem.show_notification() end)
  mem.widget:connect_signal(
    "mouse::leave", function () mem.hide_notification() end)

  mem.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function()
      mem.show_percents = not mem.show_percents
      mem.show_notification()
    end)
  ))

  mem.list_len = args.list_length or 10

  mem.command = "top -o \\%MEM -b -n 1 -w 512"
  mem.columns = args.columns or {
    percent=10,
    name=12
  }

  function mem.hide_notification()
    if mem.notification ~= nil then
      naughty.destroy(mem.notification)
      mem.notification = nil
    end
  end

  function mem.get_notification_id()
    return mem.notification and mem.notification.id or nil
  end

  function mem.show_notification()
    mem.notification = naughty.notify({
      text = "waiting for top...",
      timeout = mem.timeout,
      font = beautiful.mono_font,
      replaces_id = mem.get_notification_id(),
      position = beautiful.widget_notification_position,
    })
    awful.spawn.easy_async(
      mem.command,
      mem.notification_callback_done
    )
    mem.update()
  end

  function mem.notification_callback_done(output)
    local notification_id = mem.get_notification_id()
    if not notification_id then return end
    local result = {}

    local column_headers = h_string.split(
      h_table.range(
        parse.string_to_lines(output),
        6, 6
      )[1], ' '
    )
    for _, line in ipairs(
      h_table.range(
        parse.string_to_lines(output),
        7
      )
    ) do
      local values = h_string.split(line, ' ')
      local percent = values[mem.columns.percent]
      local name = values[mem.columns.name]
      if name == 'Web' then name = 'firefox' end
      if name == 'WebExtensions' then name = 'firefox' end
      percent = mem.show_percents and (percent + 0) or (percent * 0.01 * mem.now.total)
      if result[name] then
        result[name] = result[name] + percent
      elseif name then
        result[name] = percent
      end
    end

    local result_string = string.format(
      '%5s %s\n',
      mem.show_percents and column_headers[mem.columns.percent] or "MiB",
      column_headers[mem.columns.name]
    )
    result_string = result_string .. '<span font="'  .. tostring(beautiful.text_font)  .. '">'
    local counter = 0
    for k, v in h_table.spairs(result, function(t,a,b) return t[b] < t[a] end) do
      result_string = result_string .. string.format(mem.show_percents and "%5.1f %s" or "%5d %s", v, k)
      counter = counter + 1
      if counter == mem.list_len then
        break
      end
      result_string = result_string .. '\n'
    end
    result_string = result_string .. '</span> '

    mem.notification = naughty.notify({
      text = result_string,
      timeout = mem.timeout,
      font = beautiful.mono_font,
      replaces_id = mem.get_notification_id(),
      position = beautiful.widget_notification_position,
    })
  end

  function mem.update()
    mem.now = parse.find_values_in_file(
      "/proc/meminfo",
      "([%a]+):[%s]+([%d]+).+",
      { total = "MemTotal",
        free = "MemFree",
        available = "MemAvailable",
        buf = "Buffers",
        cache = "Cached",
        --shared = "Shmem",
        --swap = "SwapTotal",
        --swapf = "SwapFree",
      },
      function(v) return math.floor(v / 1024) end)
    --mem.now.used = mem.now.total - (mem.now.free + mem.now.buf + mem.now.cache)
    mem.now.used = mem.now.total - mem.now.available
    --mem.now.swapused = mem.now.swap - mem.now.swapf

    local msg = string.format(
      "%6s", mem.now.used .. "MB"
    )
    if mem.now.used > mem.now.total * 0.9 then
      mem.widget:set_error()
    elseif mem.now.used > mem.now.total * 0.8 then
      mem.widget:set_warning()
    else
      mem.widget:set_normal()
      msg = args.text or 'mem'
    end
    mem.widget.textbox:set_text(msg)
    mem.widget.progressbar:set_value(mem.now.used/mem.now.total)
  end

  gears_timer({
    callback=mem.update,
    timeout=update_interval,
    autostart=true,
    call_now=true,
  })

  return setmetatable(mem, { __index = mem.widget })
end -- worker

return setmetatable(mem, { __call = function(_, ...) return worker(...) end })
