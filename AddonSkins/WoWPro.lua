local _, aObj = ...
if not aObj:isAddonEnabled("WoWPro") then return end
local _G = _G

aObj.addonsToSkin.WoWPro = function(self) -- v 8.3.0-A1/1.13.3.L7

	self:SecureHookScript(_G.WoWPro.MainFrame, "OnShow", function(this)
		_G.WoWPro.BackgroundSet = _G.nop
		_G.WoWPro.Titlebar:SetBackdrop(nil)
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, y2=-2}

		self:skinSlider{obj=_G.WoWPro.Scrollbar}
		self:getChild(_G.WoWPro.Scrollbar, 3):SetBackdrop(nil)

		for _, row in _G.ipairs(_G.WoWPro.rows) do
			-- N.B. skinning checkboxes causes then to not be displayed ?
			-- tooltip
			_G.C_Timer.After(0.1, function()
				self:add2Table(self.ttList, row.action.tooltip)
			end)
			if self.modBtnBs then
				self:addButtonBorder{obj=row.itembutton, seca=true, ofs=3, clr="grey"}
				self:addButtonBorder{obj=row.targetbutton, seca=true, ofs=3, clr="grey"}
				self:addButtonBorder{obj=row.lootsbutton, ofs=3, clr="grey"}
			end
		end
		for _, row in _G.ipairs(_G.WoWPro.mousenotes) do
			self:addSkinFrame{obj=row, ft="a", kfs=true, nb=true, ofs=0}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.WoWPro.MainFrame)

	self:SecureHookScript(_G.WoWPro_SkipSteps, "OnShow", function(this)
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.WoWPro_SkipOkay}
			self:skinStdButton{obj=_G.WoWPro_SkipCancel}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.WoWPro_GuideCompleted, "OnShow", function(this)
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.WoWPro_LoadNextGuide}
			self:skinStdButton{obj=_G.WoWPro_OpenLevelingGuidelist}
			self:skinStdButton{obj=_G.WoWPro_ResetGuide}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHook(_G.WoWPro, "CreateErrorLog", function(this, title)
		self:skinSlider{obj=_G.WoWProErrorLog.Scroll.ScrollBar}
		self:addSkinFrame{obj=_G.WoWProErrorLog, ft="a", kfs=true, nb=true}

		self:Unhook(this, "CreateErrorLog")
	end)

	-- Options panels
	local cnt = 0
	self.RegisterCallback("WoWPro", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.parent ~= "WoW-Pro" then return end

		if panel.name == "Guide List"
		and not self.iofSkinnedPanels[panel]
		then
			-- TODO: tab(s)
			for _, child in _G.pairs{panel.TitleRow:GetChildren()} do
				child:SetBackdrop(nil)
			end
			self:addSkinFrame{obj=panel.TitleRow, ft="a", kfs=true, nb=true, y1=2}
			self:addSkinFrame{obj=panel.scrollBox, ft="a", kfs=true, nb=true}
			self:skinSlider{obj=panel.scrollBar}
			self:getChild(panel.scrollBar, 3):SetBackdrop(nil) -- remove border texture
			cnt = cnt + 1
		end

		if panel.name == "Current Guide"
		and not self.iofSkinnedPanels[panel]
		then
			_G.C_Timer.After(0.1, function()
				-- skin box
				local cgframe = self:getChild(panel, 1)
				self:addSkinFrame{obj=cgframe, ft="a", kfs=true, nb=true}
				-- skin scrollbar
				local slider = self:getChild(cgframe, 1)
				self:skinSlider{obj=slider}
				self:getChild(slider, 3):SetBackdrop(nil)
				slider = nil
				-- skin lines
				if self.modChkBtns then
					local cBtn
					for i = 1, cgframe:GetNumChildren() do
						cBtn = self:getChild(cgframe, i).check
						if cBtn then
							cBtn:SetSize(20, 20)
							self:skinCheckButton{obj=cBtn}
						end
					end
					cBtn = nil
				end
				cgframe = nil
			end)
			-- tooltip
			_G.C_Timer.After(0.1, function()
				self:add2Table(self.ttList, panel.tooltip)
			end)
			cnt = cnt + 1
		end

		self.iofSkinnedPanels[panel] = true

		if cnt == 2 then
			self.UnregisterCallback("WoWPro", "IOFPanel_Before_Skinning")
			cnd = nil
		end
	end)

end
