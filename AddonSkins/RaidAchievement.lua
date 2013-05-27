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
local function skinModule(modAbbr)
	aObj:addSkinFrame{obj=modAbbr ~= "ra" and _G[modAbbr .. "main6"] or _G.PSFeamain7, x1=x1, y1=y1}
	skinDropDown(modAbbr)
end
function aObj:RaidAchievement()

	self:addSkinFrame{obj=_G.PSFeamain1, kfs=true, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.PSFeamain2, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.PSFeamain3, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.PSFeamain12, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.PSFeamain10, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.PSFeamain11, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.PSFeamainmanyach, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.PSFeamainWotlk, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.raralistach, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.raralistach2, x1=x1, y1=y1}
	self:addSkinFrame{obj=_G.raralistach3, x1=x1, y1=y1}
	self:addSkinFrame{obj=RAthanks, x1=x1, y1=y1}
	self:addSkinFrame{obj=RAthanks2, x1=x1, y1=y1}

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

	self:skinScrollBar{obj=raraerrordfdfdpsdonatefr2}
	self:removeRegions(_G.raralistach3_ButtonN, {1, 2, 3})
	self:addButtonBorder{obj=_G.raralistach3_ButtonN, ofs=-2, y1=-3, x2=-3}
	self:removeRegions(_G.raralistach3_ButtonP, {1, 2, 3})
	self:addButtonBorder{obj=_G.raralistach3_ButtonP, ofs=-2, y1=-3, x2=-3}

	self:SecureHook("RAdonatef", function()
		self:skinScrollBar{obj=_G.psdonatefr22}
		self:Unhook("RAdonatef")
	end)
	self:SecureHook("raerrorloading", function()
		self:skinScrollBar{obj=_G.raerrordfdfdpsdonatefr2}
		self:Unhook("raerrorloading")
	end)

end

function aObj:AchievementsReminder()

	self:addSkinFrame{obj=_G.icralistach, x1=x1, y1=y1}
	self:SecureHook("iclldrawtext", function()
		self:skinEditBox{obj=_G.rallpseb1, regs={9}}
		self:skinScrollBar{obj=_G.psllinfscroll}
		self:Unhook("iclldrawtext")
	end)
	self:addSkinFrame{obj=_G.icralistach2, x1=x1, y1=y1}
	self:SecureHook("iclldrawtext2", function()
		self:skinEditBox{obj=_G.rallpseb2, regs={9}}
		self:skinScrollBar{obj=_G.psllinfscroll2}
		self:Unhook("iclldrawtext2")
	end)
	self:addSkinFrame{obj=_G.icralistach3, x1=x1, y1=y1}
	self:SecureHook("iclldrawtext3", function()
		self:skinEditBox{obj=_G.rallpsebf3, regs={9}}
		self:skinScrollBar{obj=_G.rallinfscroll}
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

function aObj:RaidAchievement_Icecrown()

	skinModule("icra")

end

function aObj:RaidAchievement_Naxxramas()

	skinModule("nxra")

end

function aObj:RaidAchievement_Ulduar()

	skinModule("ra")

end

function aObj:RaidAchievement_WotlkHeroics()

	skinModule("whra")

end

function aObj:RaidAchievement_CataHeroics()

	skinModule("chra")

end

function aObj:RaidAchievement_CataRaids()

	skinModule("crra")

end

function aObj:RaidAchievement_PandaHeroics()

	skinModule("phra")

end

function aObj:RaidAchievement_PandaRaids()

	skinModule("prra")

end

function aObj:RaidAchievement_PandaScenarios()

	skinModule("pzra")

end
