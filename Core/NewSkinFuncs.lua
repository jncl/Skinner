local _, aObj = ...

local _G = _G

local function setScrollTrackOffsets(tbl, type)
	local h, w, o = _G.Round(tbl.obj:GetHeight()), _G.Round(tbl.obj:GetWidth())
	if type == "slider" then
		o = tbl.obj:GetOrientation()
	else
		if tbl.obj.isHorizontal then
			o = "HORIZONTAL"
		else
			o = "VERTICAL"
		end
	end
	-- aObj:Debug("setScrollTrackOffsets#1 O/H/W: [%s, %s, %s, %s]", type, o, w, h)
	-- setup offsets based on Orientation/Height/Width
	if o == "HORIZONTAL" then
		if h <= 16 then
			tbl.y1 = _G.rawget(tbl, "y1") or -1
			tbl.y2 = _G.rawget(tbl, "y2") or 2
		elseif h <= 18 then
			tbl.y1 = _G.rawget(tbl, "y1") or -2
			tbl.y2 = _G.rawget(tbl, "y2") or 3
		elseif h <= 20 then
			tbl.y1 = _G.rawget(tbl, "y1") or -3
			tbl.y2 = _G.rawget(tbl, "y2") or 4
		elseif h <= 22 then
			tbl.y1 = _G.rawget(tbl, "y1") or -4
			tbl.y2 = _G.rawget(tbl, "y2") or 5
		elseif h == 25 then
			tbl.y1 = _G.rawget(tbl, "y1") or -4
			tbl.y2 = _G.rawget(tbl, "y2") or 5
		end
		tbl.x1 = _G.rawget(tbl, "x1") or 0
		tbl.x2 = _G.rawget(tbl, "x2") or 0
	else
		if w <= 10 then -- OribosScrollTemplate/WowTrimScrollBar/MinimalScrollBar
			tbl.x1 = _G.rawget(tbl, "x1") or -1
			tbl.x2 = _G.rawget(tbl, "x2") or 1
		elseif w <= 12 then
			tbl.x1 = _G.rawget(tbl, "x1") or -2
			tbl.x2 = _G.rawget(tbl, "x2") or -1
		elseif w <= 16 then
			tbl.x1 = _G.rawget(tbl, "x1") or 0
			tbl.x2 = _G.rawget(tbl, "x2") or -1
		elseif w <= 20 then
			tbl.x1 = _G.rawget(tbl, "x1") or 3
			tbl.x2 = _G.rawget(tbl, "x2") or -4
			tbl.y1 = _G.rawget(tbl, "y1") or -2
			tbl.y2 = _G.rawget(tbl, "y2") or 2
		elseif w == 22 then
			tbl.x1 = _G.rawget(tbl, "x1") or 3
			tbl.x2 = _G.rawget(tbl, "x2") or -3
			tbl.y1 = _G.rawget(tbl, "y1") or -1
			tbl.y2 = _G.rawget(tbl, "y2") or 1
		elseif w == 25 then
			tbl.x1 = _G.rawget(tbl, "x1") or --[[not aObj.isMnln and 2 or]] 0
			tbl.x2 = _G.rawget(tbl, "x2") or --[[not aObj.isMnln and 4 or]] 0
		end
		tbl.y1 = _G.rawget(tbl, "y1") or 0
		tbl.y2 = _G.rawget(tbl, "y2") or 0
	end
	-- aObj:Debug("setScrollTrackOffsets#2: [%s, %s, %s, %s]", tbl.x1, tbl.x2, tbl.y1, tbl.y2)
end

-- skin Templates
aObj.skinTPLs = {
	button = {
		name		= false, -- use a name if required (VuhDo Options)
		-- bg          = true, -- put into specified FrameStrata
		sfs 		= "BACKGROUND", -- set the Frame Strata
		aso         = {},-- applySkin options,
		hide        = false, -- hide skin
		ofs         = 4, -- skin frame offset to object
		-- x1          = -4,
		-- y1          = 4,
		-- x2          = 4,
		-- y2          = -4,
		sap         = false, -- SetAllPoints to object
		sft         = false, -- use SecureFrameTemplate
		sabt		= false, -- use SecureActionButtonTemplate
		subt		= false, -- use SecureUnitButtonTemplate
		shat		= false, -- use SecureHandlerAttributeTemplate
	},
	ddbutton = {
		-- clr         = "grey",
		-- filter      = false,
		-- filtercb    = "ResetButton",
		-- noBB        = false, -- don't skin button
		-- noSF        = false, -- don't skin frame
		bofs        = aObj.isMnln and -1 or 1,
		-- bx1         = nil,
		by1         = aObj.isMnln and 2 or nil,
		-- bx2         = nil,
		by2         = aObj.isMnln and 4 or nil,
		ofs         = 2,
		-- x1 			= -2,
		-- y1 			= -2,
		-- x2 			= -2,
		-- y3 			= -2,
		-- sechk 		= false,
	},
	ddlist = {
		nop         = false, -- stop backdrop textures being updated (ZygorGuides)
		kfs         = true,
		ofs         = -4,
	},
	dropdown = {
		lrgTpl      = false,
		noBB        = false,
		noSkin      = false,
		regions     = {1, 2, 3},
		x1          = 16,
		y1          = -1,
		x2          = -16,
		y2          = 7,
		ddtx1		= -5,
		ddty1		= 2,
		ddtx2		= 5,
		ddty2		= 2,
		adjBtnX		= false,
		initState	= false, -- initial State is "Enabled" i.e. NOT "Disabled"
		rpc			= false, -- reverse parent child relationship
	},
	editbox = {
		bd          = 4,
		-- clr         = "darkgrey", -- backdrop border colour [aso]
		-- ca          = 0.5, -- backdrop border alpha
		-- ng          = true, -- no Gradient texture
		regions     = {3, 4, 5}, -- 1 is text, 2 is cursor, 6 is text, 7 is icon
		si			= false, -- move search icon
		six         = 3, -- search icon x offset
		ofs         = 0,
		-- x1          = 0,
		-- y1          = -4,
		-- x2          = 0,
		-- y2          = 4,
		chginset	= true,
		inset		= 5,
		mi			= true, -- move Instructions
		mix			= 6, -- Instructions x offset
	},
	frame = {
		name		= false, -- use a name if required (VuhDo Options)
		-- bg          = true, -- put into specified FrameStrata
		sfs 		= "BACKGROUND", -- set the Frame Strata, (WorldMap uses "LOW")
		-- cb          = true, -- skin close button
		-- cbns        = true, -- use noSkin otion when skinning the close button
		-- hat         = true, -- hide all textures except font strings
		-- kfs         = true, -- remove all textures except font strings
		regions     = {}, -- remove specified regions
		rb          = true, -- remove Backdrop, "nop" ApplyBackdrop function
		ri          = true, -- disable draw layers; [Background, Border & Overlay]
		rns         = true, -- disable draw layers; [Background, Border & Overlay]
		rp          = true, -- disable PortraitContainer.portrait (Dragonflight)
		rpc         = false, -- reverse parent child relationship
		-- sft         = true, -- use SecureFrameTemplate
		ofs         = 2, -- skin frame offset to object
		-- x1          = ofs * -2,
		-- y1          = ofs,
		-- x2          = ofs,
		-- y2          = ofs * -1,
		aso         = {}, -- applySkin options
		bd          = 1, -- backdrop to use
		-- hdr         = true, -- header texture(s)
		hOfs 		= -7, -- header text offset
		-- noBdr       = true, -- equivalent to bd=11 when true
		-- ba          = 1, -- backdrop alpha
		-- clr         = "default", -- backdrop border colour
		-- ca          = 1, -- backdrop border alpha
		-- ng          = true, -- no Gradient texture
		-- fh          =, -- fade height
		-- invert      = true, -- invert Gradient
		-- rotate      = true, -- rotate Gradient
		-- fb          = true, -- frame border [bd=10, ng=true, ofs=0]
		-- ckbfb       = true, -- frame border [bd=10, ng=true, ofs=0], check aObj.prdb.FrameBorders option
		sft         = false, -- use SecureFrameTemplate
		-- bbc         = {} -- colour the .sf's BackdropBorder using these values
	},
	glowbox = {
	},
	moneyframe = {
		-- moveIcon  = false, -- move Icon to the right
		-- adjWdth   = 0, -- amount to change the width of the editbox
		-- moveGEB   = false, -- move the Gold edit box left
		-- moveSEB   = false, -- move the Silver edit box left
	},
	skin = {
		-- ba          = 1, -- backdrop alpha
		-- bbclr       = "default", -- backdrop border colour
		-- bba         = 1, -- backdrop border alpha
		bd          = 1,
		ng          = false,
		-- fh          =,
		-- invert      =,
		-- rotate      =,
	},
	scrollbar = {
		-- bd          = 4, -- narrow
		-- clr         = "darkgrey", -- backdrop border colour
		-- ca          = 0.5, -- backdrop border alpha
		-- ng          = true, -- no Gradient texture
		-- x1          = 2,
		-- y1          = -2,
		-- x2          = -3,
		-- y2          = 3,
	},
	slider = {
		-- bd          = 4, -- narrow
		-- clr         = "darkgrey", -- backdrop border colour
		-- ca          = 0.5, -- backdrop border alpha
		-- ng          = true, -- no Gradient texture
		rpTex       = false, -- remove parent's textures [single draw layer or array of draw layers]
		-- x1          = 2,
		-- y1          = -2,
		-- x2          = -3,
		-- y2          = 3,
	},
	statusbar = {
		fi        = 0, -- frame inset
		regions   = {}, -- remove specified regions
		-- bg        = false, -- existing background texture
		-- other.    = {}, -- other texture objects
		-- nilFuncs  = false, -- nop Atlas functions
		-- hookFuncs = false, -- raw hook SetStatusBarTexture function
	},
	tabs = {
		bd          = 13, -- alternate version of 1
		-- prefix      = "",
		-- tabs        = {},
		numTabs     = 1,
		selectedTab = 1,
		suffix      = "",
		regions     = aObj.isMnln and {10} or {7, 8},
		-- ng			= nil,
		ignoreSize  = true,
		lod         = false,
		upwards     = false,
		offsets     = {x1=8, y1=2, x2=-8, y2=2},
		ignoreHLTex = true,
		track       = true,
		noCheck     = false,
		func        = nil,
		pool		= false, -- uses TabSystem .tabPool (DF)
	},
	tooltip = {
		-- ofs         = 2, -- skin frame offset to object
	},
}
-- add type value for each table entry
do
	for name, optsTable in _G.pairs(aObj.skinTPLs) do
		optsTable.type  = name
	end
end
-- use a metatable to return default values and handle the initialisation of the passed options table
_G.setmetatable(aObj.skinTPLs, {
	__call = function(_, objType, objTable)
		_G.setmetatable(objTable, {__index = function(_, key) return aObj.skinTPLs[objType][key] end})
		return objTable
	end,
	ftype = "a",
	ncc   = false,
})
-- add skinning functions to this table
local skinFuncs = {}

local objType, objTable, optsTable
function aObj:skinObject(...)
	--@debug@
	_G.assert(..., "Missing arguments (skinObject)\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	aObj:Debug2("skinObject: [%s, %s]", ...)

	-- handle called with both a type and a table or just a table
	if _G.select('#', ...) == 2 then
		objType, objTable = ...
		--@debug@
		_G.assert(self.skinTPLs[objType], "Unknown type (skinObject)\n" .. _G.debugstack(2, 3, 2))
		--@end-debug@
	else
		objType = nil
		objTable = ...
	end
	--@debug@
	_G.assert(objTable and _G.type(objTable) == "table", "Missing table (skinObject)\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	if objType then
		optsTable = self.skinTPLs(objType, objTable)
		if aObj:canSkin(skinFuncs[objType], optsTable, optsTable.ncc) then
			skinFuncs[objType](optsTable)
		end
	else
		if aObj:canSkin(skinFuncs[objTable.type], objTable, optsTable.ncc) then
			skinFuncs[objTable.type](objTable)
		end
	end

end

local r, g, b, a
local function applySkin(tbl)
	--@debug@
	_G.assert(tbl.obj, "Missing object (applySkin)\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@
	aObj:Debug2("applySkin: [%s]", tbl)

	if tbl.kfs then
		aObj:keepFontStrings(tbl.obj)
	end
	-- fix for backdrop textures not tiling vertically
	-- using info from here: http://boss.wowinterface.com/forums/showthread.php?p=185868
	if aObj.prdb.BgUseTex then
		if not tbl.obj.tbg then
			tbl.obj.tbg = tbl.obj:CreateTexture(nil, "BORDER")
			tbl.obj.tbg:SetTexture(aObj.LSM:Fetch("background", aObj.bgTexName), true) -- have to use true for tiling to work
			tbl.obj.tbg:SetBlendMode("ADD") -- use existing frame alpha setting
			-- allow for border inset
			tbl.obj.tbg:SetPoint("TOPLEFT", tbl.obj, "TOPLEFT", aObj.prdb.BdInset, -aObj.prdb.BdInset)
			tbl.obj.tbg:SetPoint("BOTTOMRIGHT", tbl.obj, "BOTTOMRIGHT", -aObj.prdb.BdInset, aObj.prdb.BdInset)
			-- the texture will be stretched if the following tiling methods are set to false
			tbl.obj.tbg:SetHorizTile(aObj.prdb.BgTile)
			tbl.obj.tbg:SetVertTile(aObj.prdb.BgTile)
		end
	elseif tbl.obj.tbg then
		tbl.obj.tbg = nil -- remove background texture if it exists
	end
	aObj:addBackdrop(tbl.obj)
	tbl.obj:SetBackdrop(aObj.Backdrop[tbl.bd])
	r, g, b, a = aObj.bClr:GetRGBA()
	tbl.obj:SetBackdropColor(r, g, b, tbl.ba or a)
	if _G.type(tbl.bbclr) == "table" then
		tbl.obj:SetBackdropBorderColor(_G.unpack(tbl.bbclr))
	else
		aObj:clrBBC(tbl.obj, tbl.bbclr, tbl.bba)
	end
	if not tbl.ng then
		aObj:applyGradient(tbl.obj, tbl.fh, tbl.invert, tbl.rotate)
		aObj.gradFrames[tbl.fType or "a"][tbl.obj] = true
	end
end
skinFuncs.skin = function(table) applySkin(table) end
local function skinButton(tbl)
	--@debug@
	_G.assert(tbl.obj, "Missing object (skinButton)\n" .. _G.debugstack(2, 3, 2))
	 if tbl.sec then
	-- handle AddOn skins using deprecated options
		aObj:CustomPrint(1, 0, 0, "Using deprecated options - sec, use sft instead", tbl.obj)
	end
	--@end-debug@
	aObj:Debug2("skinButton [%s]", tbl)

	if tbl.obj.sb
	or tbl.noSkin
	then
		return
	end
	if tbl.name then
		tbl.name = tbl.obj:GetName() .. "~sb~"
	end
	-- add a frame to the object
	tbl.sft = tbl.sft or tbl.sec or nil
	local template = tbl.sft and "SecureFrameTemplate" or tbl.sabt and "SecureActionButtonTemplate" or tbl.subt and "SecureUnitButtonTemplate"
	if tbl.shat then
		template = template .. ", " .. "SecureHandlerAttributeTemplate"
	end
	tbl.obj.sb = _G.CreateFrame("Button", tbl.name, tbl.obj, template)
	-- allow clickthrough
	tbl.obj.sb:EnableMouse(false)
	-- adjust frame level
	local success, _ = _G.pcall(_G.LowerFrameLevel, tbl.obj.sb) -- catch any error, doesn't matter if already 0
	-- raise parent's Frame Level if 0
	if not success then
		_G.RaiseFrameLevel(tbl.obj)
	end
	-- make sure it's lower than its parent's Frame Strata
	if tbl.bg then
		tbl.obj.sb:SetFrameStrata(tbl.sfs)
	end
	if tbl.hide then
		tbl.obj.sb:Hide()
	end
	if tbl.rp
	and not tbl.obj.SetParent_orig
	then
		tbl.obj.sb:SetParent(tbl.obj:GetParent())
		tbl.obj:SetParent(tbl.obj.sb)
		tbl.obj.SetParent_orig = tbl.obj.SetParent
		tbl.obj.SetParent = function(this, parent)
			tbl.obj.sb:SetParent(parent)
			this:SetParent_orig(tbl.obj.sb)
		end
	end
	-- change the draw layer of the Icon and Count
	if tbl.chgDL then
		for _, reg in _G.pairs{tbl.obj:GetRegions()} do
			-- change the DrawLayer to make the Icon show if required
			if aObj:hasAnyTextInName(reg, {"Icon", "icon", "Count", "count"})
			or aObj:hasTextInTexture(reg, "Icon")
			then
				if reg:GetDrawLayer() == "BACKGROUND" then
					reg:SetDrawLayer("ARTWORK")
				end
			end
		end
	end
	if tbl.sap then
		tbl.ofs = 0
	end
	-- position around the original frame
	tbl.x1 = tbl.x1 or tbl.ofs * -1
	tbl.y1 = tbl.y1 or tbl.ofs
	tbl.x2 = tbl.x2 or tbl.ofs
	tbl.y2 = tbl.y2 or tbl.ofs * -1
	tbl.obj.sb:ClearAllPoints()
	tbl.obj.sb:SetPoint("TOPLEFT", tbl.obj, "TOPLEFT", tbl.x1, tbl.y1)
	tbl.obj.sb:SetPoint("BOTTOMRIGHT", tbl.obj, "BOTTOMRIGHT", tbl.x2, tbl.y2)
	-- setup applySkin options
	local so = aObj.skinTPLs("skin", tbl.aso)
	so.obj   = tbl.obj.sb
	so.fType = tbl.fType
	so.ba    = tbl.ba
	so.bbclr = tbl.clr
	so.bba   = tbl.bba
	so.bd    = tbl.bd
	so.ng    = tbl.ng
	-- apply the 'Skinner effect' to the frame
	aObj:skinObject(so)
	return tbl.obj.sb
end
skinFuncs.button = function(table) skinButton(table) end
local function skinDDButton(tbl)
	--@debug@
	_G.assert(tbl.obj, "Missing object (skinDDButton)\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	aObj:Debug2("skinDDButton: [%s]", tbl)

	-- don't skin it twice
	if tbl.obj.sf
	or tbl.obj.sb
	then
		return
	end

	if tbl.filter then
		-- skin the WowStyle1FilterDropdownTemplate/WowStyle2DropdownTemplate
		aObj:skinStdButton{obj=tbl.obj, fType=tbl.ftype, bd=5, sechk=true, y2=-2}
		if tbl.obj.ResetButton then -- WowStyle1FilterDropdownTemplate ONLY
			aObj.modUIBtns:skinCloseButton{obj=tbl.obj[tbl.filtercb or "ResetButton"], fType=tbl.ftype, noSkin=true}
			tbl.obj.arrow = tbl.obj:CreateTexture(nil, "ARTWORK", nil, 5)
			tbl.obj.arrow:SetTexture(aObj.tFDIDs.cfEA)
			tbl.obj.arrow:SetSize(16, 16)
			tbl.obj.arrow:SetPoint("RIGHT", -2, -1)
		end
	else
		-- skin the WowStyle1DropdownTemplate & other DropdownButtons
		if tbl.obj.Background then
			tbl.obj.Background:SetTexture("")
		end
		if not tbl.noSF then
			aObj:skinObject("frame", {obj=tbl.obj, fType=tbl.ftype, sechk=tbl.sechk, ofs=tbl.ofs, x1=tbl.x1, y1=tbl.y1, x2=tbl.x2, y2=tbl.y2})
			if aObj.prdb.TabDDTextures.textureddd then
				tbl.obj.Background:SetTexture(aObj.itTex)
				-- offset the background within the frame
				tbl.obj.Background:SetPoint("TOPLEFT", tbl.ofs + 2, tbl.ofs - 2)
				tbl.obj.Background:SetPoint("BOTTOMRIGHT", tbl.ofs - 2, tbl.ofs + 2)
			end
		end
		if not tbl.noBB then
			-- position around the original frame
			tbl.bx1  = tbl.bx1 or tbl.bofs * -1
			tbl.by1  = tbl.by1 or tbl.bofs
			tbl.bx2  = tbl.bx2 or tbl.bofs
			tbl.by2  = tbl.by2 or tbl.bofs * -1
			aObj:addButtonBorder{obj=tbl.obj, fType=tbl.ftype, relTo=tbl.obj.Arrow, clr=tbl.clr, sechk=tbl.sechk, ofs=tbl.bofs, x1=tbl.bx1, y1=tbl.by1, x2=tbl.bx2, y2=tbl.by2}
		end
	end
end
skinFuncs.ddbutton = function(table) skinDDButton(table) end
local fName, bdObj
local function skinDDList(tbl)
	--@debug@
	_G.assert(tbl.obj, "Missing object sDDL\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	aObj:Debug2("skinDDList: [%s]", tbl)

	fName = tbl.obj:GetName()
	for _, backdrop in _G.pairs{"Border", "Backdrop", "MenuBackdrop"} do
		bdObj = tbl.obj[backdrop] or _G[fName .. backdrop]
		if bdObj then
			if bdObj.ApplyBackdrop then
				aObj:removeBackdrop(bdObj, tbl.nop)
			else
				aObj:keepFontStrings(bdObj)
			end
			if bdObj.NineSlice then
				aObj:removeNineSlice(bdObj.NineSlice)
			end
		end
	end
	aObj:skinObject("frame", {obj=tbl.obj, fType=tbl.ftype, kfs=tbl.kfs, ofs=tbl.ofs})
end
skinFuncs.ddlist = function(table) skinDDList(table) end
local function skinDropDown(tbl)
	--@debug@
	_G.assert(tbl.obj, "Missing object (skinDropDown)\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	aObj:Debug2("skinDropDown: [%s]", tbl)

	-- don't skin it twice
	if tbl.obj.sf then return end
	-- hide textures
	aObj:removeRegions(tbl.obj, tbl.regions)
	-- return if not to be skinned
	if tbl.noSkin then return end
	-- skin the DropDown
	aObj:skinObject("frame", {obj=tbl.obj, fType=tbl.fType, ng=true, bd=5, rpc=tbl.rp, x1=tbl.x1, y1=tbl.y1, x2=tbl.x2, y2=tbl.y2})
	-- add a button border around the dd button
	if not tbl.noBB then
		local btn = tbl.obj.Button or tbl.obj.dropButton or _G[tbl.obj:GetName() .. "Button"]
		if tbl.lrgTpl then
			aObj:addButtonBorder{obj=btn, es=12, ofs=0}
		else
			local xOfs1 = tbl.adjBtnX and tbl.obj:GetWidth() + 10 or 1
			aObj:addButtonBorder{obj=btn, es=12, ofs=-2, x1=xOfs1}
		end
	end
	-- add texture
	if aObj.prdb.TabDDTextures.textureddd then
		tbl.obj.ddTex = tbl.obj:CreateTexture(nil, "ARTWORK", nil, -5) -- appear behind text
		tbl.obj.ddTex:SetTexture(aObj.itTex)
		-- align it to the middle texture
		local lTex = tbl.obj.Left or tbl.obj.DLeft or tbl.obj.LeftTexture or _G[tbl.obj:GetName() .. "Left"]
		local rTex = tbl.obj.Right or tbl.obj.DRight or tbl.obj.RightTexture or _G[tbl.obj:GetName() .. "Right"]
		if tbl.lrgTpl then
			tbl.obj.ddTex:SetPoint("LEFT", lTex, "RIGHT", -11, 2)
			tbl.obj.ddTex:SetPoint("RIGHT", rTex, "LEFT", -15, 0)
			tbl.obj.ddTex:SetHeight(24)
		else
			tbl.obj.ddTex:SetPoint("LEFT", lTex, "RIGHT", tbl.ddtx1, tbl.ddty1)
			tbl.obj.ddTex:SetPoint("RIGHT", rTex, "LEFT", tbl.ddtx2, tbl.ddty2)
			tbl.obj.ddTex:SetHeight(17)
		end
	end
	-- colour on Initial State
	aObj:checkDisabledDD(tbl.obj, tbl.initState)
	-- show Text and Icon
	if tbl.obj.Text then
		tbl.obj.Text:SetAlpha(1)
	end
	if tbl.obj.Icon then
		tbl.obj.Icon:SetAlpha(1)
	end
end
skinFuncs.dropdown = function(table) skinDropDown(table) end
local function skinEditBox(tbl)
	--@debug@
	_G.assert(tbl.obj, "Missing object (skinEditBox)\n" .. _G.debugstack(2, 3, 2))
	_G.assert(tbl.obj:IsObjectType("EditBox"), "Not an EditBox (skinEditBox)\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@
	aObj:Debug2("skinEditBox: [%s]", tbl)

	-- don't skin it twice
	if tbl.obj.sf then return end
	aObj:removeRegions(tbl.obj, tbl.regions)
	aObj:skinObject("frame", {obj=tbl.obj, fType=tbl.fType, bd=tbl.bd, ng=true, ofs=tbl.ofs, x1=tbl.x1, y1=tbl.y1, x2=tbl.x2, y2=tbl.y2, clr="slider"})
	-- move the search icon
	if tbl.si then
		local sIcon = tbl.obj.SearchIcon or tbl.obj.searchIcon or tbl.obj.icon or tbl.obj:GetName() and _G[tbl.obj:GetName() .. "SearchIcon"]
		if not sIcon then  -- e.g. WeakAurasFilterInput
			for _, reg in _G.pairs{tbl.obj:GetRegions()} do
				if aObj:hasTextInTexture(reg, "UI-Searchbox-Icon") then
					sIcon = reg
					break
				end
			end
		end
		aObj:moveObject{obj=sIcon, x=tbl.six}
		sIcon:SetAlpha(1)
		tbl.mix = 16 -- adjust Instructions offset
	elseif tbl.chginset then
		-- move left text insert
		local left, right, top, bottom = tbl.obj:GetTextInsets()
		tbl.obj:SetTextInsets(left + tbl.inset, right, top, bottom)
	end
	if tbl.mi
	and tbl.obj.Instructions
	then
		tbl.obj.Instructions:ClearAllPoints()
		tbl.obj.Instructions:SetPoint("LEFT", tbl.obj, "LEFT", tbl.mix, 0)
	end
	aObj:getRegion(tbl.obj, 2):SetAlpha(1) -- cursor texture
end
skinFuncs.editbox = function(table) skinEditBox(table) end
local hObj
local function skinFrame(tbl)
	--@debug@
	_G.assert(tbl, "Missing options table (skinFrame)\n" .. _G.debugstack(2, 3, 2))
	_G.assert(tbl.obj, "Missing object (skinFrame)\n" .. _G.debugstack(2, 3, 2))
	if tbl.sec then
		-- handle AddOn skins using deprecated options
		aObj:CustomPrint(1, 0, 0, "Using deprecated options - sec, use sft instead", tbl.obj)
	end
	--@end-debug@
	aObj:Debug2("skinFrame [%s]", tbl)

	if tbl.obj.sf then
		return
	end
	-- DON'T add a frame border if not required
	if tbl.chkfb
	and not aObj.prdb.FrameBorders
	then
		return
	end
	-- hide all textures
	if tbl.kfs
	or tbl.hat
	then
		aObj:keepFontStrings(tbl.obj, tbl.hat)
	else
		aObj:removeRegions(tbl.obj, tbl.regions)
	end
	if tbl.rb then
		aObj:removeBackdrop(tbl.obj, tbl.rb=="nop" and true)
	end
	if tbl.ri
	and tbl.obj.Inset or (tbl.obj.inset and _G.type(tbl.obj.inset) ~= "number")
	then
		aObj:removeInset(tbl.obj.Inset or tbl.obj.inset)
	end
	if tbl.rns
	and tbl.obj.NineSlice
	then
		aObj:removeNineSlice(tbl.obj.NineSlice)
	end
	if tbl.rp
	and tbl.obj.PortraitContainer
	and tbl.obj.PortraitContainer.portrait
	then
		tbl.obj.PortraitContainer.portrait:SetAlpha(0) -- texture changed in code
	end
	if tbl.hdr then
		-- remove Header textures and move text
		if tbl.obj.header then -- Classic
			tbl.obj.header:DisableDrawLayer("BACKGROUND")
			tbl.obj.header:DisableDrawLayer("BORDER")
			if tbl.obj.header.text
			then
				aObj:moveObject{obj=tbl.obj.header.text, y=tbl.hOfs}
			else
				aObj:moveObject{obj=aObj:getRegion(tbl.obj.header, tbl.obj.header:GetNumRegions()), y=tbl.hOfs}
			end
			-- return
		elseif tbl.obj.Header then
			aObj:removeRegions(tbl.obj.Header, {1, 2, 3})
			aObj:moveObject{obj=tbl.obj.Header.Text, y=tbl.hOfs}
			-- return
		elseif tbl.obj:GetName() ~= nil then
			local oName = tbl.obj:GetName()
			for _, suffix in _G.pairs{"Header", "_Header", "_HeaderBox", "_FrameHeader", "FrameHeader", "HeaderTexture", "HeaderFrame"} do
				hObj = _G[oName .. suffix] or _G[oName:sub(1, -6) .. suffix] -- try without "Frame" in the name
				if hObj then
					hObj:SetPoint("TOP", tbl.obj, "TOP", 0, tbl.hOfs * -1)
					if aObj:hasTextInTexture(hObj, 131080) -- FileDataID
					or aObj:hasTextInTexture(hObj, "UI-DialogBox-Header")
					then
						hObj:SetAlpha(0)
					end
					break
				end
			end
		end
	end
	if tbl.name then
		tbl.name = tbl.obj:GetName() .. "~sf~"
	end
	-- add a frame to the object
	tbl.sft = tbl.sft or tbl.sec or nil
	tbl.obj.sf = _G.CreateFrame("Frame", tbl.name, tbl.obj, tbl.sft and "SecureFrameTemplate")
	-- allow clickthrough
	tbl.obj.sf:EnableMouse(false)
	-- adjust frame level & make it mirror its parent's
	tbl.obj.sf:SetFrameLevel(tbl.obj:GetFrameLevel())
	tbl.obj.sf.SetFrameLevel = tbl.obj.SetFrameLevel
	-- position around the original frame
	tbl.x1  = tbl.x1 or tbl.ofs * -1
	tbl.y1  = tbl.y1 or tbl.ofs
	tbl.x2  = tbl.x2 or tbl.ofs
	tbl.y2  = tbl.y2 or tbl.ofs * -1
	tbl.obj.sf:ClearAllPoints()
	tbl.obj.sf:SetPoint("TOPLEFT", tbl.obj, "TOPLEFT", tbl.x1, tbl.y1)
	tbl.obj.sf:SetPoint("BOTTOMRIGHT", tbl.obj, "BOTTOMRIGHT", tbl.x2, tbl.y2)
	-- make sure it's lower than its parent's Frame Strata
	if tbl.bg then
		tbl.obj.sf:SetFrameStrata(tbl.sfs)
	else
		tbl.obj.sf:SetFrameStrata(tbl.obj:GetFrameStrata())
	end
	-- skin the CloseButton
	if aObj.modBtns
	and tbl.cb
	or tbl.cbns
	then
		local cBtn = tbl.obj.CloseButton or tbl.obj.closeButton or tbl.obj.closebutton or tbl.obj:GetName() and _G[tbl.obj:GetName() .. "CloseButton"] or tbl.obj.Close or tbl.obj.close
		if cBtn then
			aObj:skinCloseButton{obj=cBtn, fType=tbl.ftype, noSkin=tbl.cbns}
		end
	end
	-- reverse parent child relationship
	if tbl.rpc
	and not tbl.obj.SetParent_orig
	then
		tbl.obj.sf:SetParent(tbl.obj:GetParent())
		tbl.obj:SetParent(tbl.obj.sf)
		tbl.obj.SetParent_orig = tbl.obj.SetParent
		tbl.obj.SetParent = function(this, parent)
			tbl.obj.sf:SetParent(parent)
			this:SetParent_orig(tbl.obj.sf)
		end
		-- hook Show and Hide methods
		aObj:SecureHook(tbl.obj, "Show", function(this) this.sf:Show() end)
		aObj:SecureHook(tbl.obj, "Hide", function(this) this.sf:Hide() end)
	end
	-- add hook to change border colour when disabled/enabled
	if tbl.sechk then
		-- save colour info on object
		tbl.obj.sf.clr = tbl.clr
		tbl.obj.sf.ca = tbl.ca
		aObj:SecureHook(tbl.obj, "SetEnabled", function(fObj)
			aObj:clrFrameBdr(fObj, fObj.sf.clr, fObj.sf.ca)
		end)
	end
	-- setup Frame Border options
	if tbl.fb then
		tbl.bd  = 10
		tbl.ng  = true
		tbl.ofs = tbl.ofs or 0
	end
	-- setup applySkin options
	local so  = aObj.skinTPLs("skin", tbl.aso)
	so.obj    = tbl.obj.sf
	so.fType  = tbl.fType
	so.ba     = tbl.ba
	so.bbclr  = tbl.clr
	so.bba    = tbl.ca
	so.bd     = tbl.noBdr and 11 or tbl.bd
	so.ng     = tbl.ng
	so.fh     = tbl.fh
	so.invert = tbl.invert
	so.rotate = tbl.rotate
	-- apply the 'Skinner effect' to the frame
	aObj:skinObject(so)
	return tbl.obj.sf
end
skinFuncs.frame = function(table) skinFrame(table) end
local function skinGlowBox(tbl)
	--@debug@
	_G.assert(tbl.obj, "Missing object (skinGlowBox)\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@
	aObj:Debug2("skinGlowBox: [%s]", tbl)

	-- don't skin it twice
	if tbl.obj.sf then return end
	-- remove Arrow Glow texture
	if tbl.obj.Glow then
		tbl.obj.Glow:SetTexture(nil)
	elseif tbl.obj.Arrow
	and tbl.obj.Arrow.Glow then
		tbl.obj.Arrow.Glow:SetTexture(nil)
	elseif tbl.obj.ArrowGlow then
		tbl.obj.ArrowGlow:SetTexture(nil)
	end
	tbl.obj:DisableDrawLayer("BACKGROUND")
	-- skin the GlowBox
	aObj:skinObject("frame", {obj=tbl.obj, fType=tbl.fType, cbns=true, clr="gold"})
end
skinFuncs.glowbox = function(table) skinGlowBox(table) end
local skinnedMFs = {}
local function skinMoneyFrame(tbl)
	--@debug@
	_G.assert(tbl.obj, "Missing object (skinMoneyFrame)\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@
	aObj:Debug2("skinMoneyFrame: [%s]", tbl)

	-- don't skin it twice
	if skinnedMFs[tbl.obj] then
		return
	else
		skinnedMFs[tbl.obj] = true
	end

	local mfObj
	for key, type in _G.ipairs{"Gold", "Silver", "Copper"} do
		mfObj = _G[tbl.obj:GetName() .. type]
		aObj:skinObject("editbox", {obj=mfObj, ofs=0})
		if key ~= 1 then
			if tbl.moveIcon then
				aObj:moveObject{obj=mfObj.texture, x=10}
				aObj:moveObject{obj=mfObj.label, x=10}
			end
			if tbl.adjWdth then
				aObj:adjWidth{obj=mfObj, adj=tbl.adjWdth}
			end
		end
		if type == "Gold"
		and tbl.moveGEB
		then
			aObj:moveObject{obj=mfObj, x=-8}
		end
		if type == "Silver"
		and tbl.moveSEB
		then
			aObj:moveObject{obj=mfObj, x=-8}
		end
	end
end
skinFuncs.moneyframe = function(table) skinMoneyFrame(table) end
local function skinScrollBar(tbl)
	--@debug@
	_G.assert(tbl.obj, "Missing object (skinScrollBar)\n" .. _G.debugstack(2, 3, 2))
	_G.assert(tbl.obj.Track, "Not a ScrollBarBase (skinScrollBar)\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@
	aObj:Debug2("skinScrollBar: [%s, %s]", tbl)

	-- don't skin it twice
	if tbl.obj.sf then return end
	-- remove textures
	tbl.obj:DisableDrawLayer("BACKGROUND")
	-- handle .Background frame being hijacked by a .Background texture
	local child = aObj:getChild(tbl.obj, 1)
	if child
	and child.Begin
	and child.Middle
	and child.End
	then
		child:DisableDrawLayer("ARTWORK")
	end
	setScrollTrackOffsets(tbl, "scrollbar")
	aObj:skinObject("frame", {obj=tbl.obj.Track, fType=tbl.fType, bd=4, ng=true, x1=tbl.x1, y1=tbl.y1, x2=tbl.x2, y2=tbl.y2, clr="slider"})
end
skinFuncs.scrollbar = function(table) skinScrollBar(table) end
local function skinSlider(tbl)
	--@debug@
	_G.assert(tbl.obj, "Missing object (skinSlider)\n" .. _G.debugstack(2, 3, 2))
	_G.assert(tbl.obj:IsObjectType("Slider"), "Not a Slider (skinSlider)\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@
	aObj:Debug2("skinSlider: [%s, %s]", tbl)

	-- don't skin it twice
	if tbl.obj.sf then return end
	-- remove textures
	aObj:keepFontStrings(tbl.obj)
	-- remove parent's textures
	if tbl.rpTex then
		if _G.type(tbl.rpTex) == "table" then
			for _, layer in _G.pairs(tbl.rpTex) do
				tbl.obj:GetParent():DisableDrawLayer(layer)
			end
		else
			tbl.obj:GetParent():DisableDrawLayer(tbl.rpTex)
		end
	end
	setScrollTrackOffsets(tbl, "slider")
	aObj:skinObject("frame", {obj=tbl.obj, fType=tbl.fType, bd=4, ng=true, x1=tbl.x1, y1=tbl.y1, x2=tbl.x2, y2=tbl.y2, clr="slider"})
	-- make objects visible
	tbl.obj:SetAlpha(1)
	tbl.obj:GetThumbTexture():SetAlpha(1)
end
skinFuncs.slider = function(table) skinSlider(table) end
local sbG
local function skinStatusBar(tbl)
	--@debug@
	_G.assert(tbl.obj, "Missing object __sSB\n" .. _G.debugstack(2, 3, 2))
	_G.assert(tbl.obj:IsObjectType("StatusBar"), "Not a StatusBar (skinStatusBar)\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@
	aObj:Debug2("skinStatusBar: [%s, %s]", tbl)

	-- apply StatusBar texture
	tbl.obj:SetStatusBarTexture(aObj.sbTexture)
	-- don't skin it twice
	if not aObj.sbGlazed[tbl.obj] then
		aObj.sbGlazed[tbl.obj] = {}
	else
		return
	end
	-- create local object
	sbG = aObj.sbGlazed[tbl.obj]
	-- remove texture regions
	aObj:removeRegions(tbl.obj, tbl.regions)
	-- create background texture if required
	if tbl.fi then
		if not sbG.bg then
			sbG.bg = tbl.bg or tbl.obj:CreateTexture(nil, "BACKGROUND", nil, -1)
			sbG.bg:SetTexture(aObj.sbTexture)
			sbG.bg:SetVertexColor(aObj.sbClr:GetRGBA())
			if not tbl.bg then
				sbG.bg:SetAllPoints()
			end
		end
	end
	-- apply texture to and store other texture objects
	if tbl.other
	and _G.type(tbl.other) == "table"
	then
		for _, tex in _G.pairs(tbl.other) do
			tex:SetTexture(aObj.sbTexture)
			tex:SetVertexColor(aObj.sbClr:GetRGBA())
			aObj:add2Table(sbG, tex)
		end
	end
	-- nop Atlas functions
	if tbl.nilFuncs then
		tbl.obj.SetStatusBarTexture = _G.nop
		tbl.obj.SetStatusBarAtlas = _G.nop
		for _, tex in _G.pairs(sbG) do
			tex.SetTexture = _G.nop
			tex.SetAtlas = _G.nop
		end
	end
	if tbl.hookFunc then
		aObj:RawHook(tbl.obj, "SetStatusBarTexture", function(this, _)
			aObj.hooks[this].SetStatusBarTexture(this, aObj.sbTexture)
		end, true)
	end
end
skinFuncs.statusbar = function(table) skinStatusBar(table) end
local function skinTabs(tbl)
	--@debug@
	_G.assert(tbl.obj, "Missing Tab Object (skinTabs)\n" .. _G.debugstack(2, 3, 2))
	_G.assert(tbl.tabs and _G.type(tbl.tabs) == "table" or tbl.prefix or tbl.pool, "Missing Tabs Table, Tab Prefix or Tab Pool (skinTabs)\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@
	aObj:Debug2("skinTabs: [%s]", tbl)

	-- don't skin it twice unless required (Ace3)
	if _G.tContains(aObj.tabFrames, tbl.obj)
	and not tbl.noCheck
	then
		return
	end

	if not tbl.pool then
		-- create table of tab objects if not supplied
		if not tbl.tabs then
			tbl.tabs = {}
			for i = 1, tbl.obj.numTabs or tbl.numTabs do
				aObj:add2Table(tbl.tabs, _G[tbl.prefix .. "Tab"  ..  tbl.suffix .. i])
			end
		end
	end
	if aObj.isTT then
		if not tbl.offsets.y1
		or tbl.offsets.y1 == 2
		then
			tbl.offsets.y1 = 3
		end
	end
	if aObj.isMnln then
		if not tbl.offsets.x1
		or tbl.offsets.x1 == 8
		then
			tbl.offsets.x1 = 0
		end
		if not tbl.offsets.x2
		or tbl.offsets.x2 == -8
		then
			tbl.offsets.x2 = 0
		end
	end
	if aObj.isTukUI then
		tbl.offsets.x1 = (tbl.offsets.x1 or 0) + 4
		tbl.offsets.y1 = (tbl.offsets.y1 or 0) - 3
		tbl.offsets.x2 = (tbl.offsets.x2 or 0) - 4
		tbl.offsets.y2 = (tbl.offsets.y2 or 0) + 3
	end
	local function skinTabObject(tab, idx)
		aObj:keepRegions(tab, tbl.regions)
		if not aObj.isTT then
			aObj:skinObject("frame", {obj=tab, fType=tbl.fType, ng=tbl.ng, x1=tbl.offsets.x1, y1=tbl.offsets.y1, x2=tbl.offsets.x2, y2=tbl.offsets.y2})
		else
			aObj:skinObject("frame", {obj=tab, fType=tbl.fType, bd=tbl.bd, noBdr=true, x1=tbl.offsets.x1, y1=tbl.offsets.y1, x2=tbl.offsets.x2, y2=tbl.offsets.y2})
			if tbl.lod then
				if idx == (tbl.obj.selectedTab or tbl.selectedTab) then
					aObj:setActiveTab(tab.sf)
				else
					aObj:setInactiveTab(tab.sf)
				end
			elseif tbl.pool then
				if tab.isSelected then
					aObj:setActiveTab(tab.sf)
				else
					aObj:setInactiveTab(tab.sf)
				end
				aObj:SecureHook(tab, "SetTabSelected", function(tObj, _)
					aObj:Debug("tab SetTabSelected: [%s, %s]", tObj)
					if tObj.isSelected then
						aObj:setActiveTab(tObj.sf)
					else
						aObj:setInactiveTab(tObj.sf)
					end
				end)
			end
		end
		tab.sf.ignore = tbl.ignoreSize
		tab.sf.up = tbl.upwards
		-- change highlight texture
		if tbl.ignoreHLTex then
			if not aObj.isMnln then
				local ht = tab:GetHighlightTexture()
				if ht then
					ht:SetTexture(aObj.tFDIDs.ctabHL)
					ht:ClearAllPoints()
					ht:SetPoint("TOPLEFT", tab, "TOPLEFT", tbl.offsets.x1, tbl.offsets.y1)
					ht:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", tbl.offsets.x2, tbl.offsets.y2)
				end
			else
				if tab.LeftHighlight then
					tab.LeftHighlight:SetTexture(nil)
					tab.RightHighlight:SetTexture(nil)
					tab.MiddleHighlight:SetTexture(nil)
				end
			end
		end
		if tbl.func then
			tbl.func(tab)
		end
	end
	if tbl.pool then
		local idx = 0
		for tab in tbl.obj.tabPool:EnumerateActive() do
			idx = idx + 1
			skinTabObject(tab, idx)
		end
	else
		for i, tab in _G.pairs(tbl.tabs) do
			skinTabObject(tab, i)
		end
	end
	-- track tab updates
	aObj.tabFrames[tbl.obj] = tbl.track
end
skinFuncs.tabs = function(table) skinTabs(table) end
local function skinTooltip(tbl)
	if not aObj.prdb.Tooltips.skin then return end
	--@debug@
	_G.assert(tbl.obj, "Missing object (skinTooltip)\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@
	aObj:Debug2("skinTooltip: [%s]", tbl.obj)

	if not tbl.obj then return end
	if not tbl.obj.sf then
		-- Bugfix for ElvUI
		local ttSB
		if aObj.isElvUI then
			ttSB = tbl.obj.SetBackdrop
			tbl.obj.SetBackdrop = _G.nop
		end
		aObj:skinObject("frame", {obj=tbl.obj, fType=tbl.ftype, kfs=true, rb=true, ofs=tbl.ofs or 0})
		if aObj.isElvUI then
			tbl.obj.SetBackdrop = ttSB
		end
	end
	tbl.obj.sf:SetBackdropBorderColor(aObj.tbClr:GetRGBA())
	if aObj.isClscERA then
		local kid1 = aObj:getChild(tbl.obj, 1)
		if kid1:GetNumRegions() == 9 then
			aObj:removeNineSlice(kid1)
		end
	else
		if tbl.obj.TopLeftCorner then
			aObj:removeNineSlice(tbl.obj)
		end
	end
	aObj:applyTooltipGradient(tbl.obj.sf)
end
skinFuncs.tooltip = function(table) skinTooltip(table) end

-- N.B. The following functions have been moved from UtilFuncs.lua
function aObj:skinColumnDisplay(frame)

	frame:DisableDrawLayer("BACKGROUND")
	frame:DisableDrawLayer("BORDER")
	frame:DisableDrawLayer("ARTWORK")
	for header in frame.columnHeaders:EnumerateActive() do
		header:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=header, x2=-2})
	end

end

function aObj:skinIconSelector(frame, ftype)

	ftype = ftype or "a"
	self:keepFontStrings(frame.BorderBox)
	frame.BorderBox.SelectedIconArea.SelectedIconButton:DisableDrawLayer("BACKGROUND")
	self:skinObject("editbox", {obj=frame.BorderBox.IconSelectorEditBox, fType=ftype})
	self:skinObject("ddbutton", {obj=frame.BorderBox.IconTypeDropdown, fType=ftype})
	self:skinObject("scrollbar", {obj=frame.IconSelector.ScrollBar, fType=ftype})
	self:skinObject("frame", {obj=frame, fType=ftype, ofs=-3, x1=-2})
	if self.modBtns then
		self:skinStdButton{obj=frame.BorderBox.CancelButton, fType=ftype}
		self:skinStdButton{obj=frame.BorderBox.OkayButton, fType=ftype, schk=true, sechk=true}
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=frame.BorderBox.SelectedIconArea.SelectedIconButton, fType=ftype, relTo=frame.BorderBox.SelectedIconArea.SelectedIconButton.Icon}
		local function skinElement(...)
			local _, element, new
			if _G.select("#", ...) == 2 then
				element, _ = ...
			elseif _G.select("#", ...) == 3 then
				element, _, new = ...
			else
				_, element, _, new = ...
			end
			if new ~= false then
				element:DisableDrawLayer("BACKGROUND")
				aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon}
			end
		end
		_G.ScrollUtil.AddAcquiredFrameCallback(frame.IconSelector.ScrollBox, skinElement, aObj, true)
	end

end

function aObj:skinMainHelpBtn(frame)

	frame.MainHelpButton.Ring:SetTexture(nil)
	self:moveObject{obj=frame.MainHelpButton, y=-4}

end

local function skinNavBarButton(btn)
	btn:DisableDrawLayer("OVERLAY")
	btn:GetNormalTexture():SetAlpha(0)
	btn:GetPushedTexture():SetAlpha(0)
	if aObj.modBtnBs
	and btn.MenuArrowButton -- Home button doesn't have one
	and not btn.MenuArrowButton.sbb
	then
		aObj:addButtonBorder{obj=btn.MenuArrowButton, ofs=-2, x1=-1, x2=0, clr="gold", ca=0.75}
		if btn.MenuArrowButton.sbb then
			btn.MenuArrowButton.sbb:SetAlpha(0) -- hide button border
		end
		-- handle in combat hooking
		aObj:hookScript(btn.MenuArrowButton, "OnEnter", function(bObj)
			bObj.sbb:SetAlpha(1)
		end)
		aObj:hookScript(btn.MenuArrowButton, "OnLeave", function(bObj)
			bObj.sbb:SetAlpha(0)
		end)
	end
end
function aObj:skinNavBar(navBar)

	navBar:DisableDrawLayer("BACKGROUND")
	navBar:DisableDrawLayer("BORDER")
	navBar.overlay:DisableDrawLayer("OVERLAY")

	for _, btn in _G.pairs(navBar.navList) do
		skinNavBarButton(btn)
	end
	navBar.overflowButton:GetNormalTexture():SetAlpha(0)
	navBar.overflowButton:GetPushedTexture():SetAlpha(0)
	navBar.overflowButton:GetHighlightTexture():SetAlpha(0)
	navBar.overflowButton:SetText("<<")
	navBar.overflowButton:SetNormalFontObject(self.modUIBtns.fontP) -- use module name instead of shortcut

end
-- hook this to skin new buttons (Encounter Journal uses this)
aObj:SecureHook("NavBar_AddButton", function(this, _)
	skinNavBarButton(this.navList[#this.navList])
end)

function aObj:skinPagingControls(frame)

	if frame.PageText then
		frame.PageText:SetTextColor(self.BT:GetRGB())
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=frame.PrevPageButton, ofs=-2, x1=1, clr="gold", sechk=true}
		self:addButtonBorder{obj=frame.NextPageButton, ofs=-2, x1=1, clr="gold", sechk=true}
	end

end

aObj.skinRoleBtns = _G.nop
if _G.PVEFrame then
	-- The following function is used by the LFD & RaidFinder skinning functions
	local roleBtn
	function aObj:skinRoleBtns(frame)
		for _, type in _G.pairs{"Tank", "Healer", "DPS", "Leader"} do
			roleBtn = _G[frame .. "QueueFrameRoleButton" .. type]
			if roleBtn.background then
				roleBtn.background:SetTexture(nil)
			end
			if roleBtn.shortageBorder then
				roleBtn.shortageBorder:SetTexture(nil)
			end
			if roleBtn.incentiveIcon then
				roleBtn.incentiveIcon.border:SetTexture(nil)
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=roleBtn.checkButton}
			end
		end
	end
end

if aObj.isMnln then
	function aObj:skinTabSettingsMenu(frame, ftype)

		self:SecureHookScript(frame.TabSettingsMenu, "OnShow", function(fObj)
			self:skinIconSelector(fObj, ftype)
			self:getRegion(fObj.DepositSettingsMenu, 4):SetTexture(nil) -- Separator texture
			self:skinObject("ddbutton", {obj=fObj.DepositSettingsMenu.ExpansionFilterDropdown, fType=ftype})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true})
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.DepositSettingsMenu.AssignEquipmentCheckbox, fType=ftype, size=22}
				self:skinCheckButton{obj=fObj.DepositSettingsMenu.AssignConsumablesCheckbox, fType=ftype, size=22}
				self:skinCheckButton{obj=fObj.DepositSettingsMenu.AssignProfessionGoodsCheckbox, fType=ftype, size=22}
				self:skinCheckButton{obj=fObj.DepositSettingsMenu.AssignReagentsCheckbox, fType=ftype, size=22}
				self:skinCheckButton{obj=fObj.DepositSettingsMenu.AssignJunkCheckbox, fType=ftype, size=22}
				self:skinCheckButton{obj=fObj.DepositSettingsMenu.IgnoreCleanUpCheckbox, fType=ftype, size=22}
			end

			self:Unhook(frame, "OnShow")
		end)

	end
end
