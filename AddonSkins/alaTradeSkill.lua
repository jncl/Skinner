local _, aObj = ...
if not aObj:isAddonEnabled("alaTradeSkill") then return end
local _G = _G

aObj.addonsToSkin.alaTradeSkill = function(self) -- v 205r.210902

	if not _G.ALA_TRADESKILL_EXPLORER then
		_G.C_Timer.After(0.25, function()
			self.addonsToSkin.alaTradeSkill(self)
		end)
		return
	end

	-- hook this to skin dropdown frames
	self:SecureHook("ALADROP", function(_, _, data, _)
		if _G.type(data) ~= "table"
		or _G.type(data.elements) ~= "table"
		then
			return
		end
		local frame = self:getLastChild(_G.UIParent)
		if frame.__flag == "show" then
			self:skinObject("frame", {obj=frame, kfs=true, ofs=4})
		end
		frame = nil
	end)

	-- ALA_TRADESKILL_EXPLORER
		-- .SearchEditBox
		-- .ScrollFrame
		-- .ProfitFrame
		-- .SetFrame
			-- .PhaseSlider
	self:SecureHookScript(_G.ALA_TRADESKILL_EXPLORER, "OnShow", function(this)
		self:skinObject("frame", {obj=this.ProfitFrame, kfs=true, ofs=0})
		self:skinObject("frame", {obj=this.SetFrame, kfs=true, ofs=0, y1=2})
		self:skinObject("slider", {obj=this.SetFrame.PhaseSlider})
		self:skinObject("frame", {obj=this, kfs=true, ofs=0})

		self:Unhook(this, "OnShow")
	end)

	-- ALA_TRADESKILL_CONFIG
		-- .CharList
			-- .ScrollFrame
	self:SecureHookScript(_G.ALA_TRADESKILL_CONFIG, "OnShow", function(this)
		self:skinObject("frame", {obj=this.CharList, kfs=true, ofs=0})
		self:skinObject("frame", {obj=this, kfs=true, ofs=0})
		if self.modChkBtns then
			 for _, child in _G.ipairs{this:GetChildren()} do
			 	if child:IsObjectType("CheckButton") then
			 		self:skinCheckButton{obj=child}
			 	end
			 end
		end

		self:Unhook(this, "OnShow")
	end)

	-- BOARD
	self.RegisterCallback("alaTradeSkill", "UIParent_GetChildren", function(_, child, _)
		if child.info_lines
		and child.T_Lines
		and child.curLine
		then
			self:skinObject("frame", {obj=child, ofs=4})
			self.UnregisterCallback("alaTradeSkill", "UIParent_GetChildren")
		end
	end)
	self:scanUIParentsChildren()

end
