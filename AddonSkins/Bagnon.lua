local _, aObj = ...
if not aObj:isAddonEnabled("Bagnon") then return end
local _G = _G

aObj.addonsToSkin.Bagnon = function(self) -- v 11.2.2
	if not self.db.profile.ContainerFrames or self.initialized.Bagnon then return end
	self.initialized.Bagnon = true

	local skinMenuBtns, skinBGBtns, skinIGBtns, skinTGBtns =_G.nop, _G.nop, _G.nop, _G.nop
	if aObj.modBtnBs then
		function skinMenuBtns(frame)
			for _, btn in _G.pairs(frame.MenuButtons) do
				aObj:addButtonBorder{obj=btn, ofs=3, clr="grey"}
			end
			-- Options button
			if frame:HasOptionsToggle() then
				aObj:addButtonBorder{obj=frame.OptionsToggle or frame.optionsToggle, ofs=3, clr="grey"}
			end
		end
		function skinBGBtns(frame)
		    for bBtn, _ in _G.pairs(frame.__frames) do
		    	aObj:addButtonBorder{obj=bBtn, ofs=4, clr=bBtn.owned and "grey" or "red"}
		    	aObj:secureHook(bBtn, "Update", function(bObj)
					aObj:clrBBC(bObj.sbb, bObj.owned and "grey" or "red")
		    	end)
		    end
		end
		function skinIGBtns(frame)
			for _, btn in _G.ipairs(frame.buttons) do
				aObj:addButtonBorder{obj=btn, ibt=true, y2=-3}
				aObj:setBtnClr(btn, btn.info.quality)
				aObj:secureHook(btn, "Update", function(bObj)
					aObj:setBtnClr(bObj, bObj.info.quality)
				end)
			end
		end
		function skinTGBtns(frame)
			for _, btn in _G.ipairs(frame.buttons) do
				aObj:addButtonBorder{obj=btn, ofs=4, clr="grey"}
			end
		end
	end
	local function skinFrame(frame, _)
		if frame.sf then return end
		aObj:SecureHookScript(frame, "OnShow", function(this)
			aObj:skinObject("editbox", {obj=this.SearchBar})
			aObj:skinObject("frame", {obj=this, kfs=true, cb=true, ofs=1})
			if aObj.modBtnBs then
				skinMenuBtns(this)

				-- BagGroup buttons
				aObj:SecureHook(this.BagButton, "New", function(bGrp, parent)
					skinBGBtns(parent.frame.BagButton)
				end)
				skinBGBtns(this.BagButton)

			    -- ItemGroup buttons
				aObj:SecureHook(this.ItemGroup, "Layout", function(fObj)
					skinIGBtns(fObj)
				end)
				skinIGBtns(this.ItemGroup)

				-- TabGroup buttons
				if this.TabGroup then
					aObj:SecureHook(this.TabGroup, "Update", function(tGrp)
						skinTGBtns(tGrp)
					end)
					skinTGBtns(this.TabGroup)
				end

				-- hook to handle Button & TabGroup toggles
				aObj:SecureHook(this, "Layout", function(fObj)
					skinMenuBtns(fObj)
					if fObj:HasSidebar() then
						skinTGBtns(fObj.TabGroup)
					end

				end)

			end

			aObj:Unhook(this, "OnShow")
		end)
		aObj:checkShown(frame)
	end

	-- hook this to skin new frames
	self:RawHook(_G.Bagnon.Frames, "New", function(this, id)
		local frame = self.hooks[this].New(this, id)
		-- add a slight delay for tables to be populated
		_G.C_Timer.After(0.05, function()
			skinFrame(frame, id)
		end)
		return frame
	end, true)

end

aObj.lodAddons.Bagnon_Config = function(self) -- v 11.2.2
	if self.initialized.Bagnon_Config then return end
	self.initialized.Bagnon_Config = true

	local function skinKids(frame)
		for _, child in _G.ipairs_reverse{frame:GetChildren()} do
			if child:GetName() then
				if child:GetName():find("DropChoice") then
					self:skinObject("dropdown", {obj=child, x2=-1})
				elseif child:GetName():find("Slider") then
					self:skinObject("slider", {obj=child})
				end
			elseif child:IsObjectType("Frame") then
				skinKids(child)
			end
		end
	end
	self.RegisterCallback("Bagnon_Config", "SettingsPanel_DisplayCategory", function(this, panel)
		if not panel:GetNumChildren() == 1
		or not self:getChild(panel, 1)
		or not self:getChild(panel, 1).Tag
		or not self:getChild(panel, 1).Tag == "Bagnon."
		then
			return
		end

		skinKids(self:getChild(panel, 1))

	end)

	self:SecureHookScript(_G.Bagnon.RuleEdit, "OnShow", function(fObj)

		self:skinIconSelector(fObj)

		fObj.Code:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=fObj.Code, fb=true, ofs=8})
		if self.modBtns then
			self:skinStdButton{obj=fObj.BorderBox.DeleteButton}
			self:skinStdButton{obj=fObj.BorderBox.ShareButton, sechk=true}
		end

		self:Unhook(fObj, "OnShow")
	end)

end
