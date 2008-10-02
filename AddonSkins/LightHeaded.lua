
function Skinner:LightHeaded()

	local LHFout = false
	local LHdiv = 1

	local function moveLHFrame()
--		Skinner:Debug("moveLHFrame: [%s, %s]", LightHeaded.db.profile.open, LHFout)

		local xOfs
		if not LightHeaded.db.profile.open then
			if IsAddOnLoaded("DoubleWide") then xOfs = 30
			elseif IsAddOnLoaded("beql") then
			 	if beql.db.profile.simplequestlog then xOfs = 14 else xOfs = 20 end
			else xOfs = 15 end
			Skinner:moveObject(LightHeadedFrame, "+", xOfs, "-", 19)
			LHFout = false
		end

	end

	self:SecureHook(LightHeaded, "LockUnlockFrame", function()
--		self:Debug("LH_LUF")
		LightHeadedFrame:SetWidth(QuestLogFrame:GetWidth() / LHdiv)
		LightHeadedFrame:SetHeight(QuestLogFrame:GetHeight())
		if LightHeaded.db.profile.attached then
			if LightHeaded.db.profile.open then
				self:moveObject(LightHeadedFrame, "+", 48, "-", 19)
			end
		end
	end)

	self:SecureHook(LightHeadedFrameSub, "Hide", function()
--		self:Debug("LHFS_Hide")
		moveLHFrame()
	end)

	self:SecureHook(LightHeaded, "SelectQuestLogEntry", function()
--		self:Debug("LH_SQLE: [%s, %s]", LightHeaded.db.profile.open, LHFout)
		if LightHeaded.db.profile.open and not LHFout then
--			self:Debug("LH_SQLE#2")
			self:moveObject(LightHeadedFrame, "+", 48, "-", 19)
			LHFout = true
		end
	end)

	self:keepFontStrings(LightHeadedFrame)
	local qlfW = QuestLogFrame:GetWidth()
	if qlfW > 400 then LHdiv = 2 end
	LightHeadedFrame:SetWidth(qlfW / LHdiv)
	LightHeadedFrame:SetHeight(QuestLogFrame:GetHeight())
	self:moveObject(LightHeadedFrameSub.title, nil, nil, "-", 4)
	self:moveObject(LightHeadedFrame.close, "-", 6, "-", 4)
	self:moveObject(LightHeadedFrame.handle, "-", 4, nil, nil)
	self:keepFontStrings(LightHeadedScrollFrame)
	self:skinScrollBar(LightHeadedScrollFrame)
	self:applySkin(LightHeadedFrame)

	moveLHFrame()

-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then LightHeadedTooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(LightHeadedTooltip)
	end

end
