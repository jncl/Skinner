local _, aObj = ...
if not aObj:isAddonEnabled("Baganator") then return end
local _G = _G

aObj.addonsToSkin.Baganator = function(self) -- v 505

	local skinBtns, skinSpecialistBtns, skinSpecialistBags, skinViewBtns, skinBagSlots = _G.nop, _G.nop, _G.nop, _G.nop, _G.nop
	if self.modBtnBs then
		function skinBtns(frame)
			for _, btn in _G.ipairs(frame.buttons) do
				aObj:addButtonBorder{obj=btn, ibt=true, reParent={btn.ItemLevel, btn.BindingText, btn.UpgradeArrow}}
			end
			-- N.B. DON'T hide SlotBackground/ItemTexture as the AddOn does that. [Theme -> Hide icon backgrounds]
		end
		function skinSpecialistBtns(layout)
			skinBtns(layout.live)
			skinBtns(layout.cached)
			if layout.button then
				aObj:skinStdButton{obj=layout.button, ofs=0} -- Specialist bag button in BLHC
			end
			if layout.divider then
				layout.divider.Divider:SetTexture(nil)
			end
		end
		function skinSpecialistBags(frame, _)
			if frame.CollapsingBags then
				for _, layout in _G.pairs(frame.CollapsingBags) do
					skinSpecialistBtns(layout)
				end
			end
			if frame.CollapsingBankBags then
				for _, layout in _G.pairs(frame.CollapsingBankBags) do
					skinSpecialistBtns(layout)
				end
			end
		end
		local containerTypes = {
			Backpack = {"BagLive", "BagCached"},
			Bank     = {"BankLive", "BankCached"},
			Guild    = {"GuildLive", "GuildCached", "GuildUnifiedLive", "GuildUnifiedCached"},
			Warband  = {"BankTabLive", "BankTabCached", "BankUnifiedLive", "BankUnifiedCached"},
			Category = {"LiveLayouts", "CachedLayouts"},
		}
		local method, ctype
		function skinViewBtns(frame, type)
			if type:find("SV") then
				method = "RebuildLayout"
				ctype = aObj:hasTextInDebugNameRE(frame, "Backpack") and containerTypes.Backpack
				     or aObj:hasTextInDebugNameRE(frame, "Warband") and containerTypes.Warband -- N.B. put Warband before Bank
				     or aObj:hasTextInDebugNameRE(frame, "Bank") and containerTypes.Bank
				     or aObj:hasTextInDebugNameRE(frame, "Guild") and containerTypes.Guild
				for _, view in _G.pairs(ctype) do
					aObj:secureHook(frame.Container[view], method, function(vObj)
						skinBtns(vObj)
					end)
					skinBtns(frame.Container[view])
				end
			else
				method = "ShowGroup"
				ctype = containerTypes.Category
				for _, view in _G.pairs(ctype) do
					for _, layout in _G.pairs(frame[view]) do
						aObj:secureHook(layout, method, function(vObj)
							skinBtns(vObj)
						end)
						skinBtns(layout)
					end
				end
			end
		end
		function skinBagSlots(frame)
			for _, array in _G.pairs{frame.BagSlots.liveBagSlots, frame.BagSlots.cachedBagSlots} do
				for _, btn in _G.pairs(array) do
					aObj:addButtonBorder{obj=btn, ibt=true, clr=btn.needPurchase and "red" or nil}
				end
			end
		end
	end

	local sBox
	local function skinFrame(frame, _)
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		frame:DisableDrawLayer("OVERLAY")
		if not aObj.isRtl then
			frame.TitleText:SetDrawLayer("ARTWORK")
		end
		sBox = frame.SearchBox or frame.searchBox or frame.SearchWidget and frame.SearchWidget.SearchBox
		if sBox then
			aObj:skinObject("editbox", {obj=sBox, si=true})
		end
		if frame.ScrollBar then
			self:skinObject("scrollbar", {obj=frame.ScrollBar})
		end
		aObj:skinObject("frame", {obj=frame, kfs=true, ri=true, cb=true, ofs=3, x2=1, y2=-2})
		if frame.SearchWidget
		and aObj.modBtns
		then
			aObj:skinStdButton{obj=frame.SearchWidget.GlobalSearchButton, sechk=true}
			aObj:skinStdButton{obj=frame.SearchWidget.HelpButton}
		end
	end
	local function skinBag(frame, bagType)
		skinFrame(frame, bagType)
		skinBagSlots(frame)
		aObj:SecureHook(frame, "RefreshTabs", function(fObj)
			aObj:skinObject("tabs", {obj=fObj, tabs=fObj.Tabs, lod=self.isTT and true})
		end)
	end
	local type
	self:SecureHookScript(_G.Baganator_SingleViewBackpackViewFrame, "OnShow", function(this)
		type = "SVBags"

		skinBag(this,type)
		skinViewBtns(this, type)

		self:SecureHook(this, "UpdateForCharacter", function(fObj, _)
			skinSpecialistBags(fObj, type)
			if aObj.modBtns then
				for _, btn in _G.ipairs(fObj.AllButtons) do
					aObj:skinStdButton{obj=btn, schk=true, sechk=true}
				end
			end
		end)

		self:Unhook(this, "OnShow")
	end)

	local function skinCVBtnsAfterDelay(frame, cvType)
		_G.C_Timer.After(_G.CountTable(frame.Container.Layouts) == 0 and 1 or 0, function()
			skinViewBtns(frame, cvType)
		end)
	end
	self:SecureHookScript(_G.Baganator_CategoryViewBackpackViewFrame, "OnShow", function(this)
		type = "CVBags"

		skinBag(this,type)

		self:SecureHook(this, "UpdateForCharacter", function(fObj, _)
			if aObj.modBtns then
				for _, btn in _G.ipairs(fObj.AllButtons) do
					aObj:skinStdButton{obj=btn, schk=true, sechk=true}
				end
			end
			skinCVBtnsAfterDelay(fObj, type)
		end)

		self:Unhook(this, "OnShow")
	end)

	local function skinSideTabs(fObj)
		if fObj.Tabs then
			for _, tab in _G.pairs(fObj.Tabs) do
				tab:DisableDrawLayer("BACKGROUND")
				if aObj.modBtnBs then
					 aObj:addButtonBorder{obj=tab, relTo=tab.Icon, ofs=3, x2=2, schk=true, sechk=true}
				end
			end
		end
	end
	local function skinBank(frame, bankType)
		skinFrame(frame, bankType)
		skinBagSlots(frame.Character)
		aObj:skinObject("tabs", {obj=frame, tabs=frame.Tabs, lod=aObj.isTT and true})
		if aObj.modBtns then
			for _, btn in _G.pairs(frame.AllFixedButtons) do
				aObj:skinStdButton{obj=btn, schk=true, sechk=true}
			end
		end

		if frame.Character.UpdateForCharacter then
			aObj:SecureHook(frame.Character, "UpdateForCharacter", function(fObj, _)
				if aObj.modBtns then
					for _, btn in _G.pairs(fObj.TopButtons) do
						aObj:skinStdButton{obj=btn, schk=true, sechk=true}
					end
				end

				if bankType:find("CV")
				and fObj.BankMissingHint:IsShown()
				then
					return
				end

				if aObj.modBtns then
					for _, btn in _G.pairs(fObj:GetParent().AllButtons) do
						aObj:skinStdButton{obj=btn, schk=true, sechk=true}
					end
				end

				skinCVBtnsAfterDelay(fObj, type)

				if bankType:find("SV") then
					skinSpecialistBags(fObj, bankType)
				end
			end)
		end

		if aObj.isRtl then
			aObj:SecureHookScript(frame.Warband, "OnShow", function(this)
				for _, btn in _G.pairs(this.LiveButtons) do
					if btn:IsObjectType("CheckButton")
					and aObj.modChkBtns
					then
						aObj:skinCheckButton{obj=btn}
						btn:SetSize(24, 24)
					else
						aObj:skinStdButton{obj=btn}
					end
				end
				if type:find("SV") then
					skinViewBtns(this, bankType)
				end

				aObj:SecureHook(this, "ShowTab", function(fObj, _)
					aObj:Unhook(fObj, "ShowTab") -- N.B.: moved up here as the function is called lower down
					skinSideTabs(fObj)
					if type:find("CV") then
						skinCVBtnsAfterDelay(fObj, type)
					end
				end)

				aObj:SecureHook(this, "UpdateTabs", function(fObj)
					skinSideTabs(fObj)

				end)

				aObj:SecureHookScript(this.TabSettingsMenu, "OnShow", function(fObj)
					aObj:skinIconSelector(fObj)
					aObj:removeRegions(fObj.DepositSettingsMenu, {4}) -- Separator texture
					aObj:skinObject("ddbutton", {obj=fObj.DepositSettingsMenu.ExpansionFilterDropdown})
					aObj:skinObject("frame", {obj=fObj, kfs=true})
					if aObj.modChkBtns then
						local function skinCB(cBtn)
							aObj:skinCheckButton{obj=cBtn}
							cBtn:SetSize(20, 20)
						end
						skinCB(fObj.DepositSettingsMenu.AssignEquipmentCheckbox)
						skinCB(fObj.DepositSettingsMenu.AssignConsumablesCheckbox)
						skinCB(fObj.DepositSettingsMenu.AssignProfessionGoodsCheckbox)
						skinCB(fObj.DepositSettingsMenu.AssignReagentsCheckbox)
						skinCB(fObj.DepositSettingsMenu.AssignJunkCheckbox)
						skinCB(fObj.DepositSettingsMenu.IgnoreCleanUpCheckbox)
					end

					aObj:Unhook(fObj, "OnShow")
				end)

				aObj:Unhook(this, "OnShow")
			end)
			aObj:checkShown(frame.Warband)
		end
	end
	self:SecureHookScript(_G.Baganator_SingleViewBankViewFrame, "OnShow", function(this)
		skinBank(this, "SVBank")

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.Baganator_CategoryViewBankViewFrame, "OnShow", function(this)
		skinBank(this, "CVBank")

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.Baganator_SingleViewGuildViewFrame, "OnShow", function(this)
		skinSideTabs(this)
		self:SecureHook(this, "UpdateTabs", function(fObj)
			skinSideTabs(fObj)
		end)
		skinFrame(this, "SVGuild")
		if self.modBtns then
			for _, array in _G.pairs{"AllFixedButtons", "LiveButtons"} do
				for _, btn in _G.pairs(this[array]) do
					aObj:skinStdButton{obj=btn, schk=true, sechk=true}
				end
			end
		end
		skinViewBtns(this, "SVGuild")
		-- wait for layouts to be created
		_G.C_Timer.After(0.05, function()
			for _, layout in _G.pairs(this.Container.Layouts) do
				skinBtns(layout)
			end
		end)

		self:SecureHookScript(this.LogsFrame, "OnShow", function(fObj)
			skinFrame(fObj)

			self:Unhook(fObj, "OnShow")
		end)
		self:SecureHookScript(this.TabTextFrame, "OnShow", function(fObj)
			skinFrame(fObj)
			if self.modBtns then
				self:skinStdButton{obj=fObj.SaveButton}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.Baganator_CharacterSelectFrame, "OnShow", function(fObj)
		skinFrame(fObj)
		if self.modBtns then
			self:skinStdButton{obj=fObj.ManageCharactersButton}
		end

		self:Unhook(fObj, "OnShow")
	end)

	self:SecureHookScript(_G.Baganator_CurrencyPanelFrame, "OnShow", function(this)
		self:skinObject("scrollbar", {obj=self:getChild(this, 10)})
		skinFrame(this)

		self:Unhook(this, "OnShow")
	end)

	if _G.Baganator_WelcomeFrame then
		self:skinObject("frame", {obj=_G.Baganator_WelcomeFrame, kfs=true, cb=true})
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(_G.Baganator_WelcomeFrame, _G.Baganator_WelcomeFrame:GetNumChildren() - 2)}
			self:skinStdButton{obj=self:getChild(_G.Baganator_WelcomeFrame, _G.Baganator_WelcomeFrame:GetNumChildren() - 1)}
		end
	end

	_G.Baganator.CallbackRegistry:RegisterCallback("ShowCustomise", function()
		local this = _G.BaganatorCustomiseDialogFrame
		this.Bg:SetTexture(nil)
		this.TopTileStreaks:SetTexture(nil)
		local function skinKids(frame)
			for _, child in _G.ipairs{frame:GetChildren()} do
				if child:IsObjectType("CheckButton")
				and self.modChkBtns
				then
					self:skinCheckButton{obj=child}
				elseif child.Arrow then
					self:skinObject("ddbutton", {obj=child})
				elseif child:IsObjectType("EditBox") then
					self:skinObject("editbox", {obj=child, y1=-4, y2=4})
				elseif child.DropDown
				and child.DropDown.Popout
				then
					self:skinObject("frame", {obj=child.DropDown.Popout.Border, kfs=true, x1=7, y1=0, x2=-12, y2=20})
				elseif child.Popout then
					self:skinObject("frame", {obj=child.Popout.Border, kfs=true, x1=7, y1=0, x2=-12, y2=20})
				elseif child.ScrollBar then
					self:skinObject("scrollbar", {obj=child.ScrollBar})
					self:skinObject("frame", {obj=child, kfs=true, rns=true, fb=true})
				elseif child.Slider then
					self:skinObject("slider", {obj=child.Slider})
				elseif child:IsObjectType("Button")
				and child.Count -- Corners central button
				and self.modBtnBs
				then
					self:addButtonBorder{obj=child}
				elseif child:IsObjectType("Button")
				and self.modBtns
				then
					self:skinStdButton{obj=child, schk=true, sechk=true}
				elseif child:IsObjectType("Frame") then
					if child.Bg then
						child.Bg:SetTexture(nil)
					end
					if child.InsetBorderTop then
						child:DisableDrawLayer("BORDER")
						self:skinObject("frame", {obj=child, fb=true})
					end
					if child.NineSlice then
						self:skinObject("frame", {obj=child, rns=true, fb=true})
					end
					skinKids(child)
				end
			end
		end
		for _, frame in _G.ipairs(this.Views) do
			skinKids(frame)
			if frame.ResetFramePositions
			and self.modBtns
			then
				self:skinStdButton{obj=frame.ResetFramePositions}
			end
			self:skinObject("frame", {obj=frame, kfs=true, fb=true, ofs=-2, y1=23})
		end
		self:skinObject("tabs", {obj=this, tabs=this.Tabs, ignoreSize=true, lod=self.isTT and true, upwards=true, offsets={x1=8, y1=-4, x2=-8, y2=-2}})
		self:skinObject("frame", {obj=this, kfs=true, ri=true, cb=true, ofs=self.isRTl and 0 or 1, y1=self.isRtl and -1 or 2})

		_G.Baganator.CallbackRegistry:UnregisterCallback("ShowCustomise", aObj)
	end)

	self.RegisterCallback("Baganator", "SettingsPanel_DisplayCategory", function(_, panel, category)
		if category.name ~= "Baganator" then return end
		self.spSkinnedPanels[panel] = true

		if self.modBtns then
			self:skinStdButton{obj=self:getChild(panel, 1)}
		end

		self.UnregisterCallback("Baganator", "SettingsPanel_DisplayCategory")
	end)

end

aObj.addonsToSkin.Syndicator = function(self) -- v 133
	self:SecureHook(_G.Syndicator.API, "GetSearchKeywords", function(this)
		_G.C_Timer.After(0.05, function()
			self:skinObject("scrollbar", {obj=_G.Baganator_SearchHelpFrame.ScrollBar})
			self:skinObject("frame", {obj=_G.Baganator_SearchHelpFrame, kfs=true, cb=true, x2=1})
		end)

		self:Unhook(this, "GetSearchKeywords")
	end)

	self.RegisterCallback("Syndicator", "SettingsPanel_DisplayCategory", function(_, panel, category)
		if category.name ~= "Syndicator" then return end
		self.spSkinnedPanels[panel] = true

		local function skinKids(frame)
			for _, child in _G.ipairs_reverse{frame:GetChildren()} do
				if child:IsObjectType("CheckButton")
				and self.modChkBtns
				then
					self:skinCheckButton{obj=child}
				elseif child:IsObjectType("Slider") then
					self:skinObject("slider", {obj=child})
				elseif child:IsObjectType("Frame") then
					if child.thumbAnchor then
						self:skinObject("scrollbar", {obj=child})
					end
					if child.layoutType == "InsetFrameTemplate"	then
						aObj:skinObject("frame", {obj=child, kfs=true, ri=true, rns=true, fb=true})
					end
					skinKids(child)
				end
			end
		end
		skinKids(panel)

		self.UnregisterCallback("Syndicator", "SettingsPanel_DisplayCategory")
	end)

end
