local aName, aObj = ...
if not aObj:isAddonEnabled("oQueue") then return end
local _G =_G
local ipairs, strlower = _G.ipairs, _G.strlower

function aObj:oQueue() -- v 2.0.1

	-- bugfix for version 1.6.1 (names are now lowercase)
	_G.OQBRBDialog		= _G.oqbrbdialog
	_G.OQMarquee		= _G.oqmarquee
	_G.OQKarmaShield	= _G.oqkarmashield
	_G.OQBountyBoard	= _G.oqbountyboard
	_G.OQLogBoard		= _G.oqlogboard
	_G.OQTabPage2List	= _G.oqtabpage2list
	_G.OQTabPage5List	= _G.oqtabpage5list
	_G.OQTabPage6List	= _G.oqtabpage6list
	_G.OQTabPage7List	= _G.oqtabpage7list

	_G.OQLongTooltip	= _G.oqlongtooltip
	_G.OQGenTooltip		= _G.oqgentooltip
	_G.OQPMTooltip		= _G.oqpmtooltip
	_G.OQPMTooltipExtra = _G.oqpmtooltipextra

	-- Shade children
	-- _badtag
	-- _banned
	-- _beg
	-- _bnetdown
	-- _help
	-- _hint

	local skinKids -- required to prevent reference error in the following local function
	local function skinShadeChild(frame)
		skinKids(frame)
		aObj:addSkinFrame{obj=frame}
		local shade = frame:GetParent()
		if not aObj:IsHooked(shade, "Show") then
			aObj:SecureHook(shade, "Show", function(this)
				if not this._child.sf then
					skinKids(this._child)
					aObj:addSkinFrame{obj=this._child}
				end
			end)
		end
	end
	function skinKids(parent)

		local pName = parent:GetName()
		for _, child in ipairs{parent:GetChildren()} do
			if child:IsObjectType("Button")
			and aObj:hasTextInName(child, strlower(pName .. "Button"))
			then
				aObj:skinButton{obj=child}
				-- check for BRB button
				if parent == _G.OQTabPage1
				and aObj:getInt(child:GetWidth()) == 100
				and aObj:getInt(child:GetHeight()) == 28
				then
					-- skin the OQBRBDialog
					aObj:SecureHookScript(child, "OnClick", function(this)
						aObj:addSkinFrame{obj=_G.OQBRBDialog, nb=true}
						aObj:skinButton{obj=aObj:getChild(_G.OQBRBDialog, 1)}
						aObj:Unhook(child, "OnClick")
					end)
				end
			elseif child:IsObjectType("Button")
			and aObj:hasTextInName(child, "oqclose")
			then
				aObj:skinButton{obj=child, cb=true}
			elseif child:IsObjectType("Button")
			and aObj:hasTextInName(child, strlower("OQClikLabel"))
			then
				-- skin the begbox
				aObj:SecureHookScript(child, "OnClick", function(this)
					-- v1.8.1 following entry might be Uppercase again
					_G.begbox = _G.BegBox and _G.BegBox or _G.begbox

					if not _G.begbox.sf then
						skinShadeChild(_G.begbox)
					end
					aObj:Unhook(child, "OnClick")
				end)
			elseif child:IsObjectType("Button")
			and aObj:hasTextInTexture(self:getRegion(child, 1), strlower("help-i"), true)
			then
				-- skin the helperbox
				aObj:SecureHookScript(child, "OnClick", function(this)
					if not _G.helperbox.sf then
						skinShadeChild(_G.helperbox)
					end
					aObj:Unhook(child, "OnClick")
				end)
			elseif child:IsObjectType("Button")
			and aObj:hasTextInName(child, "OQKarmaButton")
			then
				-- skin the karma dropdown
				aObj:SecureHookScript(child, "OnClick", function(this)
					if not _G.oqmenu.sf then
						self:addSkinFrame{obj=_G.oqmenu}
					end
					aObj:Unhook(child, "OnClick")
				end)
			elseif child:IsObjectType("Button")
			and aObj:hasTextInName(child, "OQRaffleButton")
			then
				-- skin the raffle frame
				aObj:SecureHookScript(child, "OnClick", function(this)
					if not _G.rafflebox.sf then
						skinShadeChild(_G.rafflebox)
					end
					aObj:Unhook(child, "OnClick")
				end)
			elseif child:IsObjectType("EditBox") then
				aObj:skinEditBox{obj=child, regs={9}}
			elseif child:IsObjectType("ScrollFrame")
			and aObj:hasTextInName(child, strlower(pName .. "ListScrollBar"))
			then
				aObj:skinScrollBar{obj=child}
				aObj:applySkin{obj=_G[strlower(pName .. "List")]} -- use applySkin so list items appear in the FG
			elseif child:IsObjectType("Frame")
			and aObj:isDropDown(child)
			then
				aObj:skinDropDown{obj=child, x2=35}
			elseif child:IsObjectType("Button")
			and aObj:hasTextInName(child, "oqbutton")
			then
				self:skinButton{obj=child}
			end
		end

	end
	local function skinTooltip(ttip)

		aObj:addSkinFrame{obj=ttip}
		ttip.SetBackdrop = function() end
		if ttip.emphasis_texture then ttip.emphasis_texture:SetTexture(nil) end
		if ttip.splat then ttip.splat:SetTexture(nil) end

	end

	-- OQMarquee
	self:addSkinFrame{obj=_G.OQMarquee}
	-- OQMain Frame
	self:moveObject{obj=_G.OQFrameHeader, y=-6}
	skinKids(_G.OQMainFrame)
	self:skinButton{obj=_G.OQMainFrame.closepb, cb=true}
	self:addSkinFrame{obj=_G.OQMainFrame, kfs=true, nb=true, y2=-2}
	-- find and skin the shade frame child if it's being displayed
	self:ScheduleTimer(function()
		if _G.shade then skinShadeChild(_G.shade._child) end
	end, 2)
	-- Tabs
	self:skinTabs{obj=_G.OQMainFrame}
	-- KarmaShield
	self:removeRegions(_G.OQKarmaShield, {1}) -- border ring
	_G.OQKarmaShield.shield:SetAlpha(0)
	self:skinButton{obj=_G.OQKarmaShield}
	self:SecureHookScript(_G.OQKarmaShield, "OnEnter", function(this)
		skinTooltip(_G.OQLongTooltip)
		self:Unhook(_G.OQKarmaShield, "OnEnter")
	end)
	-- BountyBoard
	_G.OQBountyBoard._poster:SetTextColor('h1', self.HTr, self.HTg, self.HTb)
	_G.OQBountyBoard._poster:SetTextColor('h3', self.BTr, self.BTg, self.BTb)
	_G.OQBountyBoard._reward_l:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.OQBountyBoard._reward:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.OQBountyBoard._remaining_l:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.OQBountyBoard._remaining:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.OQBountyBoard._page:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinButton{obj=self:getChild(_G.OQBountyBoard, 1), cb=true}
	self:addSkinFrame{obj=_G.OQBountyBoard, kfs=true, nb=true, ofs=-20, y1=-80}
	-- OQLogBoard
	_G.OQLogBoard.top_texture:SetTexture(nil)
	_G.OQLogBoard.middle_texture:SetTexture(nil)
	_G.OQLogBoard.bottom_texture:SetTexture(nil)
	_G.OQLogBoard.backdrop_texture:SetTexture(nil)
	self:skinButton{obj=self:getChild(_G.OQLogBoard, 1), cb=true}
	self:addSkinFrame{obj=_G.OQLogBoard}
	-- LootContract frame
	self:RegisterEvent("PARTY_LOOT_METHOD_CHANGED", function(...)
		local lcTmr = self:ScheduleRepeatingTimer(function()
			if _G.LootContract then
				self:skinButton{obj=_G.LootContract.closepb, cb=true}
				self:skinButton{obj=_G.LootContract.accept_but}
				self:skinButton{obj=_G.LootContract.donot_but}
				self:skinButton{obj=_G.LootContract.reject_but}
				self:addSkinFrame{obj=_G.LootContract, kfs=true, nb=true}
				self:CancelTimer(lcTmr, true)
				lcTmr = nil
			end
		end, 0.5)
		self:UnregisterEvent("PARTY_LOOT_METHOD_CHANGED")
	end)
	-- TabPage1 (Premade)
	self:SecureHook(_G.OQTabPage1, "Show", function(this)
		skinKids(this)
		self:Unhook(_G.OQTabPage1, "Show")
	end)
	local OQtt
	local function checkPremades(parent)

		for _, child in ipairs{parent:GetChildren()} do
			if child:IsObjectType("Frame")
			and aObj:hasTextInName(child, strlower("DotRegion"))
			then
				if not OQtt
				and not aObj:IsHooked(child, "OnEnter")
				then
					aObj:SecureHookScript(child, "OnEnter", function(this)
						skinTooltip(_G.OQPMTooltip)
						OQtt = true
						aObj:Unhook(child, "OnEnter")
					end)
				end
			elseif child:IsObjectType("Button")
			and aObj:hasTextInName(child, strlower("BGsButton"))
			then
				aObj:skinButton{obj=child}
			elseif child:IsObjectType("Button")
			and aObj:hasTextInName(child, strlower("OQModelFrame"))
			then
				aObj:skinButton{obj=child}
			end
			if child:IsObjectType("Frame") then
				checkPremades(child)
			end
		end

	end
	local tp1Tmr
	self:SecureHookScript(_G.OQTabPage1, "OnShow", function(this)
		if not tp1Tmr then
			tp1Tmr = self:ScheduleRepeatingTimer(checkPremades, 0.2, _G.OQTabPage1)
		end
	end)
	self:SecureHookScript(_G.OQTabPage1, "OnHide", function(this)
		if tp1Tmr then
			self:CancelTimer(tp1Tmr, true)
			tp1Tmr = nil
		end
	end)
	-- TabPage2 (Find Premade)
	local OQPMtt, OQGENtt
	local function checkList()

		for _, child in ipairs{_G.OQTabPage2List:GetChildren()} do
			if child:IsObjectType("Frame")
			and aObj:hasTextInName(child, strlower("ListingRegion"))
			then
				if not OQPMtt
				and not aObj:IsHooked(child, "OnEnter")
				then
					aObj:SecureHookScript(child, "OnEnter", function(this)
						skinTooltip(_G.OQPMTooltipExtra)
						OQPMtt = true
						aObj:Unhook(child, "OnEnter")
					end)
				end
				if not OQGENtt
				and not aObj:IsHooked(child.unlist_but, "OnEnter")
				then
					aObj:SecureHookScript(child.unlist_but, "OnEnter", function(this)
						skinTooltip(_G.OQGenTooltip)
						OQGENtt = true
						aObj:Unhook(child.unlist_but, "OnEnter")
					end)
				end
				aObj:skinButton{obj=child.req_but, as=true}
			end
		end

	end
	-- run a repeating timer task to skin new list entries as required
	local tp2Tmr
	self:SecureHookScript(_G.OQTabPage2, "OnShow", function(this)
		if not tp2Tmr then
			tp2Tmr = self:ScheduleRepeatingTimer(checkList, 0.2)
		end
	end)
	self:SecureHookScript(_G.OQTabPage2, "OnHide", function(this)
		if tp2Tmr then
			self:CancelTimer(tp2Tmr, true)
			tp2Tmr = nil
		end
	end)
	if _G.OQTabPage2:IsShown() then
		skinKids(_G.OQTabPage2)
		tp2Tmr = self:ScheduleRepeatingTimer(checkList, 0.2)
	else
		self:SecureHook(_G.OQTabPage2, "Show", function(this)
			skinKids(this)
			self:Unhook(_G.OQTabPage2, "Show")
		end)
	end
	-- TabPage3 (Create Premade)
	self:SecureHook(_G.OQTabPage3, "Show", function(this)
		skinKids(this)
		if _G.notice then
			self:addSkinFrame{obj=_G.notice}
		end
		self:Unhook(_G.OQTabPage3, "Show")
	end)
	-- TabPage4 (The Score)
		-- N.B. can't do anything about the capture bars, removing main texture exposes count value too early
	-- TabPage5 (Setup)
	local function skinLists(tab, name)

		-- for _, child in ipairs{tab:GetChildren()} do
		--	   if aObj:hasTextInName(child, strlower(name)) then
		--		   -- aObj:skinButton{obj=child.remove_but, as=true} -- use applySkin so text appears in the FG
		--	   end
		-- end

	end
	self:SecureHook(_G.OQTabPage5, "Show", function(this)

		skinKids(this)

		-- hook this to skin new Alts
		self:SecureHook(_G.StaticPopupDialogs["OQ_AddToonName"], "OnAccept", function(this, ...)
			skinLists(_G.OQTabPage5List, "Alt")
		end)
		self:SecureHook(_G.StaticPopupDialogs["OQ_AddToonName"], "EditBoxOnEnterPressed", function(this)
			skinLists(_G.OQTabPage5List, "Alt")
		end)
		-- skin any existing Alts
		skinLists(_G.OQTabPage5List, "Alt")

		self:Unhook(_G.OQTabPage5, "Show")
	end)
	-- TabPage6 (BanList)
	self:SecureHook(_G.OQTabPage6, "Show", function(this)

		skinKids(this)

		-- hook this to skin new Banned Users
		self:SecureHook(_G.StaticPopupDialogs["OQ_BanUser"], "OnAccept", function(this, ...)
			skinLists(_G.OQTabPage6List, "Banned")
		end)
		self:SecureHook(_G.StaticPopupDialogs["OQ_BanUser"], "EditBoxOnEnterPressed", function(this)
			skinLists(_G.OQTabPage6List, "Banned")
		end)
		-- skin any existing Banned Users
		skinLists(_G.OQTabPage6List, "Banned")

		self:Unhook(_G.OQTabPage6, "Show")
	end)
	-- TabPage7 (WaitList)
	self:SecureHook(_G.OQTabPage7, "Show", function(this)
		skinKids(this)
		self:Unhook(_G.OQTabPage7, "Show")
	end)
	local function checkWaitList()

		for _, child in ipairs{_G.OQTabPage7List:GetChildren()} do
			aObj:skinButton{obj=child.invite_but, as=true}
			if child.ginvite_but then aObj:skinButton{obj=child.ginvite_but, as=true} end
		end

	end
	-- run a repeating timer task to skin new list entries as required
	local tp7Tmr
	self:SecureHookScript(_G.OQTabPage7, "OnShow", function(this)
		if not tp7Tmr then
			tp7Tmr = self:ScheduleRepeatingTimer(checkWaitList, 0.2)
		end
	end)
	self:SecureHookScript(_G.OQTabPage7, "OnHide", function(this)
		if tp7Tmr then
			self:CancelTimer(tp7Tmr, true)
			tp7Tmr = nil
		end
	end)
	-- Minimap button
	if self.db.profile.MinimapButtons.skin then
		self:removeRegions(_G.OQ_MinimapButton, {1, 2}) -- remove Icon & Border
		self:skinButton{obj=_G.OQ_MinimapButton, ob="oQ", sap=true}
	end

end
