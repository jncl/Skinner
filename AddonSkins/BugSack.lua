local _, aObj = ...
if not aObj:isAddonEnabled("BugSack") then return end
local _G = _G

aObj.addonsToSkin.BugSack = function(self) -- v10.2.7

	if not _G.BugGrabber then
		return
	end

	self:SecureHook(_G.BugSack, "OpenSack", function(this)
		self:skinObject("slider", {obj=_G.BugSackScroll.ScrollBar})
		self:moveObject{obj=self:getRegion(_G.BugSackFrame, 11), y=-8} -- countLabel
		_G.BugSackFrame.Tabs = {_G.BugSackTabAll, _G.BugSackTabSession, _G.BugSackTabLast}
		self:skinObject("tabs", {obj=_G.BugSackFrame, tabs=_G.BugSackFrame.Tabs, lod=self.isTT and true, offsets={x1=7, y1=self.isTT and 2 or -3, x2=-7, y2=2}, track=false, func=self.isTT and function(tab)
			self:SecureHookScript(tab, "OnClick", function(tObj)
				for _, tabObj in _G.pairs(tObj:GetParent().Tabs) do
					if tabObj == tObj then
						aObj:setActiveTab(tabObj.sf)
					else
						aObj:setInactiveTab(tabObj.sf)
					end
				end
			end)
		end})
		self:skinObject("frame", {obj=_G.BugSackFrame, kfs=true, ofs=-2, x2=-1, y2=2})
		_G.BugSackFrame:SetFrameStrata("FULLSCREEN_DIALOG")
		if self.modBtns then
			self:skinCloseButton{obj=self:getChild(_G.BugSackFrame, 1)}
			local btn
			for _, name in _G.pairs{"Prev", "Send", "Next"} do
				btn = _G["BugSack" .. name .. "Button"]
				self:skinStdButton{obj=btn, schk=true}
			end
		end

		self:Unhook(this, "OpenSack")
	end)

	-- add custom Settings entry for the Sound Dropdown
	aObj.customSettings["soundDropdown"] = "DropdownButton"

end
