local aName, aObj = ...
local _G = _G
local module = aObj:NewModule("UIButtons", "AceEvent-3.0", "AceHook-3.0")

local db
local defaults = {
	profile = {
		UIButtons = false,
		ButtonBorders = false,
	}
}

do
	-- characters used on buttons
	module.mult = "×"
	module.plus = "+"
	module.minus = "-" -- using Hyphen-minus(-) instead of minus sign(−) for font compatiblity reasons
	-- create font to use for Close Buttons
	module.fontX = CreateFont("fontX")
	module.fontX:SetFont([[Fonts\FRIZQT__.TTF]], 22)
	module.fontX:SetTextColor(1.0, 0.82, 0)
	-- create font for disabled text
	module.fontDX = CreateFont("fontDX")
	module.fontDX:SetFont([[Fonts\FRIZQT__.TTF]], 22)
	module.fontDX:SetTextColor(0.35, 0.35, 0.35)
	-- create font to use for small blue Close Buttons (e.g. BNToastFrame)
	module.fontSBX = CreateFont("fontSBX")
	module.fontSBX:SetFont([[Fonts\FRIZQT__.TTF]], 14)
	module.fontSBX:SetTextColor(0.2, 0.6, 0.8)
	-- create font to use for small Buttons (e.g. MinimalArchaeology)
	module.fontSB = CreateFont("fontSB")
	module.fontSB:SetFont([[Fonts\FRIZQT__.TTF]], 14)
	module.fontSB:SetTextColor(1.0, 0.82, 0)
	-- create font to use for Minus/Plus Buttons
	module.fontP = CreateFont("fontP")
	module.fontP:SetFont([[Fonts\ARIALN.TTF]], 16)
	module.fontP:SetTextColor(1.0, 0.82, 0)
	-- create font for disabled text
	module.fontDP = CreateFont("fontDP")
	module.fontDP:SetFont([[Fonts\ARIALN.TTF]], 16)
	module.fontDP:SetTextColor(0.35, 0.35, 0.35)
end
local btnTexNames = {"Left", "Middle", "Right", "_LeftTexture", "_MiddleTexture", "_RightTexture", "_LeftSeparator", "_RightSeparator"}
local function __checkTex(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		nTex = Texture
		mp2 = minus/plus type 2
--]]
--@alpha@
	assert(opts.obj, "Missing object __cT\n"..debugstack())
--@end-alpha@

	-- hide existing textures if they exist (GupCharacter requires this)
	if opts.obj:GetNormalTexture() then opts.obj:GetNormalTexture():SetAlpha(0) end
	if opts.obj:GetPushedTexture() then opts.obj:GetPushedTexture():SetAlpha(0) end
	if opts.obj:GetDisabledTexture() then opts.obj:GetDisabledTexture():SetAlpha(0) end

	local nTex = opts.nTex or opts.obj:GetNormalTexture() and opts.obj:GetNormalTexture():GetTexture() or nil
	local btn = opts.mp2 and opts.obj or aObj.sBtn[opts.obj]
	if not btn then return end -- allow for unskinned buttons

	-- aObj:Debug("__checkTex: [%s, %s, %s, %s, %s]", opts.obj, btn, nTex, opts.mp2, btn.skin)

	if not opts.mp2 then btn:Show() end -- why done here and not within following test stanza ???

	if nTex then
		if btn.skin then btn:Show() end -- Waterfall/tomQuest2
		if nTex:find("MinusButton")
		or nTex:find("ZoomOutButton") -- ARL
		then
			btn:SetText(module.minus)
		elseif nTex:find("PlusButton")
		or nTex:find("ZoomInButton") -- ARL
		then
			btn:SetText(module.plus)
		else -- not a header line
			btn:SetText("")
			if not opts.mp2 then btn:Hide() end
		end
	else -- not a header line
		btn:SetText("")
		if not opts.mp2
		or btn.skin -- Waterfall/tomQuest2
		then
			btn:Hide()
		end
	end

end
function module:checkTex(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object cT\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.nTex = select(2, ...) and select(2, ...) or nil
		opts.mp2 = select(3, ...) and select(3, ...) or nil
	end
	__checkTex(opts)

end

function module:skinButton(opts)
--[[
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
--]]
--@alpha@
	assert(opts.obj, "Missing object skinButton\n"..debugstack())
--@end-alpha@

	if not opts.obj then return end

	-- don't skin it twice
	if aObj.sBtn[opts.obj] or opts.obj.tfade then return end

	if opts.obj.GetNormalTexture and opts.obj:GetNormalTexture() then -- [UIPanelButtonTemplate/UIPanelCloseButton/... and derivatives]
		opts.obj:GetNormalTexture():SetAlpha(0)
		if opts.obj:GetPushedTexture() then opts.obj:GetPushedTexture():SetAlpha(0) end
		if opts.obj:GetDisabledTexture() then opts.obj:GetDisabledTexture():SetAlpha(0) end
		if opts.obj.GetCheckedTexture -- CheckButton (Archy)
		and opts.obj:GetCheckedTexture()
		then
			opts.obj:GetCheckedTexture():SetAlpha(0)
		end
	elseif opts.obj.left then -- ARL & Collectinator
		opts.obj.left:SetAlpha(0)
		opts.obj.middle:SetAlpha(0)
		opts.obj.right:SetAlpha(0)
	elseif opts.obj.LeftTexture then -- Outfitter
		opts.obj.LeftTexture:SetAlpha(0)
		opts.obj.MiddleTexture:SetAlpha(0)
		opts.obj.RightTexture:SetAlpha(0)
	else -- [UIPanelButtonTemplate2/... and derivatives]
		local objName = opts.obj:GetName()
		if objName then -- handle unnamed objects (e.g. Waterfall MP buttons)
			for _, tName in pairs(btnTexNames) do
				local bTex = _G[objName..tName]
				if bTex then bTex:SetAlpha(0) end
			end
		end
	end

	local x1, x2, y1, y2, btn
	local bW, bH = floor(opts.obj:GetWidth() + 0.01), floor(opts.obj:GetHeight() + 0.01) -- add adj for 31.999 buttons
	if bW <= 20 and opts.cb then -- ArkInventory/Recount close buttons
		local adj = bW < 20 and bW + 1 or bW
--		print(opts.obj:GetParent():GetName(), bW, adj)
		opts.cb2 = opts.cb
		opts.cb = nil
		opts.x1, opts.y1, opts.x2, opts.y2 = bW - adj, 0, adj - bW, 0
	end
	if opts.cb then -- it's a close button
		opts.obj:SetNormalFontObject(module.fontX)
		opts.obj:SetText(module.mult)
		opts.obj:SetPushedTextOffset(-1, -1)
		if opts.sap then
			aObj:addSkinButton{obj=opts.obj, parent=opts.obj, sap=true}
		else
			x1 = opts.x1 or bW == 32 and 6 or 4
			y1 = opts.y1 or bW == 32 and -6 or -4
			x2 = opts.x2 or bW == 32 and -6 or -4
			y2 = opts.y2 or bW == 32 and 6 or 4
			aObj:addSkinButton{obj=opts.obj, parent=opts.obj, aso={bd=5}, x1=x1, y1=y1, x2=x2, y2=y2}
		end
	elseif opts.cb2 then -- it's pretending to be a close button (e.g. ArkInventory/Recount/Outfitter)
		x1 = opts.x1 or 0
		y1 = opts.y1 or 0
		x2 = opts.x2 or 0
		y2 = opts.y2 or 0
		btn = aObj:addSkinButton{obj=opts.obj, parent=opts.obj, aso={bd=5}, x1=x1, y1=y1, x2=x2, y2=y2}
		btn:SetNormalFontObject(module.fontX)
		btn:SetText(module.mult)
	elseif opts.cb3 then -- it's a small blue close button
		aObj:adjWidth{obj=opts.obj, adj=-4}
		aObj:adjHeight{obj=opts.obj, adj=-4}
		btn = aObj:addSkinButton{obj=opts.obj, parent=opts.obj, aso={bd=5, bba=0}, x1=2, y1=1, x2=2, y2=1}
		btn:SetNormalFontObject(module.fontSBX)
		btn:SetText(module.mult)
	elseif opts.mp then -- it's a minus/plus texture on a larger button
		btn = aObj:addSkinButton{obj=opts.obj, parent=opts.obj, aso={bd=6}}
		btn:SetAllPoints(opts.obj:GetNormalTexture())
		btn:SetNormalFontObject(module.fontP)
		btn:SetText(opts.plus and module.plus or module.minus)
	elseif opts.mp2 then -- it's a minus/plus button (IOF has them on RHS)
		opts.obj:SetNormalFontObject(module.fontP)
		opts.obj:SetText(opts.plus and module.plus or module.minus)
		opts.obj:SetPushedTextOffset(-1, -1)
		if not opts.as then
			aObj:addSkinButton{obj=opts.obj, parent=opts.obj, aso={bd=6}, sap=true}
			module:SecureHook(opts.obj, "SetNormalTexture", function(this, nTex)
				module:checkTex{obj=this, nTex=nTex, mp2=true}
			end)
		else -- just skin it (used by Waterfall & tomQuest2)
			aObj:applySkin{obj=opts.obj, bd=6}
			opts.obj.skin = true
		end
	elseif opts.ob then -- it's another type of button, text supplied (e.g. beql minimize)
		opts.obj:SetNormalFontObject(module.fontP)
		opts.obj:SetText(opts.ob)
		opts.obj:SetPushedTextOffset(-1, -1)
		if opts.sap then
			aObj:addSkinButton{obj=opts.obj, parent=opts.obj, sap=true}
		else
			x1 = opts.x1 or bW == 32 and 6 or 4
			y1 = opts.y1 or bW == 32 and -6 or -4
			x2 = opts.x2 or bW == 32 and -6 or -4
			y2 = opts.y2 or bW == 32 and 6 or 4
			aObj:addSkinButton{obj=opts.obj, parent=opts.obj, aso={bd=5}, x1=x1, y1=y1, x2=x2, y2=y2}
		end
	elseif opts.ob2 then -- it's another type of button, text supplied, style 2 (e.g. MinimalArchaeology)
		opts.obj:SetNormalFontObject(module.fontSB)
		opts.obj:SetText(opts.ob2)
		opts.obj:SetPushedTextOffset(-1, -1)
		opts.obj:SetHighlightTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]])
		opts.obj:SetWidth(18)
		opts.obj:SetHeight(18)
		aObj:addSkinButton{obj=opts.obj, parent=opts.obj, aso={bd=5}, sap=true}
	else -- standard button (UIPanelButtonTemplate/UIPanelButtonTemplate2 and derivatives)
		aso = {bd=bH > 18 and 5 or 6} -- use narrower backdrop if required
		if not opts.as then
			x1 = opts.x1 or 1
			y1 = opts.y1 or -1
			x2 = opts.x2 or -1
			y2 = opts.y2 or -1
			aObj:addSkinButton{obj=opts.obj, parent=opts.obj, aso=aso, bg=opts.bg, x1=x1, y1=y1, x2=x2, y2=y2}
		else
			aObj:applySkin{obj=opts.obj, bd=aso.bd}
		end
	end

	-- reparent skinButton to avoid whiteout issues caused by animations
	if opts.anim and aObj.sBtn[opts.obj] then
		aObj.sBtn[opts.obj]:SetParent(aObj.skinFrame[opts.obj:GetParent()])
	end

end

local function getTexture(obj)

	if obj
	and obj:IsObjectType("Texture")
	then
		return obj:GetTexture()
	else
		return
	end

end

function module:isButton(obj, cb, blue)

	local bType, oName, oTex
	if obj.GetNormalTexture -- is it a true button
	and not obj.GetChecked -- and not a checkbutton
	and not obj.SetSlot -- and not a lootbutton
	then -- check textures are as expected
		oName = obj:GetName() or nil
		oTex = getTexture(obj:GetNormalTexture()) or getTexture(aObj:getRegion(obj, 1))
		if oTex then
			if oTex:find("UI-Panel-Button-Up", 1, true) -- UI Panel Button
			or oTex:find("UI-Panel-Button-Disabled", 1, true) -- UI Panel Button (Gray template)
			or oTex:find("UI-DialogBox-Button-Up", 1, true) -- Static Popup Button
			or oTex:find("HelpButtons") -- "new" Help Button
			or oTex:find("UI-Achievement", 1, true) and oName:find("AtlasLoot") -- AtlasLoot "new" style
			and not (oName:find("AceConfig") or oName:find("AceGUI")) -- ignore AceConfig/AceGui buttons
			then
				bType = "normal"
			end
			if oTex:find("UI-Panel-MinimizeButton", 1, true)
			or oTex:find("UI-Panel-HideButton", 1, true) -- PVPFramePopup (Cataclysm)
			then
				bType = "close"
			end
			if oTex:find("UI-Toast-CloseButton", 1, true)
			then
				bType = "toast"
			end
			if oTex:find("KnowledgeBaseButtton") -- "new" KnowledgeBase Button
			then
				bType = "helpKB"
			end
			if oTex:find("UI-PlusButton", 1, true) -- UI Plus button
			or oTex:find("UI-MinusButton", 1, true) -- UI Minus Button
			then
				bType = "mp"
			end
		end
	end

	-- aObj:Debug("isButton: [%s, %s, %s]", obj, bType, oTex)

	return bType, oTex

end

local function __skinAllButtons(opts, bgen)
--[[
	Calling parameters:
		obj = object (Mandatory)
		bgen = generations of children to traverse
		other options as per skinButton
--]]
--@alpha@
	assert(opts.obj, "Missing object__sAB\n"..debugstack())
--@end-alpha@
	if not opts.obj then return end

	-- maximum number of button generations to traverse
	bgen = bgen or opts.bgen or 3

	for _, child in ipairs{opts.obj:GetChildren()} do
		if child:IsObjectType("Button") then
			if child:GetNumChildren() > 0 and bgen > 0 then
				opts.obj=child
				__skinAllButtons(opts, bgen - 1)
			end
			local bType = module:isButton(child)
			if bType == "normal" then
				module:skinButton{obj=child, x1=opts.x1, y1=opts.y1, x2=opts.x2, y2=opts.y2, anim=opts.anim, as=opts.as}
			elseif bType == "close" then
				module:skinButton{obj=child, cb=true, sap=opts.sap, anim=opts.anim}
			elseif bType == "toast" then
				module:skinButton{obj=child, cb3=true, anim=opts.anim}
			elseif bType == "helpKB" then
				child:DisableDrawLayer("ARTWORK")
				module:skinButton{obj=child, as=true}
			elseif bType == "mp" then -- ignore for now
			end
		elseif child:IsObjectType("Frame") and bgen > 0 then
			opts.obj=child
			__skinAllButtons(opts, bgen - 1)
		end
	end

end
function module:skinAllButtons(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sAB\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
	end
	__skinAllButtons(opts)

end

local function __addButtonBorder(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		relTo = object to position relative to
		hide = hook Hide/Show scripts of relTo object
		ofs = global offset
		abt = Action Button template
		pabt = Pet Action Button template
		ibt = Item Button template
		tibt = Talent Item Button template
		libt = Large Item Button template
		spbt = Simple Popup Button template
		mb = Main Menu Bar Micro Button
		sec = requires SecureFrameTemplate to inherit from otherwise tainting occurs
		reParent = table of objects to reparent to the border frame
		es = edgeSize, used for small icons
		x1 = X offset for TOPLEFT
		y1 = Y offset for TOPLEFT
		x2 = X offset for BOTTOMRIGHT
		y2 = Y offset for BOTTOMRIGHT
--]]
--@alpha@
	assert(opts.obj, "Missing object__aBB\n"..debugstack())
--@end-alpha@
	if not opts.obj then return end

	local btnName = opts.obj:GetName()

	-- remove Normal texture if required
	if opts.ibt
	or opts.abt
	or opts.pabt
	then
		opts.obj:GetNormalTexture():SetTexture(nil) -- vertex colour changed in blizzard code
	end

	-- create the border frame
	opts.obj.sknrBdr = CreateFrame("Frame", nil, opts.obj, opts.sec and "SecureFrameTemplate" or nil)
	-- DON'T lower the frame level otherwise the border appears below the frame
	-- setup and apply the backdrop
	opts.obj.sknrBdr:SetBackdrop({edgeFile = aObj.Backdrop[1].edgeFile,
								  edgeSize = opts.es or aObj.Backdrop[1].edgeSize})
	opts.obj.sknrBdr:SetBackdropBorderColor(unpack(aObj.bbColour))
	-- position the frame
	opts.ofs = opts.ofs or 2
	local xOfs1 = opts.x1 or opts.ofs * -1
	local yOfs1 = opts.y1 or opts.ofs
	local xOfs2 = opts.x2 or opts.ofs
	local yOfs2 = opts.y2 or opts.ofs * -1
	-- Large Item Button templates have an IconTexture to position to
	relTo = opts.relTo
			or opts.libt and _G[btnName.."IconTexture"]
			or nil
	opts.obj.sknrBdr:SetPoint("TOPLEFT", relTo or opts.obj, "TOPLEFT", xOfs1, yOfs1)
	opts.obj.sknrBdr:SetPoint("BOTTOMRIGHT", relTo or opts.obj, "BOTTOMRIGHT", xOfs2, yOfs2)

	if opts.hide and opts.relTo then
		-- hook Show and Hide methods of the relTo object
		module:SecureHook(opts.relTo, "Show", function(this) opts.obj.sknrBdr:Show() end)
		module:SecureHook(opts.relTo, "Hide", function(this) opts.obj.sknrBdr:Hide() end)
		-- hide border if required
		if not opts.relTo:IsShown() then opts.obj.sknrBdr:Hide() end
	end

	-- reparent objects if required
	if opts.reParent then
		for _, obj in pairs(opts.reParent) do
			obj:SetParent(opts.obj.sknrBdr)
		end
	end
	-- reparent these textures so they are displayed above the border
	if opts.ibt then -- Item Buttons
		_G[btnName.."Count"]:SetParent(opts.obj.sknrBdr)
		_G[btnName.."Stock"]:SetParent(opts.obj.sknrBdr)
	elseif opts.abt then -- Action Buttons
		_G[btnName.."HotKey"]:SetParent(opts.obj.sknrBdr)
		-- reparent FlyoutArrow so it is displayed above the border
		opts.obj.FlyoutArrow:SetParent(opts.obj.sknrBdr)
		_G[btnName.."Name"]:SetParent(opts.obj.sknrBdr)
		_G[btnName.."Count"]:SetParent(opts.obj.sknrBdr)
	elseif opts.libt then -- Large Item Buttons
		_G[btnName.."Name"]:SetParent(opts.obj.sknrBdr)
		_G[btnName.."Count"]:SetParent(opts.obj.sknrBdr)
	elseif opts.mb then -- Micro Buttons
		opts.obj.Flash:SetParent(opts.obj.sknrBdr)
	elseif opts.pabt then -- Pet Action Buttons
		_G[btnName.."AutoCastable"]:SetParent(opts.obj.sknrBdr)
		_G[btnName.."Shine"]:SetParent(opts.obj.sknrBdr)
	elseif opts.tibt then -- Talents
		_G[btnName.."RankBorder"]:SetParent(opts.obj.sknrBdr)
		_G[btnName.."Rank"]:SetParent(opts.obj.sknrBdr)
		if _G[btnName.."RankBorderGreen"] then
			_G[btnName.."RankBorderGreen"]:SetParent(opts.obj.sknrBdr)
		end
	elseif opts.spbt then -- Simple Popup Buttons
		_G[btnName.."Name"]:SetParent(opts.obj.sknrBdr)
	end

end
function module:addButtonBorder(...)

	local opts = select(1, ...)

	-- handle in combat
	if InCombatLockdown() then
		aObj:add2Table(module.btnTab, opts)
		return
	end

--@alpha@
	assert(opts, "Missing object sAB\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
	end
	__addButtonBorder(opts)

end

function module:OnInitialize()

	self.db = aObj.db:RegisterNamespace("UIButtons", defaults)
	db = self.db.profile

	-- convert any old settings
	if aObj.db.profile.Buttons then
		db.UIButtons = aObj.db.profile.Buttons
		aObj.db.profile.Buttons = nil
	end

	if not db.UIButtons
	and not db.ButtonBorders
	then
		self:Disable()
	end -- disable ourself

end

function module:OnEnable()

	-- this code will handle button border creation during combat
	if module.db.profile.ButtonBorders then
		module.btnTab = {}
		module:RegisterEvent("PLAYER_REGEN_ENABLED", function()
			for _, v in pairs(module.btnTab) do
				module:addButtonBorder(v)
			end
			wipe(module.btnTab)
		end)
	end

end

function module:GetOptions()

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
				name = aObj.L["UI Buttons"],
				desc = aObj.L["Toggle the skinning of the UI Buttons, reload required"],
			},
			ButtonBorders = {
				type = "toggle",
				name = aObj.L["Button Borders"],
				desc = aObj.L["Toggle the skinning of the Button Borders, reload required"],
			},
		},
	}
	return options

end
