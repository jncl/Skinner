local _, aObj = ...
if not aObj:isAddonEnabled("BigWigs") then return end
local _G = _G

aObj.addonsToSkin.BigWigs = function(self) -- v 394.3

	-- skin BigWigs statusbar on the LFGDungeonReadyPopup
	if _G.BigWigsLoader then
		_G.BigWigsLoader.RegisterMessage(self, "BigWigs_FrameCreated", function(event, frame, name)
			if name == "QueueTimer" then
				aObj:skinObject("statusbar", {obj=frame, regions={4}, fi=0, bg=aObj:getRegion(frame, 2)})
				_G.BigWigsLoader.UnregisterMessage(self, "BigWigs_FrameCreated")
			end
		end)
	end

	local function skinKeystonesFrame(frame)
		aObj:skinObject("tabs", {obj=frame, tabs=frame.Tabs, ignoreSize=true, lod=aObj.isTT and true, offsets={x1=nil, y1=nil, x2=nil, y2=-2}, track=false})
		if aObj.isTT then
			for _, tab in _G.pairs(frame.Tabs) do
				aObj:SecureHookScript(tab, "OnClick", function(this)
					for _, tab in _G.pairs(frame.Tabs) do
						aObj:setInactiveTab(tab.sf)
					end
					aObj:setActiveTab(this.sf)
				end)
			end
		end
		aObj:skinObject("scrollbar", {obj=aObj:getChild(frame, 6).ScrollBar})
		aObj:skinObject("frame", {obj=frame, kfs=true, cb=true})
	end
	-- find keystones frame
	aObj.RegisterCallback("BigWigs", "UIParent_GetChildren", function(self, child, _)
		if _G.Round(child:GetWidth()) == 350
		and child:GetFrameStrata() == "DIALOG"
		and child.Tabs
		and #child.Tabs == 4
		and child.GetSourceLocation
		and child:GetSourceLocation()
		and child:GetSourceLocation():find("BigWigs")
		then
			skinKeystonesFrame(child)
			aObj.UnregisterCallback("BigWigs", "UIParent_GetChildren")
		end
	end)
	aObj:scanChildren{obj=_G.UIParent, cbstr="UIParent_GetChildren"}

end
