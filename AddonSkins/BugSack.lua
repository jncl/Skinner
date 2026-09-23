local _, aObj = ...
if not aObj:isAddonEnabled("BugSack") then return end
local _G = _G

aObj.addonsToSkin.BugSack = function(self) -- v12.1.7

	if not _G.BugGrabber then
		return
	end

	self:SecureHook(_G.BugSack, "OpenSack", function(_)
		local frame = _G.BugSackFrame
		local scrollBar = self:getChild(frame, frame:GetNumChildren() - 5).ScrollBar
		local optionsFrame = self:getChild(frame, frame:GetNumChildren() - 4)
		if self.isMorF then
			self:skinObject("scrollbar", {obj=scrollBar})
		else
			self:skinObject("slider", {obj=scrollBar})
		end
		frame.Tabs = frame.Tabs or {_G.BugSackTabAll, _G.BugSackTabSession, _G.BugSackTabLast, _G.BugSackTabOptions}
		self:skinObject("tabs", {obj=frame, tabs=frame.Tabs, lod=self.isTT and true, track=false, func=self.isTT and function(tab)
			self:SecureHookScript(tab, "OnClick", function(tObj)
				for _, tabObj in _G.pairs(frame.Tabs) do
					if tabObj == tObj then
						self:setActiveTab(tabObj.sf)
					else
						self:setInactiveTab(tabObj.sf)
					end
				end
			end)
		end})
		local x1Ofs, y1Ofs, x2Ofs, y2Ofs = 2, -2, -1, 4
		if self.isMorF then
			x1Ofs, y1Ofs, x2Ofs, y2Ofs = nil, nil, nil, nil
		end
		self:skinObject("frame", {obj=frame, kfs=true, cb=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
		frame:SetFrameStrata("FULLSCREEN_DIALOG")
		if self.modBtns then
			for _, name in _G.pairs{"Prev", "Send", "Next"} do
				self:skinStdButton{obj=_G["BugSack" .. name .. "Button"], schk=true}
			end
			self:skinStdButton{obj=_G.BugSackWipeButton, sechk=true}
		end

		local kid1
		for _, child in _G.ipairs_reverse{optionsFrame:GetChildren()} do
			if child:IsObjectType("CheckButton")
			and self.modChkBtns
			then
				self:skinCheckButton{obj=child}
			elseif child:IsObjectType("Frame") then
				kid1 = self:getChild(child, 1)
				if kid1
				and kid1:IsObjectType("Button") then
					self:skinObject("ddbutton", {obj=kid1})
				end
			end
		end

		self:Unhook(_G.BugSack, "OpenSack")
	end)

end
