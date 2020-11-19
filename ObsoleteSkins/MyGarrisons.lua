local aName, aObj = ...
if not aObj:isAddonEnabled("MyGarrisons") then return end
local _G = _G

function aObj:MyGarrisons() -- WIP

-->>-- Garrison Buildings
	local cbtn = self:getChild(_G.GarrisonBuildings, 2)
	cbtn:SetSize(26, 26)
	self:skinButton{obj=cbtn, cb=true}
	self:moveObject{obj=cbtn, x=10, y=10}
	self:addSkinFrame{obj=_G.GarrisonBuildings, kfs=true, nb=true, ofs=-10}
	-- Character scroll frame
	self:skinScrollBar{obj=_G.GarrisonBuildings.charScroll}
	for i = 1, 10 do
		local rlh = _G["RealmListHeader" .. i]
		if rlh then
			rlh:SetBackdrop(nil)
			self:skinButton{obj=rlh.expander, mp=true, plus=true}
			-- charbut
			for j = 1, 10 do
				local clt = _G["CharacterListTemplate" .. i .. j]
				if clt then
					clt:SetBackdrop(nil)
				end
				local cp = _G["CharacterProp" .. i .. j]
				if cp then
					cp:SetBackdrop(nil)
					self:skinAllButtons{obj=cp}
				end
			end
		end
		local rb = _G["RealmBag" .. i]
		if rb then
			rb:SetBackdrop(nil)
		end
	end
	-- Realm Options frame
	self:skinScrollBar{obj=_G.re.scroll}
	-- Character Timers frame
	self:skinScrollBar{obj=_G.GBCharaTimers.timescroll}
	-- Buildings scroll frame
	self:skinScrollBar{obj=_G.GarrisonBuildings.garrbuildscroll}
	-- Character Properties frame
	self:skinAllButtons{obj=_G.GBCharaProp}

-->>-- Timers
	self:skinButton{obj=self:getChild(_G.MyGarrisonTimers, 1), cb=true}
	self:skinButton{obj=_G.MyGarrisonTimers.minmax, ob2="-"}
	_G.MyGarrisonTimers:DisableDrawLayer("BACKGROUND")
	self:skinScrollBar{obj=_G.MyGarrisonTimers.timerscroll}
	for i = 1, 10 do
		local cht = _G["CharacterHeaderTemplate" .. i]
		local tb = _G["TimerBag" .. i]
		local charname = nil
		if cht then
			charname = cht.charname:GetText()
			cht:SetBackdrop(nil)
			self:getRegion(cht, 4):SetTexture(nil)
			self:skinButton{obj=cht.expander, mp=true, plus=true}
			if tb then
				for j = 1, 10 do
					local mtt = _G["MissionTimerTemplate" .. charname .. j]
					if mtt then
						mtt:DisableDrawLayer("BACKGROUND")
						self:glazeStatusBar(mtt.timebar, 0, nil)
					end
				end
			end
		end
	end
	self:addSkinFrame{obj=_G.MyGarrisonTimers, kfs=true, nb=true, ofs=3, x2=-1}

	-- hook to skin new timers
	self:SecureHook(_G.MyGarrisons, "AddCharacterTimer", function(this, charname, typeID, missID)
		for i = 1, 10 do
			local cht = _G["CharacterHeaderTemplate" .. i]
			local tb = _G["TimerBag" .. i]
			local charname = nil
			if cht then
				charname = cht.charname:GetText()
				if tb then
					for j = 1, 10 do
						local mtt = _G["MissionTimerTemplate" .. charname .. j]
						if mtt and not self.sbGlazed[mtt.timebar] then
							mtt:DisableDrawLayer("BACKGROUND")
							self:glazeStatusBar(mtt.timebar, 0, nil)
						end
					end
				end
			end
		end
	end)

	-- hook this to resize frame when minmax button clicked
	self:SecureHook(_G.MyGarrisons, "MinizerMaxi", function(this)
		if _G.MyGarrisonTimers:GetHeight() < 30 then
			_G.MyGarrisonTimers:SetHeight(49)
		end
	end)

-->>-- Confirm Frame
	self:addSkinFrame{obj=_G.MyGarrisonsConfirmFrame, kfs=true}

end
