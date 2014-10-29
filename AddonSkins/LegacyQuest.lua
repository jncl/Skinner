local aName, aObj = ...
if not aObj:isAddonEnabled("LegacyQuest") then return end
local _G = _G

function aObj:LegacyQuest()

    self:keepFontStrings(_G.QuestLogCount)
    self:keepFontStrings(_G.EmptyQuestLogFrame)

    if self.modBtns then
        local function qlUpd()

            -- handle in combat
            if _G.InCombatLockdown() then
                aObj:add2Table(aObj.oocTab, {qlUpd, {nil}})
                return
            end

            for i = 1, #_G.QuestLogScrollFrame.buttons do
                aObj:checkTex(_G.QuestLogScrollFrame.buttons[i])
            end

        end
        -- hook to manage changes to button textures
        self:SecureHook("QuestLog_Update", function()
            qlUpd()
        end)
        -- hook this as well as it's a copy of QuestLog_Update
        self:SecureHook(_G.QuestLogScrollFrame, "update", function()
            qlUpd()
        end)
        -- skin minus/plus buttons
        for i = 1, #_G.QuestLogScrollFrame.buttons do
            self:skinButton{obj=_G.QuestLogScrollFrame.buttons[i], mp=true}
        end
    end
    self:skinSlider{obj=_G.QuestLogScrollFrame.scrollBar, adj=-4}
    self:addButtonBorder{obj=_G.QuestLogFrameShowMapButton, relTo=_G.QuestLogFrameShowMapButton.texture, x1=2, y1=-1, x2=-2, y2=1}
    self:removeRegions(_G.QuestLogScrollFrame, {1, 2, 3, 4})
    self:skinAllButtons{obj=_G.QuestLogControlPanel, ft=ftype}
    self:addSkinFrame{obj=_G.QuestLogFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
    self:removeMagicBtnTex(_G.QuestLogFrameCompleteButton)

-->>-- QuestLogDetail Frame
    _G.QuestLogDetailTitleText:SetTextColor(self.HTr, self.HTg, self.HTb)
    self:skinScrollBar{obj=_G.QuestLogDetailScrollFrame}
    self:addSkinFrame{obj=_G.QuestLogDetailFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
    _G.RaiseFrameLevelByTwo(_G.QuestLogDetailScrollFrame) -- make Quest text appear above frame

end
