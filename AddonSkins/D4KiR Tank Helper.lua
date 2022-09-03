local _, aObj = ...
if not aObj:isAddonEnabled("D4KiR Tank Helper") then return end
local _G = _G

aObj.addonsToSkin["D4KiR Tank Helper"] = function(self) -- v 2.22

    self:SecureHookScript(_G.frameCockpit, "OnShow", function(this)
        self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
        if self.modBtns then
            for i = 1, 4 do
                self:skinStdButton{obj=this["btnp" .. i], fType=ftype}
            end
            self:skinStdButton{obj=this.btnReadycheck, fType=ftype}
            if self.isRtl then
                self:skinStdButton{obj=this.btnRolepoll, fType=ftype}
            end
            self:skinStdButton{obj=this.btnDiscord, fType=ftype}
        end

        self:SecureHookScript(this.btnDiscord, "OnClick", function(this)
            this.frame = self:getLastChild(_G.UIParent)
            self:skinObject("editbox", {obj=_G.logEditBox, fType=ftype})
            self:skinObject("frame", {obj=this.frame, fType=ftype, kfs=true, ofs=0})
            this.frame:SetFrameLevel(5)
            if self.modBtns then
                self:skinCloseButton{obj=_G.closediscord, fType=ftype}
            end
            this:SetScript("OnClick", function(this, ...)
                this.frame:Show()
            end)
            self:Unhook(this, "OnClick")
        end)

        self:Unhook(this, "OnShow")
    end)
    self:checkShown(_G.frameCockpit)


    self:SecureHookScript(_G.frameStatus, "OnShow", function(this)
        self:skinObject("frame", {obj=this, fType=ftype, kfs=true})

        self:Unhook(this, "OnShow")
    end)

    -- frameDesign

end
