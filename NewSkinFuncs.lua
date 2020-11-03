local _, aObj = ...

local _G = _G

-- skin Templates
aObj.skinTPLs = {
	defaults = {
		fType		= "a",
	},
	tabs = {
		numTabs     = 1,
		selectedTab = 1,
		suffix      = "",
		regions     = {7, 8},
		ignoreSize  = false,
		lod         = false,
		upwards     = false,
		offsets     = {x1=6, y1=0, x2=-6, y2=2},
		ignoreHLTex = false,
		offsetsHL   = {x1=8, y1=2, x2=-8, y2=0},
		track       = true,
		noCheck     = false,
		func        = nil,
	},
	new = function(type, table)
		_G.setmetatable(table, {__index = function(table, key) return aObj.skinTPLs[type][key] end})
		return table
	end,
}
do
	for name, table in _G.pairs(aObj.skinTPLs) do
		if name ~= "defaults"
		and name ~= "new"
		then
			table.type = name
			_G.setmetatable(table, {__index = function(table, key) return aObj.skinTPLs.defaults[key] end})
		end
	end
end

local function skinTabs(template)
--@alpha@
	_G.assert(template, "Missing Template (skinTabs)\n" .. _G.debugstack(2, 3, 2))
	_G.assert(template.obj, "Missing Tab Object (skinTabs)\n" .. _G.debugstack(2, 3, 2))
	_G.assert(template.names or template.prefix, "Missing Tab Names or Tab Prefix (skinTabs)\n" .. _G.debugstack(2, 3, 2))
--@end-alpha@

	aObj:Debug2("skinTabs: [%s]", template)

	-- don't skin it twice unless required (Ace3)
	if not template.noCheck
	and template.obj.sknd
	then
		return
	else
		template.obj.sknd = true
	end

	-- create table of tab names if not supplied
	if not template.names then
		template.names = {}
		for i = 1, template.obj.numTabs or template.numTabs do
			aObj:add2Table(template.names, _G[template.prefix .. "Tab"  ..  template.suffix .. i])
		end
	end

	local oFs = template.offsets
	for i, tab in _G.pairs(template.names) do
		aObj:keepRegions(tab, template.regions)
		aObj:addSkinFrame{obj=tab, ft=template.fType, noBdr=aObj.isTT, x1=oFs.x1, y1=oFs.y1, x2=oFs.x2, y2=oFs.y2}
		tab.sf.ignore = template.ignoreSize
		tab.sf.up = template.upwards
		if template.lod then -- set textures here first time thru as it's LoD
			if aObj.isTT then
				if i == template.selectedTab then
					aObj:setActiveTab(tab.sf)
				else
					aObj:setInactiveTab(tab.sf)
				end
			end
		end
		if template.ignoreHLTex then
			-- change highlight texture
			local ht = tab:GetHighlightTexture()
			if ht then -- handle other AddOns using tabs without a highlight texture
				ht:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-Tab-Highlight]])
				ht:ClearAllPoints()
				if template.upwards then -- (GuildInfoFrame, LookingForGuild, MacroFrame, FriendsTabHeader)
					ht:SetPoint("TOPLEFT", 1, -5)
					ht:SetPoint("BOTTOMRIGHT", -1, -5)
				else
					local hOFs = template.offsetsHL
					ht:SetPoint("TOPLEFT", hOFs.x1, hOFs.y1)
					ht:SetPoint("BOTTOMRIGHT", hOFs.x2, hOFs.y2)
					hOFs = nil
				end
			end
			ht = nil
		end
		if template.func then
			template.func(tab)
		end
	end
	oFs = nil

	-- add object to table to track tab updates is required
	aObj.tabFrames[template.obj] = template.track

end

-- Add skinning functions to this table
local skinFuncs = {
	tabs = function(table) skinTabs(table) end,
}
function aObj:skinObject(table)
--@alpha@
	_G.assert(table, "Missing table skinObject\n" .. _G.debugstack(2, 3, 2))
	_G.assert(table.type, "Missing object type skinObject\n" .. _G.debugstack(2, 3, 2))
--@end-alpha@

	-- _G.Spew("", table)
	-- aObj:Debug("skinObject: [%s, %s]", table, table.type)

	skinFuncs[table.type](table)

end
