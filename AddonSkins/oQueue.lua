local aName, aObj = ...
if not aObj:isAddonEnabled("oQueue") then return end
local _G =_G
local ipairs, strlower = _G.ipairs, _G.strlower

function aObj:oQueue()

	-- bugfix for version 1.6.1 (names are now lowercase)
	_G.OQBRBDialog = _G.oqbrbdialog
	_G.OQMarquee = _G.oqmarquee
	_G.OQKarmaShield = _G.oqkarmashield
	_G.OQBountyBoard = _G.oqbountyboard
	_G.OQLogBoard = _G.oqlogboard
	_G.OQTabPage2List =_G.oqtabpage2list
	_G.OQTabPage5List =_G.oqtabpage5list
	_G.OQTabPage6List =_G.oqtabpage6list
	_G.OQTabPage7List =_G.oqtabpage7list
	_G.OQTabPage3ShadeNotice = _G.oqtabpage3shadenotice
	_G.OQTabPage3ShadeTimeVariance =_G.oqtabpage3shadetimevariance

	local function skinKids(parent)

		local pName = parent:GetName()
		for _, child in ipairs{parent:GetChildren()} do
			if child:IsObjectType("Button")
			and aObj:hasTextInName(child, strlower(pName .. "Button"))
			then
				aObj:skinButton{obj=child}
				aObj:SecureHookScript(child, "OnEnter", function(this)
					if _G[strlower("OQGenTooltip")]
					and not _G[strlower("OQGenTooltip")].sf
					then
						aObj:addSkinFrame{obj=_G[strlower("OQGenTooltip")]}
					end
					aObj:Unhook(child, "OnEnter")
				end)
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
			and aObj:hasTextInName(child, strlower(pName .. "Close"))
			then
				aObj:skinButton{obj=child, cb=true}
			elseif child:IsObjectType("Button")
			and aObj:hasTextInName(child, strlower("OQClikLabel"))
			then
				-- skin the begbox
				aObj:SecureHookScript(child, "OnClick", function(this)
					if not _G.begbox.sf then
						skinKids(_G.begbox)
						aObj:addSkinFrame{obj=_G.begbox}
					end
					aObj:Unhook(child, "OnClick")
				end)
			elseif child:IsObjectType("Button")
			and aObj:hasTextInTexture(self:getRegion(child, 1), strlower("help-i"), true)
			then
				-- skin the helperbox
				aObj:SecureHookScript(child, "OnClick", function(this)
					if not _G.helperbox.sf then
						skinKids(_G.helperbox)
						aObj:addSkinFrame{obj=_G.helperbox}
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
			end
		end

	end

	-- OQMarquee
	self:addSkinFrame{obj=_G.OQMarquee}
	-- OQMain Frame
	self:SecureHook(_G.OQMainFrame, "Show", function(this)

		self:moveObject{obj=_G.OQFrameHeader, y=-6}
		skinKids(_G.OQMainFrame)
		self:skinButton{obj=_G.OQMainFrame.closepb, cb=true}
		self:addSkinFrame{obj=_G.OQMainFrame, kfs=true, nb=true, y2=-2}
		-- Tabs
		self:skinTabs{obj=_G.OQMainFrame}

		self:Unhook(_G.OQMainFrame, "Show")
	end)
	-- KarmaShield
	self:removeRegions(_G.OQKarmaShield, {1}) -- border ring
	_G.OQKarmaShield.shield:SetAlpha(0)
	self:skinButton{obj=_G.OQKarmaShield}
	self:SecureHookScript(_G.OQKarmaShield, "OnEnter", function(this)
		self:addSkinFrame{obj=_G[strlower("OQTooltip")]}
		_G[strlower("OQTooltip")].SetBackdrop = function() end
		self:Unhook(_G.OQKarmaShield, "OnEnter")
	end)
	-- BountyBoard
	-- self:addButtonBorder{obj=_G.OQ_TexturedButton3, y1=-18}
	_G.OQBountyBoard._poster:SetTextColor('h1', self.HTr, self.HTg, self.HTb)
	_G.OQBountyBoard._poster:SetTextColor('h3', self.BTr, self.BTg, self.BTb)
	_G.OQBountyBoard._reward_l:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.OQBountyBoard._reward:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.OQBountyBoard._remaining_l:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.OQBountyBoard._remaining:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.OQBountyBoard._page:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.OQBountyBoard, kfs=true, ofs=-40, y1=-120}
	-- OQLogBoard
	_G.OQLogBoard.top_texture:SetTexture(nil)
	_G.OQLogBoard.middle_texture:SetTexture(nil)
	_G.OQLogBoard.bottom_texture:SetTexture(nil)
	_G.OQLogBoard.backdrop_texture:SetTexture(nil)
	self:skinButton{obj=self:getChild(_G.OQLogBoard, 1), cb=true}
	self:addSkinFrame{obj=_G.OQLogBoard}

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
						if _G[strlower("OQTooltip")]
						and not _G[strlower("OQTooltip")].sf
						then
							aObj:addSkinFrame{obj=_G[strlower("OQTooltip")]}
							_G[strlower("OQTooltip")].SetBackdrop = function() end
							OQtt = true
						end
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
	self:SecureHook(_G.OQTabPage2, "Show", function(this)
		skinKids(this)
		self:Unhook(_G.OQTabPage2, "Show")
	end)
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
						if _G[strlower("OQPMTooltip")]
						and not _G[strlower("OQPMTooltip")].sf
						then
							aObj:addSkinFrame{obj=_G[strlower("OQPMTooltip")]}
							OQPMtt = true
						end
						aObj:Unhook(child, "OnEnter")
					end)
				end
				if not OQGENtt
				and not aObj:IsHooked(child.unlist_but, "OnEnter")
				then
					aObj:SecureHookScript(child.unlist_but, "OnEnter", function(this)
						if _G[strlower("OQGenTooltip")]
						and not _G[strlower("OQGenTooltip")].sf
						then
							aObj:addSkinFrame{obj=_G[strlower("OQGenTooltip")]}
							OQGENtt = true
						end
						aObj:Unhook(child.unlist_but, "OnEnter")
					end)
				end
				aObj:skinButton{obj=child.req_but, as=true}
				aObj:skinButton{obj=child.unlist_but, as=true}
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

	-- TabPage3 (Create Premade)
	self:SecureHook(_G.OQTabPage3, "Show", function(this)
		skinKids(this)
		if _G.OQTabPage3ShadeNotice then
			self:addSkinFrame{obj=_G.OQTabPage3ShadeNotice}
			self:skinButton{obj=self:getChild(_G.OQTabPage3ShadeNotice, 1), cb=true}
		end
		if _G.OQTabPage3ShadeTimeVariance then
			self:addSkinFrame{obj=_G.OQTabPage3ShadeTimeVariance}
			self:skinButton{obj=self:getChild(_G.OQTabPage3ShadeTimeVariance, 1), cb=true}
		end
		self:Unhook(_G.OQTabPage3, "Show")
	end)
	-- TabPage4 (The Score)
		-- N.B. can't do anything about the capture bars, removing main texture exposes count value too early
	-- TabPage5 (Setup)
	local function skinLists(tab, name)

		for _, child in ipairs{tab:GetChildren()} do
			if aObj:hasTextInName(child, strlower(name)) then
				child.texture:SetTexture(nil)
				aObj:skinButton{obj=child.remove_but, as=true} -- use applySkin so text appears in the FG
			end
		end

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
			aObj:skinButton{obj=child.remove_but, as=true}
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
