local _, aObj = ...
if not aObj:isAddonEnabled("Questie") then return end
local _G = _G

aObj.addonsToSkin.Questie = function(self) -- v /7.0.2/

	if self.modBtns then
		self:skinStdButton{obj=_G.Questie_Toggle}
	end

	if self.modBtnBs then
		local qt = _G.QuestieLoader._modules["QuestieTracker"]
		self:SecureHook(qt, "Initialize", function(this)
			if _G.Questie.db.global.trackerEnabled then
				for i = 1, _G.C_QuestLog.GetMaxNumQuestsCanAccept() do
					self:addButtonBorder{obj=_G["Questie_ItemButton" .. i], abt=true, sabt=true, clr="grey"}
				end
				-- TODO skin TrackedQuests expandQuest buttons
			end

			self:Unhook(this, "Initialize")
		end)
	end

end
