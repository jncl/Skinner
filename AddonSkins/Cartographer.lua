
function Skinner:Cartographer()
	if not self.db.profile.WorldMap then return end

	if CartographerLookNFeelNonOverlayHolder then
		self:keepFontStrings(CartographerLookNFeelNonOverlayHolder)
	end

	if Cartographer_Notes then self:Cartographer_Notes() end

end

function Skinner:Cartographer_Notes()
	if self.initialized.Cartographer_Notes then return end
	self.initialized.Cartographer_Notes = true

	local function skinNNF()

		local CNNNF = CartographerNotesNewNoteFrame
		if not CNNNF.skinned then
			Skinner:keepFontStrings(CNNNF)
			Skinner:moveObject(CNNNF.header, nil, nil, "+", 6, CNNNF)
			local last = nil
			for i = 1, select("#", CNNNF:GetChildren()) do
				local v = select(i, CNNNF:GetChildren())
				if v:GetObjectType() == "EditBox"  then
					Skinner:skinEditBox(v, {9})
					if last then
						Skinner:moveObject(v, nil, nil, "+", 15, last)
					end
					last = v
				end
			end
			Skinner:keepRegions(CartographerNotesNewNoteFrameIcon, {4, 5}) -- N.B region 4 is text, 5 is the icon
			Skinner:applySkin(CNNNF)
			CNNNF.skinned = true
		end

	end

	self:SecureHook(Cartographer_Notes, "OpenNewNoteFrame", function(this)
--		self:Debug("C_N_ONNF")
		skinNNF()
	end)

	self:SecureHook(Cartographer_Notes, "ShowEditDialog", function(this)
--		self:Debug("C_N_SED")
		skinNNF()
	end)

end

function Skinner:Cartographer_QuestInfo()

	if Cartographer_QuestInfo.db.profile.wideQuestLog then
		self:ScheduleEvent(function()
			self:keepFontStrings(QuestLogFrame)
			self:applySkin(QuestLogFrame)
			QuestLogFrame:SetWidth(694)
			QuestLogFrame:SetHeight(463)
			if IsAddOnLoaded("LightHeaded") then
				LightHeadedFrame:SetWidth(QuestLogFrame:GetWidth() / 2)
				LightHeadedFrame:SetHeight(QuestLogFrame:GetHeight())
			end
		end, 1)
	end

end
