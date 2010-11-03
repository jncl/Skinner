if not Skinner:isAddonEnabled("RaidAchievement") then return end

local aVer = GetAddOnMetadata("RaidAchievement", "Version")
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

function Skinner:RaidAchievement_AchieveReminder()

	self:addSkinFrame{obj=icralistach, x1=x1, y1=y1}
	self:SecureHook("iclldrawtext2", function()
		self:skinEditBox{obj=rallpseb2, regs={9}}
		self:skinScrollBar{obj=psllinfscroll2}
		self:Unhook("iclldrawtext2")
	end)
	self:addSkinFrame{obj=icralistach2, x1=x1, y1=y1}
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
	if not DropDownMenureportll2 then
		self:SecureHook("openmenull2", function()
			self:skinDropDown{obj=DropDownMenureportll2}
			self:Unhook("openmenull2")
		end)
	else
		self:skinDropDown{obj=DropDownMenureportll2}
	end
	if not DropDownMenullch1 then
		self:SecureHook("openmenullch1", function()
			self:skinDropDown{obj=DropDownMenullch1}
			self:Unhook("openmenullch1")
		end)
	else
		self:skinDropDown{obj=DropDownMenullch1}
	end
	if not DropDownMenullch2 then
		self:SecureHook("openmenullch2", function()
			self:skinDropDown{obj=DropDownMenullch2}
			self:Unhook("openmenullch2")
		end)
	else
		self:skinDropDown{obj=DropDownMenullch2}
	end
	if not DropDownMenullch3 then
		self:SecureHook("openmenullch3", function()
			self:skinDropDown{obj=DropDownMenullch3}
			self:Unhook("openmenullch3")
		end)
	else
		self:skinDropDown{obj=DropDownMenullch3}
	end
	-- check for Beta version
	if aVer == "1.052" then
		self:SecureHook("iclldrawtext3", function()
			self:skinEditBox{obj=rallpsebf3, regs={9}}
			self:skinScrollBar{obj=rallinfscroll}
			self:skinEditBox{obj=rallinfframe, regs={9}}
			self:Unhook("iclldrawtext3")
		end)
		self:addSkinFrame{obj=icralistach3, x1=x1, y1=y1}
		if not DropDownMenureportll3 then
			self:SecureHook("openmenull3", function()
				self:skinDropDown{obj=DropDownMenureportll3}
				self:Unhook("openmenull3")
			end)
		else
			self:skinDropDown{obj=DropDownMenureportll3}
		end
		if not DropDownMenullch34 then
			self:SecureHook("openmenullch34", function()
				self:skinDropDown{obj=DropDownMenullch34}
				self:Unhook("openmenullch34")
			end)
		else
			self:skinDropDown{obj=DropDownMenullch34}
		end
	end

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

function Skinner:RaidAchievement_CataHeroics()

	self:addSkinFrame{obj=chramain6, x1=x1, y1=y1}
	if not DropDownMenureportchra then
		self:SecureHook("openmenureportchra", function()
			self:skinDropDown{obj=DropDownMenureportchra}
			self:Unhook("openmenureportchra")
		end)
	else
		self:skinDropDown{obj=DropDownMenureportchra}
	end

end

function Skinner:RaidAchievement_CataRaids()

	self:addSkinFrame{obj=crramain6, x1=x1, y1=y1}
	if not DropDownMenureportcrra then
		self:SecureHook("openmenureportcrra", function()
			self:skinDropDown{obj=DropDownMenureportcrra}
			self:Unhook("openmenureportcrra")
		end)
	else
		self:skinDropDown{obj=DropDownMenureportcrra}
	end

end
