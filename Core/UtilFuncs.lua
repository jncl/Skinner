local aName, aObj = ...

local _G = _G

function aObj.addBackdrop(_, obj)

	if not obj.ApplyBackdrop then
		_G.Mixin(obj, _G.BackdropTemplateMixin)
	end

end

local function __adjHeight(opts)
	--[[
		Calling parameters:
			obj = object (Mandatory)
			adj = value to adjust height by
	--]]
	--@debug@
	_G.assert(opts.obj, "Missing object aH\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	if opts.adj == 0 then return end

	if not _G.strfind(_G.tostring(opts.adj), "+") then -- if not negative value
		opts.obj:SetHeight(opts.obj:GetHeight() + opts.adj)
	else
		opts.adj = opts.adj * -1 -- make it positive
		opts.obj:SetHeight(opts.obj:GetHeight() - opts.adj)
	end
end
function aObj.adjHeight(_, ...)

	local opts = _G.select(1, ...)

	--@debug@
	_G.assert(opts, "Missing object aH\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata" and _G.type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
		opts.adj = _G.select(2, ...) and _G.select(2, ...) or 0
	end
	__adjHeight(opts)

end

local function __adjWidth(opts)
	--[[
		Calling parameters:
			obj = object (Mandatory)
			adj = value to adjust width by
	--]]
		--@debug@
		_G.assert(opts.obj, "Missing object aW\n" .. _G.debugstack(2, 3, 2))
		--@end-debug@

		if opts.adj == 0 then return end

		if not _G.strfind(_G.tostring(opts.adj), "+") then -- if not negative value
			opts.obj:SetWidth(opts.obj:GetWidth() + opts.adj)
		else
			opts.adj = opts.adj * -1 -- make it positive
			opts.obj:SetWidth(opts.obj:GetWidth() - opts.adj)
		end
end
function aObj.adjWidth(_, ...)

	local opts = _G.select(1, ...)

	--@debug@
	_G.assert(opts, "Missing object aW\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata" and _G.type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
		opts.adj = _G.select(2, ...) and _G.select(2, ...) or 0
	end
	__adjWidth(opts)

end

function aObj:addFrameBorder(opts)

	self:skinObject("frame", {obj=opts.obj, kfs=opts.kfs, aso=opts.aso or nil, chkfb=true, ofs=opts.ofs or 0, x1=opts.x1 or nil, y1=opts.y1 or nil, x2=opts.x2 or nil, y2=opts.y2 or nil})

end

function aObj:applyGradient(obj, fh, invert, rotate)

	if not self.prdb.Gradient.enable then
		return
	end

	-- don't apply a gradient if required
	if not self.prdb.Gradient.char then
		if self.gradFrames.p[obj] then
			return
		end
	end
	if not self.prdb.Gradient.ui then
		if self.gradFrames.u[obj] then
			return
		end
	end
	if not self.prdb.Gradient.npc then
		if self.gradFrames.n[obj] then
			return
		end
	end
	if not self.prdb.Gradient.skinner then
		if self.gradFrames.s[obj] then
			return
		end
	end
	if not self.prdb.Gradient.addon then
		if self.gradFrames.a[obj] then
			return
		end
	end

	invert = invert or self.prdb.Gradient.invert
	rotate = rotate or self.prdb.Gradient.rotate

	if not obj.tfade then
		obj.tfade = obj:CreateTexture(nil, "BORDER", nil, -1)
		obj.tfade:SetTexture(self.gradientTex)
		obj.tfade:SetBlendMode("ADD")
		obj.tfade:SetGradient(self:getGradientInfo(invert, rotate))
	end

	if self.prdb.FadeHeight.enable
	and (self.prdb.FadeHeight.force or not fh)
	and _G.Round(obj:GetHeight()) ~= obj.hgt
	then
		-- set the Fade Height if not already passed to this function or 'forced'
		-- making sure that it isn't greater than the frame height
		obj.hgt = _G.Round(obj:GetHeight())
		fh = self.prdb.FadeHeight.value <= obj.hgt and self.prdb.FadeHeight.value or obj.hgt
	end

	local oFs = self.prdb.BdInset
	obj.tfade:ClearAllPoints()
	if not invert -- fade from top
	and not rotate
	then
		obj.tfade:SetPoint("TOPLEFT", obj, "TOPLEFT", oFs, oFs * -1)
		if fh then
			obj.tfade:SetPoint("BOTTOMRIGHT", obj, "TOPRIGHT", oFs * -1, -(fh - oFs))
		else
			obj.tfade:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", oFs * -1, oFs)
		end
	elseif invert -- fade from bottom
	and not rotate
	then
		obj.tfade:SetPoint("BOTTOMLEFT", obj, "BOTTOMLEFT", oFs, oFs)
		if fh then
			obj.tfade:SetPoint("TOPRIGHT", obj, "BOTTOMRIGHT", oFs * -1, (fh - oFs))
		else
			obj.tfade:SetPoint("TOPRIGHT", obj, "TOPRIGHT", oFs * -1, oFs * -1)
		end
	elseif not invert -- fade from right
	and rotate
	then
		obj.tfade:SetPoint("TOPRIGHT", obj, "TOPRIGHT", oFs * -1, oFs * -1)
		if fh then
			obj.tfade:SetPoint("BOTTOMLEFT", obj, "BOTTOMRIGHT", -(fh - oFs), oFs)
		else
			obj.tfade:SetPoint("BOTTOMLEFT", obj, "BOTTOMLEFT", oFs, oFs)
		end
	elseif invert -- fade from left
	and rotate
	then
		obj.tfade:SetPoint("TOPLEFT", obj, "TOPLEFT", oFs, oFs * -1)
		if fh then
			obj.tfade:SetPoint("BOTTOMRIGHT", obj, "BOTTOMLEFT", fh - oFs, oFs)
		else
			obj.tfade:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", oFs * -1, oFs)
		end
	end

end

function aObj:applyTooltipGradient(obj)
	--@debug@
	if obj:IsForbidden() then
		aObj:CustomPrint(1, 0, 0, "Object is flagged as Forbidden, aTG", obj)
	end
	--@end-debug@

	if obj:IsForbidden() then return end

	if self.prdb.Tooltips.style == 1 then -- Rounded
		self:applyGradient(obj, 32)
	elseif self.prdb.Tooltips.style == 2 then -- Flat
		self:applyGradient(obj)
	elseif self.prdb.Tooltips.style == 3 then -- Custom
		self:applyGradient(obj, self.prdb.FadeHeight.value <= _G.Round(obj:GetHeight()) and self.prdb.FadeHeight.value or _G.Round(obj:GetHeight()))
	end

end

function aObj:canSkin(callingFunc, opts, dontCheckCombat)

	if not opts.obj then
		return false
	end

	if opts.obj:IsForbidden() then
		--@debug@
		aObj:CustomPrint(1, 0, 0, "ERROR: object is flagged as Forbidden, canSkin", opts.obj)
		--@end-debug@
		return false
	end

	dontCheckCombat = dontCheckCombat or false
	-- handle in combat
	if not dontCheckCombat
	and _G.InCombatLockdown()
	then
		self:add2Table(self.oocTab, {callingFunc, {opts}})
		return false
	end

	return true

end

function aObj.canSkinActionBtns()

	--@debug@
	return true
	--@end-debug@
	--[===[@non-debug@
	return aObj.isMnln and false or true
	--@end-non-debug@]===]

end

function aObj.capitStr(_, str)

	return str:sub(1,1):upper() .. str:sub(2):lower()

end

local coords
function aObj:changeHdrExpandTex(reg)
	--@debug@
	_G.assert(reg, "Unknown region changeHdrExpandTex\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	reg:ClearAllPoints()
	reg:SetPoint("RIGHT")
	reg:SetAlpha(1)
	reg:SetDesaturated(1) -- make the texture grey
	self:RawHook(reg, "SetAtlas", function(eReg, tex, useAtlasSize)
		-- aObj:Debug("changeHdrExpandTex SetAtlas: [%s, %s]", reg, tex)
		if tex == "Options_ListExpand_Right_Expanded" then -- minus
			tex = self.isMnln and "ui-hud-minimap-zoom-out" or self.tFDIDs.mpTex
			coords = not self.isMnln and {0.29687500, 0.54687500, 0.00781250, 0.13281250}
		else
			tex = self.isMnln and "ui-hud-minimap-zoom-in" or self.tFDIDs.mpTex
			coords = not self.isMnln and {0.57812500, 0.82812500, 0.14843750, 0.27343750}
		end
		if self.isMnln then
			self.hooks[eReg].SetAtlas(eReg, tex, useAtlasSize)
		else
			eReg:SetTexture(tex) -- N.B. use SetTexture instead of SetAtlas otherwise the texture doesn't display correctly
			eReg:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
			eReg:SetScale(0.75)
		end
	end, true)

end

function aObj:changeLock(lockObj)
	--@debug@
	_G.assert(lockObj, "Unknown object changeLock\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- Lock button, change texture
	local tex = lockObj:GetNormalTexture()
	tex:SetTexture(self.tFDIDs.gAOI)
	tex:SetTexCoord(0, 0.25, 0, 1.0)
	tex:SetAlpha(1)
	tex = lockObj:GetPushedTexture()
	tex:SetTexture(self.tFDIDs.gAOI)
	tex:SetTexCoord(0.25, 0.5, 0, 1.0)
	tex:SetAlpha(0.75)
	if lockObj.GetCheckedTexture then
		tex = lockObj:GetCheckedTexture()
		tex:SetTexture(self.tFDIDs.gAOI)
		tex:SetTexCoord(0.25, 0.5, 0, 1.0)
		tex:SetAlpha(1)
	end

end

function aObj:changeShield(shldReg, iconReg)
	--@debug@
	_G.assert(shldReg, "Unknown object changeShield\n" .. _G.debugstack(2, 3, 2))
	_G.assert(iconReg, "Unknown object changeShield\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	self:changeTandC(shldReg, self.tFDIDs.shieldTex)
	shldReg:SetSize(44, 44)
	-- move it behind the icon
	shldReg:ClearAllPoints()
	shldReg:SetPoint("CENTER", iconReg, "CENTER", 9, -1)

end

function aObj:changeTandC(obj, tex)
	--@debug@
	_G.assert(obj, "Unknown object changeTandC\n" .. _G.debugstack(2, 3, 2))
	if tex == self.tFDIDs.lvlBG then
		self:CustomPrint(1, 0, 0, "changeTandC - Using default texture")
	end
	--@end-debug@

	obj:SetTexture(tex or self.tFDIDs.lvlBG)
	obj:SetTexCoord(0, 1, 0, 1)
	if tex == self.sbTexture then
		self.sbGlazed[obj] = {}
	end

end

function aObj:changeTex(obj, isYellow, isUnitFrame)
	--@debug@
	_G.assert(obj, "Unknown object changeTex\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	obj:SetTexture(self.tFDIDs.hfHB)
	if isYellow then
		obj:SetTexCoord(isUnitFrame and 0.015 or 0.0038, isUnitFrame and 0.66 or 0.7, 0.67, 0.855) -- yellow
	else
		obj:SetTexCoord(0.0038, 0.7, 0.004, 0.205) -- blue
	end

end

function aObj:changeTex2SB(obj)
	--@debug@
	_G.assert(obj, "Unknown object changeTex2SB\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	obj:SetTexture(self.sbTexture)
	self.sbGlazed[obj] = {}

end

local errorhandler, success, err = _G.geterrorhandler()
local function safecall(funcName, funcObj, LoD, quiet)
	--@debug@
	_G.assert(funcObj, "Unknown object safecall\n" .. _G.debugstack(2, 3, 2))
	local beginTime = _G.debugprofilestop()
	--@end-debug@

	-- handle errors from internal functions
	success, err = _G.xpcall(funcObj, errorhandler, aObj, LoD)

	--@debug@
	local timeUsed = _G.Round(_G.debugprofilestop() - beginTime)
	if timeUsed > 5 then
		 _G.print("Took " .. timeUsed .. " milliseconds to load " .. funcName)
	end
	--@end-debug@

	if not success
	and not quiet
	then
		if aObj.prdb.Errors then
			aObj:CustomPrint(1, 0, 0, "Error running", funcName)
		end
	end
	return success, err
end

local hadWarning, tObj = {}
function aObj:checkAndRun(funcName, funcType, LoD, quiet)
	--@debug@
	_G.assert(funcName, "Unknown functionName checkAndRun\n" .. _G.debugstack(2, 3, 2))
	_G.assert(funcType, "Unknown functionType checkAndRun\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	self:Debug2("checkAndRun: [%s, %s, %s, %s]", funcName, funcType, LoD, quiet)

	-- handle in combat
	if _G.InCombatLockdown() then
		self:add2Table(self.oocTab, {self.checkAndRun, {self, funcName, funcType, LoD, quiet}})
		return
	end

	-- setup function's table object to use
	if funcType		== "s" then tObj = self
	elseif funcType == "l" then tObj = self.libsToSkin
	elseif funcType == "o" then tObj = self.otherAddons
	elseif funcType == "opt" then tObj = self
	else tObj = LoD and self.blizzLoDFrames[funcType] or self.blizzFrames[funcType]
	end

	-- only skin frames if required
	if (funcType == "n" and self.prdb.DisableAllNPC)
	or (funcType == "p" and self.prdb.DisableAllP)
	or (funcType == "u" and self.prdb.DisableAllUI)
	or (funcType == "s" and (self.prdb.DisabledSkins[funcName] or self.prdb.DisabledSkins[funcName .. " (LoD)"] or self.prdb.DisableAllAS))
	or (funcType == "l" and (self.prdb.DisabledSkins[funcName .. " (Lib)"] or self.prdb.DisableAllAS))
	or (funcType == "o" and (self.prdb.DisabledSkins[funcName] or self.prdb.DisableAllAS))
	then
		if self.prdb.Warnings
		and not hadWarning[funcName]
		then
			self:CustomPrint(1, 0, 0, funcName, "not skinned, flagged as disabled (c&R)")
			hadWarning[funcName] = true
		end
		-- N.B. DON'T nil the function otherwise it won't appear in list of disabled skins
		tObj[funcName] = _G.nop
		return
	end

	self:Debug2("checkAndRun #2: [%s]", _G.type(tObj[funcName]))
	if _G.type(tObj[funcName]) == "function" then
		return safecall(funcName, tObj[funcName], nil, quiet)
	else
		if not quiet and self.prdb.Warnings then
			self:CustomPrint(1, 0, 0, "function [" .. funcName .. "] not found in " .. aName .. " (c&R)")
		end
	end

end

function aObj:checkAndRunAddOn(addonName, addonFunc, LoD)
	--@debug@
	_G.assert(addonName, "Unknown object checkAndRunAddOn\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	self:Debug2("checkAndRunAddOn #1: [%s, %s, %s, %s]", addonName, addonFunc, LoD, _G.type(addonFunc))

	-- handle in combat
	if _G.InCombatLockdown() then
		self:add2Table(self.oocTab, {self.checkAndRunAddOn, {self, addonName, addonFunc, LoD}})
		return
	end

	-- handle old & new function definitions
	addonFunc = _G.type(addonFunc) == "function" and addonFunc or self[addonFunc]

	-- don't skin any Addons whose skins are flagged as disabled
	if self.prdb.DisabledSkins[addonName]
	or self.prdb.DisabledSkins[addonName .. " (LoD)"]
	or self.prdb.DisableAllAS
	then
		if self.prdb.Warnings
		and not hadWarning[addonName]
		then
			self:CustomPrint(1, 0, 0, addonName, "not skinned, flagged as disabled (c&RA)")
			hadWarning[addonName] = true
		end
		addonFunc = nil
		return
	end

	self:Debug2("checkAndRunAddOn #2: [%s, %s, %s, %s]", _G.C_AddOns.IsAddOnLoaded(addonName), _G.C_AddOns.IsAddOnLoadOnDemand(addonName), addonFunc, _G.type(addonFunc))

	if not _G.C_AddOns.IsAddOnLoaded(addonName) then
		-- deal with Addons under the control of an LoadManager
		if _G.C_AddOns.IsAddOnLoadOnDemand(addonName)
		and not LoD
		then
			self.lmAddons[addonName:lower()] = addonFunc -- store with lowercase addonname (AddonLoader fix)
		-- Nil out loaded Skins for Addons that aren't loaded
		elseif addonFunc then
			addonFunc = nil
		end
	else
		-- check to see if AddonSkin is loaded when Addon is loaded
		if not LoD and not addonFunc then
			if self.prdb.Warnings then
				self:CustomPrint(1, 0, 0, addonName, "loaded but skin not found in the AddonSkins directory (c&RA)")
			end
		elseif _G.type(addonFunc) == "function" then
			return safecall(addonName, addonFunc, LoD)
		else
			if self.prdb.Warnings then
				self:CustomPrint(1, 0, 0, "function [" .. addonName .. "] not found in " .. aName .. " (c&RA)")
			end
		end
	end

end

function aObj:checkLoadable(addonName)
	--@debug@
	_G.assert(addonName, "Unknown object checkLoadable\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	local _, _, _, loadable, reason, _, _ = _G.C_AddOns.GetAddOnInfo(addonName)
	if not loadable then
		if self.prdb.Warnings then
			self:CustomPrint(1, 0, 0, addonName, "not skinned, flagged as:", reason, "(cL)")
		end
	end

	return loadable

end

function aObj.checkShown(_, frame)

	if frame:IsShown() then
		frame:Hide()
		frame:Show()
	end

end

function aObj:checkDisabledDD(obj, disabled)

	disabled = disabled or obj.isDisabled
	if obj.sf then
		self:clrBBC(obj.sf, disabled and "disabled")
		if self.modBtnBs then
			local btn = obj.Button and obj.Button.sbb
					 or obj.dropButton and obj.dropButton.sbb
					 or obj:GetName() and _G[obj:GetName() .. "Button"] and _G[obj:GetName() .. "Button"].sbb
			if btn then
				self:clrBtnBdr(btn, disabled and "disabled")
			end
		end
	end

end

function aObj.getChild(_, obj, childNo)
	--@debug@
	_G.assert(obj, "Unknown object getChild\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	if obj and childNo then return (_G.select(childNo, obj:GetChildren())) end

end

function aObj:getGradientInfo(invert, rotate)

	if self.prdb.Gradient.enable then
		if invert then
			return rotate and "HORIZONTAL" or "VERTICAL", aObj.gmaxClr, aObj.gminClr
		else
			return rotate and "HORIZONTAL" or "VERTICAL", aObj.gminClr, aObj.gmaxClr
		end
	else
		return rotate and "HORIZONTAL" or "VERTICAL", _G.BLACK_FONT_COLOR, _G.BLACK_FONT_COLOR
	end

end

function aObj.getInt(_, num)
	--@debug@
	_G.assert(num, "Missing number\n" .. _G.debugstack(2, 3, 2))
	-- handle AddOn skins still using this code rather than _G.Round
	aObj:CustomPrint(1, 0, 0, "Using deprecated function - getInt, use _G.Round instead", _G.debugstack(2, 3, 2))
	--@end-debug@

	return _G.math.floor(num + 0.5)

end

function aObj:getLastChild(obj)

	return self:getChild(obj, obj:GetNumChildren())

end

function aObj:getPenultimateChild(obj)

	return self:getChild(obj, obj:GetNumChildren() - 1)

end

function aObj:getLastRegion(obj)

	return self:getRegion(obj, obj:GetNumRegions())

end

function aObj.getRegion(_, obj, regNo)
	--@debug@
	_G.assert(obj, "Unknown object getRegion\n" .. _G.debugstack(2, 3, 2))
	_G.assert(regNo, "Missing value getRegion\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	if obj and regNo then return (_G.select(regNo, obj:GetRegions())) end

end

function aObj.hasTextInName(_, obj, text)
	--@debug@
	_G.assert(obj, "Unknown object hasTextInName\n" .. _G.debugstack(2, 3, 2))
	_G.assert(text, "Missing value hasTextInName\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- ignore embedded hyphens
	return obj and obj.GetName and obj:GetName() and obj:GetName():find(text, 1, true) and true or false

end

function aObj.hasTextInDebugNameRE(_, obj, text)
	--@debug@
	_G.assert(obj, "Unknown object hasTextInName\n" .. _G.debugstack(2, 3, 2))
	_G.assert(text, "Missing value hasTextInName\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	return obj and obj.GetDebugName and obj:GetDebugName() and obj:GetDebugName():find(text) and true or false

end

function aObj:hasAnyTextInName(obj, tab)
	--@debug@
	_G.assert(obj, "Unknown object hasAnyTextInName\n" .. _G.debugstack(2, 3, 2))
	_G.assert(tab and _G.type(tab) == "table", "Missing text table hasAnyTextInName\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	for _, text in _G.ipairs(tab) do
		if self:hasTextInName(obj, text) then
			return true
		end
	end

	return false

end

function aObj.hasTextInTexture(_, obj, text)
	--@debug@
	_G.assert(obj, "Unknown object hasTextInTexture\n" .. _G.debugstack(2, 3, 2))
	_G.assert(text, "Missing value hasTextInTexture\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	return obj and obj.GetTexture and obj:GetTexture() and _G.tostring(obj:GetTexture()):find(text, 1, true) and true or false

end

function aObj:hook(obj, method, func)

	if not self:IsHooked(obj, method) then
		self:Hook(obj, method, func)
	end

end

function aObj:hookQuestText(btn)

	self:rawHook(btn, "SetFormattedText", function(this, fmtString, text)
		if fmtString == _G.NORMAL_QUEST_DISPLAY then
			fmtString = self.HT:WrapTextInColorCode("%s|r")
		elseif fmtString == _G.TRIVIAL_QUEST_DISPLAY then
			fmtString = self.BT:WrapTextInColorCode("%s (low level)|r")
		elseif fmtString == _G.IGNORED_QUEST_DISPLAY then
			fmtString = self.IT:WrapTextInColorCode("%s (ignored)|r")
		end
		return self.hooks[this].SetFormattedText(this, fmtString, text)
	end, true)

end

function aObj:hookSocialToastFuncs(frame)

	self:SecureHook(frame.animIn, "Play", function(this)
		if this.sf
		and this.sf.tfade
		then
			this.sf.tfade:SetParent(_G.MainMenuBar)
			if self.isClscERA then
				this.sf.tfade:SetGradientAlpha(self:getGradientInfo())
			else
				this.sf.tfade:SetGradient(self:getGradientInfo())
			end
		end
		if this.cb
		and this.cb.tfade
		then
			this.cb.tfade:SetParent(_G.MainMenuBar)
			if self.isClscERA then
				this.cb.tfade:SetGradientAlpha(self:getGradientInfo())
			else
				this.cb.tfade:SetGradient(self:getGradientInfo())
			end
		end
	end)
	self:SecureHook(frame.waitAndAnimOut, "Play", function(this)
		if this.sf
		and this.sf.tfade
		then
			this.sf.tfade:SetParent(this.sf)
		end
		if this.cb
		and this.cb.tfade
		then
			this.cb.tfade:SetParent(this.cb)
		end
	end)

end

function aObj:hookScript(obj, method, func)

	if not self:IsHooked(obj, method) then
		self:HookScript(obj, method, func)
	end

end

function aObj.isAddOnLoaded(_, addonName)
	--@debug@
	_G.assert(addonName, "Unknown object isAddOnLoaded\n" .. _G.debugstack(2, 3, 2))
	-- handle AddOn skins still using this code rather than _G.C_AddOns.IsAddOnLoaded
	aObj:CustomPrint(1, 0, 0, "Using deprecated function - isAddOnLoaded, use _G.C_AddOns.IsAddOnLoaded instead", _G.debugstack(2, 3, 2))
	--@end-debug@

	return _G.C_AddOns.IsAddOnLoaded(addonName)

end

function aObj:isAddonEnabled(addonName)
	--@debug@
	_G.assert(addonName, "Unknown object isAddonEnabled\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	return _G.C_AddOns.GetAddOnEnableState(addonName, self.uName) == 2 and true or false

end

function aObj:isDropDown(obj)
	--@debug@
	_G.assert(obj, "Unknown object isDropDown\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	if obj:IsObjectType("Frame") then
		local chkObj = obj.Left or obj:GetName() and _G[obj:GetName() .. "Left"]
		if chkObj then
			if self:hasTextInTexture(chkObj, "CharacterCreate")
			or self:hasTextInTexture(chkObj, self.tFDIDs.ccLF)
			then
				return true
			end
		end
	end
	return false

end

function aObj.keepFontStrings(_, obj, hide)
	--@debug@
	_G.assert(obj, "Missing object kFS\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	for _, reg in _G.ipairs{obj:GetRegions()} do
		if not reg:IsObjectType("FontString") then
			if not hide then
				reg:SetAlpha(0)
			else
				reg:Hide()
			end
		end
	end

end

function aObj:keepRegions(obj, regions)
	--@debug@
	_G.assert(obj, "Missing object kR\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	local tmpTab = _G.tInvert(regions)
	for key, reg in _G.ipairs{obj:GetRegions()} do
		if not tmpTab[key] then
			reg:SetAlpha(0)
			--@debug@
			if reg:IsObjectType("FontString") then
				self:Debug("kr FS: [%s, %s]", obj, key)
				self:Print(_G.debugstack(1, 5, 2))
			end
			--@end-debug@
		end
	end

end

function aObj:makeMFRotatable(modelFrame)
	--@debug@
	_G.assert(modelFrame and modelFrame:IsObjectType("PlayerModel"), "Not a PlayerModel\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- Don't make Model Frames Rotatable if CloseUp is loaded
	if _G.C_AddOns.IsAddOnLoaded("CloseUp") then return end

	-- hide rotation buttons
	for _, child in _G.ipairs{modelFrame:GetChildren()} do
		if self:hasTextInName(child, "Rotate") then
			child:Hide()
		end
	end

	if modelFrame.RotateLeftButton then
		modelFrame.RotateLeftButton:Hide()
		modelFrame.RotateRightButton:Hide()
	end

	if modelFrame.controlFrame then
		modelFrame.controlFrame:DisableDrawLayer("BACKGROUND")
	end

end

function aObj:makeIconSquare(obj, iconObjName, clr, rpArray)

	obj[iconObjName]:SetTexCoord(.1, .9, .1, .9)

	if self.modBtnBs then
		self:addButtonBorder{obj=obj, relTo=obj[iconObjName], reParent=rpArray, ofs=3, clr=clr}
	end

end

local function __moveObject(opts)
	--[[
		Calling parameters:
			obj = object (Mandatory)
			x = left/right adjustment
			y = up/down adjustment
			relTo = object to move relative to
	--]]

	--@debug@
	if opts.obj:GetNumPoints() > 1 then
		aObj:CustomPrint(1, 0, 0, "moveObject: %s, GetNumPoints = %d\n%s", opts.obj, opts.obj:GetNumPoints())
		_G.assert(false, _G.debugstack(2, 3, 2) )
		return
	end
	--@end-debug@

	local point, relTo, relPoint, xOfs, yOfs = opts.obj:GetPoint()

	-- handle no Point info
	if not point then return end

	relTo = opts.relTo or relTo
	--@debug@
	_G.assert(relTo, "__moveObject relTo is nil\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@
	-- Workaround for relativeTo crash
	if not relTo then
		if aObj.prdb.Warnings then
			aObj:CustomPrint(1, 0, 0, "moveObject (relativeTo) is nil: %s", opts.obj)
		end
		return
	end

	-- apply the adjustment
	xOfs = opts.x and xOfs + opts.x or xOfs
	yOfs = opts.y and yOfs + opts.y or yOfs

	-- now move it
	opts.obj:ClearAllPoints()
	opts.obj:SetPoint(point, relTo, relPoint, xOfs, yOfs)
end
function aObj.moveObject(_, ...)

	local opts = _G.select(1, ...)

	--@debug@
	_G.assert(opts, "Missing object mO\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if _G.type(_G.rawget(opts, 0)) == "userdata" and _G.type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = _G.select(1, ...) and _G.select(1, ...) or nil
		opts.x = _G.select(3, ...) and _G.select(3, ...) or nil
		if _G.select(2, ...) and _G.select(2, ...) == "-" then opts.x = opts.x * -1 end
		opts.y = _G.select(5, ...) and _G.select(5, ...) or nil
		if _G.select(4, ...) and _G.select(4, ...) == "-" then opts.y = opts.y * -1 end
		opts.relTo = _G.select(6, ...) and _G.select(6, ...) or nil
	end

	__moveObject(opts)

end

function aObj.nilTexture(_, obj, nop)
	--@debug@
	_G.assert(false, "calling nilTexture function" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	obj:SetTexture(nil)
	obj:SetAtlas(nil)

	if nop then
		obj.SetTexture = _G.nop
		obj.SetAtlas = _G.nop
	end

end

function aObj:rawHook(obj, method, func, sec)

	if not self:IsHooked(obj, method) then
		self:RawHook(obj, method, func, sec)
	end

end

function aObj.removeBackdrop(_, obj, nop)

	if obj.ClearBackdrop then
		obj:ClearBackdrop()
		if nop then
			obj.ApplyBackdrop = _G.nop
		end
	elseif obj.SetBackdrop then
		obj:SetBackdrop(nil)
		if nop then
			obj.SetBackdrop = _G.nop
		end
	end

end

local function ddlBBO(frame)
	frame:DisableDrawLayer("BACKGROUND")
	frame:DisableDrawLayer("BORDER")
	frame:DisableDrawLayer("OVERLAY")
end
function aObj:removeInset(frame)
	--@debug@
	_G.assert(frame, "Unknown object removeInset\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	ddlBBO(frame)
	-- InsetFrameTemplate can have a NineSlice child
	if frame.NineSlice then
		self:removeNineSlice(frame.NineSlice)
	end

end

function aObj.removeMagicBtnTex(_, btn)
	--@debug@
	_G.assert(btn, "Unknown object removeMagicBtnTex\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	-- Magic Button textures
	for _, prefix in _G.pairs{"Left", "Right"} do
		if btn[prefix .. "Separator"] then
			btn[prefix .. "Separator"]:SetTexture(nil)
		end
	end

end

function aObj.removeNineSlice(_, frame)
	--@debug@
	_G.assert(frame, "Unknown object removeNineSlice\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	ddlBBO(frame)

end

function aObj:removeRegions(obj, regions)
	--@debug@
	_G.assert(obj, "Missing object (removeRegions)\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	local tmpTab = _G.tInvert(regions)
	for key, reg in _G.pairs{obj:GetRegions()} do
		if tmpTab[key] then
			reg:SetAlpha(0)
			--@debug@
			if reg:IsObjectType("FontString") then
				self:Debug("rr FS: [%s, %s]", obj, key)
				self:Print(_G.debugstack(1, 5, 2))
			end
			--@end-debug@
		end
	end

end

function aObj:resizeEmptyTexture(texture)
	--@debug@
	_G.assert(texture, "Unknown object resizeEmptyTexture\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	texture:SetTexture(self.tFDIDs.esTex)
	texture:SetSize(64, 64)
	texture:SetTexCoord(0, 1, 0, 1)
	texture:ClearAllPoints()
	texture:SetPoint("CENTER", texture:GetParent())

end

function aObj:rmRegionsTex(obj, regions)
	--@debug@
	aObj:CustomPrint(1, 0, 0, "Using deprecated function - rmRegionsTex, use removeRegions(obj, regions) instead", obj)
	--@end-debug@

	self:removeRegions(obj, regions)

end

function aObj.round2(_, num, idp)
	--@debug@
	_G.assert(num, "Missing number\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

  return _G.tonumber(_G.string.format("%." .. (idp or 0) .. "f", num))

end

function aObj.scanChildren(_, opts)

	local method = not opts.reversed and _G.ipairs or _G.ipairs_reverse
	for idx, child in method{opts.obj:GetChildren()} do
		-- check for forbidden objects (StoreUI components etc.)
		if not child:IsForbidden() then
			aObj.callbacks:Fire(opts.cbstr, child, idx)
		end
	end
	-- remove callback
	aObj.callbacks.events[opts.cbstr] = nil

end

function aObj:scanUIParentsChildren()
	--@debug@
	_G.assert(false, "Replace this function call with aObj:scanChildren{obj=_G.UIParent, cbstr=\"UIParent_GetChildren\"}")
	--@end-debug@

	self:scanChildren{obj=_G.UIParent, cbstr="UIParent_GetChildren"}

end

function aObj:secureHook(obj, method, func)

	if not self:IsHooked(obj, method) then
		self:SecureHook(obj, method, func)
	end

end

function aObj:secureHookScript(obj, method, func)

	if not self:IsHooked(obj, method) then
		self:SecureHookScript(obj, method, func)
	end

end

function aObj:setActiveTab(tabSF)
	--@debug@
	_G.assert(tabSF, "Missing object sAT\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	if not tabSF then return end
	if not tabSF.tfade then return end

	tabSF.tfade:SetTexture(self.gradientTex)
	tabSF.tfade:SetGradient(self:getGradientInfo(self.prdb.Gradient.invert, self.prdb.Gradient.rotate))

end

function aObj:setInactiveTab(tabSF)
	--@debug@
	_G.assert(tabSF, "Missing object sIT\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	if not tabSF then return end
	if not tabSF.tfade then return end

	tabSF.tfade:SetTexture(self.itTex)
	tabSF.tfade:SetAlpha(1)

end

function aObj:setupBackdrop()

	local dflts = self.db.defaults.profile

	self.bdTexName = dflts.BdTexture
	self.bdbTexName = dflts.BdBorderTexture
	if self.prdb.BdDefault then
		self.backdrop = {
			bgFile = self.LSM:Fetch("background", self.bdTexName),
			tile = dflts.BdTileSize > 0 and true or false, tileSize = dflts.BdTileSize,
			edgeFile = self.LSM:Fetch("border", self.bdbTexName),
			edgeSize = dflts.BdEdgeSize,
			insets = {left = dflts.BdInset, right = dflts.BdInset, top = dflts.BdInset, bottom = dflts.BdInset},
		}
	else
		if self.prdb.BdFile
		and self.prdb.BdFile ~= "None"
		then
			self.bdTexName = aName .. " User Backdrop"
			self.LSM:Register("background", self.bdTexName, self.prdb.BdFile)
		else
			self.bdTexName = self.prdb.BdTexture
		end
		if self.prdb.BdEdgeFile
		and self.prdb.BdEdgeFile ~= "None"
		then
			self.bdbTexName = aName .. " User Border"
			self.LSM:Register("border", self.bdbTexName, self.prdb.BdEdgeFile)
		else
			self.bdbTexName = self.prdb.BdBorderTexture
		end
		self.backdrop = {
			bgFile = self.LSM:Fetch("background", self.bdTexName),
			tile = self.prdb.BdTileSize > 0 and true or false, tileSize = self.prdb.BdTileSize,
			edgeFile = self.LSM:Fetch("border", self.bdbTexName),
			edgeSize = self.prdb.BdEdgeSize,
			insets = {left = self.prdb.BdInset, right = self.prdb.BdInset, top = self.prdb.BdInset, bottom = self.prdb.BdInset},
		}
	end

end

function aObj:setupFramesOptions(optTab, framesType)

	local opt, oDesc
	for optName, optVals in _G.pairs(optTab) do
		oDesc = optName
		if _G.type(optVals) == "table" then
			if optVals.desc then
				oDesc = optVals.desc
			elseif optVals.pref then
				oDesc = _G.string.format("%s %s", optVals.pref, optName)
			elseif optVals.suff then
				oDesc = _G.string.format("%s %s", optName, optVals.suff)
			end
		end
		opt = optName:gsub("%s+", "")
		-- aObj:Debug("setupFramesOptions: [%s, %s, %s, %s, %s]", optName, optVals, opt, oDesc)
		self.db.defaults.profile[opt] = true
		if self.db.profile[opt] == nil then
			self.db.profile[opt] = true
		end
		self.optTables[framesType .. " Frames"].args[opt] = {
			type = "toggle",
			name = self.L[oDesc],
			desc = _G.strjoin(" ", self.L["Toggle the skin of the"], self.L[oDesc]),
			width = oDesc:len() > 21 and "double" or nil,
		}
	end

end

function aObj:setupTextures()
	--[[
		N.B. Texture paths replaced by FileDataIDs
		These can be found here: https://wow.tools/files/#search=&page=1&sort=0&desc=asc
			-- 136509 - ui-backpack-emptyslot
			-- 4701874 - bagitemslot2x
			-- 651080 - whiteiconframe
			-- 130841 - ui-quickslot2
	--]]
	self.tFDIDs = {
		["bHLS"]      = _G.GetFileIDFromPath([[Interface\Buttons\ButtonHilight-Square]]), -- blue highlight with black background
		["bHLSQ"]     = _G.GetFileIDFromPath([[Interface\Buttons\ButtonHilight-SquareQuickslot]]), -- smaller & lighter blue highlight with black background
		["cbH"]       = _G.GetFileIDFromPath([[Interface\Buttons\CheckButtonHilight]]), -- yellow highlight with black background
		["cfEA"]      = _G.GetFileIDFromPath([[Interface\ChatFrame\ChatFrameExpandArrow]]),
		["hfHB"]      = _G.GetFileIDFromPath([[Interface\HelpFrame\HelpButtons]]),
		["cbMin"]     = _G.GetFileIDFromPath([[interface\Common\MinimalCheckbox.blp]]),
		["cbSC"]      = _G.GetFileIDFromPath([[Interface\Buttons\UI-Checkbox-SwordCheck]]),
		["cbUP"]      = _G.GetFileIDFromPath([[interface\Buttons\UI-CheckBox-Up]]),
		["ccLF"]      = _G.GetFileIDFromPath([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]]),
		["cfBg"]      = _G.GetFileIDFromPath([[Interface\ChatFrame\ChatFrameBackground]]),
		["ctabHL"]    = _G.GetFileIDFromPath([[Interface\PaperDollInfoFrame\UI-Character-Tab-Highlight]]),
		["dpI"]       = _G.GetFileIDFromPath([[Interface\PetBattles\DeadPetIcon]]),
		["ejt"]       = _G.GetFileIDFromPath([[Interface\EncounterJournal\UI-EncounterJournalTextures]]),
		["enI"]       = _G.GetFileIDFromPath([[Interface\Tooltips\EliteNameplateIcon]]),
		["esTex"]     = _G.GetFileIDFromPath([[Interface\Buttons\UI-Quickslot2]]),
		["gAOI"]      = _G.GetFileIDFromPath([[Interface\Glues\CharacterSelect\Glues-AddOn-Icons]]),
		["gearWhl"]   = _G.GetFileIDFromPath([[Interface\AddOns\]] .. aName .. [[\Textures\gear]]),
		["inactTab"]  = _G.GetFileIDFromPath([[Interface\AddOns\]] .. aName .. [[\Textures\inactive]]),
		["lfgIR"]     = _G.GetFileIDFromPath([[Interface\AddOns\]] .. aName .. [[\Textures\lfgroles]]),
		["lvlBG"]     = _G.GetFileIDFromPath([[Interface\PetBattles\BattleBar-AbilityBadge-Neutral]]),
		["mHG"]       = _G.GetFileIDFromPath([[Interface\Common\mini-hourglass]]),
		["mpTex"]     = _G.GetFileIDFromPath([[Interface\Common\UI-ModelControlPanel]]),
		["mpw01"]     = _G.GetFileIDFromPath([[Interface\Icons\INV_Misc_Pelt_Wolf_01]]),
		["pMBHL"]     = _G.GetFileIDFromPath([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]]),
		["qltHL"]     = _G.GetFileIDFromPath([[Interface\QuestFrame\UI-QuestLogTitleHighlight]]),
		["rB"]        = _G.GetFileIDFromPath([[Interface\Glues\CharacterSelect\RestoreButton]]),
		["renI"]      = _G.GetFileIDFromPath([[Interface\Tooltips\RareEliteNameplateIcon]]),
		["rareNP"]    = _G.GetFileIDFromPath([[Interface\AddOns\]] .. aName .. [[\Textures\RareNameplateIcon]]),
		["shieldTex"] = _G.GetFileIDFromPath([[Interface\CastingBar\UI-CastingBar-Arena-Shield]]),
		["skinBdr"]   = _G.GetFileIDFromPath([[Interface\AddOns\]] .. aName .. [[\Textures\krsnik]]),
		["tfBF"]      = _G.GetFileIDFromPath([[Interface\TargetingFrame\UI-TargetingFrame-BarFill]]),
		["tMB"]       = _G.GetFileIDFromPath([[Interface\Minimap\Tracking\Mailbox]]),
		["w8x8"]      = _G.GetFileIDFromPath([[Interface\Buttons\WHITE8X8]]),
	}

end

local fObj, method
function aObj:skinPageBtns(frame)
	if frame.PagingControls then
		fObj = frame.PagingControls
		method = "UpdateControls"
	else
		fObj = frame.PagingFrame
		method = "Update"
	end
	self:skinPagingControls(fObj)
	self:SecureHook(fObj, method, function(this)
		self:clrPNBtns(this, true)
	end)
end

function aObj:updateSBTexture()

	-- get updated colour/texture
	local sBar = self.prdb.StatusBar
	self.sbTexture = self.LSM:Fetch("statusbar", sBar.texture)
	self.sbClr = _G.CreateColor(sBar.r, sBar.g, sBar.b, sBar.a)

	for obj, tab in _G.pairs(self.sbGlazed) do
		if obj:IsObjectType("StatusBar") then
			obj:SetStatusBarTexture(self.sbTexture)
		else
			obj:SetTexture(self.sbTexture)
		end
		for k, tex in _G.pairs(tab) do
			tex:SetTexture(self.sbTexture)
			if k == "bg" then tex:SetVertexColor(self.sbClr:GetRGBA()) end
		end
	end

end

function aObj.unwrapTextFromColourCode(_, text, sOfs, eOfs)

	local newText = _G.gsub(text, "\124", "\124\124") -- turn Hex string into text

	if _G.strlen(newText) == _G.strlen(text) then return text end

	local clrCode = _G.strsub(newText, 6, 11)
	newText = _G.strsub(newText, sOfs or 12, eOfs or -4) -- remove colour prefix and suffix
	newText = _G.gsub(newText, "\124\124", "\124") -- convert string to Hex for any embedded characters (e.g. newlines)
	return newText, clrCode

end

function aObj.RaiseFrameLevelByFour(_, frame)

	frame:SetFrameLevel(frame:GetFrameLevel() + 4)

end

--@debug@
function aObj:SetupCmds()

	local function getMouseFocus()
		return _G.GetMouseFoci()[1]:GetParent()
	end

	local function makeString(obj)
		if _G.type(obj) == "table" then
			if _G.type(_G.rawget(obj, 0)) == "userdata"
			and _G.type(obj.GetObjectType) == "function"
			then
				return ("<%s:%s:%s>"):format(_G.tostring(obj), obj:GetObjectType(), obj:GetName() or "(Anon)")
			end
		end
		return _G.tostring(obj)
	end
	local function makeText(fStr, ...)
		local tmpTab = {}
		local output = ""
		if fStr
		and fStr.find
		and fStr:find("%%")
		and _G.select('#', ...) >= 1
		then
			for i = 1, _G.select('#', ...) do
				tmpTab[i] = makeString(_G.select(i, ...))
			end
			 -- handle missing variables
			local varCnt = _G.select(2, fStr:gsub("%%", ""))
			for i = #tmpTab, varCnt do
				tmpTab[i + 1] = "nil"
			end
			output = _G.string.join(" ", fStr:format(_G.unpack(tmpTab)))
		else
			tmpTab[1] = output
			tmpTab[2] = fStr and _G.type(fStr) == "table" and makeString(fStr) or fStr or ""
			for i = 1, _G.select('#', ...) do
				tmpTab[i + 2] = makeString(_G.select(i, ...))
			end
			output = _G.table.concat(tmpTab, " ")
		end
		return output
	end
	local function print_family_tree(fName)
		if fName:IsForbidden() then
			_G.print("Frame access is forbidden", fName)
			return
		end
		local lvl = "Parent"
		_G.print(makeText("Frame is %s, %s, %s, %s, %s", fName, fName:GetFrameLevel(), fName:GetFrameStrata(), _G.Round(fName:GetWidth()) or "nil", _G.Round(fName:GetHeight()) or "nil"))
		while fName:GetParent() do
			fName = fName:GetParent()
			_G.print(makeText("%s is %s, %s, %s, %s, %s", lvl, fName, (fName:GetFrameLevel() or "<Anon>"), (fName:GetFrameStrata() or "<Anon>"), _G.Round(fName:GetWidth()) or "nil", _G.Round(fName:GetHeight()) or "nil"))
			lvl = (lvl:find("Grand") and "Great" or "Grand") .. lvl
		end
	end
	local function getObjFromString(input)
		local tmpTab = {}
		-- first split the string on "."
		for word in _G.string.gmatch(input, "%w+") do
			tmpTab[#tmpTab + 1] = word
		end
		-- then build string in the form _G["str1"]["str2"]...["strn"]
		local objString = "_G"
		for _, t in _G.pairs(tmpTab) do
			objString = objString .. '["' .. t .. '"]'
		end
		-- finally use loadstring to get the object from the command
		-- _G.print("getObjFromString", input, objString)
		return _G.assert(_G.loadstring("return " .. objString)())
	end
	local function getObj(input)
		 _G.print("getObj", input, _G[input], getMouseFocus())
		if not input or input:trim() == "" then
			return getMouseFocus()
		else
			return getObjFromString(input)
		end
	end
	local function getObjP(input)
		_G.print("getObjP", input, _G[input], getMouseFocus():GetParent())
		if not input or input:trim() == "" then
			return getMouseFocus():GetParent()
		else
			return getObjFromString(input)
		end
	end
	local function getObjGP(input)
		-- _G.print("getObjGP", input, _G[input], getMouseFocus():GetParent():GetParent())
		if not input or input:trim() == "" then
			return getMouseFocus():GetParent():GetParent()
		else
			return getObjFromString(input)
		end
	end
	local function showIt(...)
		aObj:Debug3(...)
	end
	local function getRegions(cObj, lvl)
		for k, reg in _G.ipairs{cObj:GetRegions()} do
			showIt("[lvl%sr%s : %s : %s : %s : %s : %s]", lvl, k, reg, reg:GetObjectType() or "nil", reg.GetWidth and _G.Round(reg:GetWidth()) or "nil", reg.GetHeight and _G.Round(reg:GetHeight()) or "nil", reg:GetObjectType() == "Texture" and ("%s : %s"):format(reg:GetTexture() or "nil", reg:GetDrawLayer() or "nil") or "nil")
		end
	end
	local function getChildren(frame, lvl, showKids, noDepth)
		if not showKids then return end
		if lvl > 1 and noDepth then return end

		self.RegisterCallback("UTFgC", frame:GetDebugName() .. "_getChildren_" .. _G.tostring(lvl), function(_, child, key)
			showIt("[lvl%sc%s : %s : %s : %s : %s : %s]", lvl, key, child, child.GetWidth and _G.Round(child:GetWidth()) or "nil", child.GetHeight and _G.Round(child:GetHeight()) or "nil", child:GetFrameLevel() or "nil", child:GetFrameStrata() or "nil")
			local objType = child:GetObjectType()
			if objType == "Frame"
			or objType == "Button"
			or objType == "StatusBar"
			or objType == "Slider"
			or objType == "ScrollFrame"
			then
				getRegions(child, lvl .. "c" .. key)
				getChildren(child, lvl + key, showKids, noDepth)
			end
		end)
		self:scanChildren{obj=frame, cbstr=frame:GetDebugName() .. "_getChildren_" .. _G.tostring(lvl), reversed=false}

	end
	local function showInfo(obj, showKids, noDepth)
		_G.print("showInfo:", obj, showKids, noDepth, obj.IsForbidden and obj:IsForbidden())
		_G.assert(obj, "Unknown object showInfo\n" .. _G.debugstack(2, 3, 2))
		if obj.IsForbidden and obj:IsForbidden() then return end
		showKids = showKids or false
		noDepth = noDepth or false
		showIt("%s : %s : %s : %s : %s : %s : %s", obj, _G.Round(obj:GetWidth()) or "nil", _G.Round(obj:GetHeight()) or "nil", obj:GetFrameLevel() or "nil", obj:GetFrameStrata() or "nil", obj:GetNumRegions(), obj:GetNumChildren())
		showIt("Started Regions")
		getRegions(obj)
		showIt("Finished Regions")
		showIt("Started Children")
		getChildren(obj, 0, showKids, noDepth)
		showIt("Finished Children")
	end

	self:RegisterChatCommand("ft", function() print_family_tree(getMouseFocus()) end)
	self:RegisterChatCommand("ftp", function() print_family_tree(getMouseFocus():GetParent()) end)
	self:RegisterChatCommand("gp", function() _G.print(getMouseFocus():GetPoint()) end)
	self:RegisterChatCommand("gpp", function() _G.print(getMouseFocus():GetParent():GetPoint()) end)
	self:RegisterChatCommand("lo", function() _G.UIErrorsFrame:AddMessage("Use /camp instead of /lo", 1.0, 0.1, 0.1, 1.0) end)
	self:RegisterChatCommand("pii", function(msg) _G.print(_G.C_Item.GetItemInfo(msg)) end)
	self:RegisterChatCommand("pil", function(msg) _G.print(_G.gsub(msg, "\124", "\124\124")) end)
	self:RegisterChatCommand("pin", function(msg) _G.print(msg, "is item:", (_G.C_Item.GetItemInfoFromHyperlink(msg))) end)
	-- self:RegisterChatCommand("rl", function() _G.C_UI.Reload() end)
	self:RegisterChatCommand("si1", function(msg) showInfo(getObj(msg), true, true) end) -- 1 level only
	self:RegisterChatCommand("si1p", function(msg) showInfo(getObjP(msg), true, true) end) -- 1 level only
	self:RegisterChatCommand("si1gp", function(msg) showInfo(getObjGP(msg), true, true) end) -- 1 level only
	self:RegisterChatCommand("sid", function(msg) showInfo(getObj(msg), true, false) end) -- detailed
	self:RegisterChatCommand("sidp", function(msg) showInfo(getObjP(msg), true, false) end) -- detailed
	self:RegisterChatCommand("sidgp", function(msg) showInfo(getObjGP(msg), true, false) end) -- detailed
	self:RegisterChatCommand("sir", function(msg) showInfo(getObj(msg), false, false) end) -- regions only
	self:RegisterChatCommand("sirp", function(msg) showInfo(getObjP(msg), false, false) end) -- regions only
	self:RegisterChatCommand("sirgp", function(msg) showInfo(getObjGP(msg), false, false) end) -- regions only
	self:RegisterChatCommand("mspew", function(_) return _G.Spew and _G.Spew("", getMouseFocus()) end)
	self:RegisterChatCommand("sspew", function(msg) return _G.Spew and _G.Spew(msg, getObj(msg)) end)
	self:RegisterChatCommand("sspewp", function(msg) return _G.Spew and _G.Spew(msg, getObjP(msg)) end)
	self:RegisterChatCommand("sspewgp", function(msg) return _G.Spew and _G.Spew(msg, getObjGP(msg)) end)

	self:RegisterChatCommand("shc", function() self:Debug("Hooks table Count: [%s]", _G.CountTable(self.hooks)) end)

	self:RegisterChatCommand("wai", function() -- where am I ?
		local posTab = _G.C_Map.GetPlayerMapPosition(_G.C_Map.GetBestMapForUnit("player"), "player")
		_G.DEFAULT_CHAT_FRAME:AddMessage(_G.format("%s, %s: %.1f, %.1f", _G.GetZoneText(), _G.GetSubZoneText(), posTab.x * 100, posTab.y * 100))
		return
	end)

	local loadAddOn = _G.LoadAddOn or _G.C_AddOns.LoadAddOn
	self:RegisterChatCommand("tad", function(frame) loadAddOn("Blizzard_DebugTools"); _G.TableAttributeDisplay:InspectTable(_G[frame] or getMouseFocus()); _G.TableAttributeDisplay:Show() end)

end
--@end-debug@
