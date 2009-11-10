
function Skinner:Cauldron()

	-- Main frame
	self:skinButton{obj=CauldronFrameCloseButton, cb=true}
	self:skinDropDown{obj=CauldronFiltersFilterDropDown}
	self:skinEditBox{obj=CauldronFiltersSearchEditBox}
	self:skinDropDown{obj=CauldronFiltersCategoryDropDown}
	self:skinDropDown{obj=CauldronFiltersInvSlotDropDown}
	self:addSkinFrame{obj=CauldronFrame, kfs=true, x1=9, y1=-11, x2=-5, y2=-1}
	-- List frame
	self:removeRegions(CauldronSkillListFrameExpandButtonFrame)
	self:skinButton{obj=CauldronSkillListFrameExpandButtonFrameCollapseAllButton, mp=true}
	self:skinScrollBar{obj=CauldronSkillListFrameScrollFrame}
	if self.db.profile.Buttons then
		-- hook to manage changes to button textures
		self:SecureHook(Cauldron, "UpdateSkillList", function()
			local skillName = CURRENT_TRADESKILL
			if IsTradeSkillLinked() then skillName = "Linked-"..skillName end
			local skillList = Cauldron:GetSkillList(self.uName, skillName)
			for i = 1, #skillList do
				local btn = _G["CauldronSkillItem"..i.."DiscloseButton"]
				if not btn then break end
				if not btn.skin then -- skin button if required
					self:skinButton{obj=btn, mp=true, plus=true}
					btn.skin = true
				end
				if btn then self:checkTex(btn) end
			end
--			self:checkTex(CauldronSkillListFrameExpandButtonFrameCollapseAllButton) --[ Not currently updated v154]
		end)
	end
	
	-- Skill Info frame
	self:keepFontStrings(CauldronRankFrame)
	self:glazeStatusBar(CauldronRankFrame, 0)
	-- Queue frame
	self:skinScrollBar{obj=CauldronQueueFrameScrollFrame}
	CauldronQueueFrameQueueEmptyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	-- Buttons frame
	self:skinButton{obj=CauldronQueueAllButton}
	self:skinButton{obj=CauldronCreateAllButton}
	self:skinEditBox{obj=CauldronAmountInputBox}
	self:adjHeight{obj=CauldronAmountInputBox, adj=-4}
	self:moveObject{obj=CauldronAmountInputBox, x=-4}
	self:skinButton{obj=CauldronCreateButton}
	self:skinButton{obj=CauldronQueueButton}
	self:skinButton{obj=CauldronProcessButton}
	self:skinButton{obj=CauldronClearQueueButton}
	self:skinButton{obj=CauldronCloseButton}

-->>-- Shopping List
	self:skinButton{obj=CauldronShoppingListFrameCloseButton, cb=true}
	self:addSkinFrame{obj=CauldronShoppingListFrame, x1=-2}

end
