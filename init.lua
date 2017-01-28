-- mods/chisel/init.lua
-- ====================
-- See LICENSE.txt for licensing information.

chisel = {}
chisel.data = {}

function chisel.register_chisel_of(baseitem, cname, cdef)
	-- use the def of the normal, unchiseled item as base
	basedef = table.copy(core.registered_items[baseitem])

	-- set the given chisel-changes
	for field, fvar in pairs(cdef) do
		basedef[field] = fvar
	end

	-- add the base item in the def
	basedef.chisel_base = baseitem
	basedef.groups = basedef.groups or {}
	basedef.groups.chisel = 1

	-- register the new chisel
	core.register_item(":" .. baseitem .. "_" .. cname, basedef)

	-- add the new chisel item to the list
	if not chisel.data[baseitem] then
		chisel.data[baseitem] = {}
	end
	table.insert(chisel.data[baseitem], baseitem .. "_" .. cname)

	-- register a new alias, with the chisel ID
	-- the chisel IDs may differ, if the order of the loaded mods has changed
	core.register_alias(baseitem .. ".c" .. tostring(#chisel.data[baseitem]),
		baseitem .. "_" .. cname)
end

function chisel.get_formspec()
	local form = "size[8,8.5]" ..
		-- inventory design
		default.gui_bg ..
		default.gui_bg_img ..
		default.gui_slots ..
		-- chisel input
		"list[current_player;chisel_input;0,0;1,1]" ..
		-- chisel output
		"list[current_player;chisel_output;0,1;8,4]" ..
		-- main inv. of the player
		"list[current_player;main;0,4.25;8,1;]" ..
		"list[current_player;main;0,5.5;8,3;8]" ..
		"listring[current_player;main]" ..
		"listring[current_player;craft]" ..
		-- darker hotbar slots
		default.get_hotbar_bg(0, 4.25)

	return form
end

local function openChiselMenu(itemstack, user, pointed_thing)
	--if placer:is_player() then
		core.show_formspec(user:get_player_name(), "chisel:menu", chisel.get_formspec())
	--end
end

core.register_tool("chisel:chisel", {
	description = "Chisel",
	inventory_image = "default_coal_block.png",
	on_use = openChiselMenu,
})


chisel.register_chisel_of("default:sandstone", "brown", {
	description = "Brown Sandstone",
	tiles = {"default_coal_block.png"},
})
