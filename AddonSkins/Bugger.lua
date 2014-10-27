local aName, aObj = ...
if not aObj:isAddonEnabled("Bugger") then return end
local _G = _G

function aObj:Bugger()
	if not aObj.db.profile.DebugTools then return end

	local function chgTabTex(tab)
		for i = 1, _G.ScriptErrorsFrame.numTabs do
			local tabObj = _G["ScriptErrorsFrameTab" .. i]
			if tab == tabObj then
				aObj:setActiveTab(tabObj.sf)
			else
				aObj:setInactiveTab(tabObj.sf)
			end
			
		end
	end
	self:SecureHook(_G.Bugger, "SetupFrame", function(this)
		_G.ScriptErrorsFrame.numTabs = 3
		_G.ScriptErrorsFrame.selectedTab = 3
		self:skinTabs{obj=_G.ScriptErrorsFrame, ignore=true, lod=true, x1=16, y1=3, x2=-14, y2=4}
		if aObj.isTT then
			for i = 1, _G.ScriptErrorsFrame.numTabs do
				self:SecureHookScript(_G["ScriptErrorsFrameTab" .. i], "OnClick", function(this)
					chgTabTex(this)	
				end)
			end
		end
		_G.ScriptErrorsFrame:SetScale(1.25)
		self:Unhook(_G.Bugger, "SetupFrame")
	end)

end
