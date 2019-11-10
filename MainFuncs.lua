local aName, aObj = ...

local _G = _G

local assert, debugstack, ipairs, pairs, rawget, select, type, Round = _G.assert, _G.debugstack, _G.ipairs, _G.pairs, _G.rawget, _G.select, _G.type, _G.Round

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
		sec = use the "SecureUnitButtonTemplate"
		sab = use the "SecureActionButtonTemplate"
		nohooks = don't hook methods
--]]
--@alpha@
	assert(opts.obj, "Missing object __aSB\n" .. debugstack(2, 3, 2))
--@end-alpha@

	aObj:Debug2("__addSkinButton: [%s, %s]", opts.obj, opts.obj:GetName())

	-- don't skin it twice
	if opts.obj.sb then return end

	-- remove the object's Backdrop if it has one
	if opts.obj.GetBackdrop and opts.obj:GetBackdrop() then opts.obj:SetBackdrop(nil) end

	-- make all textures transparent, if required
	if opts.kfs then aObj:keepFontStrings(opts.obj) end

	opts.parent = opts.parent or opts.obj:GetParent()

	-- store button object within original button
	opts.obj.sb = _G.CreateFrame("Button", nil, opts.parent, opts.sec and "SecureUnitButtonTemplate" or opts.sab and "SecureActionButtonTemplate" or nil)
	local btn = opts.obj.sb
	_G.LowerFrameLevel(btn)
	btn:EnableMouse(false) -- allow clickthrough

	if not opts.nohooks then
		opts.hook = opts.hook or opts.obj
		-- hook Show/Hide methods
        -- changed to hook scripts as functions don't always work
		aObj:hookScript(opts.hook, "OnShow", function(this)
			if _G.InCombatLockdown()
			and (opts.sec
			or opts.sab)
			then
				aObj:add2Table(aObj.oocTab, {this.sb.Show, {this}})
				return
			end
			opts.obj.sb:Show()
		end)
		aObj:hookScript(opts.hook, "OnHide", function(this)
			if _G.InCombatLockdown()
			and (opts.sec
			or opts.sab)
			then
				aObj:add2Table(aObj.oocTab, {this.sb.Hide, {this}})
				return
			end
			opts.obj.sb:Hide()
		end)
		if opts.obj:IsObjectType("Button") then -- hook Enable/Disable methods
			aObj:secureHook(opts.hook, "Enable", function(this) opts.obj.sb:Enable() end)
			aObj:secureHook(opts.hook, "Disable", function(this) opts.obj.sb:Disable() end)
		end
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

	-- hide button skin, if required or not shown
	btn:SetShown(opts.obj:IsShown() and not opts.hide)

	 -- make sure it's lower than its parent's Frame Strata
	if opts.bg then btn:SetFrameStrata("BACKGROUND") end

	-- change the draw layer of the Icon and Count, if necessary
	if opts.obj.GetNumRegions then
		local regOT
		for _, reg in ipairs{opts.obj:GetRegions()} do
			regOT = reg:GetObjectType()
			if regOT == "Texture" or regOT == "FontString" then
				-- change the DrawLayer to make the Icon show if required
				if aObj:hasAnyTextInName(reg, {"[Ii]con", "[Cc]ount"})
				or aObj:hasTextInTexture(reg, "[Ii]con") then
					if reg:GetDrawLayer() == "BACKGROUND" then reg:SetDrawLayer("ARTWORK") end
				end
			end
		end
		regOT = nil
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

	btn = nil
	return opts.obj.sb

end
function aObj:addSkinButton(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object aSB\n" .. debugstack(2, 3, 2))
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.parent = select(2, ...) and select(2, ...) or nil
		opts.hook = select(3, ...) and select(3, ...) or nil
		opts.hide = select(4, ...) and select(4, ...) or nil
	end
	-- new style call
	return __addSkinButton(opts)

end

local function hideHeader(obj)

	-- hide the Header Texture and move the Header text, if required
	local hdr
	for _, suff in pairs{"Header", "_Header", "_HeaderBox", "_FrameHeader", "FrameHeader", "HeaderTexture", "HeaderFrame"} do
		if _G[obj:GetName() .. suff] then
			_G[obj:GetName() .. suff]:Hide()
			_G[obj:GetName() .. suff]:SetPoint("TOP", obj, "TOP", 0, 7)
			break
		end
	end
	if obj.header then
		obj.header:DisableDrawLayer("BACKGROUND")
		obj.header:DisableDrawLayer("BORDER")
		aObj:moveObject{obj=obj.header.text, y=-6}
	end
	if aObj.isPTR then
		if obj.Header then
			aObj:removeRegions(obj.Header, {1, 2, 3})
			aObj:moveObject{obj=obj.Header.Text, y=-6}
		end
	end

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
	assert(opts.obj, "Missing object __aSF\n" .. debugstack(2, 3, 2))
	-- CHANGED: show AddOn skins still using skinAllButtons
	if not opts.ft and not opts.nb then
		aObj:CustomPrint(1, 0, 0, "Not using nb=true", opts.obj)
		if not opts.obj:GetName() then _G.print("No Name supplied __aSF\n", debugstack(2, 3, 2)) end
	end
	-- FIXME: use ft="a" when AddOn skin has been changed to manually skin buttons
--@end-alpha@

	aObj:Debug2("__addSkinFrame: [%s, %s]", opts.obj, opts.obj.GetName and opts.obj:GetName() or "<Anon>")

	-- don't skin it twice
	if opts.obj.sf then return end

	-- remove the object's Backdrop if it has one
	if opts.obj.GetBackdrop and opts.obj:GetBackdrop() then opts.obj:SetBackdrop(nil) end

	-- store frame obj, if required
	if opts.ft then aObj:add2Table(aObj.gradFrames[opts.ft], opts.obj) end

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
		for _, reg in ipairs{opts.obj:GetRegions()} do
			if not reg:IsObjectType("FontString") then
				reg:SetTexture(nil)
			end
		end
	end

	-- setup defaults used by majority of frames
	if not opts.ofs then
		opts.x1 = opts.x1 or -3
		opts.y1 = opts.y1 or 2
		opts.x2 = opts.x2 or 3
		opts.y2 = opts.y2 or -2
	end
	-- setup offset values
	opts.ofs = opts.ofs or 0
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
	local success, err = _G.pcall(_G.LowerFrameLevel, skinFrame) -- catch any error, doesn't matter if already 0
	if not success then _G.RaiseFrameLevel(opts.obj) end -- raise parent's Frame Level if 0
	success, err = nil, nil

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
				cBtn = nil
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

	skinFrame = nil
	return opts.obj.sf

end
function aObj:addSkinFrame(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object aSF\n" .. debugstack(2, 3, 2))
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.x1 = select(2, ...) and select(2, ...) or -3
		opts.y1 = select(3, ...) and select(3, ...) or 3
		opts.x2 = select(4, ...) and select(4, ...) or 3
		opts.y2 = select(5, ...) and select(5, ...) or -3
		opts.ft = select(6, ...) and select(6, ...) or nil
		opts.noBdr = select(7, ...) and select(7, ...) or nil
	end

	return __addSkinFrame(opts)

end

function aObj:applyGradient(obj, fh, invert, rotate)

	-- don't apply a gradient if required
	if not self.prdb.Gradient.char then
		for i = 1, #self.gradFrames["p"] do
			if self.gradFrames["p"][i] == obj then return end
		end
	end
	if not self.prdb.Gradient.ui then
		for i = 1, #self.gradFrames["u"] do
			if self.gradFrames["u"][i] == obj then return end
		end
	end
	if not self.prdb.Gradient.npc then
		for i = 1, #self.gradFrames["n"] do
			if self.gradFrames["n"][i] == obj then return end
		end
	end
	if not self.prdb.Gradient.skinner then
		for i = 1, #self.gradFrames["s"] do
			if self.gradFrames["s"][i] == obj then return end
		end
	end

	invert = invert or self.prdb.Gradient.invert
	rotate = rotate or self.prdb.Gradient.rotate

	if not obj.tfade then
		obj.tfade = obj:CreateTexture(nil, "BORDER", nil, -1)
		obj.tfade:SetTexture(self.gradientTex)
		obj.tfade:SetBlendMode("ADD")
		obj.tfade:SetGradientAlpha(self:getGradientInfo(invert, rotate))
	end

	if self.prdb.FadeHeight.enable
	and (self.prdb.FadeHeight.force or not fh)
	and Round(obj:GetHeight()) ~= obj.hgt
	then
		-- set the Fade Height if not already passed to this function or 'forced'
		-- making sure that it isn't greater than the frame height
		obj.hgt = Round(obj:GetHeight())
		fh = self.prdb.FadeHeight.value <= obj.hgt and self.prdb.FadeHeight.value or obj.hgt
	end

	obj.tfade:ClearAllPoints()
	if not invert -- fade from top
	and not rotate
	then
		obj.tfade:SetPoint("TOPLEFT", obj, "TOPLEFT", 4, -4)
		if fh then
			obj.tfade:SetPoint("BOTTOMRIGHT", obj, "TOPRIGHT", -4, -(fh - 4))
		else
			obj.tfade:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", -4, 4)
		end
	elseif invert -- fade from bottom
	and not rotate
	then
		obj.tfade:SetPoint("BOTTOMLEFT", obj, "BOTTOMLEFT", 4, 4)
		if fh then
			obj.tfade:SetPoint("TOPRIGHT", obj, "BOTTOMRIGHT", -4, (fh - 4))
		else
			obj.tfade:SetPoint("TOPRIGHT", obj, "TOPRIGHT", -4, -4)
		end
	elseif not invert -- fade from right
	and rotate
	then
		obj.tfade:SetPoint("TOPRIGHT", obj, "TOPRIGHT", -4, -4)
		if fh then
			obj.tfade:SetPoint("BOTTOMLEFT", obj, "BOTTOMRIGHT", -(fh - 4), 4)
		else
			obj.tfade:SetPoint("BOTTOMLEFT", obj, "BOTTOMLEFT", 4, 4)
		end
	elseif invert -- fade from left
	and rotate
	then
		obj.tfade:SetPoint("TOPLEFT", obj, "TOPLEFT", 4, -4)
		if fh then
			obj.tfade:SetPoint("BOTTOMRIGHT", obj, "BOTTOMLEFT", fh - 4, 4)
		else
			obj.tfade:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", -4, 4)
		end
	end

end

function aObj:applyTexture(obj)

	obj.tbg = obj:CreateTexture(nil, "BORDER")
	obj.tbg:SetTexture(self.LSM:Fetch("background", self.bgTexName), true) -- have to use true for tiling to work
	obj.tbg:SetBlendMode("ADD") -- use existing frame alpha setting
	-- allow for border inset
	obj.tbg:SetPoint("TOPLEFT", obj, "TOPLEFT", self.prdb.BdInset, -self.prdb.BdInset)
	obj.tbg:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", -self.prdb.BdInset, self.prdb.BdInset)
	-- the texture will be stretched if the following tiling methods are set to false
	obj.tbg:SetHorizTile(self.prdb.BgTile)
	obj.tbg:SetVertTile(self.prdb.BgTile)

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
--]]
--@alpha@
	assert(opts.obj, "Missing object __aS\n" .. debugstack(2, 3, 2))
--@end-alpha@

	aObj:Debug2("__applySkin: [%s, %s]", opts.obj, opts.obj:GetName())

	local hasIOT = assert(opts.obj.IsObjectType, "The Object passed isn't a Frame") -- throw an error here to get its original location reported
	if hasIOT and not opts.obj:IsObjectType("Frame") then
		if aObj.prdb.Errors then
			aObj:CustomPrint(1, 0, 0, "Error skinning", opts.obj.GetName and opts.obj:GetName() or opts.obj, "not a Frame or subclass of Frame:", opts.obj:GetObjectType())
			return
		end
	end
	hasIOT = nil

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

	-- store frame obj, if required
	if opts.ft then aObj:add2Table(aObj.gradFrames[opts.ft], opts.obj) end

	-- make all textures transparent, if required
	if opts.kfs then aObj:keepFontStrings(opts.obj) end

	-- setup the backdrop
	opts.obj:SetBackdrop(aObj.Backdrop[opts.bd or 1])
	if not opts.ebc then
		-- colour the backdrop as required
		local r, g, b, a = aObj.bClr:GetRGBA()
		opts.obj:SetBackdropColor(r, g, b, opts.ba or a)
		if opts.bbclr then
			r, g, b, a = aObj:getColourByName(opts.bbclr)
		else
			r, g, b, a = aObj.bbClr:GetRGBA()
		end
		opts.obj:SetBackdropBorderColor(r, g, b, opts.bba or a)
		r, g, b, a = nil, nil ,nil ,nil
	else
		opts.obj:SetBackdropColor(.1, .1, .1, 1)
		opts.obj:SetBackdropBorderColor(.2, .2, .2, 1)
	end

	-- fix for backdrop textures not tiling vertically
	-- using info from here: http://boss.wowinterface.com/forums/showthread.php?p=185868
	if aObj.prdb.BgUseTex then
		if not opts.obj.tbg then aObj:applyTexture(opts.obj) end
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
function aObj:applySkin(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object aS\n" .. debugstack(2, 3, 2))
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.hdr = select(2, ...) and select(2, ...) or nil
		opts.bba = select(3, ...) and select(3, ...) or nil
		opts.ba = select(4, ...) and select(4, ...) or nil
		opts.fh = select(5, ...) and select(5, ...) or nil
		opts.bd = select(6, ...) and select(6, ...) or nil
	end
	__applySkin(opts)
	opts = nil

end

function aObj:skinColHeads(buttonName, noCols, ftype)

	local btn
	noCols = noCols or 4
	for i = 1, noCols do
		btn = _G[buttonName .. i]
		if not btn.sb then -- only do if not already skinned as a button
			self:removeRegions(btn, {1, 2, 3})
			-- CHANGED: ft="a" is used to stop buttons being skinned automatically
			self:addSkinFrame{obj=btn, ft=ftype or "a", nb=true, ofs=1}
		end
	end
	btn = nil

end

local function __skinDropDown(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		noSkin = don't skin the DropDown
		x1 = X offset for TOPLEFT
		y1 = Y offset for TOPLEFT
		x2 = X offset for BOTTOMRIGHT
		y2 = Y offset for BOTTOMRIGHT
		rp = re-parent, reverse the parent child relationship (addSkinFrame option)
		ign = ignore this dropdown when skinning IOF panels
		noBB = don't add a border around the button
		bx1 = adjust x1 offset for the button (used by Overachiever)
		lrg = Large UI template used (AuctionHouseUI)
--]]
--@alpha@
	assert(opts.obj, "Missing object __sDD\n" .. debugstack(2, 3, 2))
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

	if aObj:hasAnyTextInName(opts.obj, {"tekKonfigDropdown", "Left"}) -- ignore tekKonfigDropdown/Az DropDowns
	and not opts.obj.LeftTexture -- handle MC2UIElementsLib ones (used by GroupCalendar5)
	then
		return
	end

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

	-- hide textures
	aObj:removeRegions(opts.obj, {1, 2, 3})

	-- return if not to be skinned
	if not aObj.prdb.TexturedDD
	and not aObj.prdb.DropDownButtons
	or opts.noSkin
	then
		return
	end

	-- add texture
	opts.obj.ddTex = opts.obj:CreateTexture(nil, "ARTWORK", -5) -- appear behind text
	opts.obj.ddTex:SetTexture(aObj.prdb.TexturedDD and aObj.itTex or nil)
	-- align it to the middle texture
	if opts.lrg then
		opts.obj.ddTex:SetPoint("LEFT", opts.obj.Left or _G[opts.obj:GetName() .. "Left"], "RIGHT", -11, 2)
		opts.obj.ddTex:SetPoint("RIGHT", opts.obj.Right or _G[opts.obj:GetName() .. "Right"], "LEFT", -15, 0)
		opts.obj.ddTex:SetHeight(24)
	else
		opts.obj.ddTex:SetPoint("LEFT", opts.obj.Left or _G[opts.obj:GetName() .. "Left"], "RIGHT", -5, 2)
		opts.obj.ddTex:SetPoint("RIGHT", opts.obj.Right or _G[opts.obj:GetName() .. "Right"], "LEFT", 5, 2)
		opts.obj.ddTex:SetHeight(17)
	end

	local xOfs1 = opts.x1 or 16
	local yOfs1 = opts.y1 or -1
	local xOfs2 = opts.x2 or -16
	local yOfs2 = opts.y2 or 7
	-- skin the frame
	if aObj.prdb.DropDownButtons then
		-- CHANGED: ft ... or "a" is used to stop buttons being skinned automatically
		aObj:addSkinFrame{obj=opts.obj, ft=opts.ftype or "a", aso={ng=true, bd=5}, rp=opts.rp, x1=xOfs1, y1=yOfs1, x2=xOfs2, y2=yOfs2}
	end
	-- add a button border around the dd button
	if not opts.noBB then
		if opts.lrg then
			aObj:addButtonBorder{obj=opts.obj.Button, es=12, ofs=0}
		else
			xOfs1 = opts.bx1 and opts.obj:GetWidth() + 10 or 1
			aObj:addButtonBorder{obj=opts.obj.Button or _G[opts.obj:GetName() .. "Button"], es=12, ofs=-2, x1=xOfs1}
		end
	end

	xOfs1, yOfs1, xOfs2, yOfs2 = nil, nil, nil, nil

end
function aObj:skinDropDown(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sDD\n" .. debugstack(2, 3, 2))
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.moveTex = select(2, ...) and select(2, ...) or nil
		opts.noSkin = select(3, ...) and select(3, ...) or nil
		opts.noMove = select(4, ...) and select(4, ...) or nil
	end

	__skinDropDown(opts)
	opts = nil

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
	assert(opts.obj, "Missing object __sEB\n" .. debugstack(2, 3, 2))
	assert(opts.obj:IsObjectType("EditBox"), "Not an EditBox\n" .. debugstack(2, 3, 2))
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
	kRegions = nil

	if not opts.noInsert then
		-- adjust the left & right text inserts
		local l, r, t, b = opts.obj:GetTextInsets()
		opts.obj:SetTextInsets(l + 5, r + 5, t, b)
		l, r, t, b = nil, nil, nil, nil
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

	-- move the search icon to the right, if required
	if opts.mi then
		if opts.obj.searchIcon then
			aObj:moveObject{obj=opts.obj.searchIcon, x=4} -- e.g. BagItemSearchBox
		elseif opts.obj.Instructions then -- e.g. InputBoxInstructionsTemplate (WoD)
			opts.obj.Instructions:ClearAllPoints()
			opts.obj.Instructions:SetPoint("Left", opts.obj, "Left", 6, 0)
		elseif opts.obj.PromptText then -- e.g. BroadcastFrame EditBox (BfA)
			opts.obj.PromptText:ClearAllPoints()
			opts.obj.PromptText:SetPoint("Left", opts.obj, "Left", 6, 0)
		elseif opts.obj.icon then
			aObj:moveObject{obj=opts.obj.icon, x=4} -- e.g. FriendsFrameBroadcastInput
		elseif _G[opts.obj:GetName() .. "SearchIcon"] then
			aObj:moveObject{obj=_G[opts.obj:GetName() .. "SearchIcon"], x=4} -- e.g. TradeSkillFrameSearchBox
		else -- e.g. WeakAurasFilterInput
			for _, reg in ipairs{opts.obj:GetRegions()} do
				if aObj:hasTextInTexture(reg, "UI-Searchbox-Icon", true) then
					aObj:moveObject{obj=reg, x=4}
				end
			end
		end
	end

end
function aObj:skinEditBox(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sEB\n" .. debugstack(2, 3, 2))
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.regs = select(2, ...) and select(2, ...) or {}
		opts.noSkin = select(3, ...) and select(3, ...) or nil
		opts.noHeight = select(4, ...) and select(4, ...) or nil
		opts.noWidth = select(5, ...) and select(5, ...) or nil
		opts.move = select(6, ...) and select(6, ...) or nil
	end

	__skinEditBox(opts)
	opts = nil

end

function aObj:skinGlowBox(gBox, ftype, ncb)
--@alpha@
	assert(gBox, "Missing object __sGB\n" .. debugstack(2, 3, 2))
--@end-alpha@

	aObj:Debug2("skinGlowBox: [%s, %s, %s]", gBox, ftype, ncb)


	local function findArrowGlowTex(gBox)
		-- aObj:Debug("findArrowGlowTex: [%s, %s]", gBox:GetNumChildren(), gBox:GetNumRegions())
		if gBox.Glow then
			gBox.Glow:SetTexture(nil)
		elseif gBox.Arrow
		and gBox.Arrow.Glow then
			gBox.Arrow.Glow:SetTexture(nil)
		elseif gBox.ArrowGlow then
			gBox.ArrowGlow:SetTexture(nil)
		elseif gBox.ArrowGlowUp then
			gBox.ArrowGlowUp:SetTexture(nil)
		elseif gBox.ArrowGlowDown then
			gBox.ArrowGlowDown:SetTexture(nil)
		elseif gBox.ArrowGlowLeft then
			gBox.ArrowGlowLeft:SetTexture(nil)
		elseif gBox.ArrowGlowRight then
			gBox.ArrowGlowRight:SetTexture(nil)
		end
	end

	findArrowGlowTex(gBox)
	gBox:DisableDrawLayer("BACKGROUND")
	if self.modBtns
	and not ncb
	and gBox:GetNumChildren() > 0 -- don't check after adding skin frames otherwise it fails
	then
		self:skinCloseButton{obj=gBox.CloseButton or _G[gBox:GetName() .. "CloseButton"], noSkin=true}
	end
	self:addSkinFrame{obj=gBox, ft=ftype, nb=true}
	gBox.sf:SetBackdropBorderColor(1, 0.82, 0)

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
	assert(opts.obj, "Missing object __sMF\n" .. debugstack(2, 3, 2))
--@end-alpha@

	aObj:Debug2("__skinMoneyFrame: [%s, %s]", opts.obj, opts.obj:GetName())

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

	local obj
	for key, type in pairs{"Gold", "Silver", "Copper"} do
		obj = _G[opts.obj:GetName() .. type]
		aObj:skinEditBox{obj=obj, regs={6, 7}, noHeight=true, noWidth=true, ign=true} -- N.B. region 6 is the icon, 7 is text
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
	obj = nil

end
function aObj:skinMoneyFrame(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sMF\n" .. debugstack(2, 3, 2))
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.moveGIcon = select(2, ...) and select(2, ...) or nil
		opts.noWidth = select(3, ...) and select(3, ...) or nil
		opts.moveSEB = select(4, ...) and select(4, ...) or nil
		opts.moveGEB = select(5, ...) and select(5, ...) or nil
	end

	__skinMoneyFrame(opts)
	opts = nil

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
	assert(opts.obj, "Missing object __sSB\n" .. debugstack(2, 3, 2))
	assert(opts.obj:IsObjectType("Frame"), "Not a ScrollFrame\n" .. debugstack(2, 3, 2))
	assert(_G[opts.obj:GetName() .. "ScrollBar"]:IsObjectType("Slider"), "Not a Slider\n" .. debugstack(2, 3, 2))
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
function aObj:skinScrollBar(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sSB\n" .. debugstack(2, 3, 2))
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		-- opts.sbPrefix = select(2, ...) and select(2, ...) or nil
		-- opts.sbObj = select(3, ...) and select(3, ...) or nil
		opts.size = select(4, ...) and select(4, ...) or 2
	end

	__skinScrollBar(opts)
	opts = nil

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
	assert(opts.obj, "Missing object __sS\n" .. debugstack(2, 3, 2))
	assert(opts.obj:IsObjectType("Slider"), "Not a Slider\n" .. debugstack(2, 3, 2))
--@end-alpha@

	aObj:Debug2("__skinSlider: [%s, %s]", opts.obj, opts.obj:GetName())

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

	aObj:keepFontStrings(opts.obj)
	opts.obj:SetAlpha(1)
	opts.obj:GetThumbTexture():SetAlpha(1)

	aObj:skinUsingBD{obj=opts.obj, size=opts.size}

	-- adjust width if required
	if opts.wdth then aObj:adjWidth{obj=opts.obj, adj=opts.wdth} end
	-- adjust height if required (horizontal orientation)
	if opts.hgt then aObj:adjHeight{obj=opts.obj, adj=opts.hgt} end

	-- remove parent's textures if required
	if opts.rt then
		if type(opts.rt) == "table" then
			for i = 1, #opts.rt do
				opts.obj:GetParent():DisableDrawLayer(opts.rt[i])
			end
		else
			opts.obj:GetParent():DisableDrawLayer(opts.rt)
		end
	end

end
function aObj:skinSlider(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sS\n" .. debugstack(2, 3, 2))
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.size = select(2, ...) and select(2, ...) or 2
	end

	-- handle change of parameter name: adj -> wdth
	if opts.adj then
		opts.wdth = opts.adj
		opts.adj = nil
	end

	__skinSlider(opts)
	opts = nil

end

-- table to hold StatusBars that have been glazed, with weak keys
aObj.sbGlazed = _G.setmetatable({}, {__mode = "k"})
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
	assert(opts.obj, "Missing object __sSB\n" .. debugstack(2, 3, 2))
	assert(opts.obj:IsObjectType("StatusBar"), "Not a StatusBar\n" .. debugstack(2, 3, 2))
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
	and type(opts.otherTex) == "table"
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
		tex = nil
	end

	sbG = nil

end
function aObj:skinStatusBar(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object gSB\n" .. debugstack(2, 3, 2))
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
	--@alpha@
		-- handle AddOn skins still using this code rather than skinSlider
		aObj:CustomPrint(1, 0, 0, "Using old style call - skinStatusBar", select(1, ...), debugstack(2, 3, 2))
	--@end-alpha@
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.fi = select(2, ...) and select(2, ...) or nil
		opts.bgTex = select(3, ...) and select(3, ...) or nil
		opts.otherTex = select(4, ...) and select(4, ...) or nil
		opts.hookFunc = select(5, ...) and select(5, ...) or nil
	end

	__skinStatusBar(opts)
	opts = nil

end
-- previous name for the above function (statusBar, fi, bgTex, otherTex, hookFunc)
function aObj:glazeStatusBar(...)
--@alpha@
	-- handle AddOn skins still using this code rather than skinStatusBar
	aObj:CustomPrint(1, 0, 0, "Using deprecated function - glazeStatusBar, use skinStatusBar instead", select(1, ...),  debugstack(2, 3, 2))
--@end-alpha@

	self:skinStatusBar(...)

end

local function __skinTabs(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
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
	assert(opts.obj, "Missing object __sT\n" .. debugstack(2, 3, 2))
	assert(opts.obj:IsObjectType("Frame"), "Not a Frame\n" .. debugstack(2, 3, 2))
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
				ht:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-Tab-Highlight]])
				ht:ClearAllPoints()
				if opts.up then -- (GuildInfoFrame, LookingForGuild, MacroFrame, FriendsTabHeader)
					ht:SetPoint("TOPLEFT", 1, -5)
					ht:SetPoint("BOTTOMRIGHT", -1, -5)
				else
					ht:SetPoint("TOPLEFT", 8, 2)
					ht:SetPoint("BOTTOMRIGHT", -8, 0)
				end
			end
			ht = nil
		end
	end
	aObj.tabFrames[opts.obj] = true

	tabName, kRegions, xOfs1, yOfs1, xOfs2, yOfs2, tabID, tab = nil, nil, nil, nil, nil, nil, nil, nil

end
function aObj:skinTabs(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sT\n" .. debugstack(2, 3, 2))
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
	end

	__skinTabs(opts)
	opts = nil

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
	togTab = nil

end

function aObj:skinTooltip(tooltip)
	if not self.prdb.Tooltips.skin then return end
--@alpha@
	assert(tooltip, "Missing object sT\n" .. debugstack(2, 3, 2))
--@end-alpha@

	aObj:Debug2("skinTooltip: [%s, %s, %s]", tooltip, tooltip:GetName(), tooltip.sf)

	if not tooltip then return end

	if not tooltip.sf then
		-- Bugfix for ElvUI
		local ttSB
		if _G.IsAddOnLoaded("ElvUI") then
			ttSB = tooltip.SetBackdrop
			tooltip.SetBackdrop = _G.nop
		end
		self:addSkinFrame{obj=tooltip, ft=tooltip.ftype or "a", kfs=true, aso={ng=true}, ofs=0}
		if _G.IsAddOnLoaded("ElvUI") then
			tooltip.SetBackdrop = ttSB
		end
		ttSB = nil
	end

	-- colour the Border
	tooltip.sf:SetBackdropBorderColor(aObj.tbClr:GetRGBA())

	if self.prdb.Tooltips.style == 1 then -- Rounded
		self:applyGradient(tooltip.sf, 32)
	elseif self.prdb.Tooltips.style == 2 then -- Flat
		self:applyGradient(tooltip.sf)
	elseif self.prdb.Tooltips.style == 3 then -- Custom
		self:applyGradient(tooltip.sf, self.prdb.FadeHeight.value <= Round(tooltip:GetHeight()) and self.prdb.FadeHeight.value or Round(tooltip:GetHeight()))
	end

end

local function __skinUsingBD(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		size = backdrop size to use (2 - wide, 3 - medium, 4 - narrow)
--]]
--@alpha@
	assert(opts.obj, "Missing object __sUBD\n" .. debugstack(2, 3, 2))
--@end-alpha@

	opts.size = opts.size or 3 -- default to medium

	opts.obj:SetBackdrop(aObj.Backdrop[opts.size])
	opts.obj:SetBackdropBorderColor(.2, .2, .2, 1)
	opts.obj:SetBackdropColor(.1, .1, .1, 1)

end
function aObj:skinUsingBD(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sUBD\n" .. debugstack(2, 3, 2))
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.size = select(2, ...) and select(2, ...) or 3
	end

	__skinUsingBD(opts)
	opts = nil

end

function aObj:skinUsingBD2(obj)

	self:skinUsingBD{obj=obj, size=2}

end