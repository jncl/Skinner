local aName, aObj = ...
if not aObj:isAddonEnabled("QuestGuru") then return end
local _G = _G

aObj.addonsToSkin.QuestGuru = function(self) -- v 2.5.08

	-- Bugfix for missing object
	if not _G.QuestGuru.Track then
		_G.QuestGuru.Track = {}
		_G.QuestGuru.Track.SetText = _G.nop
	end

    if self.modBtns then
        local function qlUpd()

            -- handle in combat
            if _G.InCombatLockdown() then
                aObj:add2Table(aObj.oocTab, {qlUpd, {nil}})
                return
            end

            for i = 1, #_G.QuestGuru.scrollFrame.buttons do
				aObj:checkTex(_G.QuestGuru.scrollFrame.buttons[i])
            end

        end
        -- skin minus/plus buttons
        for i = 1, #_G.QuestGuru.scrollFrame.buttons do
			self:skinExpandButton{obj=_G.QuestGuru.scrollFrame.buttons[i], onSB=true, noHook=true}
        end
        -- hook to manage changes to button type
        self:SecureHook(_G.QuestGuru, "UpdateLog", function(this)
            qlUpd()
        end)
		self:skinExpandButton{obj=_G.QuestGuru.scrollFrame.expandAll, onSB=true}
		self:skinStdButton{obj=_G.QuestGuru.close}
		self:skinStdButton{obj=_G.QuestGuru.abandon}
		self:skinStdButton{obj=_G.QuestGuru.push}
		self:skinStdButton{obj=_G.QuestGuru.track}
    end
	_G.QuestGuru.scrollFrame.expandAll:DisableDrawLayer("BACKGROUND")
	self:removeInset(_G.QuestGuru.count)
	self:addButtonBorder{obj=_G.QuestGuru.mapButton, x1=2, y1=-1, x2=-2, y2=1}
	_G.QuestGuru.scrollFrame.BG:SetTexture(nil)
	self:skinSlider{obj=_G.QuestGuru.scrollFrame.scrollBar, rt="background", adj=-4}
	_G.QuestGuru.detail.DetailBG:SetTexture(nil)
	self:skinSlider{obj=_G.QuestGuru.detail.ScrollBar, rt="artwork"}
	self:removeMagicBtnTex(_G.QuestGuru.close)
	self:removeMagicBtnTex(_G.QuestGuru.abandon)
	self:removeMagicBtnTex(_G.QuestGuru.push)
	self:removeMagicBtnTex(_G.QuestGuru.track)
	self:addSkinFrame{obj=_G.QuestGuru, ft="a", kfs=true, ri=true, ofs=2, x2=1}

end
