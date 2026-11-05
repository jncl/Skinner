local _, aObj = ...
if not aObj:isAddonEnabled("BugSack") then return end
local _G = _G

aObj.addonsToSkin.BugSack = function(self) -- v12.1.9

	if not _G.BugGrabber then
		return
	end

	local function skinSack()
		local frame = _G.BugSackFrame
		local scrollBar = aObj:getChild(frame, frame:GetNumChildren() - 5).ScrollBar
		local optionsFrame = aObj:getChild(frame, frame:GetNumChildren() - 4)
		if aObj.isMorF then
			aObj:skinObject("scrollbar", {obj=scrollBar})
		else
			aObj:skinObject("slider", {obj=scrollBar})
		end
		frame.Tabs = frame.Tabs or {_G.BugSackTabAll, _G.BugSackTabSession, _G.BugSackTabLast, _G.BugSackTabOptions}
		aObj:skinObject("tabs", {obj=frame, tabs=frame.Tabs, lod=aObj.isTT, track=false, func=aObj.isTT and function(tab)
			aObj:SecureHookScript(tab, "OnClick", function(tObj)
				for _, tabObj in _G.pairs(frame.Tabs) do
					if tabObj == tObj then
						aObj:setActiveTab(tabObj.sf)
					else
						aObj:setInactiveTab(tabObj.sf)
					end
				end
			end)
		end})
		if aObj.isMorF then
			aObj:skinObject("frame", {obj=frame, kfs=true, cb=true})
		else
			aObj:skinObject("frame", {obj=frame, kfs=true, x1=2, y1=-2, x2=-1, y2=4})
			if aObj.modBtns then
				aObj:skinCloseButton{obj=aObj:getChild(frame, 1)}
			end
		end
		frame:SetFrameStrata("FULLSCREEN_DIALOG")
		if aObj.modBtns then
			for _, name in _G.pairs{"Prev", "Send", "Next"} do
				aObj:skinStdButton{obj=_G["BugSack" .. name .. "Button"], schk=true}
			end
			aObj:skinStdButton{obj=_G.BugSackWipeButton, sechk=true}
		end

		local kid1
		for _, child in _G.ipairs_reverse{optionsFrame:GetChildren()} do
			if child:IsObjectType("CheckButton")
			and aObj.modChkBtns
			then
				aObj:skinCheckButton{obj=child}
			elseif child:IsObjectType("Frame") then
				kid1 = aObj:getChild(child, 1)
				if kid1
				and kid1:IsObjectType("Button") then
					aObj:skinObject("ddbutton", {obj=kid1})
				end
			end
		end

		skinSack = _G.nop

	end

	self:SecureHook(_G.BugSack, "OpenSack", function(_)
		skinSack()

		self:Unhook(_G.BugSack, "OpenSack")
	end)
	self:SecureHook(_G.BugSack, "OpenConfig", function(_)
		skinSack()

		self:Unhook(_G.BugSack, "OpenConfig")
	end)

end
