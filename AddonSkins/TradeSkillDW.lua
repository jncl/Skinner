local aName, aObj = ...
if not aObj:isAddonEnabled("TradeSkillDW") then return end
local _G = _G

function aObj:TradeSkillDW() -- LoD (dependant upon Blizzard_TradeSkillUI)

-->>-- TradeSkillDW changes to TradeSkillFrame
	-- skill buttons on RHS
	local tsfc, child = _G.TradeSkillFrame:GetNumChildren(), nil
	for i = tsfc, tsfc - 8, -1 do
		child = self:getChild(_G.TradeSkillFrame, i)
		if child:IsObjectType("CheckButton") then
			self:getRegion(child, 1):SetTexture(nil)
		end
	end

	-- expand/collapse button
	self:addButtonBorder{obj=_G.TradeSkillDWExpandButton, ofs=-2}

	-- BUG: header button & progress bar being shown on lines 9-16 !

-->>-- TradeSkillDW Queue Frame
	self:skinScrollBar{obj=_G.TradeSkillDW_QueueFrameDetailScrollFrame}
	self:skinScrollBar{obj=_G.TradeSkillDW_QueueFrameScrollFrame}
	self:removeMagicBtnTex(_G.TradeSkillDWQueueFrame.DoButton)
	self:removeMagicBtnTex(_G.TradeSkillDWQueueFrame.UpButton)
	self:removeMagicBtnTex(_G.TradeSkillDWQueueFrame.DownButton)
	self:removeMagicBtnTex(_G.TradeSkillDWQueueFrame.ClearButton)
	-- addon already uses .sf so nil out entry otherwise skinframe won't be created
	_G.TradeSkillDWQueueFrame.sf = nil
	self:addSkinFrame{obj=_G.TradeSkillDWQueueFrame, kfs=true, ri=true, x1=0, y1=2, x2=1, y2=-5}
	-- reinstate the original .sf entry
	_G.TradeSkillDWQueueFrame.sf = _G["TradeSkillDW_QueueFrameScrollFrame"]
	-- Scroll Child frame
	self:keepFontStrings(_G.TradeSkillDWQueueFrame.df.cf)
	self:addButtonBorder{obj=_G.TradeSkillDWQueueFrame.df.cf.Icon}
	for i = 1, _G.MAX_TRADE_SKILL_REAGENTS do
		_G["TradeSkillDW_QueueFrameDetailScrollFrameChildFrameReagent" .. i .. "NameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G.TradeSkillDWQueueFrame.df.cf.Reagents[i], libt=true}
	end
	for i = 1, #_G.TradeSkillDWQueueFrame.sf.buttons do
		self:skinButton{obj=_G["TradeSkillDW_QueueButton" .. i .. "Remove"], mp=true}
	end

end
