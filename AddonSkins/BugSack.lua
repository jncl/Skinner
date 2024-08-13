local _, aObj = ...
if not aObj:isAddonEnabled("BugSack") then return end
local _G = _G
-- luacheck: ignore 631 (line is too long)

aObj.addonsToSkin.BugSack = function(self) -- v10.2.7

	if not _G.BugGrabber then
		return
	end

	-- close with Esc
	self:add2Table(_G.UISpecialFrames, "BugSackFrame")

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

	self.RegisterCallback("BugSack", "IOFPanel_Before_Skinning", function(_, panel)
		if panel.name ~= "BugSack" then return end
		self.iofSkinnedPanels[panel] = true

		for _, child in _G.ipairs_reverse{panel:GetChildren()} do
			if child:IsObjectType("CheckButton")
			and self.modChkBtns
			then
				self:skinCheckButton{obj=child}
			elseif self:isDropDown(child) then
				self:skinObject("dropdown", {obj=child, x2=109})
			elseif child:IsObjectType("Button")
			and self.modBtns
			then
				self:skinStdButton{obj=child}
			end
		end

		self.UnregisterCallback("BugSack", "IOFPanel_Before_Skinning")
	end)

end
