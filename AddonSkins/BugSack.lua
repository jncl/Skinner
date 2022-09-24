local _, aObj = ...
if not aObj:isAddonEnabled("BugSack") then return end
local _G = _G

aObj.addonsToSkin.BugSack = function(self) -- v 9.0.0

	-- close with Esc
	self:add2Table(_G.UISpecialFrames, "BugSackFrame")

	self:SecureHook(_G.BugSack, "OpenSack", function(this)
		self:skinObject("slider", {obj=_G.BugSackScroll.ScrollBar})
		self:moveObject{obj=self:getRegion(_G.BugSackFrame, 11), y=-8} -- countLabel
		_G.BugSackFrame.Tabs = {_G.BugSackTabAll, _G.BugSackTabSession, _G.BugSackTabLast}
		self:skinObject("tabs", {obj=this, tabs=_G.BugSackFrame.Tabs, regions={7, 8}, lod=self.isTT and true, offsets={x1=7, y1=self.isTT and 2 or -3, x2=-7, y2=2}, track=false, func=self.isTT and function(tab)
			self:SecureHookScript(tab, "OnClick", function(this)
				for _, tab in _G.pairs(this:GetParent().Tabs) do
					if tab == this then
						aObj:setActiveTab(tab.sf)
					else
						aObj:setInactiveTab(tab.sf)
					end
				end
			end)
		end})
		self:skinObject("frame", {obj=_G.BugSackFrame, kfs=true, ofs=-2, x2=-1, y2=4})
		_G.BugSackFrame:SetFrameStrata("FULLSCREEN_DIALOG")
		if self.modBtns then
			self:skinCloseButton{obj=self:getChild(_G.BugSackFrame, 1), fType=ftype}
			local btn
			for _, name in _G.pairs{"Prev", "Send", "Next"} do
				btn = _G["BugSack" .. name .. "Button"]
				self:skinStdButton{obj=btn, schk=true}
			end
			btn = nil
		end

		self:Unhook(this, "OpenSack")
	end)

	-- Config
	self.iofDD["BugSackFontSize"] = 109
	self.iofDD["BugSackSoundDropdown"] = 109

end
