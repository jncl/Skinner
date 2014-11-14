local aName, aObj = ...
if not aObj:isAddonEnabled("QuestGuru") then return end
local _G = _G

function aObj:QuestGuru()

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
        -- hook to manage changes to button textures
        self:SecureHook(_G.QuestGuru, "UpdateLogList", function()
            qlUpd()
        end)
        -- skin minus/plus buttons
        for i = 1, #_G.QuestGuru.scrollFrame.buttons do
            self:skinButton{obj=_G.QuestGuru.scrollFrame.buttons[i], mp=true}
        end
    end
	self:removeInset(_G.QuestGuru.count)
	self:addButtonBorder{obj=_G.QuestGuru.mapButton, x1=2, y1=-1, x2=-2, y2=1}
	_G.QuestGuru.scrollFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.QuestGuru.scrollFrame.scrollBar, adj=-4}
	_G.QuestGuru.detail:DisableDrawLayer("ARTWORK")
	self:skinSlider{obj=_G.QuestGuru.detail.ScrollBar}
	self:addSkinFrame{obj=_G.QuestGuru, kfs=true, ri=true, y1=2, x2=2}

end
