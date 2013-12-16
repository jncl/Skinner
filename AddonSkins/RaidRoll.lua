local aName, aObj = ...
if not aObj:isAddonEnabled("RaidRoll") then return end
local _G = _G

function aObj:RaidRoll()

	self:addSkinFrame{obj=_G.RR_LOOT_FRAME}
	_G.RR_LOOT_FRAME.SetBackdrop = function() end

	self:addSkinFrame{obj=_G.RR_NAME_FRAME} -- above Roll frame
	self:addSkinFrame{obj=_G.RR_Frame} -- below Roll frame

	self:skinButton{obj=_G.RR_Close_Button, cb=true}
	self:addSkinFrame{obj=_G.RR_RollFrame}


	-- Options Panel
	self:addSkinFrame{obj=_G.RR_Panel_GuildRankFrame, ofs=4}

end

function aObj:RaidRoll_LootTracker()

	self:skinButton{obj=self:getChild(_G.RR_LOOT_FRAME, 24), cb=true}

	-- Options panel
	_G.RR_Msg1_FRAME:SetBackdrop(nil)
	_G.RR_Msg2_FRAME:SetBackdrop(nil)
	_G.RR_Msg3_FRAME:SetBackdrop(nil)

end
