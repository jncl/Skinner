local _, aObj = ...
if not aObj:isAddonEnabled("WoWPro") then return end
local _G = _G

aObj.addonsToSkin.WoWPro = function(self) -- v 8.3.0-A1

	self:addSkinFrame{obj=_G.WoWPro.MainFrame, ft="a", kfs=true, nb=true, y2=-2}
	_G.WoWPro.BackgroundSet = _G.nop

	-- WoWPro.GuideFrame objects
	self:skinSlider{obj=_G.WoWPro.Scrollbar}
	self:getChild(_G.WoWPro.Scrollbar, 3):SetBackdrop(nil)
	for i, row in ipairs(_G.WoWPro.rows) do
		-- N.B. skinning checkboxes causes then to not be displayed ?
		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, row.action.tooltip)
		end)
	end

	-- Options panels
	local cnt = 0
	self.RegisterCallback("WoWPro", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.parent ~= "WoW-Pro" then return end

		if panel.name == "Guide List" then
			-- TODO: tab(s)
			for _, child in pairs{panel.TitleRow:GetChildren()} do
				child:SetBackdrop(nil)
			end
			self:addSkinFrame{obj=panel.TitleRow, ft="a", kfs=true, nb=true, y1=2}
			self:addSkinFrame{obj=panel.scrollBox, ft="a", kfs=true, nb=true}
			self:skinSlider{obj=panel.scrollBar}
			self:getChild(panel.scrollBar, 3):SetBackdrop(nil) -- remove border texture
			cnt = cnt + 1
		end

		if panel.name == "Current Guide" then
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
