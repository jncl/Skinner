-- luacheck: ignore 631 (line is too long)
--[===[@non-debug@

local _, aObj = ...

local _G = _G

local hOfs = -7
local function hideHeader(obj)
	local hAdj, hObj = false
	-- move the Header texture, if required
	for _, suff in _G.pairs{"Header", "_Header", "_HeaderBox", "_FrameHeader", "FrameHeader", "HeaderTexture", "HeaderFrame"} do
		hObj = _G[obj:GetName() .. suff]
		if hObj then
			hObj:SetPoint("TOP", obj, "TOP", 0, 7)
			hAdj = true
			if aObj:hasTextInTexture(hObj, "UI-DialogBox-Header") then
				hObj:SetTexture(nil)
			end
			break
		end
	end
	if obj.header then -- Classic
		obj.header:DisableDrawLayer("BACKGROUND")
		obj.header:DisableDrawLayer("BORDER")
		if obj.header.text
		then
			aObj:moveObject{obj=obj.header.text, y=hAdj and 0 or hOfs}
		else
			aObj:moveObject{obj=aObj:getRegion(obj.header, obj.header:GetNumRegions()), y=hAdj and 0 or hOfs}
		end
	end
	if obj.Header then
		aObj:removeRegions(obj.Header, {1, 2, 3})
		aObj:moveObject{obj=obj.Header.Text, y=hAdj and 0 or hOfs}
	end
end

local function __addSkinButton(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		parent = object to parent to, default is the object's parent
		hook = object to hook Show/Hide methods, defaults to object
		hide = Hide button skin
		sap = SetAllPoints
		bg = set FrameStrata to "BACKGROUND"
		kfs = Remove all textures, only keep font strings
		aso = applySkin options
		ofs = offset value to use
		x1 = X offset for TOPLEFT
		y1 = Y offset for TOPLEFT
		x2 = X offset for BOTTOMRIGHT
		y2 = Y offset for BOTTOMRIGHT
		rp = re-parent, reverse the parent child relationship
		sec = use the "SecureFrameTemplate"
		noHooks = don't hook methods
--]]
	--@alpha@
	_G.assert(opts.obj, "Missing object __aSB\n" .. _G.debugstack(2, 3, 2))
	 if opts.seca
	 or opts.secu
	 then
		-- handle AddOn skins using deprecated options
		aObj:CustomPrint(1, 0, 0, "Using deprecated options - seca,secu, use sft instead", opts.obj)
	end
	--@end-alpha@

	aObj:Debug2("__addSkinButton: [%s, %s]", opts.obj, opts.obj:GetName())

	if opts.obj.sb then
		return
	end

	aObj:removeBackdrop(opts.obj)

	if opts.kfs then
		aObj:keepFontStrings(opts.obj)
	end

	opts.parent = opts.parent or opts.obj

	-- store button object within original button
	opts.obj.sb = _G.CreateFrame("Button", nil, opts.parent, (opts.sec or opts.secu or opts.seca) and "SecureFramenTemplate")
	local btn = opts.obj.sb
	_G.LowerFrameLevel(btn)
	btn:EnableMouse(false) -- allow clickthrough

	if not opts.noHooks then
		opts.hook = opts.hook or opts.obj
		-- hook Show/Hide methods
        -- changed to hook scripts as functions don't always work
		aObj:hookScript(opts.hook, "OnShow", function(bObj)
			-- handle in combat
			if _G.InCombatLockdown() then
			    aObj:add2Table(aObj.oocTab, {bObj.sb.Show, {bObj}})
			    return
			end
			opts.obj.sb:Show()
		end)
		aObj:hookScript(opts.hook, "OnHide", function(bObj)
			if _G.InCombatLockdown() then
			    aObj:add2Table(aObj.oocTab, {bObj.sb.Hide, {bObj}})
			    return
			end
			opts.obj.sb:Hide()
		end)
	end

	-- position the button skin
	if opts.sap then
		btn:SetAllPoints(opts.obj)
	else
		-- setup offset values
		opts.ofs = opts.ofs or 4
		opts.x1 = opts.x1 or opts.ofs * -1
		opts.y1 = opts.y1 or opts.ofs
		opts.x2 = opts.x2 or opts.ofs
		opts.y2 = opts.y2 or opts.ofs * -1
		btn:SetPoint("TOPLEFT", opts.obj, "TOPLEFT", opts.x1, opts.y1)
		btn:SetPoint("BOTTOMRIGHT", opts.obj, "BOTTOMRIGHT", opts.x2, opts.y2)
	end
	-- setup applySkin options
	opts.aso = opts.aso or {}
	opts.aso.obj = btn
	aObj:applySkin(opts.aso)

	-- hide button skin, if required
	if opts.hide then
		btn:Hide()
	end

	 -- make sure it's lower than its parent's Frame Strata
	if opts.bg then
		btn:SetFrameStrata("BACKGROUND")
	end

	-- change the draw layer of the Icon and Count, if necessary
	if opts.obj.GetNumRegions then
		local regOT
		for _, reg in _G.ipairs{opts.obj:GetRegions()} do
			regOT = reg:GetObjectType()
			if regOT == "Texture"
			or regOT == "FontString"
			then
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
	end

	-- reverse parent child relationship
	if opts.rp then
		btn:SetParent(opts.obj:GetParent())
		opts.obj:SetParent(btn)
		opts.obj.SetParent_orig = opts.obj.SetParent
		opts.obj.SetParent = function(this, parent)
			this.sb:SetParent(parent)
			this:SetParent_orig(this.sb)
		end
	end

	return opts.obj.sb

end
function aObj:addSkinButton(...) -- luacheck: ignore 212 (unused argument)

	local opts = _G.select(1, ...)

	--@alpha@
	_G.assert(opts, "Missing object aSB\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata" and _G.type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
		opts.parent = _G.select(2, ...) and _G.select(2, ...) or nil
		opts.hook = _G.select(3, ...) and _G.select(3, ...) or nil
		opts.hide = _G.select(4, ...) and _G.select(4, ...) or nil
	end
	-- new style call
	return __addSkinButton(opts)

end

local function __addSkinFrame(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		ft = Frame Type (Skinner classification)
		kfs = Remove all textures, only keep font strings
		hat = Hide all textures
		rt = remove Textures
		hdr = Header Texture to be hidden
		bg = set FrameStrata to "BACKGROUND"
		noBdr = no border
		aso = applySkin options
		ofs = offset value to use
		x1 = X offset for TOPLEFT
		y1 = Y offset for TOPLEFT
		x2 = X offset for BOTTOMRIGHT
		y2 = Y offset for BOTTOMRIGHT
		nb = don't skin UI buttons
		bgen = generations of button children to traverse
		anim = reparent skinFrame to avoid whiteout issues caused by animations
		ri = Disable Inset DrawLayers
		bas = use applySkin for buttons
		rp = re-parent, reverse the parent child relationship
		sec = use the "SecureFrameTemplate"
--]]
	--@alpha@
	_G.assert(opts.obj, "Missing object __aSF\n" .. _G.debugstack(2, 3, 2))
	-- CHANGED: show AddOn skins still using skinAllButtons
	if not opts.ft and not opts.nb then
		aObj:CustomPrint(1, 0, 0, "Not using nb=true", opts.obj)
		if not opts.obj:GetName() then _G.print("No Name supplied __aSF\n", _G.debugstack(2, 3, 2)) end
	end
	-- FIXME: use ft="a" when AddOn skin has been changed to manually skin buttons
	--@end-alpha@

	aObj:Debug2("__addSkinFrame: [%s, %s]", opts.obj, opts.obj.GetName and opts.obj:GetName() or "<Anon>")

	-- don't skin it twice
	if opts.obj.sf then return end

	-- remove the object's Backdrop if it has one
	aObj:removeBackdrop(opts.obj)

	-- make all textures transparent, if required
	if opts.kfs
	or opts.hat
	then
		aObj:keepFontStrings(opts.obj, opts.hat)
		if opts.obj.NineSlice then
			aObj:removeNineSlice(opts.obj.NineSlice)
		end
	end

	-- remove all textures, if required
	if opts.rt then
		for _, reg in _G.ipairs{opts.obj:GetRegions()} do
			if not reg:IsObjectType("FontString") then
				reg:SetTexture(nil)
			end
		end
	end

	-- setup offset values
	opts.ofs = opts.ofs or 2
	opts.x1 = opts.x1 or opts.ofs * -1
	opts.y1 = opts.y1 or opts.ofs
	opts.x2 = opts.x2 or opts.ofs
	opts.y2 = opts.y2 or opts.ofs * -1

	-- add a frame around the current object
	opts.obj.sf = _G.CreateFrame("Frame", nil, opts.obj, opts.sec and "SecureFrameTemplate" or nil)
	local skinFrame = opts.obj.sf
	skinFrame:ClearAllPoints()
	skinFrame:SetPoint("TOPLEFT", opts.obj, "TOPLEFT", opts.x1, opts.y1)
	skinFrame:SetPoint("BOTTOMRIGHT", opts.obj, "BOTTOMRIGHT", opts.x2, opts.y2)

	skinFrame:EnableMouse(false) -- allow clickthrough

	-- handle header, if required
	if opts.hdr then hideHeader(opts.obj) end

	-- setup applySkin options
	opts.aso = opts.aso or {}
	opts.aso.obj = skinFrame

	-- handle no Border, if required
	if opts.noBdr then opts.aso.bd = 11 end

	-- skin the frame using supplied options
	aObj:applySkin(opts.aso)

	-- adjust frame level
	local success, _ = _G.pcall(_G.LowerFrameLevel, skinFrame) -- catch any error, doesn't matter if already 0
	if not success then _G.RaiseFrameLevel(opts.obj) end -- raise parent's Frame Level if 0

	 -- make sure it's lower than its parent's Frame Strata
	if opts.bg then skinFrame:SetFrameStrata("BACKGROUND") end

	if aObj.modBtns then
		-- CHANGED: skinAllButtons only used for AddOn skins, until all are converted (use ft="a" when converting)
		if not opts.nb then
			if not opts.ft then
				aObj:skinAllButtons{obj=opts.obj, bgen=opts.bgen, anim=opts.anim, as=opts.bas, ft=opts.ft}
			else
				-- skin the CloseButton if it exists
				local cBtn = opts.obj.CloseButton or opts.obj.closeButton or opts.obj:GetName() and _G[opts.obj:GetName() .. "CloseButton"]
				if cBtn then
					aObj:skinCloseButton{obj=cBtn}
				end
			end
		end
	end

	-- remove inset textures
	if opts.ri then
		aObj:removeInset(opts.obj.Inset)
	end

	-- reverse parent child relationship
	if opts.rp
	and not opts.obj.SetParent_orig
	then
		skinFrame:SetParent(opts.obj:GetParent())
		opts.obj:SetParent(skinFrame)
		opts.obj.SetParent_orig = opts.obj.SetParent
		opts.obj.SetParent = function(this, parent)
			opts.obj.sf:SetParent(parent)
			this:SetParent_orig(opts.obj.sf)
		end
		-- hook Show and Hide methods
		aObj:SecureHook(opts.obj, "Show", function(this) this.sf:Show() end)
		aObj:SecureHook(opts.obj, "Hide", function(this) this.sf:Hide() end)
	end

	return opts.obj.sf

end
function aObj:addSkinFrame(...) -- luacheck: ignore 212 (unused argument)

	local opts = _G.select(1, ...)

	--@alpha@
	_G.assert(opts, "Missing object aSF\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata" and _G.type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
		opts.x1 = _G.select(2, ...) and _G.select(2, ...) or -3
		opts.y1 = _G.select(3, ...) and _G.select(3, ...) or 3
		opts.x2 = _G.select(4, ...) and _G.select(4, ...) or 3
		opts.y2 = _G.select(5, ...) and _G.select(5, ...) or -3
		opts.ft = _G.select(6, ...) and _G.select(6, ...) or nil
		opts.noBdr = _G.select(7, ...) and _G.select(7, ...) or nil
	end

	return __addSkinFrame(opts)

end

local function __applySkin(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		ft = Frame Type (Skinner classification)
		kfs = Remove all textures, only keep font strings
		hdr = Header Texture to be hidden
		bba = Backdrop Border Alpha value
		ba = Backdrop Alpha value
		fh = Fade Height
		bd = Backdrop table to use, default is 1
		ng = No Gradient effect
		invert = invert gradient
		rotate = rotate gradient
		ebc = Use EditBox Colours
		bbclr = BackdropBorder colour name
		bbca = BackdropBorder colour alpha
--]]
	--@alpha@
	_G.assert(opts.obj, "Missing object __aS\n" .. _G.debugstack(2, 3, 2))
	local hasIOT = _G.assert(opts.obj.IsObjectType, "The Object passed isn't a Frame") -- throw an error here to get its original location reported
	if hasIOT and not opts.obj:IsObjectType("Frame") then
		if aObj.prdb.Errors then
			aObj:CustomPrint(1, 0, 0, "Error skinning", opts.obj.GetName and opts.obj:GetName() or opts.obj, "not a Frame or subclass of Frame:", opts.obj:GetObjectType())
			return
		end
	end
	--@end-alpha@

	aObj:Debug2("__applySkin: [%s, %s]", opts.obj, opts.obj:GetName())

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

	-- store frame obj, if required
	if opts.ft then
		aObj.gradFrames[opts.ft][opts.obj] = true
	end

	-- make all textures transparent, if required
	if opts.kfs then aObj:keepFontStrings(opts.obj) end

	aObj:addBackdrop(opts.obj)
	-- setup the backdrop
	opts.obj:SetBackdrop(aObj.Backdrop[opts.bd or 1])
	if not opts.ebc then
		-- colour the backdrop as required
		local r, g, b, a = aObj.bClr:GetRGBA()
		opts.obj:SetBackdropColor(r, g, b, opts.ba or a)
		aObj:clrBBC(opts.obj, opts.bbclr, opts.bbca)
	else
		opts.obj:SetBackdropColor(.1, .1, .1, 1)
		opts.obj:SetBackdropBorderColor(.2, .2, .2, 1)
	end

	-- fix for backdrop textures not tiling vertically
	-- using info from here: http://boss.wowinterface.com/forums/showthread.php?p=185868
	if aObj.prdb.BgUseTex then
		if not opts.obj.tbg then
			opts.obj.tbg = opts.obj:CreateTexture(nil, "BORDER")
			opts.obj.tbg:SetTexture(aObj.LSM:Fetch("background", aObj.bgTexName), true) -- have to use true for tiling to work
			opts.obj.tbg:SetBlendMode("ADD") -- use existing frame alpha setting
			-- allow for border inset
			opts.obj.tbg:SetPoint("TOPLEFT", opts.obj, "TOPLEFT", aObj.prdb.BdInset, -aObj.prdb.BdInset)
			opts.obj.tbg:SetPoint("BOTTOMRIGHT", opts.obj, "BOTTOMRIGHT", -aObj.prdb.BdInset, aObj.prdb.BdInset)
			-- the texture will be stretched if the following tiling methods are set to false
			opts.obj.tbg:SetHorizTile(aObj.prdb.BgTile)
			opts.obj.tbg:SetVertTile(aObj.prdb.BgTile)
		end
	elseif opts.obj.tbg then
		opts.obj.tbg = nil -- remove background texture if it exists
	end

	-- handle header, if required
	if opts.hdr then hideHeader(opts.obj) end

	-- apply the Gradient, if required
	if not opts.ng then
		aObj:applyGradient(opts.obj, opts.fh, opts.invert, opts.rotate)
	end

end
function aObj:applySkin(...) -- luacheck: ignore 212 (unused argument)

	local opts = _G.select(1, ...)

	--@alpha@
	_G.assert(opts, "Missing object aS\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata" and _G.type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
		opts.hdr = _G.select(2, ...) and _G.select(2, ...) or nil
		opts.bba = _G.select(3, ...) and _G.select(3, ...) or nil
		opts.ba = _G.select(4, ...) and _G.select(4, ...) or nil
		opts.fh = _G.select(5, ...) and _G.select(5, ...) or nil
		opts.bd = _G.select(6, ...) and _G.select(6, ...) or nil
	end
	__applySkin(opts)

end

function aObj:skinColHeads(buttonName, noCols, ftype)

	local btn
	noCols = noCols or 4
	for i = 1, noCols do
		btn = _G[buttonName .. i]
		if not btn.sb then -- only do if not already skinned as a button
			self:removeRegions(btn, {1, 2, 3})
			if btn ~= _G.WhoFrameColumnHeader2 then -- N.B. this is really a dropdown
				self:skinObject("frame", {obj=btn, fType=ftype, ofs=0})
			end
		end
	end

end

local function __skinDropDown(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		noSkin = don't skin the DropDown
		x1 = X offset for LEFT
		y1 = Y offset for TOP
		x2 = X offset for RIGHT
		y2 = Y offset for BOTTOM
		rp = re-parent, reverse the parent child relationship (addSkinFrame option)
		ign = ignore this dropdown when skinning IOF panels
		noBB = don't add a border around the button
		bx1 = adjust x1 offset for the button (used by Overachiever)
		lrg = Large UI template used (AuctionHouseUI)
		regs = regions to remove
--]]
	--@alpha@
	_G.assert(opts.obj, "Missing object __sDD\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	aObj:Debug2("__skinDropDown: [%s, %s]", opts.obj, opts.obj:GetName())

	--@debug@
	if opts.noMove
	or opts.moveTex
	or opts.mtx
	or opts.mty
	then
		aObj:CustomPrint(1, 0, 0, "skinDropDown: %s, deprecated option used", opts.obj)
	end
	--@end-debug@

	if aObj:hasAnyTextInName(opts.obj, {"tekKonfigDropdown", "Left"}) then -- ignore tekKonfigDropdown/Az DropDowns
		return
	end

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

	-- hide textures
	-- N.B. to make sure System Options Languages DropDown shows the language, use {1, 2, 3}
	aObj:removeRegions(opts.obj, opts.regs or {1, 2, 3})

	-- return if not to be skinned
	if not aObj.prdb.TabDDTextures.textureddd
	or opts.noSkin
	then
		return
	end

	-- add texture
	opts.obj.ddTex = opts.obj:CreateTexture(nil, "ARTWORK", -5) -- appear behind text
	opts.obj.ddTex:SetTexture(aObj.prdb.TabDDTextures.textureddd and aObj.itTex or nil)

	-- align it to the middle texture
	local lTex = opts.obj.Left or opts.obj.DLeft or _G[opts.obj:GetName() .. "Left"]
	local rTex = opts.obj.Right or opts.obj.DRight or _G[opts.obj:GetName() .. "Right"]
	if opts.lrg then
		opts.obj.ddTex:SetPoint("LEFT", lTex, "RIGHT", -11, 2)
		opts.obj.ddTex:SetPoint("RIGHT", rTex, "LEFT", -15, 0)
		opts.obj.ddTex:SetHeight(24)
	else
		opts.obj.ddTex:SetPoint("LEFT", lTex, "RIGHT", -5, 2)
		opts.obj.ddTex:SetPoint("RIGHT", rTex, "LEFT", 5, 2)
		opts.obj.ddTex:SetHeight(17)
	end

	opts.x1 = opts.x1 or 16
	opts.y1 = opts.y1 or -1
	opts.x2 = opts.x2 or -16
	opts.y2 = opts.y2 or 7
	aObj:addSkinFrame{obj=opts.obj, ft=opts.ftype or "a", aso={ng=true, bd=5}, rp=opts.rp, x1=opts.x1, y1=opts.y1, x2=opts.x2, y2=opts.y2}

	-- add a button border around the dd button
	if not opts.noBB then
		local btn = opts.obj.Button or opts.obj.dropButton or _G[opts.obj:GetName() .. "Button"]
		if opts.lrg then
			aObj:addButtonBorder{obj=btn, es=12, ofs=0}
		else
			local xOfs1 = opts.bx1 and opts.obj:GetWidth() + 10 or 1
			aObj:addButtonBorder{obj=btn, es=12, ofs=-2, x1=xOfs1}
		end
	end

	-- handle already disabled
	aObj:checkDisabledDD(opts.obj)

end
function aObj:skinDropDown(...) -- luacheck: ignore 212 (unused argument)

	local opts = _G.select(1, ...)

	--@alpha@
	_G.assert(opts, "Missing object sDD\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata" and _G.type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
		opts.moveTex = _G.select(2, ...) and _G.select(2, ...) or nil
		opts.noSkin = _G.select(3, ...) and _G.select(3, ...) or nil
		opts.noMove = _G.select(4, ...) and _G.select(4, ...) or nil
	end

	__skinDropDown(opts)

end

local function __skinEditBox(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		regs = regions to keep
		noSkin = don't skin the frame
		noHeight = don't change the height
		noWidth = don't change the width
		noInsert = don't change the Inserts
		move = move the edit box, left and up
		x = move the edit box left/right
		y = move the edit box up/down
		mi = move search icon/instructions to the right
		ign = ignore this editbox when skinning IOF panels
--]]
	--@alpha@
	_G.assert(opts.obj, "Missing object __sEB\n" .. _G.debugstack(2, 3, 2))
	_G.assert(opts.obj:IsObjectType("EditBox"), "Not an EditBox\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	aObj:Debug2("__skinEditBox: [%s, %s]", opts.obj, opts.obj:GetName())

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

	opts.x = opts.x or 0
	opts.y = opts.y or 0

	local kRegions = _G.CopyTable(aObj.ebRgns)
	if opts.regs then
		for i = 1, #opts.regs do
			aObj:add2Table(kRegions, opts.regs[i])
		end
	end
	aObj:keepRegions(opts.obj, kRegions)

	if not opts.noInsert then
		-- adjust the left & right text inserts
		local l, r, t, b = opts.obj:GetTextInsets()
		opts.obj:SetTextInsets(l + 5, r + 5, t, b)
	end

	-- change height, if required
	if not (opts.noHeight or opts.obj:IsMultiLine()) then opts.obj:SetHeight(24) end

	-- change width, if required
	if not opts.noWidth then opts.obj:SetWidth(opts.obj:GetWidth() + 8) end

	-- apply the backdrop
	if not opts.noSkin then aObj:skinUsingBD{obj=opts.obj} end

	-- move to the left & up, if required
	if opts.move then opts.x, opts.y = -2, 2 end

	-- move left/right & up/down, if required
	if opts.x ~= 0 or opts.y ~= 0 then aObj:moveObject{obj=opts.obj, x=opts.x or 0, y=opts.y or 0} end

	-- move the search icon/instructions to the right, if required
	if opts.mi then
		local xOfs = 6
		if opts.obj.searchIcon then
			aObj:moveObject{obj=opts.obj.searchIcon, x=xOfs} -- e.g. BagItemSearchBox
		elseif opts.obj.icon then
			aObj:moveObject{obj=opts.obj.icon, x=xOfs} -- e.g. FriendsFrameBroadcastInput
		elseif opts.obj:GetName()
		and _G[opts.obj:GetName() .. "SearchIcon"] then
			aObj:moveObject{obj=_G[opts.obj:GetName() .. "SearchIcon"], x=xOfs} -- e.g. TradeSkillFrameSearchBox
		else -- e.g. WeakAurasFilterInput
			for _, reg in _G.ipairs{opts.obj:GetRegions()} do
				if aObj:hasTextInTexture(reg, "UI-Searchbox-Icon") then
					aObj:moveObject{obj=reg, x=xOfs}
				end
			end
		end
		xOfs = 20
		if opts.obj.Instructions then -- e.g. InputBoxInstructionsTemplate (WoD)
			opts.obj.Instructions:ClearAllPoints()
			opts.obj.Instructions:SetPoint("LEFT", opts.obj, "LEFT", xOfs, 0)
		end
		if opts.obj.PromptText then -- e.g. BroadcastFrame EditBox (BfA)
			opts.obj.PromptText:ClearAllPoints()
			opts.obj.PromptText:SetPoint("LEFT", opts.obj, "LEFT", xOfs, 0)
		end
	end

end
function aObj:skinEditBox(...) -- luacheck: ignore 212 (unused argument)

	local opts = _G.select(1, ...)

	--@alpha@
	_G.assert(opts, "Missing object sEB\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata" and _G.type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
		opts.regs = _G.select(2, ...) and _G.select(2, ...) or {}
		opts.noSkin = _G.select(3, ...) and _G.select(3, ...) or nil
		opts.noHeight = _G.select(4, ...) and _G.select(4, ...) or nil
		opts.noWidth = _G.select(5, ...) and _G.select(5, ...) or nil
		opts.move = _G.select(6, ...) and _G.select(6, ...) or nil
	end

	__skinEditBox(opts)

end

function aObj:skinGlowBox(gBox, ftype)
	--@alpha@
	_G.assert(gBox, "Missing object __sGB\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	self:Debug2("skinGlowBox: [%s, %s]", gBox, ftype)

	local function removeArrowGlowTex(glowBox)
		if glowBox.Glow then
			glowBox.Glow:SetTexture(nil)
		elseif glowBox.Arrow
		and glowBox.Arrow.Glow then
			glowBox.Arrow.Glow:SetTexture(nil)
		elseif glowBox.ArrowGlow then
			glowBox.ArrowGlow:SetTexture(nil)
		end
	end
	removeArrowGlowTex(gBox)
	gBox:DisableDrawLayer("BACKGROUND")
	self:skinObject("frame", {obj=gBox, fType=ftype, ofs=-1, clr="gold"})
	local btn = gBox.CloseButton or gBox:GetName() and _G[gBox:GetName() .. "CloseButton"]
	if btn
	and self.modBtns
	then
		self:skinCloseButton{obj=gBox.CloseButton or gBox:GetName() and _G[gBox:GetName() .. "CloseButton"], noSkin=true}
	end

end

local function __skinMoneyFrame(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		regs = regions to keep
		moveGIcon = move Gold Icon
		noWidth = don't change the width
		moveSEB = move the Silver edit box left
		moveGEB = move the Gold edit box left
--]]
	--@alpha@
	_G.assert(opts.obj, "Missing object __sMF\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	aObj:Debug2("__skinMoneyFrame: [%s, %s]", opts.obj, opts.obj:GetName())

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

	local obj
	for key, type in _G.pairs{"Gold", "Silver", "Copper"} do
		obj = _G[opts.obj:GetName() .. type]
		aObj:skinObject("editbox", {obj=obj})
		-- move label to the right for colourblind mode
		if key ~= 1 or opts.moveGIcon then
			aObj:moveObject{obj=obj.texture, x=10}
			aObj:moveObject{obj=obj.label, x=10}
		end
		if not opts.noWidth and key ~= 1 then
			aObj:adjWidth{obj=obj, adj=5}
		end
		if type == "Gold" and opts.moveGEB then
			aObj:moveObject{obj=obj, x=-8}
		end
		if type == "Silver" and opts.moveSEB then
			aObj:moveObject{obj=obj, x=-10}
		end
	end

end
function aObj:skinMoneyFrame(...) -- luacheck: ignore 212 (unused argument)

	local opts = _G.select(1, ...)

	--@alpha@
	_G.assert(opts, "Missing object sMF\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata" and _G.type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
		opts.moveGIcon = _G.select(2, ...) and _G.select(2, ...) or nil
		opts.noWidth = _G.select(3, ...) and _G.select(3, ...) or nil
		opts.moveSEB = _G.select(4, ...) and _G.select(4, ...) or nil
		opts.moveGEB = _G.select(5, ...) and _G.select(5, ...) or nil
	end

	__skinMoneyFrame(opts)

end

local function __skinScrollBar(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		sbPrefix = Prefix to use
		sbObj = ScrollBar object to use
		size = backdrop size to use (2 - wide, 3 - medium, 4 - narrow)
		noRR = Don't remove regions
--]]
	--@alpha@
	_G.assert(opts.obj, "Missing object __sSB\n" .. _G.debugstack(2, 3, 2))
	_G.assert(opts.obj:IsObjectType("Frame"), "Not a ScrollFrame\n" .. _G.debugstack(2, 3, 2))
	_G.assert(_G[opts.obj:GetName() .. "ScrollBar"]:IsObjectType("Slider"), "Not a Slider\n" .. _G.debugstack(2, 3, 2))
	-- handle AddOn skins still using this code rather than skinSlider
	aObj:CustomPrint(1, 0, 0, "Using deprecated function - skinScrollBar, use skinSlider instead", opts.obj)
		--@end-alpha@

	aObj:Debug2("__skinScrollBar: [%s, %s]", opts.obj, opts.obj:GetName())

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

	-- remove all the object's regions except text ones, if required
	if not opts.noRR then aObj:keepFontStrings(opts.obj) end

	-- skin it
	aObj:skinUsingBD{obj=_G[opts.obj:GetName() .. "ScrollBar"], size=opts.size}

end
function aObj:skinScrollBar(...) -- luacheck: ignore 212 (unused argument)

	local opts = _G.select(1, ...)

	--@alpha@
	_G.assert(opts, "Missing object sSB\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata" and _G.type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
		-- opts.sbPrefix = _G.select(2, ...) and _G.select(2, ...) or nil
		-- opts.sbObj = _G.select(3, ...) and _G.select(3, ...) or nil
		opts.size = _G.select(4, ...) and _G.select(4, ...) or 2
	end

	__skinScrollBar(opts)

end

local function __skinSlider(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		size = backdrop size to use (2 - wide, 3 - medium, 4 - narrow) [default is 3]
		-- adj = width reduction required ()
		wdth = width reduction required
		hgt = height reduction required
		rt = remove textures from parent
--]]
	--@alpha@
	_G.assert(opts.obj, "Missing object __sS\n" .. _G.debugstack(2, 3, 2))
	_G.assert(opts.obj:IsObjectType("Slider"), "Not a Slider\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	aObj:Debug2("__skinSlider: [%s, %s]", opts.obj, opts.obj:GetName())

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

	-- remove textures if required
	aObj:keepFontStrings(opts.obj)
	-- make objects visible
	opts.obj:SetAlpha(1)
	opts.obj:GetThumbTexture():SetAlpha(1)

	aObj:skinUsingBD{obj=opts.obj, size=opts.size}

	-- adjust width if required
	if opts.wdth then
		aObj:adjWidth{obj=opts.obj, adj=opts.wdth}
	end
	-- adjust height if required (horizontal orientation)
	if opts.hgt then
		aObj:adjHeight{obj=opts.obj, adj=opts.hgt}
	end

	-- remove parent's textures if required
	if opts.rt then
		if _G.type(opts.rt) == "table" then
			for i = 1, #opts.rt do
				opts.obj:GetParent():DisableDrawLayer(opts.rt[i])
			end
		else
			opts.obj:GetParent():DisableDrawLayer(opts.rt)
		end
	end

end
function aObj:skinSlider(...) -- luacheck: ignore 212 (unused argument)

	local opts = _G.select(1, ...)

	--@alpha@
	_G.assert(opts, "Missing object sS\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata" and _G.type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
		opts.size = _G.select(2, ...) and _G.select(2, ...) or 2
	end

	-- handle change of parameter name: adj -> wdth
	if opts.adj then
		opts.wdth = opts.adj
		opts.adj = nil
	end

	__skinSlider(opts)

end

local function __skinStatusBar(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		fi = frame inset
		bgTex = existing background texture
		otherTex = other Textures table
		nilFuncs = nop Atlas funcs
--]]
	--@alpha@
	_G.assert(opts.obj, "Missing object __sSB\n" .. _G.debugstack(2, 3, 2))
	_G.assert(opts.obj:IsObjectType("StatusBar"), "Not a StatusBar\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	aObj:Debug2("__skinStatusBar: [%s, %s]", opts.obj, opts.obj:GetName())

	opts.obj:SetStatusBarTexture(aObj.sbTexture)
	if opts.nilFuncs then
		opts.obj.SetStatusBarTexture = _G.nop
		opts.obj.SetStatusBarAtlas = _G.nop
	end

	-- don't skin it twice
	if not aObj.sbGlazed[opts.obj] then
		aObj.sbGlazed[opts.obj] = {}
	else
		return
	end
	local sbG = aObj.sbGlazed[opts.obj]

	if opts.fi then
		if not sbG.bg then
			-- create background texture on a lower sublevel
			sbG.bg = opts.bgTex or opts.obj:CreateTexture(nil, "BACKGROUND", nil, -1)
			sbG.bg:SetTexture(aObj.sbTexture)
			sbG.bg:SetVertexColor(aObj.sbClr:GetRGBA())
			if not opts.bgTex then
				sbG.bg:SetAllPoints()
			else
				if opts.nilFuncs then
					sbG.bg.SetTexture = _G.nop
					sbG.bg.SetAtlas = _G.nop
				end
			end
		end
	end

	-- apply texture to and store other texture objects
	if opts.otherTex
	and _G.type(opts.otherTex) == "table"
	then
		local tex
		for i = 1, #opts.otherTex do
			tex = opts.otherTex[i]
			tex:SetTexture(aObj.sbTexture)
			tex:SetVertexColor(aObj.sbClr:GetRGBA())
			sbG[#sbG + 1] = tex
			if opts.nilFuncs then
				tex.SetTexture = _G.nop
				tex.SetAtlas = _G.nop
			end
		end
	end

end
function aObj:skinStatusBar(...) -- luacheck: ignore 212 (unused argument)

	local opts = _G.select(1, ...)

	--@alpha@
	_G.assert(opts, "Missing object gSB\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata" and _G.type(opts.GetObjectType) == "function" then
	--@alpha@
		-- handle AddOn skins still using this code rather than skinSlider
		aObj:CustomPrint(1, 0, 0, "Using old style call - skinStatusBar", _G.select(1, ...), _G.debugstack(2, 3, 2))
	--@end-alpha@
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
		opts.fi = _G.select(2, ...) and _G.select(2, ...) or nil
		opts.bgTex = _G.select(3, ...) and _G.select(3, ...) or nil
		opts.otherTex = _G.select(4, ...) and _G.select(4, ...) or nil
		opts.hookFunc = _G.select(5, ...) and _G.select(5, ...) or nil
	end

	__skinStatusBar(opts)

end
-- previous name for the above function (statusBar, fi, bgTex, otherTex, hookFunc)
function aObj:glazeStatusBar(...)
	--@alpha@
	-- handle AddOn skins still using this code rather than skinStatusBar
	aObj:CustomPrint(1, 0, 0, "Using deprecated function - glazeStatusBar, use skinStatusBar instead", _G.select(1, ...),  _G.debugstack(2, 3, 2))
		--@end-alpha@

	self:skinStatusBar(...)

end
local function __skinTabs(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		name = tab name
		suffix = tab name suffix
		regs = regions to keep
		ignore = ignore size changes
		up = tabs grow upwards
		lod = LoD, requires textures to be set 1st time through
		bg = put in background so highlight is visible (e.g. Garrison LandingPage)
		x1 = X offset for TOPLEFT
		y1 = Y offset for TOPLEFT
		x2 = X offset for BOTTOMRIGHT
		y2 = Y offset for BOTTOMRIGHT
		ignht = don't change Highlight texture (AchievementUI)
		nc = don't check to see if already skinned
--]]
	--@alpha@
	_G.assert(opts.obj, "Missing object __sT\n" .. _G.debugstack(2, 3, 2))
	_G.assert(opts.obj:IsObjectType("Frame"), "Not a Frame\n" .. _G.debugstack(2, 3, 2))
	-- handle AddOn skins still using this code rather than using a template
	aObj:CustomPrint(1, 0, 0, "Using deprecated function - skinTabs without a Template", opts.obj)
		--@end-alpha@

	aObj:Debug2("__skinTabs: [%s, %s]", opts.obj, opts.obj:GetName())

	-- don't skin it twice unless required (Ace3)
	if not opts.nc
	and opts.obj.sknd
	then
		return
	else
		opts.obj.sknd = true
	end

	-- use supplied name or existing name (Ace3 TabGroup fix)
	local tabName = opts.name or opts.obj:GetName()
	tabName =  tabName .. "Tab" .. (opts.suffix or "")

	local kRegions = {7, 8} -- N.B. region 7 is text, 8 is highlight for some tabs
	if opts.regs then
		for i = 1, #opts.regs do
			aObj:add2Table(kRegions, opts.regs[i])
		end
	end

	local xOfs1 = opts.x1 or 6
	local yOfs1 = opts.y1 or 0
	local xOfs2 = opts.x2 or -6
	local yOfs2 = opts.y2 or 2

	local tabID, tab = opts.obj.selectedTab or 1
	for i = 1, opts.obj.numTabs do
		tab = _G[tabName .. i]
		aObj:keepRegions(tab, kRegions)
		-- CHANGED: ft ... or "a" is used to stop buttons being skinned automatically
		aObj:addSkinFrame{obj=tab, ft=opts.ftype or "a", noBdr=aObj.isTT, bg=opts.bg or false, x1=xOfs1, y1=yOfs1, x2=xOfs2, y2=yOfs2}
		tab.sf.ignore = opts.ignore -- ignore size changes
		tab.sf.up = opts.up -- tabs grow upwards
		if opts.lod then -- set textures here first time thru as it's LoD
			if aObj.isTT then
				if i == tabID then
					aObj:setActiveTab(tab.sf)
				else
					aObj:setInactiveTab(tab.sf)
				end
			end
		end
		if not opts.ignht then
			-- change highlight texture
			local ht = tab:GetHighlightTexture()
			if ht then -- handle other AddOns using tabs without a highlight texture
				ht:SetTexture(aObj.tFDIDs.ctabHL)
				ht:ClearAllPoints()
				if opts.up then -- (GuildInfoFrame, LookingForGuild, MacroFrame, FriendsTabHeader)
					ht:SetPoint("TOPLEFT", 1, -5)
					ht:SetPoint("BOTTOMRIGHT", -1, -5)
				else
					ht:SetPoint("TOPLEFT", 8, 2)
					ht:SetPoint("BOTTOMRIGHT", -8, 0)
				end
			end
		end
	end
	aObj.tabFrames[opts.obj] = true

end
function aObj:skinTabs(...) -- luacheck: ignore 212 (unused argument)

	local opts = _G.select(1, ...)

	--@alpha@
	_G.assert(opts, "Missing object sT\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata" and _G.type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
	end

	__skinTabs(opts)

end

function aObj:skinToggleTabs(tabName, tabCnt, noHeight)

	local togTab
	for i = 1, tabCnt or 3 do
		togTab = _G[tabName .. i]
		if not togTab then break end -- handle missing Tabs (e.g. Muted)
		if not togTab.sknd then -- don't skin it twice
			self:keepRegions(togTab, {7, 8}) -- N.B. regions 7 & 8 are text & highlight
			if not noHeight then self:adjHeight{obj=togTab, adj=-5}	end
			-- CHANGED: ft="a" is used to stop buttons being skinned automatically
			self:addSkinFrame{obj=togTab, ft="a", y1=-2, x2=2, y2=-2}
		end
	end

end

function aObj:skinTooltip(tooltip)
	if not self.prdb.Tooltips.skin then return end
	--@alpha@
	_G.assert(tooltip, "Missing object skinTooltip\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	aObj:Debug2("skinTooltip: [%s, %s, %s]", tooltip, tooltip.GetName and tooltip:GetName() or "<ANON>", tooltip.sf)

	if not tooltip then return end

	if not tooltip.sf then
		-- Bugfix for ElvUI
		local ttSB
		if self:isAddOnLoaded("ElvUI") then
			ttSB = tooltip.SetBackdrop
			tooltip.SetBackdrop = _G.nop
		end
		self:skinObject("frame", {obj=tooltip, fType=tooltip.ftype, kfs=true, rns=true, ng=true, ofs=tooltip.ofs or 0})
		if self:isAddOnLoaded("ElvUI") then
			tooltip.SetBackdrop = ttSB
		end
	end

	-- colour the Border
	tooltip.sf:SetBackdropBorderColor(aObj.tbClr:GetRGBA())

	if aObj.isClscERA then
		local kid1 = self:getChild(tooltip, 1)
		if kid1:GetNumRegions() == 9 then
			self:removeNineSlice(kid1)
		end
	else
		if tooltip.TopLeftCorner then
			self:removeNineSlice(tooltip)
		end
	end

	self:applyTooltipGradient(tooltip.sf)

end

local function __skinUsingBD(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		size = backdrop size to use (2 - wide, 3 - medium, 4 - narrow)
--]]
	--@alpha@
	_G.assert(opts.obj, "Missing object __sUBD\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	opts.size = opts.size or 3 -- default to medium

	aObj:addBackdrop(opts.obj)
	opts.obj:SetBackdrop(aObj.Backdrop[opts.size])
	opts.obj:SetBackdropColor(.1, .1, .1, 1)
	opts.obj:SetBackdropBorderColor(aObj.prdb.SliderBorder:GetRGBA())

end
function aObj:skinUsingBD(...) -- luacheck: ignore 212 (unused argument)

	local opts = _G.select(1, ...)

	--@alpha@
	_G.assert(opts, "Missing object sUBD\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata" and _G.type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
		opts.size = _G.select(2, ...) and _G.select(2, ...) or 3
	end

	__skinUsingBD(opts)

end

function aObj:skinUsingBD2(obj)

	self:skinUsingBD{obj=obj, size=2}

end

--@end-non-debug@]===]
