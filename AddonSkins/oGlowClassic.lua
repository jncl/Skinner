local _, aObj = ...
if not aObj:isAddonEnabled("oGlowClassic") then return end
local _G = _G

aObj.addonsToSkin.oGlowClassic = function(self) -- v 0.1.1-beta

	if not self.modBtnBs then
		self.addonsToSkin.oGlowClassic = nil
		return
	end

	local function btnUpd(obj, oGCB)
		oGCB = oGCB or obj.oGlowClassicBorder
		if obj.sbb then
			if oGCB
			and oGCB:IsVisible()
			then
				obj.sbb:SetBackdrop(aObj.modUIBtns.iqbDrop)
				obj.sbb:SetBackdropBorderColor(oGCB:GetVertexColor())
				oGCB:SetTexture()
			else
				obj.sbb:SetBackdrop(aObj.modUIBtns.bDrop)
				aObj:clrBtnBdr(obj.sbb, "grey")
			end
		end
	end

	-- hook this function to update the buttons
	self:SecureHook(_G.oGlowClassic, "CallFilters", function(_, _, frame, _)
		_G.C_Timer.After(0.1, function()
			btnUpd(frame, frame.oGlowClassicBorder)
		end)
	end)

	-- Config
	local pCnt = 0
	self.RegisterMessage("oGlowClassic_Config", "IOFPanel_Before_Skinning", function(_, panel)
		if (panel.name == "oGlowClassic"
		or panel.parent == "oGlowClassic")
		and not self.iofSkinnedPanels[panel]
		then
			pCnt = pCnt + 1
		end
		-- pipes
		if panel.name == "oGlowClassic"
		and not self.iofSkinnedPanels[panel]
		then
			self.iofSkinnedPanels[panel] = true
			if self.modBtns then
				for _, btn in _G.ipairs(panel.scrollchild.rows) do
					self:removeBackdrop(btn)
					btn.SetBackdropBorderColor = _G.nop
					self:skinStdButton{obj=btn, ofs=0, y2=-3}
					self:HookScript(btn, "OnEnter", function(this)
						this.sb:SetBackdropBorderColor(0.5, 0.9, 0.06)
					end)
					self:HookScript(btn, "OnLeave", function(this)
						self:clrBtnBdr(this.sb)
					end)
					if self.modChkBtns then
						btn.check:SetSize(20, 20)
						self:skinCheckButton{obj=btn.check}
					end
				end
			end
			if self.modChkBtns then
				for _, btn in _G.ipairs(panel.filterFrame) do
					btn:SetSize(20, 20)
					self:skinCheckButton{obj=btn}
				end
			end
		-- Colors
		elseif panel.name == "Colors"
		and not self.iofSkinnedPanels[panel]
		then
			self.iofSkinnedPanels[panel] = true
			self:skinObject("frame", {obj=self:getChild(panel, 1), fb=true})
			for _, row in _G.pairs(self:getChild(panel, 1).rows) do
				self:skinObject("editbox", {obj=row.blueLabel})
				self:skinObject("editbox", {obj=row.greenLabel})
				self:skinObject("editbox", {obj=row.redLabel})
				if self.modBtns then
					self:removeBackdrop(row)
					self:skinCloseButton{obj=row.reset, noSkin=true}
				end
			end
		-- Quality
		elseif panel.name == "Filter: Quality"
		and not self.iofSkinnedPanels[panel]
		then
			self.iofSkinnedPanels[panel] = true
			self:skinDropDown{obj=_G.oGlowClassicOptFQualityThreshold, x2=109}
		end
		if pCnt == 3 then
			self.UnregisterMessage("oGlowClassic_Config", "IOFPanel_Before_Skinning")
			pCnt = nil
		end
	end)

end
