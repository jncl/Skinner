local _, aObj = ...
if not aObj:isAddonEnabled("BetterBags") then return end
local _G = _G

aObj.addonsToSkin.BetterBags = function(self) -- v 0.3.42

	local bBag = _G.LibStub("AceAddon-3.0"):GetAddon("BetterBags", true)
	if not bBag then return end

	local skinBtn = _G.nop
	if self.modBtnBs then
		function skinBtn(btn, empty)
			aObj:addButtonBorder{obj=btn, ibt=true, ofs=3}
			if empty then
				if aObj.isMnln then
					btn.ItemSlotBackground:SetTexture(nil)
				else
					_G.SetItemButtonTexture(btn, nil)
				end
			end
		end
		local events = bBag:GetModule("Events", true)
		events:RegisterMessage("item/NewButton", function(_, item, decoration)
			skinBtn(decoration, item.isFreeSlot)
		end)
		events:RegisterMessage("item/Updated", function(_, item, decoration)
			skinBtn(decoration, item.isFreeSlot)
		end)
	end
	self:SecureHookScript(_G.BetterBagsEmptySlotTooltip, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true})

		self:Unhook(this, "OnShow")
	end)

	local function skinFrame(frame, dontBg)
		if frame.Bg then
			if frame.Bg:IsObjectType("frame") then
				frame.Bg:DisableDrawLayer("BACKGROUND")
			else
				frame.Bg:SetTexture(nil)
			end
		end
		if frame.TitleContainer
		and frame.TitleContainer.TitleBg
		then
			frame.TitleContainer.TitleBg:SetTexture(nil)
		end
		if frame.search then
			aObj:skinObject("editbox", {obj=frame.search.textBox, si=true})
		end
		aObj:skinObject("frame", {obj=frame, kfs=true, cb=true, bg=not dontBg and true or nil})
	end
	local function skinSubFrame(fObj)
		aObj:SecureHookScript(fObj.frame, "OnShow", function(this)
			skinFrame(aObj:getLastChild(this)) -- decorator frame

			aObj:Unhook(this, "OnShow")
		end)
		aObj:skinObject("scrollbar", {obj=fObj.content.ScrollBar or fObj.content.bar})
		if fObj.content.ScrollBox then
			local function skinContentElement(...)
				local _, element, elementData
				if _G.select("#", ...) == 2 then
					element, elementData = ...
				else
					_, element, elementData = ...
				end
				aObj:removeBackdrop(element)
			end
			_G.ScrollUtil.AddInitializedFrameCallback(fObj.content.ScrollBox, skinContentElement, aObj, true)
		end
	end
	local function handleBag(bagObj)
		aObj:SecureHookScript(bagObj.frame, "OnShow", function(this)
			skinFrame(aObj:getLastChild(this)) -- decorator frame

			aObj:Unhook(this, "OnShow")
		end)

		aObj:SecureHookScript(bagObj.slots.frame, "OnShow", function(this)
			skinFrame(aObj:getLastChild(this)) -- decorator frame

			aObj:Unhook(this, "OnShow")
		end)
		if aObj.modBtnBs then
			local function skinBagSlots(frame)
				for _, cell in _G.ipairs(frame.content.cells) do
					skinBtn(cell.frame, cell.empty)
					if cell.canBuy then
						aObj:clrBBC(cell.frame.sbb, "red")
					end
				end
			end
			aObj:SecureHook(bagObj.slots, "Draw", function(fObj)
				skinBagSlots(fObj)
			end)
			skinBagSlots(bagObj.slots)
		end
		if bagObj.currencyFrame then
			skinSubFrame(bagObj.currencyFrame)
			if aObj.modBtnBs then
				local info
				local function skinCurBtns(frame)
					for _, cell in _G.ipairs(frame.content.cells) do
						if aObj.isMnln then
							info = _G.C_CurrencyInfo.GetCurrencyListInfo(cell.index)
						else
							info = {_G.GetCurrencyListInfo(cell.index)}
						end
						aObj:addButtonBorder{obj=cell.frame, relTo=cell.icon, clr="grey", hide=info.isHeader or info[2]}
					end
				end
				aObj:SecureHook(bagObj.currencyFrame, "Update", function(this)
					skinCurBtns(this)
				end)
				skinCurBtns(bagObj.currencyFrame)
			end
		end
		if bagObj.themeConfigFrame then
			skinSubFrame(bagObj.themeConfigFrame)
		end
		if bagObj.sectionConfigFrame then
			skinSubFrame(bagObj.sectionConfigFrame)
			skinSubFrame(bagObj.sectionConfigFrame.itemList)
		end
	end

	handleBag(bBag.Bags.Backpack)
	if not self.isMnln then
		handleBag(bBag.Bags.Bank)
	end

	local searchBox = bBag:GetModule("SearchBox", true)
	self:SecureHook(searchBox, "CreateBox", function(this)
		self:skinObject("editbox", {obj=this.textBox, si=true})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BetterBagsSearchFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this})

		self:Unhook(this, "OnShow")
	end)

	local scc = bBag:GetModule("SearchCategoryConfig")
	self:SecureHookScript(scc.frame, "OnShow", function(this)
		local td = aObj:getLastChild(this)
		skinFrame(td, true) -- decorator frame
		td.sf:SetFrameLevel(0)

		self:skinObject("editbox", {obj=scc.nameBox})
		self:skinObject("frame", {obj=scc.queryBox, kfs=true, fb=true, ofs=8})
		self:skinObject("editbox", {obj=scc.priorityBox})
		if self.modBtns then
			self:skinStdButton{obj=scc.saveButton}
			self:skinStdButton{obj=scc.cancelButton}
		end

		self:Unhook(this, "OnShow")
	end)

	local config = bBag:GetModule("Config", true)
	local cf, lo = config.configFrame
	self:skinObject("scrollbar", {obj=cf.ScrollBar})
	self:SecureHookScript(cf.frame, "OnShow", function(this)
		skinFrame(aObj:getLastChild(this), true) -- decorator frame

		lo = cf.layout
		for frame, _ in _G.pairs(lo.dropdowns) do
			if not self.isMnln then
				self:skinObject("dropdown", {obj=frame.classicDropdown, x2=-260})
			else
				self:skinObject("ddbutton", {obj=frame.dropdown})
			end
		end
		for frame, _ in _G.pairs(lo.sliders) do
			self:skinObject("slider", {obj=frame.slider})
			self:skinObject("editbox", {obj=frame.input})
		end
		for frame, _ in _G.pairs(lo.textAreas) do
			self:skinObject("frame", {obj=self:getChild(self:getChild(frame, 1), 4), kfs=true, fb=true}) -- scrollBackground
		end
		if self.modBtns then
			for frame, _ in _G.pairs(lo.buttonGroups) do
				for _, btn in _G.pairs(frame.buttons) do
					self:skinStdButton{obj=btn}
				end
			end
		end
		if self.modChkBtns then
			for frame, _ in _G.pairs(lo.checkboxes) do
				self:skinCheckButton{obj=frame.checkbox, size=28}
			end
		end

		self:Unhook(this, "OnShow")
	end)

end
