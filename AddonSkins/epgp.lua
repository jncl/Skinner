local aName, aObj = ...
if not aObj:isAddonEnabled("epgp") then return end
local _G = _G

function aObj:epgp()

	local epgpUI = _G.EPGP and _G.EPGP:GetModule("ui", true)
	if not epgpUI then return end

	local function skinEPGPUI()

		aObj:skinSlider{obj=_G.EPGPScrollFrameScrollBar, adj=2}
		_G.EPGPScrollFrameScrollBarBorder:SetAlpha(0)

		-- tabs
		for _, v in _G.pairs(aObj:getChild(aObj:getChild(_G.EPGPFrame, 6), 4).headers) do
			aObj:keepRegions(v, {5, 6}) -- N.B. regions 5 & 6 are highlight/text
			aObj:applySkin{obj=v}
		end
		aObj:addSkinFrame{obj=_G.EPGPFrame, kfs=true, x1=10, y1=-11, x2=-33, y2=71}

		-- ExportImport Frame
		aObj:skinScrollBar{obj=_G.EPGPExportScrollFrame}
		aObj:addSkinFrame{obj=_G.EPGPExportImportFrame, kfs=true}
		-- Log Frame
		aObj:addSkinFrame{obj=_G.EPGPLogRecordScrollFrame:GetParent()}
		aObj:addSkinFrame{obj=_G.EPGPLogFrame, kfs=true, x1=3, y1=-6, x2=-5, y2=2}

		-- Side Frame
		local frame
		aObj:SecureHookScript(_G.EPGPSideFrame, "OnShow", function(this)
			aObj:moveObject{obj=aObj:getRegion(this, 2), y=-7} -- header
			aObj:addSkinFrame{obj=this, kfs=true, x1=3, y1=-6, x2=-5, y2=6}
			-- GP Controls
			frame = aObj:getChild(this, 2)
			aObj:skinDropDown{obj=frame.dropDown}
			aObj:skinEditBox{obj=frame.editBox, regs={9}}
			-- EP Controls
			frame = aObj:getChild(this, 3)
			aObj:skinDropDown{obj=frame.dropDown}
			aObj:skinEditBox{obj=frame.otherEditBox, regs={9}}
			aObj:skinEditBox{obj=frame.editBox, regs={9}}
			aObj:Unhook(_G.EPGPSideFrame, "OnShow")
		end)
		-- Side Frame2
		aObj:SecureHookScript(_G.EPGPSideFrame2, "OnShow", function(this)
			aObj:addSkinFrame{obj=this, kfs=true, x1=3, y1=-6, x2=-5, y2=6}
			-- EP Controls
			frame = aObj:getChild(this, 2)
			aObj:skinDropDown{obj=frame.dropDown}
			aObj:skinEditBox{obj=frame.otherEditBox, regs={9}}
			aObj:skinEditBox{obj=frame.editBox, regs={9}}
			aObj:Unhook(_G.EPGPSideFrame2, "OnShow")
		end)

	end

	if not _G.EPGPFrame then
		self:SecureHook(epgpUI, "OnEnable", function()
--			self:Debug("EPGP_UI_OnEnable")
			skinEPGPUI()
			self:Unhook(_G.EPGPFrame, "Show")
		end)
	else
		self:SecureHook(_G.EPGPFrame, "Show", function(this)
--			self:Debug("EPGPFrame_Show")
			skinEPGPUI()
			self:Unhook(_G.EPGPFrame, "Show")
		end)
	end

end
