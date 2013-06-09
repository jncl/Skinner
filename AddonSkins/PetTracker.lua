local aName, aObj = ...
if not aObj:isAddonEnabled("PetTracker") then return end
local _G = _G

function aObj:PetTracker()

	-- Custom Tutorials
	local cTut = _G.LibStub:GetLibrary('CustomTutorials-2.1', true)
	if cTut then
		for k, frame in pairs(cTut.frames) do
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

end

function aObj:PetTracker_Switcher()
	
	self:SecureHook(_G.PetTracker.Switcher, "Initialize", function(this)
		for i = 1, NUM_BATTLE_PETS_IN_BATTLE do
			for _, slot in pairs{this[LE_BATTLE_PET_ALLY .. i], this[LE_BATTLE_PET_ENEMY .. i]} do
				slot.Bg:SetTexture(nil)
				slot.IconBorder:SetTexture(nil)
				self:changeTandC(slot.LevelBG, self.lvlBG)
				-- ability buttons
				for j = 1, NUM_BATTLE_PET_ABILITIES do
					self:getRegion(slot.Abilities[j], 1):SetTexture(nil)
				end
				self:removeRegions(slot.Health, {2, 3, 4, 5})
				self:glazeStatusBar(slot.Health, 0,  nil)
				self:removeRegions(slot.Xp, {2, 3, 4, 5})
				self:glazeStatusBar(slot.Xp, 0,  nil)
				self:addSkinFrame{obj=slot}
				-- IsEmpty frame, covers slot, don't skin it
				-- IsDead frame
			end
		end
		-- remove borders
		self:keepFontStrings(self:getChild(this, 4))
		self:keepFontStrings(self:getChild(this, 5))
		self:Unhook(_G.PetTracker.Switcher, "Initialize")
	end)
	self:addSkinFrame{obj=_G.PetTracker.Switcher, kfs=true, ri=true, y1=2, x2=1}
	
end
