local _, aObj = ...
if not aObj:isAddonEnabled("WorldQuestTab") then return end
local _G = _G

aObj.addonsToSkin.WorldQuestTab = function(self) -- v 12.0.11

	local frame, btn
	for _, name in _G.pairs{"OldTaxi", "Flight", "World"} do
		frame = _G["WQT_" .. name .. "MapContainer"]
		self:SecureHookScript(frame, "OnShow", function(this)
			if _G.InCombatLockdown() then
				self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				return
			end

			self:skinObject("frame", {obj=this, kfs=true})

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(frame)
		btn = _G["WQT_" .. name .. "MapContainerButton"]
		if self.modBtns
		and btn
		then
			self:skinStdButton{obj=btn, ofs=0, y1=-4, y2=4}
		end
	end

	-- tab on QuestLog
	_G.WQT_QuestMapTab.Background:SetTexture(nil)
	self:skinObject("button", {obj=_G.WQT_QuestMapTab, ofs=-1, x1=-1, y2=2})

	self:SecureHookScript(_G.WQT_WorldQuestFrame, "OnShow", function(this)
		if _G.InCombatLockdown() then
			self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			return
		end

		this.ScrollFrame:DisableDrawLayer("BACKGROUND")
		-- .TopBar
			-- .ProgressBar
		self:skinObject("ddbutton", {obj=this.ScrollFrame.TopBar.SortDropdown})
		self:skinObject("ddbutton", {obj=this.ScrollFrame.TopBar.FilterDropdown, filter=true})
		self:skinObject("editbox", {obj=this.ScrollFrame.TopBar.SearchBox, si=true})
			-- .SearchToggle
		-- SettingsButton
		self:keepFontStrings(this.ScrollFrame.BorderFrame)
		-- .BorderContainer
			-- .FilterBar
			-- .QuestScrollBox
		self:skinObject("scrollbar", {obj=this.ScrollFrame.ScrollBar})

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.WQT_WorldQuestFrame)

	self:SecureHookScript(_G.WQT_SettingsFrame, "OnShow", function(this)
		if _G.InCombatLockdown() then
			self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			return
		end

		this:DisableDrawLayer("BACKGROUND")
		self:keepFontStrings(this.BorderFrame)
		self:skinObject("scrollbar", {obj=this.ScrollBar})
		local function skinSettings(...)
			local _, element, elementData
			if _G.select("#", ...) == 2 then
				element, elementData = ...
			else
				_, element, elementData = ...
			end
			if elementData.template == "WQT_SettingCategoryTemplate" then
				aObj:removeRegions(element, {1, 2, 3, 5, 6, 7})
				aObj:changeHdrExpandTex(element.BGRight)
				-- force the change
				if element.UpdateState then
					element:UpdateState()
				end
			elseif elementData.template == "WQT_SettingSubCategoryTemplate" then
				aObj:removeRegions(element, {1, 4})
			elseif elementData.template == "WQT_SettingsQuestListPreviewTemplate" then
				element.Background:SetTexture(nil)
			-- "WQT_SettingsBaseTemplate"
			-- "WQT_SettingsChildTemplate"
			elseif elementData.template == "WQT_SettingCheckboxTemplate" then
				if aObj.modChkBtns then
					aObj:skinCheckButton{obj=element.CheckBox}
				end
			elseif elementData.template == "WQT_SettingSliderTemplate" then
				aObj:skinObject("slider", {obj=element.SliderWithSteppers.Slider})
				aObj:skinObject("editbox", {obj=element.TextBox})
			elseif elementData.template == "WQT_SettingTextTemplate" then
				_G.nop()
			elseif elementData.template == "WQT_SettingColorTemplate" then
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=element.Picker, ofs=0}
					aObj:addButtonBorder{obj=element.ResetButton, ofs=0}
				end
			elseif elementData.template == "WQT_SettingDropDownTemplate" then
				aObj:skinObject("ddbutton", {obj=element.Dropdown})
			-- "WQT_SettingFunctionButtonTemplate"
			elseif elementData.template == "WQT_SettingButtonTemplate" then
				if aObj.modBtns then
					aObj:skinStdButton{obj=element.Button, schk=true}
				end
			elseif elementData.template == "WQT_SettingConfirmButtonTemplate" then
				if aObj.modBtns then
					aObj:skinStdButton{obj=element.Button, schk=true}
					aObj:skinStdButton{obj=element.ButtonConfirm, schk=true}
					aObj:skinStdButton{obj=element.ButtonDecline, schk=true}
				end
			elseif elementData.template == "WQT_SettingTextInputTemplate" then
				aObj:skinObject("editbox", {obj=element.TextBox})
			elseif elementData.template == "WQT_SettingSeparatorTemplate" then
				_G.nop()
			end
		end
		_G.ScrollUtil.AddInitializedFrameCallback(this.ScrollBox, skinSettings, aObj, true)

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.WQT_SettingsFrame)

	_G.RunNextFrame(function()
	    self:add2Table(self.ttList, "a", _G.WQT_GameTooltip)
	    self:add2Table(self.ttList, "a", _G.WQT_ShoppingTooltip1)
	    self:add2Table(self.ttList, "a", _G.WQT_ShoppingTooltip2)
	end)

end
