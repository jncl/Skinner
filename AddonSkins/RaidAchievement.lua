if not Skinner:isAddonEnabled("RaidAchievement") then return end

local x1, y1 = -2, -4
function Skinner:RaidAchievement()

-->>-- Main Frames
	self:skinAllButtons{obj=PSFeamain1}
	self:addSkinFrame{obj=PSFeamain2, x1=x1, y1=y1}
	self:addSkinFrame{obj=PSFeamainWotlk, x1=x1, y1=y1}
	self:addSkinFrame{obj=PSFeamain3, x1=x1, y1=y1}
	self:addSkinFrame{obj=PSFeamain12, x1=x1, y1=y1}
	self:addSkinFrame{obj=PSFeamain10, x1=x1, y1=y1}
	self:addSkinFrame{obj=PSFeamain11, x1=x1, y1=y1}
	self:addSkinFrame{obj=PSFeamainmanyach, x1=x1, y1=y1}

end

function Skinner:RaidAchievement_Icecrown()

	self:skinDropDown{obj=DropDownMenureporticra}
	self:addSkinFrame{obj=icramain6, x1=x1, y1=y1}

end

function Skinner:RaidAchievement_Naxxramas()

	self:skinDropDown{obj=DropDownMenureportnxra}
	self:addSkinFrame{obj=nxramain6, x1=x1, y1=y1}

end

function Skinner:RaidAchievement_Ulduar()

	self:skinDropDown{obj=DropDownMenureportra}
	self:addSkinFrame{obj=PSFeamain7, x1=x1, y1=y1}

end

function Skinner:RaidAchievement_WotlkHeroics()

	self:skinDropDown{obj=DropDownMenureportwhra}
	self:addSkinFrame{obj=whramain6, x1=x1, y1=y1}

end

function Skinner:RaidAchievement_AchieveReminder()

	self:addSkinFrame{obj=icralistach, x1=x1, y1=y1}

	self:SecureHook("iclldrawtext", function()
		self:skinEditBox{obj=pseb1, regs={9}}
		self:skinScrollBar{obj=psllinfscroll}
		self:Unhook("iclldrawtext")
	end)
	self:SecureHook("openmenull", function()
		self:skinDropDown{obj=DropDownMenureportll}
		self:Unhook("openmenull")
	end)
end
