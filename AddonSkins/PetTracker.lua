local aName, aObj = ...
if not aObj:isAddonEnabled("PetTracker") then return end
local _G = _G

function aObj:PetTracker()

	-- Custom Tutorials
	local cTut = _G.LibStub:GetLibrary('CustomTutorials-2.1', true)
	if cTut then
		for k, frame in _G.pairs(cTut.frames) do
			self:addSkinFrame{obj=frame, kfs=true, ri=true, y1=1}
			self:addButtonBorder{obj=frame.prev, ofs=-1}
			self:addButtonBorder{obj=frame.next, ofs=-1}
		end
	end

	-- ProgressBar
	local function skinBar()
		aObj:keepFontStrings(_G.PetTracker.Objectives.Bar.Overlay)
		for i = 1, _G.PetTracker.MaxQuality do
			aObj:glazeStatusBar(_G.PetTracker.Objectives.Bar[i], 0,  nil)
		end

	end
	-- check to see if objectives are displayed
	if not _G.PetTracker.Objectives.Bar then
		self:SecureHook(_G.PetTracker.ProgressBar, "OnCreate", function(this)
			self:Debug("PetTracker.ProgressBar OnCreate")
			skinBar()
			self:Unhook(_G.PetTracker.ProgressBar, "OnCreate")
		end)
	else
		skinBar()
	end

	-- Tooltips
	for i = 1, _G.PetTracker["MapTip"].numFrames do
		self:add2Table(self.ttList, _G.PetTracker["MapTip"].usedFrames[i])
	end

end

local function skinSlot(slot, isBattle)

	slot.Bg:SetTexture(nil)
	slot.IconBorder:SetTexture(nil)
	aObj:changeTandC(slot.LevelBG, aObj.lvlBG)
	-- ability buttons
	for i = 1, _G.NUM_BATTLE_PET_ABILITIES do
		local btn = slot.Ability[i]
		aObj:getRegion(btn, 1):SetTexture(nil)
		aObj:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.Type}}

	end
	if isBattle then
		aObj:removeRegions(slot.Health, {2, 3, 4, 5})
		aObj:glazeStatusBar(slot.Health, 0,  nil)
		aObj:removeRegions(slot.Xp, {2, 3, 4, 5})
		aObj:glazeStatusBar(slot.Xp, 0,  nil)
	end
	aObj:addSkinFrame{obj=slot, ofs=2}
	slot.Highlight:ClearAllPoints()
	-- resize Highlight
	slot.Highlight:SetPoint("TOPLEFT", -4, 4)
	slot.Highlight:SetPoint("BOTTOMRIGHT", 4, -5)

	-- IsEmpty frame, covers slot, don't skin it
	-- IsDead frame

end
function aObj:PetTracker_Switcher()

	self:SecureHook(_G.PetTracker.Switcher, "Initialize", function(this)
		for i = 1, _G.NUM_BATTLE_PETS_IN_BATTLE do
			for _, slot in _G.pairs{this[_G.LE_BATTLE_PET_ALLY .. i], this[_G.LE_BATTLE_PET_ENEMY .. i]} do
				skinSlot(slot, true)
			end
		end
		-- remove borders
		self:keepFontStrings(self:getChild(this, 4))
		self:keepFontStrings(self:getChild(this, 5))
		self:Unhook(_G.PetTracker.Switcher, "Initialize")
	end)
	self:addSkinFrame{obj=_G.PetTracker.Switcher, kfs=true, ri=true, y1=2, x2=1}

end

function aObj:PetTracker_Journal()

	self:removeInset(_G.PetTrackerTamerJournal.Count)
	self:removeInset(_G.PetTrackerTamerJournal.LeftInset)
	self:removeInset(_G.PetTrackerTamerJournal.RightInset)
	self:skinEditBox{obj=_G.PetTrackerTamerJournal.SearchBox, regs={9}}
	self:skinSlider{obj=_G.PetTrackerTamerJournal.List.scrollBar, size=3}
	self:SecureHookScript(_G.PetTrackerTamerJournal, "OnShow", function(this)
		for i = 1, #_G.PetTrackerTamerJournal.List.buttons do
			local btn = _G.PetTrackerTamerJournal.List.buttons[i]
			self:removeRegions(btn, {1}) -- background
			self:changeTandC(btn.model.levelBG, self.lvlBG)
		end
		-- Tamer Pet cards (RHS)
		for _, slot in _G.ipairs(_G.PetTrackerTamerJournal.Slots) do
			skinSlot(slot, false)
		end
		self:Unhook(_G.PetTrackerTamerJournal, "OnShow")
	end)

	self:removeInset(_G.PetTrackerTamerJournal.Card)
	self:addSkinFrame{obj=_G.PetTrackerTamerJournal.Card, aso={bd=8, ng=true}}--, ofs=4}
	self:keepRegions(_G.PetTrackerTamerJournal.TeamBorder, {})

end
