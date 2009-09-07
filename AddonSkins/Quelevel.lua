local _G = _G

function Skinner:Quelevel()

	local QTHex = self:RGBPercToHex(self.HTr, self.HTg, self.HTb)

	for i = 1, NUMGOSSIPBUTTONS do
		self:RawHook(_G["GossipTitleButton"..i], "SetFormattedText", function(this, fmt, ...)
			local f, l = fmt:find("000000", 1, true) -- look for original colour stringx
			if f then
				f = fmt:sub(1, f - 1)
				l = fmt:sub(l + 1, -1)
				fmt = f .. QTHex .. l
			end
			self.hooks[this].SetFormattedText(this, fmt, ...)
		end, true)
	end

	-- Add tags to quest greeting frame (currently not supported by the addon)
	QuestFrameGreetingPanel:HookScript("OnShow", function()
		local numActQs = GetNumActiveQuests()
		local GetTitle, GetLevel, GetTriviality = GetActiveTitle, GetActiveLevel, IsActiveQuestTrivial
		local j = 0
		for i = 1, numActQs + GetNumAvailableQuests() do
			if i == numActQs + 1 then
				GetTitle, GetLevel, GetTriviality = GetAvailableTitle, GetAvailableLevel, IsAvailableQuestTrivial
				j = numActQs
			end
			local title, level, isTrivial = GetTitle(i - j), GetLevel(i - j), GetTriviality(i - j)
			local color = GetDifficultyColor(level)
			_G["QuestTitleButton"..i]:SetFormattedText(isTrivial and TRIVIAL or NORMAL, color.r*255, color.g*255, color.b*255, level, title)
		end
	end)

end
