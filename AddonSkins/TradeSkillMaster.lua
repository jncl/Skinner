local aName, aObj = ...
if not aObj:isAddonEnabled("TradeSkillMaster") then return end
local _G = _G

function aObj:TradeSkillMaster()

	local bbc ={}
	bbc.r, bbc.g, bbc.b, bbc.a = _G.unpack(self.bbColour)

    -- hook this to skin ScrollingTables
    self:RawHook(_G.TSMAPI, "CreateScrollingTable", function(this, ...)
        local sT = self.hooks[this].CreateScrollingTable(this, ...)
        self:addSkinFrame{obj=sT, ofs=2}
        return sT
    end, true)
    -- hook these to skin frames, buttons etc
    local btn
    self:RawHook(_G.TSMAPI.GUI, "CreateButton", function(this, ...)
        btn = self.hooks[this].CreateButton(this, ...)
        self:skinButton{obj=btn, x1=-2, y1=2, x2=2, y2=-2}
        return btn
    end, true)
    local iBox
    self:RawHook(_G.TSMAPI.GUI, "CreateInputBox", function(this, ...)
        iBox = self.hooks[this].CreateInputBox(this, ...)
        self:skinEditBox{obj=iBox, regs={9}}
        return iBox
    end, true)
    local barTex
    self:RawHook(_G.TSMAPI.GUI, "CreateHorizontalLine", function(this, ...)
        barTex = self.hooks[this].CreateHorizontalLine(this, ...)
        barTex:SetVertexColor(bbc.r, bbc.g, bbc.b, 1)
        return barTex
    end, true)
    self:RawHook(_G.TSMAPI.GUI, "CreateVerticalLine", function(this, ...)
        barTex = self.hooks[this].CreateVerticalLine(this, ...)
        barTex:SetVertexColor(bbc.r, bbc.g, bbc.b, 1)
        return barTex
    end, true)

    _G.TSMAPI.Design.SetFrameBackdropColor = function() end
    _G.TSMAPI.Design.SetFrameColor = function() end
    _G.TSMAPI.Design.SetContentColor = function() end

    -- local eBox
	-- skin modules
	for _, module in _G.pairs{"Accounting", "AuctionDB", "Auctioning", "Crafting", "Destroying", "ItemTracker", "Mailing", "Shopping", "Warehousing", "WoWAuction"} do
		if _G.IsAddOnLoaded("TradeSkillMaster_"..module) then
			self:checkAndRunAddOn("TradeSkillMaster_"..module)
		end
	end

end

function aObj:TradeSkillMaster_Accounting()
	-- body
end

function aObj:TradeSkillMaster_AuctionDB()
	-- body
end

function aObj:TradeSkillMaster_Auctioning()
	-- body
end

function aObj:TradeSkillMaster_Crafting()

	local TSM_C = _G.LibStub("AceAddon-3.0"):GetAddon("TSM_Crafting", true)

    local GUI = TSM_C:GetModule("CraftingGUI", true)
    if GUI then
        local function skinButton(btn)
            aObj:skinButton{obj=btn}
            btn:SetBackdrop(nil)
        end
        self:SecureHook(GUI, "CreateGUI", function()
            self:addSkinFrame{obj=GUI.frame.content.professionsTab.craftInfoFrame, ofs=2}
            self:addSkinFrame{obj=GUI.frame.queue, ofs=2}
            self:addSkinFrame{obj=GUI.frame, ofs=2}
            self:Unhook(GUI, "CreateGUI")
        end)
    end

end

function aObj:TradeSkillMaster_Destroying()
	-- body
end

function aObj:TradeSkillMaster_ItemTracker()
	-- body
end

function aObj:TradeSkillMaster_Mailing()

	self:RegisterEvent("MAIL_SHOW", function(...)
		self:ScheduleTimer(function()
			local frame = self:getChild(MailFrame, MailFrame:GetNumChildren() - 1) -- get penultimate child
			self:addSkinFrame{obj=frame, ofs=2, y2=-5}
			self:keepRegions(_G.MailFrameTab3, {7, 8})
			self:addSkinFrame{obj=_G.MailFrameTab3, noBdr=self.isTT, x1=6, y1=0, x2=06, y2=2}
		end, 0.2, ...)
		self:UnregisterEvent("MAIL_SHOW")
	end)

end

function aObj:TradeSkillMaster_Shopping()
	-- body
end

function aObj:TradeSkillMaster_Warehousing()
	-- body
end

function aObj:TradeSkillMaster_WoWAuction()
	-- body
end
