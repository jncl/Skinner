local _, aObj = ...
if not aObj:isAddonEnabled("WoWPro") then return end
local _G = _G

aObj.addonsToSkin.WoWPro = function(self) -- v 9.0.5-A5/2.5.2.-A0/1.14.0.A0

	self:SecureHookScript(_G.WoWPro.MainFrame, "OnShow", function(this)
		_G.WoWPro.BackgroundSet = _G.nop
		_G.WoWPro.Titlebar:SetBackdrop(nil)
		_G.WoWPro.Titlebar.SetBackdrop = _G.nop
		self:skinObject("slider", {obj=_G.WoWPro.Scrollbar})
		self:getChild(_G.WoWPro.Scrollbar, 3):SetBackdrop(nil)
		self:skinObject("frame", {obj=this, kfs=true, ng=true, ofs=0, ba=0.35})

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.WoWPro.MainFrame)

	_G.C_Timer.After(0.5, function()
		for _, row in _G.ipairs(_G.WoWPro.rows) do
			self:add2Table(self.ttList, row.action.tooltip)
			if self.modBtnBs then
				self:addButtonBorder{obj=row.itembutton, sabt=true, ofs=3, clr="grey"}
				self:addButtonBorder{obj=row.targetbutton, sabt=true, ofs=3, clr="grey"}
				self:addButtonBorder{obj=row.lootsbutton, ofs=3, clr="grey"}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=row.check}
				row.check:SetSize(22, 22)
			end
		end
		for _, row in _G.ipairs(_G.WoWPro.mousenotes) do
			self:skinObject("frame", {obj=row, kfs=true})
		end
	end)

	self:SecureHookScript(_G.WoWPro_SkipSteps, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=_G.WoWPro_SkipOkay}
			self:skinStdButton{obj=_G.WoWPro_SkipCancel}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.WoWPro_GuideCompleted, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=_G.WoWPro_LoadNextGuide}
			self:skinStdButton{obj=_G.WoWPro_OpenLevelingGuidelist}
			self:skinStdButton{obj=_G.WoWPro_ResetGuide}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHook(_G.WoWPro, "CreateErrorLog", function(this, _)
		self:skinObject("slider", {obj=_G.WoWProErrorLog.Scroll.ScrollBar})
		self:skinObject("frame", {obj=_G.WoWProErrorLog, kfs=true})

		self:Unhook(this, "CreateErrorLog")
	end)

	-- Options panels
	local pCnt = 0
	self.RegisterCallback("WoWPro", "IOFPanel_Before_Skinning", function(_, panel)
		if panel.parent ~= "WoW-Pro" then return end
		if panel.name == "Guide List"
		and not self.iofSkinnedPanels[panel]
		then
			self.iofSkinnedPanels[panel] = true
			pCnt = pCnt + 1
			self:skinObject("frame", {obj  = panel.scrollBox.titleRow, fb=true, y1=2})
			self:skinObject("slider", {obj = panel.scrollBox.scrollBar})
			self:skinObject("frame", {obj  = panel.scrollBox, fb=true})
			self:skinObject("tabs", {obj=panel.scrollBox, tabs=panel.scrollBox.Tabs, offsets={x1=6, y1=-4, x2=-6, y2=-2}})
		elseif panel.name == "Current Guide" then
			if panel:GetNumChildren() > 0
			and not self.iofSkinnedPanels[panel]
			then
				self.iofSkinnedPanels[panel] = true
				pCnt = pCnt + 1
				_G.C_Timer.After(0.2, function()
					local cgframe = self:getChild(panel, 1)
					self:skinObject("frame", {obj=cgframe, fb=true, ofs=0})
					local slider = self:getChild(cgframe, 1)
					self:skinObject("slider", {obj=slider})
					self:getChild(slider, 3):SetBackdrop(nil)
					-- skin lines
					if self.modChkBtns then
						for _, child in _G.ipairs{cgframe:GetChildren()} do
							if child.check then
								child.check:SetSize(20, 20)
								self:skinCheckButton{obj=child.check}
							end
						end
					end
				end)
				self:add2Table(self.ttList, panel.tooltip)
			end
		end

		if pCnt == 2 then
			self.UnregisterCallback("WoWPro", "IOFPanel_Before_Skinning")
		end
	end)

end
