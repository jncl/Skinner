local aName, aObj = ...
if not aObj:isAddonEnabled("Warden") then return end

function aObj:Warden()

	-- Popup frame
	self:skinEditBox{obj=GuildWardenPopTextBox, regs={9}}
	self:addSkinFrame{obj=frmGuildWardenPopup, kfs=true, ofs=-2, x2=-1}

	-- GuildLeft frame
	self:skinFFColHeads("GuildLeftColumnButton", 4)
	self:skinSlider{obj=GuildLeftContainerScrollBar}

	-- GuildJoined frame
	self:skinFFColHeads("GuildJoinedColumnButton", 4)
	self:skinSlider{obj=GuildJoinedContainerScrollBar}

	-- GuildBannedframe
	self:skinFFColHeads("GuildBannedColumnButton", 4)
	self:skinSlider{obj=GuildBannedContainerScrollBar}

	-- GuildWardenAlts frame
	self:skinFFColHeads("GuildAltsColumnButton", 4)
	self:skinSlider{obj=GuildAltsContainerScrollBar}
	self:addSkinFrame{obj=frmGuildWardenAlts}

	-- GuildWardenRealm frame
	self:skinFFColHeads("GuildRealmColumnButton", 4)
	self:skinSlider{obj=GuildRealmContainerScrollBar}
	self:addSkinFrame{obj=frmGuildWardenRealm, kfs=true, ofs=-2, x2=-1}
	self:SecureHookScript(frmGuildWardenRealm, "OnShow", function(this)
		self:skinEditBox{obj=TextBoxGWRealm1, regs={9}}
		self:Unhook(frmGuildWardenRealm, "OnShow")
	end)

	-- GuildWardenSharing frame
	self:skinFFColHeads("GuildGuildSharingColumnButton", 6)
	self:skinSlider{obj=GuildGuildSharingContainerScrollBar}
	self:addSkinFrame{obj=frmGuildWardenSharing, kfs=true, ofs=-2, x2=-1}
	self:SecureHookScript(frmGuildWardenSharing, "OnShow", function(this)
		for _, v in pairs{"Sending", "Receiving", "Ping", "Update", "Global", "GlobalIn"} do
			local sbName = "GuildWardenStatusBar"
			if v == "Receiving" then
				for j = 1, 5 do
					w = v..j
					self:glazeStatusBar(_G[sbName..w], 0, _G[sbName..w].bg)
				end
			elseif v =="Update" then
				local sbName = "GuildWardenStatus"
				for j = 1, 2 do
					w = v..j
					self:glazeStatusBar(_G[sbName..w], 0, _G[sbName..w].bg)
				end
			else
				self:glazeStatusBar(_G[sbName..v], 0, _G[sbName..v].bg)
			end
		end
		self:Unhook(frmGuildWardenSharing, "OnShow")
	end)

	-- GuildWardenInfo frame
	self:skinFFColHeads("GuildNotesColumnButton", 4)
	self:skinSlider{obj=GuildNotesContainerScrollBar}
	self:addSkinFrame{obj=frmGuildWardenInfo, kfs=true, ofs=-2, x2=-1}

end
