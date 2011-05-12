local aName, aObj = ...
if not aObj:isAddonEnabled("TradeSkillMaster") then return end
local bbc

local function skinButton(btn)

	if not aObj.skinned[btn]
	and btn:GetBackdrop()
	then
		aObj:skinButton{obj=btn}
		btn:SetBackdrop(nil)
	end

end
local function skinChildObjects(frame)

	for _, child in pairs{frame:GetChildren()} do
		if child:IsObjectType("Button") then
			skinButton(child)
		elseif child:IsObjectType("Frame") then
			-- horizontal bar(s)
			if floor(child:GetHeight()) == 8 then
				aObj:getRegion(child, 1):SetVertexColor(bbc.r, bbc.g, bbc.b, 1)
			end
		end
	end

end
local function skinRemoteFrameObjects() end
function aObj:TradeSkillMaster()

	bbc = self.db.profile.BackdropBorder

	local TSM = LibStub("AceAddon-3.0"):GetAddon("TradeSkillMaster", true)

	-- skin modules
	for _, module in pairs{"Auctioning", "Crafting", "Gathering", "AuctionDB", "Shopping"} do
		if IsAddOnLoaded("TradeSkillMaster_"..module) then
			self:checkAndRunAddOn("TradeSkillMaster_"..module)
		end
	end
	-- hook to to skin buttons and frames that appear when the AH is opened
	self:SecureHook(TSMAPI, "UnlockSidebar", function(this)
		-- Remote Frame
		local frame = self:findFrame2(AuctionFrame, "Frame", 430, 350)
		if frame then
			self:addSkinFrame{obj=frame}
		end
		-- OpenClose Button
		local btn = self:findFrame2(AuctionFrame, "Button", 25, 70)
		if btn then
			skinButton(btn)
		end
		-- Icon Container Frame
		frame = self:findFrame2(frame, "Frame", 418, 50)
		if frame then
			-- remove backdrops from Icons
			for _, child in ipairs{frame:GetChildren()} do
				if child.SetBackdrop then child:SetBackdrop(nil) end
				-- hook script to skin objects
				if child.GetScript and child:GetScript("OnMouseUp") then
					self:SecureHookScript(child, "OnMouseUp", function(this)
						skinRemoteFrameObjects()
						self:Unhook(child, "OnMouseUp")
					end)
				end
			end
			-- skin after processing children as we create a child
			self:addSkinFrame{obj=frame, bg=true}
		end
		self:Unhook(TSMAPI, "UnlockSidebar")
	end)
	-- hook this to skin status bars
	self:SecureHook(TSMAPI, "ShowSidebarStatusBar", function(this)
		TSMMajorStatusBar:GetParent():SetBackdrop(nil)
		self:glazeStatusBar(TSMMajorStatusBar, 0)
		self:glazeStatusBar(TSMMinorStatusBar)
		self:Unhook(TSMAPI, "ShowSidebarStatusBar")
	end)

end

function aObj:TradeSkillMaster_Auctioning()

	local TSM_A = LibStub("AceAddon-3.0"):GetAddon("TradeSkillMaster_Auctioning", true)
	if TSM_A.InfoFrame then
		self:moveObject{obj=TSM_A.InfoFrame.title, y=-4}
		self:addSkinFrame{obj=TSM_A.InfoFrame, kfs=true}
	end
	local Manage = TSM_A:GetModule("Manage", true)
	if Manage then
		function skinRemoteFrameObjects()
			for k, obj in pairs(Manage) do
				if type(obj) == "table" then
					if k:find("Frame") then
						skinChildObjects(obj)
					elseif k:find("Button")	then
						skinButton(obj)
					end
				end
			end
		end
	end

end

function aObj:TradeSkillMaster_Gathering()

	local TSM_G = LibStub("AceAddon-3.0"):GetAddon("TradeSkillMaster_Gathering", true)
	local GUI = TSM_G:GetModule("GUI", true)
	if GUI then
		self:SecureHook(GUI, "Create", function(this)
			self:addSkinFrame{obj=GUI.frame}
			self:Unhook(GUI, "Create")
		end)
		self:SecureHook(GUI, "CreateMerchantBuyButton", function(this	)
			skinButton(GUI.merchantButton)
			self:Unhook(GUI, "CreateMerchantBuyButton")
		end)
	end

end

function aObj:TradeSkillMaster_Crafting()

	local TSM_C = LibStub("AceAddon-3.0"):GetAddon("TradeSkillMaster_Crafting", true)
	local Crafting = TSM_C:GetModule("Crafting", true)
	if Crafting then
		self:SecureHook(Crafting, "LayoutFrame", function(this)
			skinButton(Crafting.openCloseButton)
			self:addSkinFrame{obj=Crafting.frame}
			self:addSkinFrame{obj=Crafting.frame.professionBar, bg=true}
			self:addSkinFrame{obj=Crafting.frame.titleBackground}
			self:skinScrollBar{obj=Crafting.frame.craftingScroll}
			skinButton(Crafting.frame.noCrafting.button)
			Crafting.frame.verticalBarTexture:SetVertexColor(bbc.r, bbc.g, bbc.b, 1)
			Crafting.frame.horizontalBarTexture:SetVertexColor(bbc.r, bbc.g, bbc.b, 1)
			Crafting.frame.horizontalBarTexture2:SetVertexColor(bbc.r, bbc.g, bbc.b, 1)
			skinButton(Crafting.button)
			skinButton(Crafting.restockQueueButton)
			skinButton(Crafting.onHandQueueButton)
			skinButton(Crafting.clearQueueButton)
			skinButton(Crafting.clearFilterButton)
			self:skinScrollBar{obj=Crafting.frame.shoppingScroll}
			Crafting.frame.shoppingScroll.titleRow.bar:SetVertexColor(bbc.r, bbc.g, bbc.b, 0.5)
			self:skinScrollBar{obj=Crafting.frame.queuingScroll}
			Crafting.frame.queuingScroll.titleRow.bar:SetVertexColor(bbc.r, bbc.g, bbc.b, 0.5)
			if self.modBtns then
				for i = 1, #Crafting.queuingRows do
					local btn = Crafting.queuingRows[i].button
					self:skinButton{obj=btn, mp=true}
				end
				self:SecureHook(Crafting, "UpdateQueuing", function(this)
					for i = 1, #Crafting.queuingRows do
						self:checkTex(Crafting.queuingRows[i].button)
					end
				end)
			end
			self:Unhook(Crafting, "LayoutFrame")
		end)
	end

end

function aObj:TradeSkillMaster_AuctionDB()

	local TSM_ADB = LibStub("AceAddon-3.0"):GetAddon("TradeSkillMaster_AuctionDB", true)
	local GUI = TSM_ADB:GetModule("GUI", true)
	if GUI then
		self:SecureHook(GUI, "LoadSidebar", function(this)
			skinChildObjects(GUI.frame)
			self:Unhook(GUI, "LoadSidebar")
		end)
	end

end

function aObj:TradeSkillMaster_Shopping()

	local TSM_S = LibStub("AceAddon-3.0"):GetAddon("TradeSkillMaster_Shopping", true)
	local General = TSM_S:GetModule("General", true)
	if General then
		self:SecureHook(General, "LoadSidebar", function(this)
			skinChildObjects(General.frame)
			self:Unhook(General, "LoadSidebar")
		end)
	end
	local Destroying = TSM_S:GetModule("Destroying", true)
	if Destroying then
		self:SecureHook(Destroying, "LoadSidebar", function(this)
			skinChildObjects(Destroying.frame)
			self:Unhook(Destroying, "LoadSidebar")
		end)
	end
	local Automatic = TSM_S:GetModule("Automatic", true)
	if Automatic then
		self:SecureHook(Automatic, "LoadSidebar", function(this)
			skinChildObjects(Automatic.frame)
			self:Unhook(Automatic, "LoadSidebar")
		end)
	end
	local Dealfinding = TSM_S:GetModule("Dealfinding", true)
	if Dealfinding then
		self:SecureHook(Dealfinding, "LoadSidebar", function(this)
			skinChildObjects(Dealfinding.frame)
			self:Unhook(Dealfinding, "LoadSidebar")
		end)
	end

end

