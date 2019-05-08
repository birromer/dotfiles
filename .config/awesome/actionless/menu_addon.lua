--------------------------------------------------------------------------------
-- @author Yauheni Kirylau &lt;actionless.loveless@gmail.com&gt;
-- @copyright 2013-2014 Yauheni Kirylau
--------------------------------------------------------------------------------

local menu = require("awful.menu")
local escape_f = require("gears.string").xml_escape
local awful_screen = require("awful.screen")

local table_add = require("actionless.util.table").add


local menu_addon = { mt={} }


function menu_addon.clients_on_tag(args, item_args)
  local cls_t = {}

  local selected_tags = awful_screen.focused().selected_tags
  for _, t in ipairs(selected_tags) do
    local clients_on_tag = t.clients(t)
    for _, c in ipairs(clients_on_tag) do
      table.insert(cls_t, {
        escape_f(c.name) or "",
        function ()
          client.focus = c
          c:raise()
        end,
        c.icon
      })
      if item_args then
        if type(item_args) == "function" then
          table_add(cls_t[#cls_t], item_args(c))
        else
          table_add(cls_t[#cls_t], item_args)
        end
      end
    end
  end
  args = args or {}
  args.items = args.items or {}
  table_add(args.items, cls_t)

  local m = menu.new(args)
  m:show(args)
  return m
end

function menu_addon.mt:__call(...)
  return self.new(...)
end

return setmetatable(menu_addon, menu)
