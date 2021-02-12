local _, aObj = ...
if not aObj:isAddonEnabled("SinStats") then return end
local _G = _G

aObj.addonsToSkin.SinStats = function(self) -- v 2.2

	self:SecureHookScript(_G.SinStatsConfigFrame, "OnShow", function(this)
		-- wait for frame to be populated
		_G.C_Timer.After(0.1, function()
			self:skinObject("tabs", {obj=this, tabs=this.Tabs, ignoreSize=true, lod=true, regions={1}, track=false, func=aObj.isTT and function(tab)
				aObj:SecureHookScript(tab, "OnClick", function(this)
					for _, tab in _G.pairs(this:GetParent().Tabs) do
						if tab == this then
							aObj:setActiveTab(tab.sf)
						else
							aObj:setInactiveTab(tab.sf)
						end
					end
				end)
			end})
			for _, frame in _G.pairs(this.Tabs) do
				for _, child in _G.ipairs{frame.widgets:GetChildren()} do
					if child:IsObjectType("CheckButton")
					and self.modChkBtns
					then
						self:skinCheckButton{obj=child}
					elseif child:IsObjectType("Slider") then
						self:skinObject("slider", {obj=child})
					end
				end
				self:skinObject("frame", {obj=frame.widgets, fb=true, x1=-7, y1=8, x2=-13, y2=64})
			end
			self:moveObject{obj=this.Title, y=-3}
			self:moveObject{obj=this.SigVer, x=-10, y=6}
			self:skinObject("frame", {obj=this, kfs=true, cb=true, ofs=-1})
			if self.modBtns then
				self:skinStdButton{obj=this.Reset}
			end
		end)

		self:Unhook(this, "OnShow")
	end)

end
