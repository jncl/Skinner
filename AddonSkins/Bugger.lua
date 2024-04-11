local _, aObj = ...
if not aObj:isAddonEnabled("Bugger") then return end
local _G = _G
-- luacheck: ignore 631 (line is too long)

aObj.addonsToSkin.Bugger = function(self) -- v 8.0.0.0

	self:SecureHook(_G.Bugger, "SetupFrame", function(this)
		self:skinObject("slider", {obj=this.scrollFrame.ScrollBar})
		self:skinObject("tabs", {obj=this.frame, tabs=this.tabs, selectedTab=3, lod=self.isTT and true, track=false, regions={7}})
		if self.isTT then
			self:SecureHook(this, "ShowSession", function(fObj, session)
				session = session or "current"
				for _, tab in _G.pairs(fObj.tabs) do
					if tab.session == session then
						self:setActiveTab(tab.sf)
					else
						self:setInactiveTab(tab.sf)
					end
				end
			end)
		end
		self:skinObject("frame", {obj=this.frame, kfs=true, ofs=-1, y1=-2, y2=0})
		if self.modBtns then
			self:skinCloseButton{obj=_G[this.frame:GetName() .. "Close"]}
			self:skinStdButton{obj=this.reload}
			self:skinStdButton{obj=this.clear, schk=true, sechk=true}
			self:skinStdButton{obj=this.showLocals, schk=true}
			self:skinStdButton{obj=this.next, schk=true, sechk=true}
			self:skinStdButton{obj=this.previous, schk=true, sechk=true}
		end

		self:Unhook(_G.Bugger, "SetupFrame")
	end)

end
