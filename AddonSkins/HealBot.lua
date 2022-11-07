-- many thanks to acirac/diacono for their work on previous skins
local _, aObj = ...
if not aObj:isAddonEnabled("HealBot") then return end
local _G = _G

aObj.addonsToSkin.HealBot = function(self) -- v 10.0.0.1

	local function skinKids(frame)
		local cType
		for _, child in _G.ipairs{frame:GetChildren()} do
			cType = child:GetObjectType()
			-- aObj:Debug("skinKids: [%s, %s, %s]", child, cType, child:GetNumChildren())
			if cType == "Frame"
			and child:GetName()
			then
				if aObj:isDropDown(child) then
					aObj:skinObject("dropdown", {obj=child})
					if child:GetNumChildren() > 1 then
						skinKids(child)
					end
				else
					if child.GetBackdrop then
						aObj:skinObject("frame", {obj=child, fb=true})
					end
					skinKids(child)
				end
			elseif cType == "Button"
			and child.Left
			and aObj.modBtns
			then
				aObj:skinStdButton{obj=child}
			elseif cType == "CheckButton"
			and aObj.modChkBtns
			then
				aObj:skinCheckButton{obj=child}
			elseif cType == "Slider" then
				aObj:skinObject("slider", {obj=child})
			elseif cType == "EditBox" then
				aObj:skinObject("editbox", {obj=child})
			-- elseif cType == "StatusBar" then -- used as a header
			end
		end
	end
	self:SecureHookScript(_G.HealBot_Options, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=_G.HealBot_Options_CloseButton}
			self:skinStdButton{obj=_G.HealBot_Options_Defaults}
			self:skinStdButton{obj=_G.HealBot_Options_Reset}
			self:skinStdButton{obj=_G.HealBot_Options_Reload}
		end

		-- loop through all children skinning them & continue through child frames
		skinKids(this)
		-- hide the skinframe
		_G.HealBot_Options_FramesSelFrame.sf:SetShown(_G.HealBot_Options_FramesSelFrame:IsShown())

		if self.modBtns then
			self:SecureHook("HealBot_Options_ObjectsEnableDisable", function(oName, _)
				local obj = _G[oName]
				if obj:IsObjectType("Button")
				and obj.Left
				then
					self:clrBtnBdr(obj)
				end
			end)
			self:SecureHook(_G.HealBot_Options_NewSkinb, "Disable", function(bObj, _)
				self:clrBtnBdr(bObj)
			end)
			self:SecureHook(_G.HealBot_Options_NewSkinb, "Enable", function(bObj, _)
				self:clrBtnBdr(bObj)
			end)
			self:SecureHook("HealBot_Options_CDebuffCatNameUpdate", function()
				self:clrBtnBdr(_G.HealBot_Options_DeleteCDebuffBtn)
				self:clrBtnBdr(_G.HealBot_Options_ResetCDebuffBtn)
				self:clrBtnBdr(_G.HealBot_Options_NewCDebuffBtn)
				self:clrBtnBdr(_G.HealBot_Options_CustomDebuffPresetColour)
			end)
			self:SecureHook("HealBot_Options_NewCDebuff_OnTextChanged", function(_)
				self:clrBtnBdr(_G.HealBot_Options_NewCDebuffBtn)
			end)
			self:SecureHook("HealBot_Options_SetEnableDisableCDBtn", function()
				self:clrBtnBdr(_G.HealBot_Options_EnableDisableCDBtn)
			end)
			self:SecureHook("HealBot_Options_NewHoTBuff_OnTextChanged", function(_)
				self:clrBtnBdr(_G.HealBot_Options_NewBuffHoTBtn)
			end)
			self:SecureHook("HealBot_Options_setCustomDebuffList", function()
				self:clrBtnBdr(_G.HealBot_Options_PagePrevCDebuffBtn)
				self:clrBtnBdr(_G.HealBot_Options_PageNextCDebuffBtn)
			end)
			self:SecureHook("HealBot_Options_setCustomBuffList", function()
				self:clrBtnBdr(_G.HealBot_Options_PagePrevCBuffBtn)
				self:clrBtnBdr(_G.HealBot_Options_PageNextCBuffBtn)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

	-- minimap button
	self.mmButs["HealBot"] = _G.HealBot_MMButton

end

aObj.lodAddons.HealBot_Tooltip = function(self) -- v 10.0.0.1

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.hbGameTooltip)
	end)

end
