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

	self:addSkinFrame{obj=icramain6, x1=x1, y1=y1}
	if not DropDownMenureporticra then
		self:SecureHook("openmenureporticra", function()
			self:skinDropDown{obj=DropDownMenureporticra}
			self:Unhook("openmenureporticra")
		end)
	else
		self:skinDropDown{obj=DropDownMenureporticra}
	end

end

function Skinner:RaidAchievement_Naxxramas()

	self:addSkinFrame{obj=nxramain6, x1=x1, y1=y1}
	if not DropDownMenureportnxra then
		self:SecureHook("openmenureportnxra", function()
			self:skinDropDown{obj=DropDownMenureportnxra}
			self:Unhook("openmenureportnxra")
		end)
	else
		self:skinDropDown{obj=DropDownMenureportnxra}
	end

end

function Skinner:RaidAchievement_Ulduar()

	self:addSkinFrame{obj=PSFeamain7, x1=x1, y1=y1}
	if not DropDownMenureportra then
		self:SecureHook("openmenureportra", function()
			self:skinDropDown{obj=DropDownMenureportra}
			self:Unhook("openmenureportra")
		end)
	else
		self:skinDropDown{obj=DropDownMenureportra}
	end

end

function Skinner:RaidAchievement_WotlkHeroics()

	self:addSkinFrame{obj=whramain6, x1=x1, y1=y1}
	if not DropDownMenureportwhra then
		self:SecureHook("openmenureportwhra", function()
			self:skinDropDown{obj=DropDownMenureportwhra}
			self:Unhook("openmenureportwhra")
		end)
	else
		self:skinDropDown{obj=DropDownMenureportwhra}
	end


end

function Skinner:RaidAchievement_AchieveReminder()

	self:addSkinFrame{obj=icralistach, x1=x1, y1=y1}
	self:SecureHook("iclldrawtext", function()
		self:skinEditBox{obj=rallpseb1, regs={9}}
		self:skinScrollBar{obj=psllinfscroll}
		self:Unhook("iclldrawtext")
	end)
	if not DropDownMenureportll then
		self:SecureHook("openmenull", function()
			self:skinDropDown{obj=DropDownMenureportll}
			self:Unhook("openmenull")
		end)
	else
		self:skinDropDown{obj=DropDownMenureportll}
	end

end
