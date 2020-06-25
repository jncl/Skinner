local _, aObj = ...
if not aObj:isAddonEnabled("InstanceBoostTracker") then return end
local _G = _G

aObj.addonsToSkin.InstanceBoostTracker = function(self) -- v c07ebfe [23.06.20]

	-- skin mainframe
	self.RegisterCallback("InstanceBoostTracker", "UIParent_GetChildren", function(this, child)
		if _G.Round(child:GetWidth()) == 220
		and child:GetName() == nil
		and child.obj.titletext
		and child.obj.titletext:GetText() == "Tracker"
		then
			self:addSkinFrame{obj=child, ft="a", kfs=true, nb=true, ofs=0, y1=-2, x2=-1}
			if self.modBtns then
				self:skinCloseButton{obj=child.obj.closebutton}
				for _, obj in _G.ipairs(child.obj.children[1].children[1].children) do
					self:skinStdButton{obj=obj.frame}
				end
			end
			self.UnregisterCallback("InstanceBoostTracker", "UIParent_GetChildren")
		end
	end)
	self:scanUIParentsChildren()

	-- IBPT_Lockouts
	self:SecureHook(_G.GUILockouts, "Show", function(this)
		self:skinSlider{obj=self:getLastChild(_G.IBPT_Lockouts.children[2].frame).scrollBar, wdth=-4}
	end)

	-- IBPT_History
	self:SecureHook(_G.GUIPayments, "Show", function(this)
		self:skinSlider{obj=self:getLastChild(_G.IBPT_History.children[2].frame).scrollBar, wdth=-4}
	end)

end
