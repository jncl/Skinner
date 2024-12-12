local aName, aObj = ...

local _G = _G

local module = aObj:NewModule("UIButtons", "AceEvent-3.0", "AceHook-3.0")
local db

do
	-- characters used on buttons
	module.mult    = "×" -- multiplication sign NOT lower case X
	module.plus    = "+"
	module.minus   = "-" -- using Hyphen-minus(-) instead of minus sign(−) for font compatiblity reasons
	module.larrow  = "←" -- Leftwards Arrow (U+2190)
	module.uarrow  = "↑" -- Upwards Arrow (U+2191)
	module.rarrow  = "→" -- Rightwards Arrow (U+2192)
	module.darrow  = "↓" -- Downwards Arrow (U+2193)
	module.nwarrow = "↖" -- North West Arrow (U+2196)
	module.nearrow = "↗" -- North East Arrow (U+2197)
	module.searrow = "↘" -- South East Arrow (U+2198)
	module.swarrow = "↙" -- South West Arrow (U+2199)
	module.gearcog = "⛯" -- Lighthouse Map Symbol (U+26EF)
	-- create font to use for Close Buttons
	module.fontX = _G.CreateFont("fontX")
	module.fontX:SetFont([[Fonts\FRIZQT__.TTF]], 20, "")
	module.fontX:SetTextColor(_G.NORMAL_FONT_COLOR:GetRGB())
	-- create font to use for Black Close Buttons (TalkingHeadFrame)
	module.fontBX = _G.CreateFont("fontBX")
	module.fontBX:SetFont([[Fonts\FRIZQT__.TTF]], 20, "")
	module.fontBX:SetTextColor(_G.BLACK_FONT_COLOR:GetRGB())
	-- create font for disabled text
	module.fontDX = _G.CreateFont("fontDX")
	module.fontDX:SetFont(module.fontX:GetFont())
	module.fontDX:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
	-- create font to use for small blue Close Buttons (e.g. BNToastFrame)
	module.fontSBX = _G.CreateFont("fontSBX")
	module.fontSBX:SetFont([[Fonts\FRIZQT__.TTF]], 14, "")
	module.fontSBX:SetTextColor(_G.BATTLENET_FONT_COLOR:GetRGB())
	-- create font to use for small Buttons (e.g. MinimalArchaeology)
	module.fontSB = _G.CreateFont("fontSB")
	module.fontSB:SetFont([[Fonts\FRIZQT__.TTF]], 14, "")
	module.fontSB:SetTextColor(_G.NORMAL_FONT_COLOR:GetRGB())
	-- create font to use for Minus/Plus Buttons
	module.fontP = _G.CreateFont("fontP")
	module.fontP:SetFont([[Fonts\ARIALN.TTF]], 16, "")
	module.fontP:SetTextColor(_G.NORMAL_FONT_COLOR:GetRGB())
	-- create font for disabled text on Minus/Plus Buttons
	module.fontDP = _G.CreateFont("fontDP")
	module.fontDP:SetFont(module.fontP:GetFont())
	module.fontDP:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
	-- create font to use for Arrow buttons
	module.fontS = _G.CreateFont("fontS")
	module.fontS:SetFont([[Interface\AddOns\]] .. aName .. [[\Fonts\NotoSansSymbols-Medium.ttf]], 16, "")
	module.fontS:SetTextColor(_G.NORMAL_FONT_COLOR:GetRGB())
	-- create font for disabled Arrow buttons
	module.fontDS = _G.CreateFont("fontDS")
	module.fontDS:SetFont(module.fontS:GetFont())
	module.fontDS:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
end

local texNumbers = {
	[130821] = "minus",
	[130838] = "plus",
}
local texSuffixes = {
	["plusbutton"]    = "plus",
	["zoominbutton"]  = "plus",
	["_closed"]       = "plus",
	["minusbutton"]   = "minus",
	["zoomoutbutton"] = "minus",
	["_open"]         = "minus",
}
local btn, nTex
local function __checkTex(opts)
	--[[
		Calling parameters:
			obj = object (Mandatory)
			nTex = Texture
			mp2 = minus/plus type 2
	--]]
	--@debug@
	 _G.assert(opts.obj, "Missing object __cT\n" .. _G.debugstack(2, 3, 2))
	 --@end-debug@

	-- hide existing textures if they exist (Armory/GupCharacter requires this)
	if opts.obj.GetNormalTexture and opts.obj:GetNormalTexture() then opts.obj:GetNormalTexture():SetAlpha(0) end
	if opts.obj.GetPushedTexture and opts.obj:GetPushedTexture() then opts.obj:GetPushedTexture():SetAlpha(0) end
	if opts.obj.GetDisabledTexture and opts.obj:GetDisabledTexture() then opts.obj:GetDisabledTexture():SetAlpha(0) end

	btn = opts.obj.onSB and opts.obj.sb or opts.obj
	if not btn then return end -- handle unskinned buttons
	nTex = opts.nTex or opts.obj:GetNormalTexture() and opts.obj:GetNormalTexture():GetTexture() or nil
	-- aObj:Debug("__checkTex: [%s, %s]", nTex)

	local header = false
	if nTex then
		if _G.tonumber(nTex) then
			for num, type in _G.pairs(texNumbers) do
				if nTex == num then
					btn:SetText(module[type])
					btn:Show()
					header = true
					break
				end
			end
		else
			for str, type in _G.pairs(texSuffixes) do
				if nTex:lower():find(str) then
					btn:SetText(module[type])
					btn:Show()
					header = true
					break
				end
			end
		end
	end
	if not header then
		btn:SetText("")
		btn:Hide()
	end

end
function module.checkTex(_, ...)

	local opts = _G.select(1, ...)

	--@debug@
	 _G.assert(opts, "Missing object cT\n" .. _G.debugstack(2, 3, 2))
	 --@end-debug@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata"
	and _G.type(opts.GetObjectType) == "function"
	then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
		opts.nTex = _G.select(2, ...) and _G.select(2, ...) or nil
		opts.mp2 = _G.select(3, ...) and _G.select(3, ...) or nil
	end

	if aObj:canSkin(__checkTex, opts, false) then
		__checkTex(opts)
	end

end

local hTexFile, clr, r, g ,b, _
function module:chgHLTex(obj, hTex)

	-- handle in combat
	if _G.InCombatLockdown() then
		aObj:add2Table(aObj.oocTab, {self.chgHLTex, {self, obj, hTex}})
		return
	end

	if hTex then
		hTexFile = hTex:GetTexture()
		if hTexFile then
			if _G.tonumber(hTexFile) then
				if _G.tonumber(hTexFile) == 3046538 then -- auctionhouse-nav-button
					clr = "grey"
				elseif _G.tonumber(hTexFile) == 1536801 then -- addonlist button highlight
					clr = "red"
				end
			else
				if hTexFile:find("UI-Panel-Button-Highlight", 1, true) -- UIPanelButtonHighlightTexture
				or hTexFile:find("UI-DialogBox-Button-Highlight", 1, true) -- StaticPopupButton/PetPopupButton/CinematicDialogButton
				then
					clr = "red"
				elseif hTexFile:find("UI-Silver-Button-Highlight", 1, true) -- UIMenuButtonStretchTemplate
				or hTexFile:find("UI-Minimap-ZoomButton-Highlight", 1, true)
				or hTexFile:find("HelpButtons", 1, true) -- Classic Help Buttons
				then
					clr = "blue"
				elseif hTexFile:find("UI-Silver-Button-Select", 1, true) then -- UIMenuButtonStretchTemplate
					clr = "yellow"
				end
			end
			if clr then
				r, g, b, _ = aObj:getColourByName(clr)
				hTex:SetColorTexture(r, g, b, 0.25)
				-- inset colour
				if obj.sb then
					hTex:ClearAllPoints()
					hTex:SetPoint("TOPLEFT", obj.sb, "TOPLEFT", 5, -5)
					hTex:SetPoint("BOTTOMRIGHT", obj.sb, "BOTTOMRIGHT", -5, 5)
				end
			end
		end
	end

end

local bType
function module.isButton(_, obj)

	-- ignore named/AceConfig/XConfig/AceGUI objects
	if aObj:hasAnyTextInName(obj, {"AceConfig", "XConfig", "AceGUI"}) then return end
	if obj.OrigSetText then -- Cork ui-tab buttons
		return
	end

	if (obj.Left or obj.leftArrow or obj.GetNormalTexture) -- is it a true button
	and not obj.GetChecked -- and not a checkbutton
	and not (obj.obj and obj.obj.checkbg) -- an Ace3 checkbutton
	and not obj.SetSlot -- and not a lootbutton
	then
		local oW, oH, nR = _G.Round(obj:GetWidth()), _G.Round(obj:GetHeight()), obj:GetNumRegions()
		if oH == 18 and oW == 18 and nR == 3 then -- BNToast close button
			bType = "toast"
		-- standard close button is 32x32 and has 4 regions
		-- RolePollPopup has 3 regions
		-- Channel Pullout is 24 high
		-- MasterPlan LootFrame is 28 high
		elseif obj:GetParent().CloseButton == obj
		or oH == oW and (nR >= 3 or nR <= 5) and (oH == 32 or oH == 24 or oH == 28)
		and (aObj:hasTextInName(obj, "Close") or aObj:hasTextInTexture(obj:GetNormalTexture(), "UI-Panel-MinimizeButton-Up"))
		then
			bType = "close"
		elseif (obj.Left and obj.Right and obj.Middle and nR == 5) -- based upon UIPanelButtonTemplate
		or (oH >= 20 and oH <= 25 and nR >= 5 and nR <= 8) -- std button
		or (oH == 30 and oW == 160) -- HelpFrame
		or (oH == 32 and oW == 128 and nR == 4) -- BasicScriptErrors Frame
		or (oH == 22 and oW == 108 and nR == 4) -- Tutorial Frame
		then
			bType = "normal"
		elseif oH == 54 then
			bType = "help"
		end
	end

	return bType

end

function module:skinActionBtn(bObj, ftype)

	bObj.SlotBackground:SetTexture(nil)
	bObj.SlotArt:SetTexture(nil)
	bObj.FlyoutBorderShadow:SetTexture(nil)
	bObj.Border:SetAlpha(0) -- texture changed in blizzard code
	if bObj.FlyoutBorder then
		bObj.FlyoutBorder:SetTexture(nil)
	end
	if aObj:canSkinActionBtns() then
		if bObj.NormalTexture then
			bObj.NormalTexture:SetTexture(nil)
		else
			_G[bObj:GetName() .. "NormalTexture"]:SetTexture(nil)
		end
		self:addButtonBorder{obj=bObj, fType=ftype, sabt=true, ofs=3}
	end

end

local text
local function __skinCloseButton(opts)
	--[[
		Calling parameters:
			obj     = object (Mandatory)
			ft      = Frame Type (Skinner classification)
			sap     = set all points of skinButton to object
			onSB    = put text on skinButton
			noSkin  = don't add skin frame
			font    = font to use
			disfont = disabled font to use
			ooc 	= DON'T skin in combat
	--]]
	--@debug@
	_G.assert(opts and _G.type(opts) == "table", "Missing options table __sCB\n" .. _G.debugstack(2, 3, 2))
	_G.assert(opts.obj, "Missing object __sCB\n" .. _G.debugstack(2, 3, 2))
	if opts.obj:GetParent().GlowTop then
		 _G.assert(opts.noSkin, "GlowBox should be skinned __sCB\n" .. _G.debugstack(2, 3, 2))
	end
	--@end-debug@

	-- DON'T skin it twice
	if opts.obj.sb then
		return
	end

	aObj:keepFontStrings(opts.obj)

	-- don't skin button if required
	if not opts.noSkin
	and db.FrameControls
	then
		if opts.sap then
			aObj:skinObject("button", {obj=opts.obj, fType=opts.ftype, sap=true})
		else
			local bW = _G.Round(opts.obj:GetWidth())
			opts.x1 = opts.x1 or bW == 32 and 6 or 4
			opts.y1 = opts.y1 or bW == 32 and -6 or -4
			opts.x2 = opts.x2 or bW == 32 and -6 or -4
			opts.y2 = opts.y2 or bW == 32 and 6 or 4
			aObj:skinObject("button", {obj=opts.obj, fType=opts.ftype, bd=5, x1=opts.x1, y1=opts.y1, x2=opts.x2, y2=opts.y2})
		end
		aObj:clrBtnBdr(opts.obj, opts.clr, opts.ca)
		if opts.schk then
			opts.obj.sb.clr = opts.clr
			opts.obj.sb.ca = opts.ca
			aObj:SecureHook(opts.obj, "Disable", function(bObj, _)
				aObj:clrBtnBdr(bObj)
			end)
			aObj:SecureHook(opts.obj, "Enable", function(bObj, _)
				aObj:clrBtnBdr(bObj, bObj.sb.clr, bObj.sb.ca)
			end)
		end
		if opts.onSB then -- Ace3, ArkInventory & BNToastFrame
			opts.obj.sb:SetNormalFontObject(opts.font or module.fontX)
			opts.obj.sb:SetDisabledFontObject(opts.disfont or module.fontDX)
			opts.obj.sb:SetText(module.mult)
		end
	end
	if not opts.onSB then
		opts.obj:SetNormalFontObject(opts.font or module.fontX)
		opts.obj:SetDisabledFontObject(opts.disfont or module.fontDX)
		opts.obj:SetText(module.mult)
		opts.obj:SetPushedTextOffset(-1, -1)
	end

	if aObj.isRtl then
		text = aObj:getLastRegion(opts.obj)
		text:SetDrawLayer("OVERLAY")
		aObj:moveObject{obj=text, x=-1, y=-1}
	end
end
function module.skinCloseButton(_, ...)

	local opts = _G.select(1, ...)

	--@debug@
	_G.assert(opts, "Missing object sCB\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata"
	and _G.type(opts.GetObjectType) == "function"
	then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
	end

	if aObj:canSkin(__skinCloseButton, opts, opts.ncc) then
		__skinCloseButton(opts)
	end

end

local function __skinExpandButton(opts)
	--[[
		Calling parameters:
			obj    = object (Mandatory)
			ft     = Frame Type (Skinner classification)
			aso    = applySkin options
			as     = use applySkin rather than addSkinButton, used when text appears behind the gradient
			noHook = don't hook SetNormalTexture function to manage texture changes
			onSB   = put text on skinButton
			plus   = use plus sign
			clr    = border colour
			ooc    = DON'T skin in combat
	--]]
	--@debug@
	_G.assert(opts and _G.type(opts) == "table", "Missing options table __sEB\n" .. _G.debugstack(2, 3, 2))
	_G.assert(opts.obj, "Missing object __sEB\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- don't skin it twice (BUGFIX)
	if opts.obj
	and opts.obj.sb
	then
		return
	end

	if not opts.noddl then
		opts.obj:DisableDrawLayer("BACKGROUND")
	end
	aObj:keepFontStrings(opts.obj)

	if not opts.as then
		aObj:skinObject("button", {obj=opts.obj, fType=opts.ftype, sap=opts.sap, bd=6, ofs=opts.ofs, clr=opts.clr})
		if not opts.noHook then
			if aObj.isRtl then
				nTex = opts.obj:GetNormalTexture()
				module:SecureHook(nTex, "SetAtlas", function(_, tObj)
					module:checkTex{obj=opts.obj, nTex=tObj}
				end)
			else
				module:SecureHook(opts.obj, "SetNormalTexture", function(this, tObj)
					module:checkTex{obj=this, nTex=tObj}
				end)
				module:SecureHook(opts.obj, "SetNormalAtlas", function(this, tObj)
					module:checkTex{obj=this, nTex=tObj}
				end)
			end
		end
	else -- Ace3, Archy, ReagentRestocker
		aObj:skinObject("skin", {obj=opts.obj, fType=opts.ftype, bd=opts.aso.bd or 6})
	end
	opts.obj.onSB = opts.onSB -- store this for use in checkTex function
	if not opts.onSB then
		opts.obj:SetNormalFontObject(module.fontP)
		opts.obj:SetDisabledFontObject(module.fontDP)
		opts.obj:SetText(opts.plus and module.plus or module.minus)
		opts.obj:SetPushedTextOffset(-1, -1)
	else
		opts.obj.sb:SetNormalFontObject(module.fontP)
		opts.obj.sb:SetDisabledFontObject(module.fontDP)
		opts.obj.sb:SetAllPoints(opts.obj:GetNormalTexture())
		opts.obj.sb:SetText(opts.plus and module.plus or module.minus)
	end
end
function module.skinExpandButton(_, ...)

	local opts = _G.select(1, ...)

	--@debug@
	_G.assert(opts, "Missing object sEB\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata"
	and _G.type(opts.GetObjectType) == "function"
	then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
	end

	if aObj:canSkin(__skinExpandButton, opts, opts.ncc) then
		__skinExpandButton(opts)
	end

end

local bW, bH
local function __skinOtherButton(opts)
	--[[
		Calling parameters:
			obj     = object (Mandatory)
			ft      = Frame Type (Skinner classification)
			size    = use smaller edgesize, different highlight textue and resize the button
			sap     = set all points of skinButton to object
			font    = font to use
			disfont = disabled font to use
			text    = text to use
			ooc 	= DON'T skin in combat
	--]]
	--@debug@
	_G.assert(opts and _G.type(opts) == "table", "Missing options table __sOB\n" .. _G.debugstack(2, 3, 2))
	_G.assert(opts.obj, "Missing object __sOB\n" .. _G.debugstack(2, 3, 2))
	_G.assert(opts.text, "Missing text to use __sOB\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- DON'T skin it twice
	if opts.obj.sb then
		return
	end

	opts.obj:DisableDrawLayer("BACKGROUND")
	aObj:keepFontStrings(opts.obj)

	if opts.size then
		opts.obj:SetSize(opts.size, opts.size)
		opts.obj:SetHighlightTexture(aObj.tFDIDs.pMBHL)
	end
	opts.obj:SetNormalFontObject(opts.font or module.fontP)
	opts.obj:SetDisabledFontObject(opts.disfont or module.fontDP)
	opts.obj:SetText(opts.text)
	opts.obj:SetPushedTextOffset(-1, -1)

	if not opts.noSkin
	and db.FrameControls
	then
		if opts.sap then
			aObj:skinObject("button", {obj=opts.obj, fType=opts.ftype, sap=true, aso=opts.aso})
		else
			bW = _G.Round(opts.obj:GetWidth())
			opts.x1 = opts.x1 or bW == 32 and 6 or 4
			opts.y1 = opts.y1 or bW == 32 and -6 or -4
			opts.x2 = opts.x2 or bW == 32 and -6 or -4
			opts.y2 = opts.y2 or bW == 32 and 6 or 4
			aObj:skinObject("button", {obj=opts.obj, fType=opts.ftype, bd=5, aso=opts.aso, x1=opts.x1, y1=opts.y1, x2=opts.x2, y2=opts.y2})
		end
	end
end
function module.skinOtherButton(_, ...)

	local opts = _G.select(1, ...)

	--@debug@
	_G.assert(opts, "Missing object sOB\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata"
	and _G.type(opts.GetObjectType) == "function"
	then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
	end

	if aObj:canSkin(__skinOtherButton, opts, opts.ncc) then
		__skinOtherButton(opts)
	end

end

local function __skinStdButton(opts)
	--[[
		Calling parameters:
			obj         = object (Mandatory)
			ft          = Frame Type (Skinner classification)
			aso         = applySkin options
			as          = use applySkin rather than addSkinButton, used when text appears behind the gradient
			clr         = set colour
			ca          = set colour alpha
			sabt        = use SecureActionButtonTemplate
			ignoreHLTex = ignore Highlight texture changes
			schk        = state check for colour changes
			sechk       = set enabled check for colour changes
			bd			= backdrop type
			ooc 	 	= DON'T skin in combat
	--]]
	--@debug@
	_G.assert(opts and _G.type(opts) == "table", "Missing options table __sSB\n" .. _G.debugstack(2, 3, 2))
	_G.assert(opts.obj, "Missing object __sSB\n" .. _G.debugstack(2, 3, 2))
	if opts.seca then
		aObj:CustomPrint(1, 0, 0, "Using deprecated option - seca, use sabt instead", opts.obj)
	end
	--@end-debug@

	-- DON'T skin it twice
	if opts.obj.sb
	or opts.obj.clr
	then
		return
	end

	opts.obj:DisableDrawLayer("BACKGROUND")
	if opts.obj:GetNormalTexture() then
		opts.obj:GetNormalTexture():SetAlpha(0)
	end
	if opts.obj:GetPushedTexture() then
		opts.obj:GetPushedTexture():SetAlpha(0)
	end
	if opts.obj:GetDisabledTexture() then
		opts.obj:GetDisabledTexture():SetAlpha(0)
	end

	bW, bH = _G.Round(opts.obj:GetWidth()), _G.Round(opts.obj:GetHeight())

	opts.bd = opts.bd or bH > 18 and 5 or 7 -- use narrower backdrop if required
	if not opts.as then
		opts.ofs = opts.ofs or 0
		opts.x1  = opts.x1 or opts.ofs * -1
		opts.y1  = opts.y1 or opts.ofs
		opts.x2  = opts.x2 or opts.ofs
		opts.y2  = opts.y2 or opts.ofs * -1
		aObj:skinObject("button", {obj=opts.obj, fType=opts.ftype, name=opts.name, sabt=opts.sabt, bd=opts.bd, x1=opts.x1, y1=opts.y1, x2=opts.x2, y2=opts.y2})
		opts.obj.sb.clr = opts.clr
		opts.obj.sb.ca = opts.ca
	else
		if bH < 16 then opts.obj:SetHeight(16) end -- set minimum button height (DBM option buttons)
		if bW < 16 then opts.obj:SetWidth(16) end -- set minimum button width (oQueue remove buttons)
		aObj:skinObject("skin", {obj=opts.obj, fType=opts.ftype, bd=opts.bd, ng=opts.ng})
		opts.obj.clr = opts.clr
		opts.obj.ca = opts.ca
	end

	if not opts.ignoreHLTex then
		module:chgHLTex(opts.obj, opts.obj:GetHighlightTexture())
	end

	aObj:clrBtnBdr(opts.obj, opts.clr, opts.ca)

	if opts.schk then
		aObj:SecureHook(opts.obj, "Disable", function(bObj, _)
			aObj:clrBtnBdr(bObj)
		end)
		aObj:SecureHook(opts.obj, "Enable", function(bObj, _)
			aObj:clrBtnBdr(bObj, bObj.sb and bObj.sb.clr or bObj.clr, bObj.sb and bObj.sb.ca or bObj.ca)
		end)
	end
	if opts.sechk then
		aObj:SecureHook(opts.obj, "SetEnabled", function(bObj)
			aObj:clrBtnBdr(bObj, bObj.sb and bObj.sb.clr or bObj.clr, bObj.sb and bObj.sb.ca or bObj.ca)
		end)
	end
end
function module.skinStdButton(_, ...)

	local opts = _G.select(1, ...)

	--@debug@
	_G.assert(opts, "Missing object sSB\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata"
	and _G.type(opts.GetObjectType) == "function"
	then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
	end

	if aObj:canSkin(__skinStdButton, opts, opts.ncc) then
		__skinStdButton(opts)
	end

end

local rpRegions = {
	"AutoCastable", "AutoCastShine", "Border", "Count", "Flash", "FlyoutArrow", "FlyoutArrowNormal", "FlyoutArrowPushed", "FlyoutArrowHighlight", "HotKey", "IconBorder", "IconQuestTexture", "ItemContextOverlay", "ItemOverlay", "ItemOverlay2", "LevelLinkLockIcon", "Name", "NewActionTexture", "ProfessionQualityOverlay", "searchOverlay", "SlotBorder", "SlotBorderOpen", "SpellHighlightTexture", "Stock"
}
local function reparentRegion(region, parent)
	if region
	and region:GetParent() ~= parent
	then
		if region:IsObjectType("Texture")
		or region:IsObjectType("FontString")
		then
			region:SetParent(parent)
		end
	end
end
local template, relTo
local function __addButtonBorder(opts)
	--[[
		Calling parameters:
			obj      = object (Mandatory)
			relTo    = object to position relative to
			ofs      = global offset
			abt      = Action Button template
			ibt      = Item Button template
			tibt     = Talent Item Button template
			libt     = Large Item Button template
			sibt     = Small Item Button template
			gibt     = Giant Item Button template
			cgibt    = Circular Giant Item Button template
			auit     = auction item template(s)
			bmit     = blackmarket item template
			sft      = requires SecureFrameTemplate
			sabt     = requires SecureActionButtonTemplate
			iabt     = requires InsecureActionButtonTemplate
			subt     = requires SecureUnitButtonTemplate
			reParent = table of objects to reparent to the border frame
			es       = edgeSize, used for small icons
			ofs      = offset value to use
			x1       = X offset for TOPLEFT
			y1       = Y offset for TOPLEFT
			x2       = X offset for BOTTOMRIGHT
			y2       = Y offset for BOTTOMRIGHT
			nc       = don't check to see if already skinned
			clr      = set colour
			ca       = set colour alpha
			schk     = state check for colour changes
			sechk    = set enabled check for colour changes
			ignTex	 = ignore changes to Normal & Pushed textures
			ooc 	 = DON'T skin in combat
			hide 	 = Hide if required (Better Bags)
			sba 	 = Set button Alpha function
	--]]
	--@debug@
	_G.assert(opts and _G.type(opts) == "table", "Missing options table __addButtonBorder\n" .. _G.debugstack(2, 3, 2))
	_G.assert(opts.obj, "Missing object__aBB\n" .. _G.debugstack(2, 3, 2))
	-- handle AddOn skins using deprecated options
	if opts.seca
	or opts.secu
	then
	aObj:CustomPrint(1, 0, 0, "Using deprecated options - seca,secu, use sabt or subt instead, __aBB", opts.obj)
	elseif opts.sec then
		aObj:CustomPrint(1, 0, 0, "Using deprecated options - sec, use sft instead, __aBB", opts.obj)
	end
	--@end-debug@

	-- don't skin it twice unless required
	if opts.obj.sbb
	and not opts.nc
	then
		return
	end

	-- remove Normal/Pushed textures if required (vertex colour changed in blizzard code)
	if not opts.ignTex then -- ProfessionCraftingPageRecipe slots [isModifyingRequired]
		if opts.ibt
		or opts.abt
		or opts.auit
		or opts.bmit
		then
			if opts.obj.GetNormalTexture
			and opts.obj:GetNormalTexture()
			then
				opts.obj:GetNormalTexture():SetTexture(nil)
			end
			if opts.obj.GetPushedTexture
			and opts.obj:GetPushedTexture()
			then
				opts.obj:GetPushedTexture():SetTexture(nil)
			end
		end
	end
	if opts.gibt then
		opts.obj.EmptyBackground:SetTexture(nil)
	end

	-- create the button border object
	opts.sft = opts.sft or opts.sec or nil
	template = opts.sft and "SecureFrameTemplate" or opts.sabt and "SecureActionButtonTemplate" or opts.iabt and "InsecureActionButtonTemplate" or opts.subt and "SecureUnitButtonTemplate"
	opts.obj.sbb = _G.CreateFrame(opts.obj:GetObjectType(), nil, opts.obj, template)
	opts.obj.sbb:EnableMouse(false) -- enable clickthrough
	aObj:addBackdrop(opts.obj.sbb)
	-- DON'T lower the frame level otherwise the border appears below the frame
	-- setup and apply the backdrop
	opts.obj.sbb:SetBackdrop({edgeFile = aObj.Backdrop[1].edgeFile, edgeSize = opts.es or aObj.Backdrop[1].edgeSize})
	opts.obj.sbb:SetShown(not opts.hide)
	-- position the frame
	opts.ofs = opts.ofs or 2
	opts.x1 = opts.x1 or opts.ofs * -1
	opts.y1 = opts.y1 or opts.ofs
	opts.x2 = opts.x2 or opts.ofs
	opts.y2 = opts.y2 or opts.ofs * -1
	-- Large Item Button templates have an IconTexture to position to
	relTo = opts.relTo or opts.libt and opts.obj.Icon or nil
	opts.obj.sbb:SetPoint("TOPLEFT", relTo or opts.obj, "TOPLEFT", opts.x1, opts.y1)
	opts.obj.sbb:SetPoint("BOTTOMRIGHT", relTo or opts.obj, "BOTTOMRIGHT", opts.x2, opts.y2)
	if opts.sba then
		opts.obj.sbb:SetAlpha(opts.sba)
	end

	-- reparent regions so they are displayed above the button border
	for _, rpReg in _G.pairs(rpRegions) do
		reparentRegion(opts.obj[rpReg], opts.obj.sbb)
	end
	reparentRegion(opts.obj:GetName() and _G[opts.obj:GetName() .. "Name"], opts.obj.sbb)
	reparentRegion(opts.obj:GetName() and _G[opts.obj:GetName() .. "Stock"], opts.obj.sbb)
	if opts.reParent then
		for _, rpObj in _G.pairs(opts.reParent) do
			reparentRegion(rpObj, opts.obj.sbb)
		end
	end

	-- colour the button border
	if _G.type(opts.clr) == "table" then
		opts.obj.sbb:SetBackdropBorderColor(_G.unpack(opts.clr))
	elseif opts.ibt
	or opts.libt
	then -- Item Buttons & Large Item Buttons
		-- N.B. leave subicon/SubIconTexture below .sbb (Classic ERA Engraving)
		if aObj.isRtl
		and opts.obj.IconBorder -- NB: Delves Ability button's DON'T have an IconBorder
		then
			aObj:clrButtonFromBorder(opts.obj)
		else
			aObj:clrBtnBdr(opts.obj, opts.clr or "common", opts.ca or 1)
		end
	elseif opts.abt then -- Action Buttons
		aObj:clrBtnBdr(opts.obj, opts.clr, opts.ca)
	elseif opts.gibt  -- Giant Item Buttons
	or opts.cgibt -- Circular Giant Item Buttons
	then
		aObj:clrButtonFromBorder(opts.obj)
	else
		aObj:clrBtnBdr(opts.obj, opts.clr, opts.ca)
	end

	-- hook these as required
	if opts.schk then
		aObj:secureHook(opts.obj, "Disable", function(bObj, _)
			aObj:clrBtnBdr(bObj)
		end)
		-- store colour and alpha values with the skin button
		opts.obj.sbb.clr = opts.clr
		opts.obj.sbb.ca = opts.ca
		aObj:secureHook(opts.obj, "Enable", function(bObj, _)
			aObj:clrBtnBdr(bObj, bObj.sbb.clr, bObj.sbb.ca)
		end)
	end
	if opts.sechk then
		-- store colour and alpha values with the skin button
		opts.obj.sbb.clr = opts.clr
		opts.obj.sbb.ca = opts.ca
		aObj:secureHook(opts.obj, "SetEnabled", function(bObj)
			aObj:clrBtnBdr(bObj, bObj.sbb.clr, bObj.sbb.ca)
		end)
	end
end
function module.addButtonBorder(_, ...)

	local opts = _G.select(1, ...)

	--@debug@
	_G.assert(opts, "Missing object aBB\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata"
	and _G.type(opts.GetObjectType) == "function"
	then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
	end

	if aObj:canSkin(__addButtonBorder, opts, opts.ncc) then
		__addButtonBorder(opts)
	end

end

local bd, ofs, yOfs
local function __skinCheckButton(opts)
	--[[
		Calling parameters:
			obj   = object (Mandatory)
			nc    = don't check to see if already skinned
			hf    = hook show/hide functions
			sechk = set enabled check for colour changes
			ignNT = ignore NormalTexture checks (WoWPro uses bespoke textures)
	--]]
	--@debug@
	_G.assert(opts.obj, "Missing object __sCB\n" .. _G.debugstack(2, 3, 2))
	_G.assert(opts.obj.IsObjectType and opts.obj:IsObjectType("CheckButton"), "NOT a CheckButton __sCB\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- don't skin it twice unless required
	if not opts.nc
	and opts.obj.sb
	then
		return
	end

	-- check to see if it's a 'real' CheckButton
	if not opts.ignNT then
		if not opts.obj.GetNormalTexture
		or not aObj:hasTextInTexture(opts.obj:GetNormalTexture(), "CheckBox")
		and not aObj:hasTextInTexture(opts.obj:GetNormalTexture(), aObj.tFDIDs.cbUP)
		and not aObj:hasTextInTexture(opts.obj:GetNormalTexture(), aObj.tFDIDs.cbMin) -- Settings CheckButton
		then
			return
		end
	end

	if not aObj.isClscERA then
		opts.obj:GetNormalTexture():SetTexture(nil)
		opts.obj:GetPushedTexture():SetTexture(nil)
	else
		opts.obj:GetNormalTexture():SetTexture("")
		opts.obj:GetPushedTexture():SetTexture("")
	end

	-- handle small check buttons (e.g. GuildControlUI - Rank Permissions)
	bd, ofs, yOfs = 5, opts.ofs or -4, opts.yOfs or opts.ofs and opts.ofs * -1 + 1 or 5
	if opts.obj:GetWidth() < 23 then
		bd = 12
		if aObj:hasTextInName(opts.obj, "AchievementFrame") then
			ofs = -2
			yOfs = nil
		end
	end
	aObj:skinObject("button", {obj=opts.obj, fType=opts.ftype, bd=bd, ng=true, ofs=ofs, y2=yOfs})
	aObj:clrBtnBdr(opts.obj, opts.clr, opts.ca)
	if opts.sechk then
		-- store colour and alpha values with the skin button
		opts.obj.sb.clr = opts.clr
		opts.obj.sb.ca = opts.ca
		aObj:secureHook(opts.obj, "SetEnabled", function(bObj)
			aObj:clrBtnBdr(bObj, bObj.sb.clr, bObj.sb.ca)
		end)
	end
end
function module.skinCheckButton(_, ...)

	local opts = _G.select(1, ...)

	--@debug@
	 _G.assert(opts, "Missing object sCB\n" .. _G.debugstack(2, 3, 2))
	 --@end-debug@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata"
	and _G.type(opts.GetObjectType) == "function"
	then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
	end

	if aObj:canSkin(__skinCheckButton, opts, opts.ncc) then
		__skinCheckButton(opts)
	end

end


--[===[@non-debug@
--[[
	The following functions are ONLY used by the Main.lua file, which has been deprecated,
	and are only used in AddOn skins that haven't been updated
--]]
function module:skinButton(opts)
	--[[
		Calling parameters:
			as = use applySkin rather than addSkinButton, used when text appears behind the gradient
			cb = close button
			cb2 = close button style 2 (based upon OptionsButtonTemplate)
			mp = minus/plus texture on a larger button
			mp2 = minus/plus button
			ob = other button, text supplied
			ob2 = other button style 2, text supplied
			plus = use plus sign
			anim = reparent skinButton to avoid whiteout issues caused by animations
			other options as per addSkinButton
			nc = don't check to see if already skinned (Ace3)
	--]]
	--@debug@
	_G.assert(opts.obj, "Missing object skinButton\n" .. _G.debugstack(2, 3, 2))
	aObj:CustomPrint(1, 0, 0, "Not using a specific Button skinning function", opts.obj, opts.cb)
	if not opts.obj:GetName() then _G.print("No Name supplied __sB\n", _G.debugstack(2, 5, 2)) end
	--@end-debug@

	if not opts.obj then return end

	-- don't skin it twice unless required
	if not opts.nc
	and opts.obj.sb
	then
		return
	end

	if opts.cb then -- it's a close button
		module:skinCloseButton1(opts)
	elseif opts.cb2 then -- it's pretending to be a close button (e.g. ArkInventory/Recount/Outfitter)
		module:skinCloseButton2(opts)
	elseif opts.cb3 then -- it's a small blue close button (e.g. BNToastFrame)
		module:skinCloseButton3(opts)
	elseif opts.mp then -- it's a minus/plus texture on a larger button
		module:skinExpandButton1(opts)
	elseif opts.mp2 then -- it's a minus/plus button (IOF has them on RHS)
		module:skinExpandButton2(opts)
	elseif opts.ob then -- it's another type of button, text supplied (e.g. beql minimize)
		module:skinOtherButton1(opts)
	elseif opts.ob2 then -- it's another type of button, text supplied, style 2 (e.g. MinimalArchaeology)
		module:skinOtherButton2(opts)
	elseif opts.ob3 then -- it's another type of button, text supplied, style 3 (e.g. worldmapsizeup/down button)
		module:skinOtherButton3(opts)
	elseif opts.ob4 then -- it's another type of button, text supplied, style 4 (e.g. WorldQuestTracker)
		module:skinOtherButton4(opts)
	else -- standard button (UIPanelButtonTemplate/UIPanelButtonTemplate2 and derivatives)
		module:skinStdButton(opts)
	end

end
function module:skinCloseButton1(opts)
-- text on button
	opts.cb = nil
	module:skinCloseButton(opts)

end
function module:skinCloseButton2(opts)
-- text on skinButton
	opts.cb2 = nil
	opts.onSB = true
	module:skinCloseButton(opts)

end
function module:skinCloseButton3(opts)
-- small text on skinButton (used by Details)
	opts.font = module.fontSBX
	opts.cb3 = nil
	opts.onSB = true
	module:skinCloseButton(opts)

end
function module:skinExpandButton1(opts)
-- text on skinButton
	opts.onSB = true
	module:skinExpandButton(opts)

end
function module:skinExpandButton2(opts)
-- text on button
	opts.sap = true
	module:skinExpandButton(opts)

end
function module:skinOtherButton1(opts)
-- text on button
	opts.font = module.fontP
	opts.text = opts.ob
	opts.ob = nil
	module:skinOtherButton(opts)

end
function module:skinOtherButton2(opts)
-- small text on button
	opts.size = 18
	opts.sap = true
	opts.font = module.fontSB
	opts.text = opts.ob2
	opts.ob2 = nil
	module:skinOtherButton(opts)

end
function module:skinOtherButton3(opts)
-- sizeUp/Down text on button

	opts.font = module.fontS
	opts.text = opts.ob3
	opts.ob3 = nil
	module:skinOtherButton(opts)

end
function module:skinOtherButton4(opts)
-- Normal text on button

	opts.font = "GameFontNormal"
	opts.text = opts.ob4
	opts.ob4 = nil
	module:skinOtherButton(opts)

end
local function __skinAllButtons(opts, bgen)
	--[[
		Calling parameters:
			obj = object (Mandatory)
			bgen = generations of children to traverse
			other options as per skinButton
	--]]
		--@debug@
		_G.assert(opts.obj, "Missing object__sAB\n" .. _G.debugstack(2, 3, 2))
		-- handle AddOn skins still using this code
		aObj:CustomPrint(1, 0, 0, "Using deprecated function - skinAllButtons", opts.obj)
		--@end-debug@
		if not opts.obj then return end

		-- maximum number of button generations to traverse
		bgen = bgen or opts.bgen or 5

		for _, child in _G.ipairs{opts.obj:GetChildren()} do
			if child:GetNumChildren() > 0
			and bgen > 0
			then
				opts.obj = child
				__skinAllButtons(opts, bgen - 1)
			elseif child:IsObjectType("CheckButton") then
				aObj:skinCheckButton{obj=child}
			elseif child:IsObjectType("Button") then
				bType = module:isButton(child)
				if bType == "normal" then
					module:skinButton{obj=child, ft=opts.ft, x1=opts.x1, y1=opts.y1, x2=opts.x2, y2=opts.y2, anim=opts.anim, as=opts.as}
				elseif bType == "close" then
					module:skinButton{obj=child, ft=opts.ft, cb=true, sap=opts.sap, anim=opts.anim}
				elseif bType == "toast" then
					module:skinButton{obj=child, ft=opts.ft, cb3=true}
				elseif bType == "help" then
					module:skinButton{obj=child, ft=opts.ft, x1=0, y1=0, x2=-3, y2=3}
				end
			end
		end
end
function module:skinAllButtons(...)

	local opts = _G.select(1, ...)

	--@debug@
	 _G.assert(opts, "Missing object sAB\n" .. _G.debugstack(2, 3, 2))
	-- handle AddOn skins still using this code rather than skinning button individually
	aObj:CustomPrint(1, 0, 0, "Using deprecated function - skinAllButtons, use skin???Button instead", opts.obj)
	--@end-debug@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata"
	and _G.type(opts.GetObjectType) == "function"
	then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
	end

	__skinAllButtons(opts)

end
--@end-non-debug@]===]

local defaults = {
	profile = {
		UIButtons     = false,
		ButtonBorders = false,
		CheckButtons  = false,
		FrameControls = true,
		Quality		  = {file = "None", texture = "Blizzard Tooltip"},
	}
}
function module:OnInitialize()

	self.db = aObj.db:RegisterNamespace("UIButtons", defaults)
	db = self.db.profile

	-- convert any old settings
	if aObj.db.profile.Buttons then
		db.UIButtons = aObj.db.profile.Buttons
		aObj.db.profile.Buttons = nil
	end

end

function module:OnEnable()

	-- add support for UIButton skinning
	aObj.modUIBtns  		 = module
	aObj.modBtns    		 = aObj:makeBoolean(db.UIButtons)
	aObj.modBtnBs   		 = aObj:makeBoolean(db.ButtonBorders)
	aObj.modChkBtns 		 = aObj:makeBoolean(db.CheckButtons)
	aObj.modFCBtns  		 = aObj:makeBoolean(db.FrameControls)
	aObj.fontDP              = aObj.modBtns and aObj.modUIBtns.fontDP
	aObj.fontDS              = aObj.modBtns and aObj.modUIBtns.fontDS
	aObj.fontP               = aObj.modBtns and aObj.modUIBtns.fontP
	aObj.fontS               = aObj.modBtns and aObj.modUIBtns.fontS
	aObj.fontSBX             = aObj.modBtns and aObj.modUIBtns.fontSBX
	aObj.downarrow           = aObj.modBtns and aObj.modUIBtns.darrow
	aObj.larrow              = aObj.modBtns and aObj.modUIBtns.larrow
	aObj.nearrow             = aObj.modBtns and aObj.modUIBtns.nearrow
	aObj.nwarrow             = aObj.modBtns and aObj.modUIBtns.nwarrow
	aObj.rarrow              = aObj.modBtns and aObj.modUIBtns.rarrow
	aObj.searrow             = aObj.modBtns and aObj.modUIBtns.searrow
	aObj.swarrow             = aObj.modBtns and aObj.modUIBtns.swarrow
	aObj.uparrow             = aObj.modBtns and aObj.modUIBtns.uarrow
	aObj.gearcog             = aObj.modBtns and aObj.modUIBtns.gearcog
	aObj.checkTex            = aObj.modBtns and aObj.modUIBtns.checkTex or _G.nop
	aObj.isButton            = aObj.modBtns and aObj.modUIBtns.isButton or _G.nop
	aObj.skinAllButtons      = aObj.modBtns and aObj.modUIBtns.skinAllButtons or _G.nop
	aObj.skinButton          = aObj.modBtns and aObj.modUIBtns.skinButton or _G.nop
	aObj.skinCloseButton     = aObj.modBtns and aObj.modUIBtns.skinCloseButton or _G.nop
	aObj.skinExpandButton    = aObj.modBtns and aObj.modUIBtns.skinExpandButton or _G.nop
	aObj.skinOtherButton     = aObj.modBtns and aObj.modUIBtns.skinOtherButton or _G.nop
	aObj.skinStdButton       = aObj.modBtns and aObj.modUIBtns.skinStdButton or _G.nop
	aObj.addButtonBorder     = aObj.modBtnBs and aObj.modUIBtns.addButtonBorder or _G.nop
	aObj.skinActionBtn       = aObj.modBtnBs and aObj.modUIBtns.skinActionBtn or _G.nop
	aObj.skinCheckButton     = aObj.modChkBtns and aObj.modUIBtns.skinCheckButton or _G.nop

	 -- disable ourself if required
	if not db.UIButtons
	and not db.ButtonBorders
	and not db.CheckButtons
	and not db.FrameControls
	then
		self:Disable()
	end

	if aObj.modBtnBs then
		-- hook these to colour container item borders (inc. Bags, Bank, GuildBank, ReagentBank, Professions etc)
		if aObj.isRtl then
			local function setItemButtonQuality(button, quality, itemIDOrLink)
				-- aObj:Debug("SetItemButtonQuality: [%s, %s, %s, %s, %s]", button, quality, itemIDOrLink, button.IconBorder, button.sbb)
				-- aObj:Debug("SIBQ: [%s, %s]", button.IconBorder:IsShown(), button.IconOverlay:IsShown())
				-- show Artifact Relic Item border
				if itemIDOrLink
				and _G.IsArtifactRelicItem
				and _G.IsArtifactRelicItem(itemIDOrLink)
				then
					button.IconBorder:SetAlpha(1)
				else
					button.IconBorder:SetAlpha(0)
				end
				aObj:setBtnClr(button, quality)
			end
			aObj:SecureHook("SetItemButtonQuality", function(button, quality, itemIDOrLink, _, _)
				setItemButtonQuality(button, quality, itemIDOrLink)
			end)
			aObj:SecureHook(_G.ItemButtonMixin, "SetItemButtonQuality", function(button, quality, itemIDOrLink, _, _)
				setItemButtonQuality(button, quality, itemIDOrLink)
			end)
			aObj:SecureHook(_G.CircularGiantItemButtonMixin, "SetItemButtonQuality", function(button, quality, _, _, _)
				setItemButtonQuality(button, quality)
			end)
			aObj:SecureHook(_G.ItemButtonMixin, "SetItemButtonBorderVertexColor", function(button, red, grn, blu)
				-- aObj:Debug("IBM SetItemButtonBorderVertexColor: [%s, %s, %s, %s]", btn, r ,g, b)
				if button.sbb
				and red
				then
					button.sbb:SetBackdropBorderColor(red, grn, blu)
				end
			end)
			aObj:SecureHook(_G.ItemButtonMixin, "UpdateCraftedProfessionsQualityShown", function(button)
				if not button.ProfessionQualityOverlay then
					return
				end
				if button.sbb then
					if button.ProfessionQualityOverlay then
						button.ProfessionQualityOverlay:SetParent(button.sbb)
					end
				end
			end)
		else
			aObj:SecureHook("SetItemButtonQuality", function(button, quality, _, _)
				-- aObj:Debug("SetItemButtonQuality: [%s, %s]", button, quality)
				button.IconBorder:SetAlpha(0)
				-- N.B. a table is returned from EquipmentFlyout
				aObj:setBtnClr(button, _G.type(quality) ~= "table" and quality or nil)
			end)
			-- table to hold button objects to ignore, e.g. ContainerFrame items
			aObj.btnIgnore = {}
			-- hook this to colour buttons e.g. TradeSkill reagents
			aObj:SecureHook("SetItemButtonTextureVertexColor", function(button, red, grn, blu)
				-- aObj:Debug("SetItemButtonTextureVertexColor: [%s, %s, %s, %s]", button, r, g, b)
				if _G.tContains(aObj.btnIgnore, button) then
					return
				end
				if button.sbb
				and red
				then
					button.sbb:SetBackdropBorderColor(red, grn, blu)
				end
			end)
		end
	end


	-- bypass the Item Quality Border Texture changes if the specified addons aren't loaded
	if not _G.C_AddOns.IsAddOnLoaded("AdiBags")
	and not _G.C_AddOns.IsAddOnLoaded("Fizzle")
	and not _G.C_AddOns.IsAddOnLoaded("oGlowClassic")
	and not _G.C_AddOns.IsAddOnLoaded("XLoot")
	then
		return
	end

	_G.LibStub:GetLibrary("AceConfigRegistry-3.0", true):NotifyChange(aName .. " Modules")

	-- setup default backdrop values (AdiBags, Fizzle, oGlow, XLoot)
	self.bDrop = {
		edgeFile = aObj.Backdrop[1].edgeFile,
		edgeSize = aObj.Backdrop[1].edgeSize
	}
	self.iqbDrop = {
		edgeSize = aObj.Backdrop[1].edgeSize
	}
	if db.Quality.file
	and db.Quality.file ~= "None"
	then
		aObj.LSM:Register("border", aName .. " Quality Border", db.Quality.file)
		self.iqbDrop.edgeFile = aObj.LSM:Fetch("border", aName .. " Quality Border")
	else
		self.iqbDrop.edgeFile = aObj.LSM:Fetch("border", db.Quality.texture)
	end

end

function module.GetOptions(_)

	local options = {
		type = "group",
		name = aObj.L["Button Settings"],
		order = 1,
		get = function(info) return db[info[#info]] end,
		set = function(info, value)
			if info[#info] == "ButtonBorders" and not module:IsEnabled() then module:Enable() end
			db[info[#info]] = value
		end,
		args = {
			UIButtons = {
				type = "toggle",
				order = 1,
				name = aObj.L["Buttons"],
				desc = _G.strjoin(" ", aObj.L["Toggle the skinning of"], aObj.L["the"], aObj.L["UI Buttons"], aObj.L["(reload required)"]),
			},
			ButtonBorders = {
				type = "toggle",
				order = 2,
				name = aObj.L["Button Borders"],
				desc = _G.strjoin(" ", aObj.L["Toggle the skinning of"], aObj.L["the"], aObj.L["Button Borders"], aObj.L["(reload required)"]),
			},
			CheckButtons = {
				type = "toggle",
				order = 3,
				name = aObj.L["Check Buttons"],
				desc = _G.strjoin(" ", aObj.L["Toggle the skinning of"], aObj.L["the"], aObj.L["Check Buttons"], aObj.L["(reload required)"]),
			},
			FrameControls = {
				type = "toggle",
				order = 4,
				width = "full",
				name = _G.strjoin(" ", aObj.L["Frame Control Buttons"], aObj.L["Border"]),
				desc = _G.strjoin(" ", aObj.L["Toggle the border of"], aObj.L["the"], aObj.L["Frame Control Buttons"], aObj.L["(reload required)"]),
			},
			Quality = {
				type = "group",
				order = 4,
				inline = true,
				name = aObj.L["Item Quality Border"],
				hidden = function()
					if not _G.C_AddOns.IsAddOnLoaded("AdiBags")
					and not _G.C_AddOns.IsAddOnLoaded("Fizzle")
					and not _G.C_AddOns.IsAddOnLoaded("oGlowClassic")
					and not _G.C_AddOns.IsAddOnLoaded("XLoot")
					then
						return true
					else
						return false
					end
				end,
				get = function(info) return db.Quality[info[#info]] end,
				set = function(info, value) db.Quality[info[#info]] = value end,
				args = {
					file = {
						type = "input",
						order = 1,
						width = "full",
						name = aObj.L["Border Texture File"],
						desc = aObj.L["Set Border Texture Filename"],
					},
					texture = _G._G.AceGUIWidgetLSMlists and {
						type = "select",
						order = 2,
						width = "double",
						name = aObj.L["Border Texture"],
						desc = aObj.L["Choose the Texture for the Border"],
						dialogControl = 'LSM30_Border',
						values = _G._G.AceGUIWidgetLSMlists.border,
					} or nil,
				},
			},
		},
	}

	return options

end
