local aName, aObj = ...
if not aObj:isAddonEnabled("WorldQuestTracker") then return end
local _G = _G

function aObj:WorldQuestTracker()

	local skincnt = 0
	self:SecureHook("ToggleWorldMap", function()
		if _G.WorldQuestTrackerGoToBIButton then
			_G.WorldQuestTrackerGoToBIButton.Background:SetTexture(nil)
			self:skinButton{obj=_G._G.WorldQuestTrackerGoToBIButton, ob4="World\nQuests", y1=2, y2=-1}
			skincnt = skincnt + 1
		end
		if _G.WorldQuestTrackerCloseSummaryButton then
			_G.WorldQuestTrackerCloseSummaryButton.Background:SetTexture(nil)
			self:skinButton{obj=_G._G.WorldQuestTrackerCloseSummaryButton, ob3="Close"}
			skincnt = skincnt + 1
		end
		if _G.WorldQuestTrackerSummaryUpPanel then
			self:skinSlider{obj=_G.WorldQuestTrackerSummaryUpPanelChrQuestsScrollScrollBar, adj=-4, size=3}
			skincnt = skincnt + 1
		end
		-- WQT Shipments Ready Frame
		if _G.WorldQuestTrackerShipmentsReadyFrame then
			self:removeRegions(_G.WorldQuestTrackerShipmentsReadyFrame, {1, 2})
			self:addSkinFrame{obj=_G.WorldQuestTrackerShipmentsReadyFrame, ofs=5, x1=10, x2=12}
			skincnt = skincnt + 1
		end
		if skincnt == 4 then
			self:Unhook("ToggleWorldMap")
		end
	end)

	_G.WorldQuestTrackerQuestsHeader.Background:SetTexture(nil)
	self:addButtonBorder{obj=_G.WorldQuestTrackerQuestsHeaderMinimizeButton, es=12, ofs=0}


end
