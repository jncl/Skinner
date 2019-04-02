local aName, aObj = ...
if not aObj:isAddonEnabled("oGlow") then return end
local _G = _G

aObj.addonsToSkin.oGlow = function(self) -- v 2.2.5

	if not self.modBtnBs then
		self.addonsToSkin.oGlow = nil
		return
	end

	local function btnUpd(obj, oGB)
		oGB = oGB or obj
		if obj.sbb then
			if oGB.oGlowBorder
			and oGB.oGlowBorder:IsVisible()
			then
				obj.sbb:SetBackdrop(aObj.modUIBtns.iqbDrop)
				obj.sbb:SetBackdropBorderColor(oGB.oGlowBorder:GetVertexColor())
				oGB.oGlowBorder:SetTexture()
			else
				obj.sbb:SetBackdrop(aObj.modUIBtns.bDrop)
				obj.sbb:SetBackdropBorderColor(aObj.bbClr:GetRGBA())
			end
		end
	end

	local delays = {
		["inspect"]     = 0.2, -- LoD
		["gbank"]       = 0.5, -- LoD
		["tradeskill"]  = 0.2, -- LoD
	}
	-- hook this function to update the buttons
	self:SecureHook(_G.oGlow, "CallFilters", function(this, pipe, frame, ...)
		_G.C_Timer.After(delays[pipe] or 0.1, function()
			btnUpd(frame)
		end)
	end)

	-- remove delays when UI is skinned
	self:RegisterMessage("InspectUI_Skinned", function() delays["inspect"] = nil end)
	self:RegisterMessage("GuildBankUI_Skinned", function() delays["gbank"] = nil end)
	self:RegisterMessage("TradeSkillUI_Skinned", function() delays["tradeskill"] = nil end)

	-- Config
	local pCnt = 0
	self.RegisterCallback("oGlow_Config", "IOFPanel_Before_Skinning", function(this, panel)
		if (panel.name == "oGlow"
		or panel.parent == "oGlow")
		and not self.iofSkinnedPanels[panel]
		then
			self.iofSkinnedPanels[panel] = true
			pCnt = pCnt + 1
		end

		-- pipes
		if panel.name == "oGlow"
		and not panel.sknd
		then
			panel.sknd = true
			if self.modBtns then
				local btn
				for i = 1, #panel.scrollchild.rows do
					btn = panel.scrollchild.rows[i]
					self:skinStdButton{obj=btn, ofs=0, y1=-2, y2=-3}
					if self.modChkBtns then
						btn.check:SetSize(20, 20)
						self:skinCheckButton{obj=btn.check}
					end
				end
				btn = nil
			end
			if self.modChkBtns then
				local btn
				for i = 1, #panel.filterFrame do
					btn = panel.filterFrame[i]
					btn:SetSize(20, 20)
					self:skinCheckButton{obj=btn}
				end
				btn = nil
			end

		-- Colors
		elseif panel.name == "Colors"
		and not panel.sknd
		then
			panel.sknd = true
			self:addSkinFrame{obj=self:getChild(panel, 1), ft="a", kfs=true, nb=true, ofs=0}
			if self.modBtns then
				local btn
				for i = 0, #self:getChild(panel, 1).rows do
					btn = self:getChild(panel, 1).rows[i]
					btn:SetBackdrop(nil)
					self:skinCloseButton{obj=btn.reset, noSkin=true}
				end
				btn = nil
			end
		-- Quality
		elseif panel.name == "Filter: Quality"
		and not panel.sknd
		then
			panel.sknd = true
			self:skinDropDown{obj=_G.oGlowOptFQualityThreshold, x2=109}
		end

		if pCnt == 3 then
			self.UnregisterCallback("oGlow_Config", "IOFPanel_Before_Skinning")
			pCnt = nil
		end
	end)

end
