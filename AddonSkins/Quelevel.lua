local _G = _G
local origNQD = NORMAL_QUEST_DISPLAY
local origTQD = TRIVIAL_QUEST_DISPLAY

function Skinner:Quelevel()

	local TRIVIAL = "|cff%02x%02x%02x[%d]|r "..TRIVIAL_QUEST_DISPLAY
	local NORMAL = "|cff%02x%02x%02x[%d]|r ".. NORMAL_QUEST_DISPLAY
	
	for i = 1, NUMGOSSIPBUTTONS do
		self:RawHook(_G["GossipTitleButton"..i], "SetFormattedText", function(this, fmt, ...)
			if fmt:find(origNQD, 1, true) then
				fmt = NORMAL
			elseif fmt:find(origTQD, 1, true) then
				fmt = TRIVIAL
			end
			self.hooks[this].SetFormattedText(this, fmt, ...)
		end, true)
	end

	-- Add tags to quest greeting frame (currently not supported by the addon)
	QuestFrameGreetingPanel:HookScript("OnShow", function()
		local numActQs = GetNumActiveQuests()
		local numAvailQs = GetNumAvailableQuests()
		for i = 1, numActQs do
			local title, level, isTrivial = GetActiveTitle(i), GetActiveLevel(i), IsActiveQuestTrivial(i)
			local color = GetDifficultyColor(level)
			_G["QuestTitleButton"..i]:SetFormattedText(isTrivial and TRIVIAL or NORMAL, color.r*255, color.g*255, color.b*255, level, title)
		end
		for i = numActQs + 1, numActQs + numAvailQs do
			local j = i - numActQs
			local title, level, isTrivial = GetAvailableTitle(j), GetAvailableLevel(j), IsAvailableQuestTrivial(j)
			local color = GetDifficultyColor(level)
			_G["QuestTitleButton"..i]:SetFormattedText(isTrivial and TRIVIAL or NORMAL, color.r*255, color.g*255, color.b*255, level, title)
		end
	end)
	
end
