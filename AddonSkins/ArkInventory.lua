local aName, aObj = ...
if not aObj:isAddonEnabled("ArkInventory") then return end
local _G = _G

aObj.addonsToSkin.ArkInventory = function(self) -- v 31208
	if not self.db.profile.ContainerFrames.skin then return end

	local frameName
	local function skinAIFrames(frame)
		frameName = frame:GetName()
		_G[frameName .. "SearchFilter"]:SetPoint("TOP", _G[frameName .. "Search"], "TOP", 0, -5)
		_G[frameName .. "SearchFilter"]:SetPoint("BOTTOM", _G[frameName .. "Search"], "BOTTOM", 0, 3)
		aObj:skinObject("editbox", {obj=_G[frameName .. "SearchFilter"]})
		_G[frameName .. "StatusAction"]:DisableDrawLayer("BACKGROUND") -- remove button border texture
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=_G[frameName .. "StatusAction"], es=12, ofs=-1, x1=0, clr="gold"}
		end
		-- GuildBank Frame a.k.a. Vault
		if _G[frameName .. "Info"] then
			aObj:skinObject("slider", {obj=_G[frameName .. "InfoScroll"].ScrollBar})
			if aObj.modBtns then
				aObj:skinStdButton{obj=_G[frameName .. "InfoSave"], as=true} -- use as=true to make text appear above button
			end
		end
	end

	self:SecureHook(_G.ArkInventory, "Frame_Main_Draw", function(frame)
		skinAIFrames(frame)
	end)

	self:RawHook(_G.ArkInventory, "Frame_Border_Paint", function(obj, file, size, offset, scale, r, g, b, a)
		file = self.Backdrop[1].edgeFile
		size = self.Backdrop[1].edgeSize
		offset = 2
		if r == 1
		and not self:hasTextInName(obj:GetParent(), "Item")
		then
			r, g, b, a = self.bbClr:GetRGBA()
		end
		self.hooks[_G.ArkInventory].Frame_Border_Paint(obj, file, size, offset, scale, r, g, b, a)
	end, true)

	self:RawHook(_G.ArkInventory, "SetTexture", function(obj, texture, r, g, b, a, c)
		if texture == true then
			texture = self.Backdrop[1].bgFile
			r, g, b, a = self.bClr:GetRGBA()
			if obj.GetName
			and obj:GetName()
			and not obj:GetName():find("Item")
			then
				self:applyGradient(obj:GetParent())
			end
		end
		self.hooks[_G.ArkInventory].SetTexture(obj, texture, r, g, b, a, c)
	end, true)

end

aObj.addonsToSkin.ArkInventoryRules = function(self)

	--	Rules Frame
	self:applyGradient(_G.ARKINV_RulesFrameViewTitle)
	self:applyGradient(_G.ARKINV_RulesFrameViewSearch)
	self:applyGradient(_G.ARKINV_RulesFrameViewSort)
	if self.modBtns then
		self:skinCloseButton{obj=_G.ARKINV_RulesTitleClose, onSB=true, sap=true}
	end

	-- View
	self:skinObject("editbox", {obj=_G.ARKINV_RulesFrameViewSearchFilter})
	self:skinObject("slider", {obj=_G.ARKINV_RulesFrameViewTableScroll.ScrollBar})
	if self.modBtns then
		self:skinStdButton{obj=_G.ARKINV_RulesFrameViewMenuAdd, as=true}
		self:skinStdButton{obj=_G.ARKINV_RulesFrameViewMenuEdit, as=true}
		self:skinStdButton{obj=_G.ARKINV_RulesFrameViewMenuRemove, as=true}
	end

	-- Modify (Add/Edit/Remove)
	self:applyGradient(_G.ARKINV_RulesFrameModifyTitle)
	self:skinObject("editbox", {obj=_G.ARKINV_RulesFrameModifyDataOrder})
	self:skinObject("editbox", {obj=_G.ARKINV_RulesFrameModifyDataDescription})
	self:skinObject("slider", {obj=_G.ARKINV_RulesFrameModifyDataScroll.ScrollBar})
	if self.modBtns then
		self:skinStdButton{obj=_G.ARKINV_RulesFrameModifyMenuOk, as=true}
		self:skinStdButton{obj=_G.ARKINV_RulesFrameModifyMenuCancel, as=true}
	end

end

aObj.lodAddons.ArkInventorySearch = function(self)

	self:skinObject("editbox", {obj=_G.ARKINV_SearchFrameViewSearchFilter})
	self:skinObject("slider", {obj=_G.ARKINV_SearchFrameViewTableScroll.ScrollBar})
	if self.modBtns then
		self:skinCloseButton{obj=_G.ARKINV_SearchTitleClose, onSB=true, sap=true}
	end

end
