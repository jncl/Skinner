local aName, aObj = ...
if not aObj:isAddonEnabled("RaidAchievement") then return end
local _G = _G

local x1, y1 = -2, -4
local function skinDD(ddObj, xOfs)
	aObj:skinDropDown{obj=ddObj, noBB=true}
	aObj:addButtonBorder{obj=_G[ddObj:GetName() .. "Button"], es=12, ofs=-2, x1=xOfs or 82}
end
local function skinDropDown(ddAbbr, xOfs)
	local ddName = "DropDownMenu" .. (ddAbbr:find("llch") and "" or "report") .. ddAbbr
	if _G[ddName] then
		skinDD(_G[ddName], xOfs)
	else
		local fName = "openmenu" .. (ddAbbr:find("ll") and "" or "report") .. ddAbbr
		aObj:SecureHook(fName, function()
			skinDD(_G[ddName], xOfs)
			aObj:Unhook(fName)
		end)
	end
end
local function skinBtns(frame)
	for _, child in ipairs{frame:GetChildren()} do
		if child:IsObjectType("Button") then
			aObj:skinStdButton{obj=child}
		end
	end
end
local function skinModule(modAbbr)
	aObj:addSkinFrame{obj=modAbbr ~= "ra" and _G[modAbbr .. "main6"] or _G.PSFeamain7, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	skinDropDown(modAbbr)
	skinBtns(_G[modAbbr .. "main6"])
end
aObj.addonsToSkin.RaidAchievement = function(self) -- v 8.002

	self:skinStdButton{obj=_G.PSFeamain1_Button2}
	self:addSkinFrame{obj=_G.PSFeamain1, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:skinStdButton{obj=_G.PSFeamain2_Button3}
	self:skinStdButton{obj=_G.PSFeamain2_Button11}
	self:skinStdButton{obj=_G.PSFeamain2_Button12}
	self:skinStdButton{obj=_G.PSFeamain2_Button13}
	self:skinStdButton{obj=_G.PSFeamain2_ButtonG12}
	self:skinStdButton{obj=_G.PSFeamain2_ButtonG13}
	self:skinStdButton{obj=_G.PSFeamain2_Button5}
	self:skinStdButton{obj=_G.PSFeamain2_Button6}
	self:skinStdButton{obj=_G.PSFeamain2_Buttonwotlk}
	self:skinStdButton{obj=_G.PSFeamain2_ButtonwotlkG}
	self:skinStdButton{obj=_G.PSFeamain2_ButtonPS}
	self:addSkinFrame{obj=_G.PSFeamain2, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:skinCheckButton{obj=_G.PSFeamain3_CheckButton1}
	self:skinCheckButton{obj=_G.PSFeamain3_CheckButton22}
	self:skinCheckButton{obj=_G.PSFeamain3_CheckButton11}
	self:skinCheckButton{obj=_G.PSFeamain3_CheckButton2}
	self:skinCheckButton{obj=_G.PSFeamain3_CheckButton3}
	self:skinCheckButton{obj=_G.PSFeamain3_CheckButton4}
	self:skinCheckButton{obj=_G.PSFeamain3_CheckButton5}
	self:skinCheckButton{obj=_G.PSFeamain3_CheckButton6}
	self:skinCheckButton{obj=_G.PSFeamain3_CheckButton7}
	self:skinStdButton{obj=_G.PSFeamain3_Button1}
	self:skinStdButton{obj=_G.PSFeamain3_Button777}
	self:addSkinFrame{obj=_G.PSFeamain3, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.PSFeamain12, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.PSFeamain10, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.PSFeamain11, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:skinSlider{obj=_G.PSFeamainmanyach_slider1}
	self:skinSlider{obj=_G.PSFeamainmanyach_slider2}
	self:skinStdButton{obj=_G.PSFeamainmanyach_Buttonon}
	self:addSkinFrame{obj=_G.PSFeamainmanyach, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	skinBtns(_G.PSFeamainWotlk)
	self:addSkinFrame{obj=_G.PSFeamainWotlk, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.raralistach, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.raralistach2, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.raralistach3, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.RAthanks, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.RAthanks2, ft="a", kfs=true, nb=true, x1=x1, y1=y1}

	self:SecureHook("openrasound1", function()
		skinDD(_G.DropDownrasound1, 92)
		self:Unhook("openrasound1")
	end)
	self:SecureHook("openrasound2", function()
		skinDD(_G.DropDownrasound2, 92)
		self:Unhook("openrasound2")
	end)
	skinDropDown("chra11")
	skinDropDown("chra12")

	self:removeRegions(_G.raralistach3_ButtonN, {1, 2, 3})
	self:addButtonBorder{obj=_G.raralistach3_ButtonN, ofs=-2, y1=-3, x2=-3}
	self:removeRegions(_G.raralistach3_ButtonP, {1, 2, 3})
	self:addButtonBorder{obj=_G.raralistach3_ButtonP, ofs=-2, y1=-3, x2=-3}

	self:SecureHook("RAdonatef", function()
		self:skinSlider{obj=_G.psdonatefr22.ScrollBar}
		self:Unhook("RAdonatef")
	end)
	self:SecureHook("raerrorloading", function()
		self:skinSlider{obj=_G.raerrordfdfdpsdonatefr2.ScrollBar}
		self:Unhook("raerrorloading")
	end)

end

aObj.addonsToSkin.AchievementsReminder = function(self) -- v 8.002

	self:addSkinFrame{obj=_G.icralistach, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:SecureHook("iclldrawtext", function()
		self:skinEditBox{obj=_G.rallpseb1, regs={9}}
		self:skinSlider{obj=_G.psllinfscroll.ScrollBar}
		self:Unhook("iclldrawtext")
	end)
	self:addSkinFrame{obj=_G.icralistach2, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:SecureHook("iclldrawtext2", function()
		self:skinEditBox{obj=_G.rallpseb2, regs={9}}
		self:skinSlider{obj=_G.psllinfscroll2.ScrollBar}
		self:Unhook("iclldrawtext2")
	end)
	self:addSkinFrame{obj=_G.icralistach3, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:SecureHook("iclldrawtext3", function()
		self:skinEditBox{obj=_G.rallpsebf3, regs={9}}
		self:skinSlider{obj=_G.rallinfscroll.ScrollBar}
		self:Unhook("iclldrawtext3")
	end)
	skinDropDown("ll", 102)
	skinDropDown("ll2", 102)
	skinDropDown("ll3", 102)
	skinDropDown("llch1", 102)
	skinDropDown("llch2", 102)
	skinDropDown("llch3", 102)
	skinDropDown("llch34", 162)

end

aObj.lodAddons.RaidAchievement_Icecrown = function(self)

	skinModule("icra")

end

aObj.lodAddons.RaidAchievement_Naxxramas = function(self)

	skinModule("nxra")

end

aObj.lodAddons.RaidAchievement_Ulduar = function(self)

	skinModule("ra")

end

aObj.lodAddons.RaidAchievement_WotlkHeroics = function(self)

	skinModule("whra")

end

aObj.lodAddons.RaidAchievement_CataHeroics = function(self)

	skinModule("chra")

end

aObj.lodAddons.RaidAchievement_CataRaids = function(self)

	skinModule("crra")

end

aObj.lodAddons.RaidAchievement_PandaHeroics = function(self)

	skinModule("phra")

end

aObj.lodAddons.RaidAchievement_PandaRaids = function(self)

	skinModule("prra")

end

aObj.lodAddons.RaidAchievement_PandaScenarios = function(self)

	skinModule("pzra")

end

aObj.lodAddons.RaidAchievement_WoDHeroics = function(self)

	skinModule("wodhra")

end

aObj.lodAddons.RaidAchievement_WoDRaids = function(self)

	skinModule("wodrra")

end

aObj.lodAddons.RaidAchievement_LegionHeroics = function(self)

	skinModule("legionhra")

end

aObj.lodAddons.RaidAchievement_LegionRaids = function(self)

	skinModule("legionrra")

end
