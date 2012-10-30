local aName, aObj = ...
if not aObj:isAddonEnabled("WoWPro") then return end

function aObj:WoWPro()

	self:addSkinFrame{obj=WoWPro.MainFrame, y2=-2}
	-- stop backgrounds being changed
	WoWPro.BackgroundSet = function() end

	-- Tabs
	for k, tab in pairs(WoWPro.GuideList.TabTable) do
		-- skin tabs here
		tab:SetBackdrop(nil)
		tab.SetBackdrop = function() end
		tab.border:SetTexture(nil)
		-- hook these to manage the GuideList TitleRow backdrop
		self:SecureHook(WoWPro[tab.name], "Setup_TitleRow", function(this, frame)
			WoWPro.GuideList.TitleRow.buffer:SetBackdrop(nil)
			WoWPro.GuideList.TitleRow.buffer.SetBackdrop = function() end
			for i = 1, #WoWPro.GuideList.TitleRow do
				local btn = WoWPro.GuideList.TitleRow[i]
				btn:SetBackdrop(nil)
				btn.SetBackdrop = function() end
			end
			self:Unhook(WoWPro, "Setup_TitleRow")
		end)
	end

	-- skin existing frames
	if WoWPro.GuideList then
		self:addSkinFrame{obj=WoWPro.GuideList.TitleRow, y1=2}
		self:addSkinFrame{obj=WoWPro.GuideList.scrollBox}
		self:skinSlider{obj=WoWPro.GuideList.scrollBar}
		self:getChild(WoWPro.GuideList.scrollBar, 3):SetBackdrop(nil) -- remove border texture
	end
	if WoWPro_Leveling_CurrentGuide then
		self:SecureHook(WoWPro_Leveling_CurrentGuide, "Show", function(this)
			self:Debug("WoWPro_Leveling_CurrentGuide Show: [%s]", this)
			self:Unhook(WoWPro_Leveling_CurrentGuide, "Show")
		end)
	end
	-- hook these to skin CurrentGuide option panel
	self:RawHook(WoWPro, "CreateBG", function(this, frame)
		local box = self.hooks[this].CreateBG(this, frame)
		self:addSkinFrame{obj=box}
		self:Unhook(WoWPro, "CreateBG")
		return box
	end, true)
	self:RawHook(WoWPro, "CreateScrollbar", function(this, parent, offset, step, where)
		local frame, up, down, border = self.hooks[this].CreateScrollbar(this, parent, offset, step, where)
		self:skinSlider{obj=frame}
		border:SetBackdrop(nil)
		self:Unhook(WoWPro, "CreateScrollbar")
		return frame, up, down, border
	end, true)

end
