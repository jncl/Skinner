local _, aObj = ...
if not aObj:isAddonEnabled("oGlowClassic") then return end
local _G = _G

aObj.addonsToSkin.oGlowClassic = function(self) -- v 0.1.1-beta

	if not self.modBtnBs then
		self.addonsToSkin.oGlowClassic = nil
		return
	end

	self:SecureHook(_G.oGlowClassic, "CallFilters", function(_, filter, frame, _)
		-- wait for Border to be coloured
		_G.C_Timer.After(0.1, function()
			if frame.sbb then
				if frame.oGlowClassicBorder
				and frame.oGlowClassicBorder:IsVisible()
				then
					frame.sbb:SetBackdrop(self.modUIBtns.iqbDrop)
					frame.sbb:SetBackdropBorderColor(frame.oGlowClassicBorder:GetVertexColor())
					frame.oGlowClassicBorder:SetTexture()
				else
					frame.sbb:SetBackdrop(self.modUIBtns.bDrop)
					self:clrBtnBdr(frame.sbb, "grey")
				end
			end
		end)
	end)

	local pCnt = 0
	self.RegisterCallback("oGlowClassic_Config", "IOFPanel_Before_Skinning", function(_, panel)
		if panel.name ~= "oGlowClassic"
		and panel.parent ~= "oGlowClassic"
		then
			return
		end

		if not self.iofSkinnedPanels[panel] then
			pCnt = pCnt + 1
			self.iofSkinnedPanels[panel] = true
			if panel.name == "oGlowClassic"	then
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
			elseif panel.name == "Filter: Quality" then
				self:skinDropDown{obj=_G.oGlowClassicOptFQualityThreshold, x2=109}
			elseif panel.name == "Colors" then
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
			end
		end

		if pCnt == 3 then
			self.UnregisterCallback("oGlowClassic_Config", "IOFPanel_Before_Skinning")
		end
	end)

end
