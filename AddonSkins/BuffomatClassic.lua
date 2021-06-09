local _, aObj = ...
if not aObj:isAddonEnabled("BuffomatClassic")
and not aObj:isAddonEnabled("BuffomatClassicTBC")
then
	return
end
local _G = _G

local function skinFrames(aName)
	aObj:SecureHookScript(_G.BomC_MainWindow, "OnShow", function(this)
		aObj:skinObject("slider", {obj=_G.BomC_SpellTab_Scroll.ScrollBar})
		aObj:skinObject("tabs", {obj=this, tabs=this.Tabs, lod=aObj.isTT and true, ignoreHLTex=false, offsets={x1=7, y1=aObj.isTT and 2 or 0, x2=-6, y2=aObj.isTT and 4 or 2}})
		aObj:skinObject("frame", {obj=this, kfs=true, ofs=0})
		if aObj.modBtns then
			_G.BomC_MainWindow_CloseButton:SetSize(27, 27)
			aObj:skinCloseButton{obj=_G.BomC_MainWindow_CloseButton}
			_G.BomC_MainWindow_SettingsButton:SetSize(20, 20)
			aObj:skinStdButton{obj=_G.BomC_MainWindow_SettingsButton}
			_G.BomC_MainWindow_MacroButton:SetSize(40, 20)
			aObj:skinStdButton{obj=_G.BomC_MainWindow_MacroButton}
			aObj:skinStdButton{obj=_G.BomC_ListTab_Button, sec=true}
		end

		aObj:Unhook(this, "OnShow")
	end)
	aObj:checkShown(_G.BomC_MainWindow)

	aObj.RegisterCallback(aName, "IOFPanel_Before_Skinning", function(this, panel)
		if aObj:hasTextInDebugNameRE(panel, "O_OptionFrame") then
			local sFrame = _G[panel:GetDebugName() .. "Scroll"]
			aObj:skinObject("slider", {obj=sFrame.ScrollBar})
			for _, child in _G.pairs{sFrame:GetScrollChild():GetChildren()} do
				if child:IsObjectType("CheckButton") then
					if aObj.modChkBtns then
						aObj:skinCheckButton{obj=child}
					end
				elseif child:IsObjectType("EditBox") then
					aObj:skinObject("editbox", {obj=child})
				elseif child:IsObjectType("Button") then
					if aObj.modBtns then
						aObj:skinStdButton{obj=child}
					end
				end
			end
			sFrame = nil
		end
	end)
	
end

if aObj:isAddonEnabled("BuffomatClassic") then
	aObj.addonsToSkin.BuffomatClassic = function(self) -- v 2021.6.1-68f13f34

		skinFrames("BuffomatClassic")
		
	end
elseif aObj:isAddonEnabled("BuffomatClassicTBC") then
	aObj.addonsToSkin.BuffomatClassicTBC = function(self) -- v 2021.6.2-6baae3de
	
		skinFrames("BuffomatClassicTBC")
		
	end
end
