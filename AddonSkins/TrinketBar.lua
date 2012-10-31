local aName, aObj = ...
if not aObj:isAddonEnabled("TrinketBar") then return end

function aObj:TrinketBar()

	self:addSkinFrame{obj=K_TBanchor}

	if self.modBtnBs then
		local function skinPopupBtns()

			for i = 1, 20 do
				local btn = _G["TrinketBarPopupButton"..i]
				if btn
				and not btn.sbb
				then
					aObj:addButtonBorder{obj=btn, abt=true}
				end
			end

		end
		local spbTmr
		self:addButtonBorder{obj=K_TB_TopTrinket, abt=true, sec=true}
		self:SecureHookScript(K_TB_TopTrinket, "OnEnter", function(this)
			if not spbTmr then
				spbTmr = self:ScheduleRepeatingTimer(skinPopupBtns, 0.1)
			end
		end)
		self:SecureHookScript(K_TB_TopTrinket, "OnLeave", function(this)
			self:CancelTimer(spbTmr, true)
			spbTmr = nil
		end)
		self:addButtonBorder{obj=K_TB_BottomTrinket, abt=true, sec=true}
		self:SecureHookScript(K_TB_BottomTrinket, "OnEnter", function(this)
			if not spbTmr then
				spbTmr = self:ScheduleRepeatingTimer(skinPopupBtns, 0.1)
			end
		end)
		self:SecureHookScript(K_TB_BottomTrinket, "OnLeave", function(this)
			self:CancelTimer(spbTmr, true)
			spbTmr = nil
		end)
	end

end
