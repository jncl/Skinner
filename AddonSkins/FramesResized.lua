
function Skinner:FramesResized()

--	self:Debug("resize_LootFrame")
	if self.db.profile.LootFrame and LootFrame_MidTextures then
		self:SecureHook(LootFrame, "Show", function(this)
			local _, _, _, _, yOfs = self:getRegion(LootFrame, 3):GetPoint()
			-- self:Debug("yOfs, LFyOfs: [%s, %s]", yOfs, self.LFyOfs)
			if (GetNumLootItems() > LOOTFRAME_NUMBUTTONS_ORG) then
				LootFrame:SetHeight(375)
				if math.floor(yOfs) == math.floor(self.LFyOfs) then
					self:moveObject(self:getRegion(LootFrame, 3), nil, nil, "+", 80)
				end
			else
				LootFrame:SetHeight(self.LFHeight)
				if math.floor(yOfs) ~= math.floor(self.LFyOfs) then
					self:moveObject(self:getRegion(LootFrame, 3), nil, nil, "-", 80)
				end
			end
		end)
		self:removeRegions(LootFrame_MidTextures)
	end

--	self:Debug("resize_QuestLog")
	if self.db.profile.QuestLog and QuestLogFrame_MidTextures then
		self:SecureHook("QuestLog_OnShow", function()
			QuestLogFrame:SetHeight(QuestLogFrame:GetHeight() - 64)
		end)
		self:removeRegions(QuestLogFrame_MidTextures)
	end

	if IsAddOnLoaded("Blizzard_CraftUI") then self:FR_CraftUI() end
	if IsAddOnLoaded("Blizzard_TradeSkillUI") then self:FR_TradeSkillUI() end
	if IsAddOnLoaded("Blizzard_TrainerUI") then self:FR_TrainerUI() end

end

function Skinner:FR_CraftUI()

--	self:Debug("FR_CraftUI")
	if self.db.profile.CraftFrame and CraftFrame_MidTextures then
		self:removeRegions(CraftFrame_MidTextures)
		self:removeRegions(CraftListScrollFrame_MidTextures)
		self:moveObject(CraftCreateButton, nil, nil, "+", 20)
		self:moveObject(CraftCancelButton, nil, nil, "+", 20)
	end

end

function Skinner:FR_TradeSkillUI()

--	self:Debug("FR_TradeSkillUI")
	if self.db.profile.TradeSkill and TradeSkillFrame_MidTextures then
		self:removeRegions(TradeSkillFrame_MidTextures)
		self:removeRegions(TradeSkillListScrollFrame_MidTextures)
		self:removeRegions(TradeSkillDetailScrollFrame)
		self:moveObject(TradeSkillDetailScrollFrame, "-", 5, nil, nil)
		self:skinScrollBar(TradeSkillDetailScrollFrame)
		self:moveObject(TradeSkillCreateButton, nil, nil, "+", 20)
		self:moveObject(TradeSkillCancelButton, nil, nil, "+", 20)
	end

end

function Skinner:FR_TrainerUI()

--	self:Debug("FR_TrainerUI")
	if self.db.profile.ClassTrainer and ClassTrainerFrame_MidTextures then
		self:removeRegions(ClassTrainerFrame_MidTextures)
		self:removeRegions(ClassTrainerListScrollFrame_MidTextures)
		ClassTrainerFrame:SetHeight(ClassTrainerFrame:GetHeight() + 20)
	end

end
