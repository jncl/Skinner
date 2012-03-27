local aName, aObj = ...
if not aObj:isAddonEnabled("epgp") then return end

function aObj:epgp()

	local epgpUI = EPGP and EPGP:GetModule("ui", true)
	if not epgpUI then return end

	local function skinEPGPUI()
	
		aObj:skinSlider{obj=EPGPScrollFrameScrollBar, adj=2}
		EPGPScrollFrameScrollBarBorder:SetAlpha(0)
		
		-- tabs
		for _, v in pairs(aObj:getChild(aObj:getChild(EPGPFrame, 6), 4).headers) do
			aObj:keepRegions(v, {5, 6}) -- N.B. regions 5 & 6 are highlight/text
			aObj:applySkin{obj=v}
		end
		aObj:addSkinFrame{obj=EPGPFrame, kfs=true, x1=10, y1=-11, x2=-33, y2=71}
		
		-- Side Frame
		aObj:skinDropDown{obj=EPGPSideFrameGPControlDropDown}
		aObj:skinDropDown{obj=EPGPSideFrameEPControlDropDown}
		aObj:skinEditBox{obj=EPGPSideFrameGPControlEditBox, regs={9}}
		aObj:skinEditBox{obj=EPGPSideFrameEPControlOtherEditBox, regs={9}}
		aObj:skinEditBox{obj=EPGPSideFrameEPControlEditBox, regs={9}}
		aObj:moveObject{obj=aObj:getRegion(EPGPSideFrame, 2), y=-6}
		aObj:addSkinFrame{obj=EPGPSideFrame, kfs=true, x1=3, y1=-6, x2=-5, y2=6}
		-- Side Frame2
		aObj:skinDropDown{obj=EPGPSideFrame2EPControlDropDown}
		aObj:skinEditBox{obj=EPGPSideFrame2EPControlOtherEditBox, regs={9}}
		aObj:skinEditBox{obj=EPGPSideFrame2EPControlEditBox, regs={9}}
		aObj:addSkinFrame{obj=EPGPSideFrame2, kfs=true, x1=3, y1=-6, x2=-5, y2=6}
		-- Log Frame
		aObj:addSkinFrame{obj=EPGPLogRecordScrollFrame:GetParent()}
		aObj:addSkinFrame{obj=EPGPLogFrame, kfs=true, x1=3, y1=-6, x2=-5, y2=2}
		-- ExportImport Frame
		aObj:skinScrollBar{obj=EPGPExportScrollFrame}
		aObj:addSkinFrame{obj=EPGPExportImportFrame, kfs=true}
		
	end
	
	if not EPGPFrame then
		self:SecureHook(epgpUI, "OnEnable", function()
--			self:Debug("EPGP_UI_OnEnable")
			skinEPGPUI()
			self:Unhook(EPGPFrame, "Show")
		end)
	else
		self:SecureHook(EPGPFrame, "Show", function(this)
--			self:Debug("EPGPFrame_Show")
			skinEPGPUI()
			self:Unhook(EPGPFrame, "Show")
		end)
	end
		
end
