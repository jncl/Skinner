local aName, aObj = ...
if not aObj:isAddonEnabled("TradeSkillMaster") then return end
local _G = _G

local function adjustSkinFrame(adjust)

	-- handle Skin Frame not existing yet
	if not _G.AuctionFrame.sf then
		aObj:ScheduleTimer(adjustSkinFrame, 0.2, adjust)
		return
	end
	_G.AuctionFrame.sf:ClearAllPoints()
	if adjust then
		-- increase size of AuctionFrame skin frame
		_G.AuctionFrame.sf:SetPoint("TOPLEFT", _G.AuctionFrame, "TOPLEFT", -4, 4)
		_G.AuctionFrame.sf:SetPoint("BOTTOMRIGHT", _G.AuctionFrame, "BOTTOMRIGHT", 4, -6)
	else
		-- revert size of AuctionFrame skin frame
		_G.AuctionFrame.sf:SetPoint("TOPLEFT", _G.AuctionFrame, "TOPLEFT", 10, -11)
		_G.AuctionFrame.sf:SetPoint("BOTTOMRIGHT", _G.AuctionFrame, "BOTTOMRIGHT", 0, 5)
	end

end
function aObj:TSM_AuctionFrameHook()

	self:SecureHook("AuctionFrameTab_OnClick", function(this, button, down, index)
		if this:GetID() < 4 then
			adjustSkinFrame()
		else
			adjustSkinFrame(true)
		end
	end)

end

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

	-- handle frame skinning
    _G.TSMAPI.Design.SetFrameBackdropColor = function(this, frame)
		-- print("TSMAPI.D.SFBC", frame)
		self:addSkinFrame{obj=frame, ofs=2}
	end
	-- handle Sidebar panels
    _G.TSMAPI.Design.SetFrameColor = function(this, frame)
		-- look for parent with width 300
		local obj = frame:GetParent()
		while (self:getInt(obj:GetWidth()) < 300 and self:getInt(obj:GetHeight()) < 447) do
			obj = obj:GetParent()
		end
		if self:getInt(obj:GetWidth()) == 300
		and self:getInt(obj:GetHeight()) == 447
		and not obj.sf then
			self:addSkinFrame{obj=obj}
		end
	end
    _G.TSMAPI.Design.SetContentColor = function() end

	-- skin modules
	for _, module in _G.pairs{"Accounting", "AuctionDB", "Auctioning", "Crafting", "Destroying", "ItemTracker", "Mailing", "Shopping", "Warehousing", "WoWAuction"} do
		if _G.IsAddOnLoaded("TradeSkillMaster_" .. module) then
			self:checkAndRunAddOn("TradeSkillMaster_" .. module)
		end
	end

end

function aObj:TradeSkillMaster_Accounting()
	-- body
end

function aObj:TradeSkillMaster_AuctionDB()

	local TSM_Adb = _G.LibStub("AceAddon-3.0"):GetAddon("TSM_AuctionDB", true)
    local GUI = TSM_Adb:GetModule("GUI", true)
	if GUI then
		self:SecureHook(GUI, "Show", function(this, frame)
			adjustSkinFrame(true)
			self:Unhook(GUI, "Show")
		end)
	end
end

function aObj:TradeSkillMaster_Auctioning()

	local TSM_A = _G.LibStub("AceAddon-3.0"):GetAddon("TSM_Auctioning", true)
    local GUI = TSM_A:GetModule("GUI", true)
	if GUI then
		self:SecureHook(GUI, "ShowSelectionFrame", function(this, frame)
			adjustSkinFrame(true)
			self:Unhook(GUI, "ShowSelectionFrame")
		end)
	end

end

function aObj:TradeSkillMaster_Crafting()

	local TSM_C = _G.LibStub("AceAddon-3.0"):GetAddon("TSM_Crafting", true)
    local GUI = TSM_C:GetModule("CraftingGUI", true)
    if GUI then
		self:addSkinFrame{obj=GUI.gatheringFrame.needST, ofs=2}
		self:addSkinFrame{obj=GUI.gatheringFrame.sourcesST, ofs=2}
		self:addSkinFrame{obj=GUI.gatheringFrame.availableST, ofs=2}
		self:getChild(GUI.gatheringFrame, 2):SetBackdrop(nil)
		self:skinButton{obj=self:getChild(GUI.gatheringFrame, 3), x1=-2, y1=2, x2=2, y2=-2}
		self:skinButton{obj=GUI.gatheringFrame.gatherButton, x1=-2, y1=2, x2=2, y2=-2}
		self:addSkinFrame{obj=GUI.gatheringFrame, ofs=2}
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
			local frame = self:getChild(_G.MailFrame, _G.MailFrame:GetNumChildren() - 1) -- get penultimate child
			self:addSkinFrame{obj=frame, ofs=2, y2=-5}
			_G.MailFrame.sf:Hide() -- hide to start with as mailframe opens to TSM frame initiially
			self:SecureHook(frame, "Show", function(this)
				_G.MailFrame.sf:Hide()
			end)
			self:SecureHook(frame, "Hide", function(this)
				_G.MailFrame.sf:Show()
			end)
			-- Tab
			self:keepRegions(_G.MailFrameTab3, {7, 8})
			self:addSkinFrame{obj=_G.MailFrameTab3, noBdr=self.isTT, x1=6, y1=0, x2=06, y2=2}
		end, 0.2, ...)
		self:UnregisterEvent("MAIL_SHOW")
	end)

end

function aObj:TradeSkillMaster_Shopping()

	local TSM_S = _G.LibStub("AceAddon-3.0"):GetAddon("TSM_Shopping", true)
    local Search = TSM_S:GetModule("Search", true)
	if Search then
		self:SecureHook(Search, "Show", function(this, frame)
			adjustSkinFrame(true)
			self:Unhook(Search, "Show")
		end)
	end

end

function aObj:TradeSkillMaster_Warehousing()
	-- body
end

function aObj:TradeSkillMaster_WoWAuction()
	-- body
end
