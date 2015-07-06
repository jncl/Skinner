local aName, aObj = ...
if not aObj:isAddonEnabled("GuildMaster") then return end
local frame

function aObj:GuildMaster()

	-- GuildFrame module
	self:SecureHook(GMaster.GFL, "GMGuildFrame", function(this)
		-- header1
		self:keepFontStrings(self:getChild(GuildFrame, 26))
		-- header2
		self:keepFontStrings(self:getChild(GuildFrame, 27))
		-- GMForumInset frame
		GMForumInset:DisableDrawLayer("BACKGROUND")
		GMForumInset:DisableDrawLayer("BORDER")
		-- GuildInfoFrameTab4
		self:SecureHook("GuildFrame_TabClicked", function(this)
			if this:GetID() == 4 then
				-- GuildRewards
				GuildRewardsContainer:SetWidth(302)
			elseif this:GetID() == 5
			and not self.skinFrame[GuildInfoFrameTab4]
			then
				self:keepRegions(GuildInfoFrameTab4, {7, 8})
				tabSF = self:addSkinFrame{obj=GuildInfoFrameTab4, ft=ftype, noBdr=self.isTT, x1=2, y1=-5, x2=2, y2=-5}
				tabSF.up = true -- tabs grow upwards
				if self.isTT then self:setInactiveTab(tabSF) end
			end
		end)
		self:Unhook(GMaster.GFL, "GMGuildFrame")
	end)

	-- Event module
	self:SecureHook(GMaster.GFL, "GMEvent", function(this)
		frame = GMEventEB:GetParent()
		self:skinEditBox{obj=frame.EditBox, regs={9}}
		self:skinEditBox{obj=frame.LevelBox, regs={9}}
		self:skinEditBox{obj=frame.iLevelBox, regs={9}}
		self:skinEditBox{obj=frame.RessiBox, regs={9}}
		self:skinDropDown{obj=frame.DDHeal}
		self:skinDropDown{obj=frame.DDDps}
		self:skinDropDown{obj=frame.DDTank}
		if frame then
			self:addSkinFrame{obj=frame}
		end
		for i = 1, #frame.List do
			btn = frame.List[i]
			btn:DisableDrawLayer("BACKGROUND")
		end
		self:Unhook(GMaster.GFL, "GMEvent")
	end)
	
	-- Roster module
	self:SecureHook(GMaster.GFL, "GMRoster", function(this)
		-- Roster frame
		self:skinEditBox{obj=GMRosterSearchBox, regs={9}}
		self:skinDropDown{obj=GMRosterDD}
		self:removeRegions(GMRosterTabName, {1, 2, 3})
		self:applySkin{obj=GMRosterTabName, bba=0}
		--[=[
			TODO other tabs
		--]=]
		-- Member Detail frame
		frame = self:getChild(GMRosterSearchBox:GetParent(), 3)
		self:addSkinFrame{obj=frame, ofs=-8}
		-- Member Detail Tabs
		for _, v in pairs(frame.Tabs) do
			self:removeRegions(v, {1, 2, 3})
			self:addSkinFrame{obj=v, noBdr=true, ofs=2}
		end
		self:addSkinFrame{obj=frame.Pages[1].personal}
		self:addSkinFrame{obj=frame.Pages[1].officer}
		self:Unhook(GMaster.GFL, "GMRoster")
	end)
	
	-- Ranking module
	self:SecureHook(GMaster.GFL, "GMRanker", function(this)
		self:skinDropDown{obj=GMRankerRankSelect}
		self:Unhook(GMaster.GFL, "GMRanker")
	end)
	
	-- Forum module
	self:SecureHook(GMaster.GFL, "GMForum", function(this)
		frame = self:getChild(GuildForumFrame, 1)
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		self:addSkinFrame{obj=frame}
		frame = self:getChild(GuildForumFrame, 2)
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		self:skinScrollBar{obj=ForumEditBoxScroll}
		frame = self:getChild(GuildForumFrame, 5)
		self:addSkinFrame{obj=frame}
		self:Unhook(GMaster.GFL, "GMForum")
	end)

	-- Banker module
	self:SecureHook(GMaster.GFL, "GMBanker", function(this)
		frame = self:getChild(GuildFrame, 33)
		frame.bg:SetAlpha(0)
		self:addSkinFrame{obj=frame}
		self:Unhook(GMaster.GFL, "GMBanker")
	end)

end
