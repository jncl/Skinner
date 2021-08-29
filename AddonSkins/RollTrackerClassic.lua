local _, aObj = ...
if not aObj:isAddonEnabled("RollTrackerClassic")
and not aObj:isAddonEnabled("RollTrackerClassicZ")
then return end
local _G = _G

local function skinRTCFrames()
	aObj:SecureHookScript(_G.RollTrackerClassicMainWindow, "OnShow", function(this)
		aObj:skinObject("slider", {obj=_G.RollTrackerClassicFrameRollScrollFrame.ScrollBar})
		aObj:skinObject("tabs", {obj=this, tabs=this.Tabs, lod=aObj.isTT and true, upwards=true})
		aObj:skinObject("frame", {obj=this, kfs=true, cb=true, ofs=0, y2=-1})
		_G.RollTrackerClassicMainWindowCloseButton:SetSize(28, 28)
		aObj:moveObject{obj=_G.RollTrackerClassicMainWindowCloseButton, x=4, y=4}
		_G.RollTrackerClassicMainWindowSettingsButton:SetSize(21, 21)
		_G.RollTrackerClassicMainWindowLootTable:SetSize(21, 21)
		_G.RollTrackerClassicFrameRollButton:SetHeight(20)
		_G.RollTrackerClassicFramePassButton:SetHeight(20)
		_G.RollTrackerClassicFrameGreedButton:SetHeight(20)
		_G.RollTrackerClassicFrameAnnounceButton:SetHeight(20)
		_G.RollTrackerClassicFrameClearButton:SetHeight(20)
		_G.RollTrackerClassicFrameNotRolledButton:SetHeight(20)
		_G.RollTrackerClassicZLootFrameClearButton:SetHeight(20)
		_G.RollTrackerClassicCSVFrameExportButton:SetHeight(20)
		if aObj.modBtns then
			aObj:skinStdButton{obj=_G.RollTrackerClassicMainWindowSettingsButton}
			aObj:skinStdButton{obj=_G.RollTrackerClassicMainWindowLootTable}
			aObj:skinStdButton{obj=_G.RollTrackerClassicFrameHelperButton}
			aObj:skinStdButton{obj=_G.RollTrackerClassicFrameRollButton}
			aObj:skinStdButton{obj=_G.RollTrackerClassicFramePassButton}
			aObj:skinStdButton{obj=_G.RollTrackerClassicFrameGreedButton}
			aObj:skinStdButton{obj=_G.RollTrackerClassicFrameAnnounceButton}
			aObj:skinStdButton{obj=_G.RollTrackerClassicFrameClearButton}
			aObj:skinStdButton{obj=_G.RollTrackerClassicFrameNotRolledButton}
			aObj:skinStdButton{obj=_G.RollTrackerClassicZLootFrameClearButton}
			aObj:skinStdButton{obj=_G.RollTrackerClassicCSVFrameExportButton}
		end

		aObj:Unhook(this, "OnShow")
	end)

	aObj:SecureHook(_G.RollTrackerClassic_Addon.Tool, "CopyPast", function(this, text)
		local cpFrame = aObj:getLastChild(_G.UIParent)
		aObj:skinObject("slider", {obj=aObj:getLastChild(cpFrame).ScrollBar})
		-- N.B. skin button before frame otherwise it won't be the penultimate child
		if aObj.modBtns then
			aObj:skinStdButton{obj=aObj:getPenultimateChild(cpFrame)}
		end
		aObj:skinObject("frame", {obj=cpFrame, kfs=true})
		cpFrame = nil
		
		aObj:Unhook(_G.RollTrackerClassic_Addon, "CopyPast")
	end)

	-- minimap button
	aObj.mmButs["RollTrackerClassic"] = _G.Lib_GPI_Minimap_RollTrackerClassic

	-- Option panels
	local op = {}
	aObj.RegisterCallback("RollTrackerClassic", "IOFPanel_After_Skinning", function(this, panel)
		if not aObj:hasTextInName(panel, "RollTrackerClassic") then return end

		op[panel:GetName():match("(%d)")] = true

		if _G[panel:GetName() .. "Scroll"] then
			aObj:skinObject("slider", {obj=_G[panel:GetName() .. "Scroll"].ScrollBar})
		end

		for _, eb in pairs(_G.RollTrackerClassic_Addon.Options.Edit) do
			aObj:skinEditBox{obj=eb, regs={6}} -- 6 is text
		end

		if aObj.modChkBtns then
			for _, cb in pairs(_G.RollTrackerClassic_Addon.Options.CBox) do
				aObj:skinCheckButton{obj=cb}
			end
		end

		if op[1] and op[2] and op[3] then
			aObj.UnregisterCallback("RollTrackerClassic", "IOFPanel_After_Skinning")
			op = nil
		end
	end)
end
aObj.addonsToSkin.RollTrackerClassic = function(self) -- v 2.10

	skinRTCFrames()
	
end
aObj.addonsToSkin.RollTrackerClassicZ = function(self) -- v 1.1.3

	skinRTCFrames()
	
end
