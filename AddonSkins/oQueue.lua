local aName, aObj = ...
if not aObj:isAddonEnabled("oQueue") then return end
local _G =_G
local ipairs = _G.ipairs

function aObj:oQueue()
	
	local function skinKids(parent)

		local pName = parent:GetName()
		for _, child in ipairs{parent:GetChildren()} do
			if child:IsObjectType("Button")
			and aObj:hasTextInName(child, pName .. "Button")
			then
				aObj:skinButton{obj=child}
				aObj:SecureHookScript(child, "OnEnter", function(this)
					if _G.OQGenTooltip
					and not _G.OQGenTooltip.sf
					then
						aObj:addSkinFrame{obj=_G.OQGenTooltip}
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
			and aObj:hasTextInName(child, pName .. "Close")
			then
				aObj:skinButton{obj=child, cb=true}
			elseif child:IsObjectType("Button")
			and aObj:hasTextInName(child, "OQClikLabel")
			then
				-- skin the OQMainFrameShadeBegBox
				aObj:SecureHookScript(child, "OnClick", function(this)
					if not _G.OQMainFrameShadeBegBox.sf then
						skinKids(_G.OQMainFrameShadeBegBox)
						aObj:addSkinFrame{obj=_G.OQMainFrameShadeBegBox}
					end
					aObj:Unhook(child, "OnClick")
				end)
			elseif child:IsObjectType("EditBox") then
				aObj:skinEditBox{obj=child, regs={9}}
			elseif child:IsObjectType("ScrollFrame")
			and aObj:hasTextInName(child, pName .. "ListScrollBar")
			then
				aObj:skinScrollBar{obj=child}
				aObj:applySkin{obj=_G[pName .. "List"]} -- use applySkin so list items appear in the FG
			elseif child:IsObjectType("Frame")
			and aObj:isDropDown(child)
			then
				aObj:skinDropDown{obj=child, x2=35}
			end
		end

	end

	-- OQMain Frame
	self:SecureHook(_G.OQMainFrame, "Show", function(this)

		self:moveObject{obj=_G.OQFrameHeader, y=-6}
		skinKids(_G.OQMainFrame)
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
		self:addSkinFrame{obj=_G.OQTooltip}
		_G.OQTooltip.SetBackdrop = function() end
		self:Unhook(_G.OQKarmaShield, "OnEnter")
	end)
	-- BountyBoard
	self:addButtonBorder{obj=_G.OQ_TexturedButton3, y1=-18}
	_G.OQBountyBoard._poster:SetTextColor('h1', self.HTr, self.HTg, self.HTb)
	_G.OQBountyBoard._poster:SetTextColor('h3', self.BTr, self.BTg, self.BTb)
	_G.OQBountyBoard._reward_l:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.OQBountyBoard._reward:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.OQBountyBoard._remaining_l:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.OQBountyBoard._remaining:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.OQBountyBoard._page:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.OQBountyBoard, kfs=true, ofs=-40, y1=-120}
	
	-- TabPage1 (Premade)
	self:SecureHook(_G.OQTabPage1, "Show", function(this)
		skinKids(this)
		self:Unhook(_G.OQTabPage1, "Show")
	end)
	local OQtt
	local function checkPremades(parent)
		
		for _, child in ipairs{parent:GetChildren()} do
			if child:IsObjectType("Frame")
			and aObj:hasTextInName(child, "DotRegion")
			then
				if not OQtt
				and not aObj:IsHooked(child, "OnEnter")
				then
					aObj:SecureHookScript(child, "OnEnter", function(this)
						if _G.OQTooltip
						and not _G.OQTooltip.sf
						then
							aObj:addSkinFrame{obj=_G.OQTooltip} OQtt = true
						end
						aObj:Unhook(child, "OnEnter")
					end)
				end
			elseif child:IsObjectType("Button")
			and aObj:hasTextInName(child, "BGsButton")
			then
				aObj:skinButton{obj=child}
			elseif child:IsObjectType("Button")
			and aObj:hasTextInName(child, "OQModelFrame")
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
			and aObj:hasTextInName(child, "ListingRegion")
			then
				if not OQPMtt
				and not aObj:IsHooked(child, "OnEnter")
				then
					aObj:SecureHookScript(child, "OnEnter", function(this)
						if _G.OQPMTooltip
						and not _G.OQPMTooltip.sf
						then
							aObj:addSkinFrame{obj=_G.OQPMTooltip}
							OQPMtt = true
						end
						aObj:Unhook(child, "OnEnter")
					end)
				end
				if not OQGENtt
				and not aObj:IsHooked(child.unlist_but, "OnEnter")
				then
					aObj:SecureHookScript(child.unlist_but, "OnEnter", function(this)
						if _G.OQGenTooltip
						and not _G.OQGenTooltip.sf
						then
							aObj:addSkinFrame{obj=_G.OQGenTooltip}
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
			if aObj:hasTextInName(child, name) then
				child.texture:SetTexture(nil)
				aObj:skinButton{obj=child.remove_but, as=true} -- use applySkin so text appears in the FG
			end
		end

	end
	self:SecureHook(_G.OQTabPage5, "Show", function(this)

		skinKids(this)

		-- hook this to skin new Alts
		self:SecureHook(_G.StaticPopupDialogs["OQ_AddToonName"], "OnAccept", function(this, ...)
			skinLists(_G.OQTabPage5List, "ListAlt")
		end)
		self:SecureHook(_G.StaticPopupDialogs["OQ_AddToonName"], "EditBoxOnEnterPressed", function(this)
			skinLists(_G.OQTabPage5List, "ListAlt")
		end)
		-- skin any existing Alts
		skinLists(_G.OQTabPage5List, "ListAlt")

		self:Unhook(_G.OQTabPage5, "Show")
	end)
	-- TabPage6 (BanList)
	self:SecureHook(_G.OQTabPage6, "Show", function(this)

		skinKids(this)

		-- hook this to skin new Banned Users
		self:SecureHook(_G.StaticPopupDialogs["OQ_BanUser"], "OnAccept", function(this, ...)
			skinLists(_G.OQTabPage6List, "ListBanned")
		end)
		self:SecureHook(_G.StaticPopupDialogs["OQ_BanUser"], "EditBoxOnEnterPressed", function(this)
			skinLists(_G.OQTabPage6List, "ListBanned")
		end)
		-- skin any existing Banned Users
		skinLists(_G.OQTabPage6List, "ListBanned")

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
	-- OQMarquee
	self:addSkinFrame{obj=_G.OQMarquee}
	-- Minimap button
	if self.db.profile.MinimapButtons.skin then
		self:removeRegions(_G.OQ_MinimapButton, {1, 2}) -- remove Icon & Border
		self:skinButton{obj=_G.OQ_MinimapButton, ob="oQ", sap=true}
	end

end
