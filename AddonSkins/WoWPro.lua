local aName, aObj = ...
if not aObj:isAddonEnabled("WoWPro") then return end

function aObj:WoWPro()

	self:addSkinFrame{obj=WoWPro.MainFrame, y2=-2}
	-- stop backgrounds being changed
	WoWPro.BackgroundSet = function() end

	-- hook this to skin option frames
	self:RawHook(WoWPro, "CreateBG", function(this, parent)
		local frame = self.hooks[this].CreateBG(this, parent)
		self:addSkinFrame{obj=frame}
		return frame
	end, true)
	-- hook this to skin option scrollbars
	self:RawHook(WoWPro, "CreateScrollbar", function(this, parent, offset, step)
		local frame, up, down, border = self.hooks[this].CreateScrollbar(this, parent, offset, step)
		self:skinSlider{obj=frame, size=3}
		border:SetBackdrop(nil)
		return frame, up, down, border
	end, true)
	if self.modBtnBs then
		-- add button borders
		for i = 1, 15 do
			self:addButtonBorder{obj=WoWPro.rows[i].itembutton, sec=true, es=12}
			self:addButtonBorder{obj=WoWPro.rows[i].targetbutton, sec=true, es=12}
		end
	end

-->>-- WoWPro_Levelling frames
	self:addButtonBorder{obj=WoWPro.Leveling.SpellButton, relTo=self:getRegion(WoWPro.Leveling.SpellButton, 1), es=12}
	-- tooltip Frame
	self:addSkinFrame{obj=tooltip, ofs=-2}
	-- Available Abilities Frame
	self:addSkinFrame{obj=WoWPro.Leveling.SpellListDialog, ofs=-2}

end
