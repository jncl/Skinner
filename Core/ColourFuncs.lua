local _, aObj = ...

local _G = _G

local r, g, b, _
function aObj:clrBBC(obj, clrName, alpha)

	--@debug@
	 _G.assert(obj, "Missing object cBBC\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- handle missing objects (e.g. missing button borders etc), bugfix for #269
	if not obj then
		return
	end

	-- bugfix for #239
	if obj.SetBackdropBorderColor then
		r, g, b, _ = self:getColourByName(clrName)
		obj:SetBackdropBorderColor(r, g, b, alpha or 1)
	end

end

local iBdr
function aObj:clrButtonFromBorder(bObj, texture)

	--@debug@
	 _G.assert(bObj and bObj.sbb, "Missing object cBFB\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	iBdr = bObj[texture] or bObj.IconBorder or bObj.iconBorder
	--@debug@
	 _G.assert(iBdr, "Missing border Texture cBFB\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	if iBdr then
		iBdr:SetAlpha(1) -- ensure alpha is 1 otherwise btn.sbb isn't displayed
		-- use the colour of the item's border as the BackdropBorderColor if shown
		if iBdr:IsShown() then
			bObj.sbb:SetBackdropBorderColor(iBdr:GetVertexColor())
		else
			self:clrBtnBdr(bObj, "grey", 0.75)
		end
		iBdr:SetAlpha(0)
	end

end

function aObj:clrBtnBdr(bObj, clrName, alpha)

	--@debug@
	 _G.assert(bObj.sbb or bObj.sb or bObj, "Missing object cBB\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- handle missing objects (e.g. missing button borders etc), bugfix for #269
	if not bObj then
		return
	end

	-- check button state and alter colour accordingly
	clrName = bObj.IsEnabled and not bObj:IsEnabled() and "disabled" or clrName
	self:clrBBC(bObj.sbb or bObj.sb or bObj, clrName, alpha)

end


function aObj:clrFrameBdr(fObj, clrName, alpha)

	--@debug@
	 _G.assert(fObj and fObj.sf, "Missing object cFB\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- check frame state and alter colour accordingly
	clrName = fObj.IsEnabled and not fObj:IsEnabled() and "disabled" or clrName
	self:clrBBC(fObj.sf, clrName, alpha)

end

-- colour Frame border based upon Covenant
local tKit
function aObj.clrCovenantBdr(_, frame, uiTextureKit)

	tKit = uiTextureKit or _G.C_Covenants.GetCovenantData(_G.C_Covenants.GetActiveCovenantID()).textureKit
	r, g, b = _G.COVENANT_COLORS[tKit]:GetRGB()
	frame.sf:SetBackdropBorderColor(r, g, b, 0.75)

end

local ppb, npb
function aObj:clrPNBtns(btnPrefix, isObj)

	ppb = isObj and btnPrefix.PrevPageButton or _G[btnPrefix .. "PrevPageButton"]
	npb = isObj and btnPrefix.NextPageButton or _G[btnPrefix .. "NextPageButton"]
	self:clrBtnBdr(ppb, "gold")
	self:clrBtnBdr(npb, "gold")

end

local clrTab = {
	black       = _G.BLACK_FONT_COLOR,
	blue        = _G.BLUE_FONT_COLOR,
	bright_blue = _G.BRIGHTBLUE_FONT_COLOR,
	brownish    = _G.CreateColor(0.585, 0.5, 0.31), -- 150, 130, 80 (RewardTrackFrame element border)
	common      = _G.COMMON_GRAY_COLOR,
	-- default     = aObj.bbClr, [N.B. not populated when table is created]
	disabled    = _G.DISABLED_FONT_COLOR,
	gold_df     = _G.GOLD_FONT_COLOR,
	gold        = _G.PASSIVE_SPELL_FONT_COLOR,
	green       = _G.GREEN_FONT_COLOR,
	grey        = _G.GRAY_FONT_COLOR,
	light_blue  = _G.LIGHTBLUE_FONT_COLOR,
	normal      = _G.NORMAL_FONT_COLOR,
	orange      = _G.ORANGE_FONT_COLOR,
	red         = aObj.isMnln and _G.DULL_RED_FONT_COLOR or _G.CreateColor(0.75, 0.15, 0.15),
	selected    = _G.PAPER_FRAME_EXPANDED_COLOR,
	sepia       = _G.SEPIA_COLOR,
	silver      = _G.QUEST_OBJECTIVE_FONT_COLOR,
	topaz       = _G.CreateColor(0.6, 0.31, 0.24),
	turq        = _G.ADVENTURES_BUFF_BLUE,
	white       = _G.HIGHLIGHT_FONT_COLOR,
	yellow      = _G.YELLOW_FONT_COLOR,
}
-- handle missing entries
_G.setmetatable(clrTab, {__index = function(t, k)
	if k == "slider" then
		return aObj.prdb.SliderBorder
	elseif k == "unused" then
		return t["red"]
	else
		return aObj.bbClr
	end
end})
function aObj.getColourByName(_, clrName)

	return clrTab[clrName]:GetRGBA()

end

local newText
function aObj.removeColourCodes(_, text)

	-- N.B. codes checked for are ASCII
	if text then
		newText = text
		for _, aCode in _G.pairs{"\124\99", "\124\67"} do -- if string contains colour prefix [7C 63/43] |c & |C
			if text:find(aCode) then
				if text:match("n%D+_COLOR:") then -- if string contains a color name, e.g. nPURE_BLUE_COLOR:
					newText = text:gsub(aCode .. "n%D+_COLOR:", "") -- remove colour name
				else
					newText = text:gsub(aCode .. "%x%x%x%x%x%x%x%x", "") -- remove hex digits
				end
				newText = newText:gsub("\124\114", "") -- remove colour suffix [7C 72] |r
			end
		end
		return newText, newText ~= text
	end

end

function aObj:setBtnClr(bObj, quality)

	-- handle in combat
	if _G.InCombatLockdown() then
	    self:add2Table(self.oocTab, {self.setBtnClr, {self, bObj, quality}})
	    return
	end

	if bObj.sbb then
		if quality then
			if _G.BAG_ITEM_QUALITY_COLORS[quality] then
				bObj.sbb:SetBackdropBorderColor(_G.BAG_ITEM_QUALITY_COLORS[quality].r, _G.BAG_ITEM_QUALITY_COLORS[quality].g, _G.BAG_ITEM_QUALITY_COLORS[quality].b, 1)
			else
				self:clrBtnBdr(bObj, "grey", 0.75)
			end
		else
			if _G.TradeSkillFrame
			and _G.TradeSkillFrame.DetailsFrame
			and bObj == _G.TradeSkillFrame.DetailsFrame.Contents.ResultIcon
			then
				self:clrBtnBdr(bObj, "normal", 1)
			else
				self:clrBtnBdr(bObj, "grey", 0.75)
			end
		end
	end

end
