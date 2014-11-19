local aName, aObj = ...
if not aObj:isAddonEnabled("Classic Quest Log") then return end
local _G = _G

function aObj:ClassicQuestLog()

    if self.modBtns then
        local function qlUpd()

            -- handle in combat
            if _G.InCombatLockdown() then
                aObj:add2Table(aObj.oocTab, {qlUpd, {nil}})
                return
            end

            for i = 1, #_G.ClassicQuestLog.scrollFrame.buttons do
                aObj:checkTex(_G.ClassicQuestLog.scrollFrame.buttons[i])
            end

        end
        -- hook to manage changes to button textures
        self:SecureHook(_G.ClassicQuestLog, "UpdateLogList", function()
            qlUpd()
        end)
        -- skin minus/plus buttons
        for i = 1, #_G.ClassicQuestLog.scrollFrame.buttons do
            self:skinButton{obj=_G.ClassicQuestLog.scrollFrame.buttons[i], mp=true}
        end
	end
	self:removeInset(_G.ClassicQuestLog.count)
	self:addButtonBorder{obj=_G.ClassicQuestLog.mapButton, x1=2, y1=-1, x2=-2, y2=1}
	self:skinScrollBar{obj=_G.ClassicQuestLog.scrollFrame, size=2}
	self:skinScrollBar{obj=_G.ClassicQuestLog.detail}
	self:addSkinFrame{obj=_G.ClassicQuestLog, kfs=true, ri=true, y1=2, x2=2}

end
