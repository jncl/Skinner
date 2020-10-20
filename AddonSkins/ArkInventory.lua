local aName, aObj = ...
if not aObj:isAddonEnabled("ArkInventory") then return end
local _G = _G

aObj.addonsToSkin.ArkInventory = function(self) -- v 30931
	if not self.db.profile.ContainerFrames.skin then return end

	local function skinAIFrames(frame)
		local frameName = frame:GetName()
		_G[frameName .. "SearchFilter"]:SetPoint("TOP", _G[frameName .. "Search"], "TOP", 0, -5)
		_G[frameName .. "SearchFilter"]:SetPoint("BOTTOM", _G[frameName .. "Search"], "BOTTOM", 0, 3)
		aObj:skinEditBox{obj=_G[frameName .. "SearchFilter"], regs={6}}
		frameName = nil
	end

	-- hook this to manage the frame borders
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
	-- hook this to skin the frames
	self:SecureHook(_G.ArkInventory, "Frame_Main_Draw", function(frame)
		skinAIFrames(frame)
	end)
	self:RawHook(_G.ArkInventory, "SetTexture", function(obj, texture, r, g, b, a, c)
		if texture == true then
			texture = self.Backdrop[1].bgFile
			r, g, b, a = self.bClr:GetRGBA()
			self:applyGradient(obj:GetParent())
		end
		self.hooks[_G.ArkInventory].SetTexture(obj, texture, r, g, b, a, c)
	end, true)

	-- GuildBank Frame a.k.a. Vault
	self:skinSlider{obj=_G.ARKINV_Frame4InfoScroll.ScrollBar}
	_G.ARKINV_Frame4ChangerWindowAction:DisableDrawLayer("BACKGROUND") -- remove button border texture
	if self.modBtns then
		self:skinStdButton{obj=_G.ARKINV_Frame4InfoSave, as=true} -- use as=true to make text appear above button
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.ARKINV_Frame4ChangerWindowAction, ofs=-2, x1=0}
	end

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
	self:skinEditBox(_G.ARKINV_RulesFrameViewSearchFilter, {6})
	self:skinSlider{obj=_G.ARKINV_RulesFrameViewTableScroll.ScrollBar}
	if self.modBtns then
		self:skinStdButton{obj=_G.ARKINV_RulesFrameViewMenuAdd, as=true}
		self:skinStdButton{obj=_G.ARKINV_RulesFrameViewMenuEdit, as=true}
		self:skinStdButton{obj=_G.ARKINV_RulesFrameViewMenuRemove, as=true}
	end

	-- Modify (Add/Edit/Remove)
	self:applyGradient(_G.ARKINV_RulesFrameModifyTitle)
	self:skinEditBox(_G.ARKINV_RulesFrameModifyDataOrder, {6})
	self:skinEditBox(_G.ARKINV_RulesFrameModifyDataDescription, {6})
	self:skinSlider{obj=_G.ARKINV_RulesFrameModifyDataScroll.ScrollBar}
	if self.modBtns then
		self:skinStdButton{obj=_G.ARKINV_RulesFrameModifyMenuOk, as=true}
		self:skinStdButton{obj=_G.ARKINV_RulesFrameModifyMenuCancel, as=true}
	end

end

aObj.lodAddons.ArkInventorySearch = function(self)

	if self.modBtns then
		self:skinCloseButton{obj=_G.ARKINV_SearchTitleClose, onSB=true, sap=true}
	end
	self:skinEditBox(_G.ARKINV_SearchFrameViewSearchFilter, {6})
	self:skinSlider{obj=_G.ARKINV_SearchFrameViewTableScroll.ScrollBar}

end
