local _, aObj = ...
if not aObj:isAddonEnabled("PowerRaid") then return end
local _G = _G

aObj.addonsToSkin.PowerRaid = function(self) -- v 3.2.0

	local function checkDataTab(dataTab)
		for _, tab in pairs(dataTab) do
			if tab.toolTip
			and not _G.rawget(aObj.ttList, tab.toolTip)
			then
				aObj:add2Table(aObj.ttList, tab.toolTip)
			end
		end
	end

	local function processChildren(opts)
		for key, child in _G.ipairs(opts.configTab.children) do
			-- hook CheckBox OnEnter function
			if child.type == "CheckBox"
			or child.type == "InteractiveLabel"
			then
				if aObj:IsHooked(child.events, "OnEnter") then
					aObj:Unhook(child.events, "OnEnter")
				end
				aObj:SecureHook(child.events, "OnEnter", function()
					if opts.type == "CT-1"
					and not _G.rawget(aObj.ttList, _G.lessercheckbox)
					then
						aObj:add2Table(aObj.ttList, _G.lessercheckbox)
					else
						checkDataTab(opts.dataTab)
					end
					aObj:Unhook(child.events, "OnEnter")
				end)
			elseif child.type == "Button" then
				-- resize Consumable Tabs' min/max button skins
				if aObj.modBtns
				and _G.Round(child.frame:GetWidth()) == 12 then
					child.frame.sb:SetPoint("TOPLEFT", child.frame, "TOPLEFT", -2, 2)
					child.frame.sb:SetPoint("BOTTOMRIGHT", child.frame, "BOTTOMRIGHT", 2, -2)
				end
				-- hook to skin reportBtn tooltip
				if child.events.OnEnter then
					if aObj:IsHooked(child.events, "OnEnter") then
						aObj:Unhook(child.events, "OnEnter")
					end
					aObj:SecureHook(child.events, "OnEnter", function()
						if not _G.rawget(aObj.ttList, _G.reportBtn) then
							aObj:add2Table(aObj.ttList, _G.reportBtn)
						end
						aObj:Unhook(child.events, "OnEnter")
					end)
				end
			end
			if child.children then
				processChildren{type=opts.type .. "-" .. key, configTab=child, dataTab=opts.dataTab, lvl=opts.lvl + 1}
			end
		end
	end

	-- hook these to skin Tooltips & resize Min/Max button skins
	-- N.B. These functions MUST be called each time the tab is clicked as the container contents are refreshed
	self:SecureHook(_G.RaidBuffsTab, "DrawBuffs", function(this, container)
		processChildren{type="RBT", configTab=container, dataTab=_G.PowerRaidData.RaidBuffs, lvl=0}
	end)
	self:SecureHook(_G.WorldBuffsTab, "DrawBuffs", function(this, container)
		processChildren{type="WBT", configTab=container, dataTab=_G.PowerRaidData.WorldBuffs, lvl=0}
	end)
	self:SecureHook(_G.PaladinBuffsTab, "DrawBuffs", function(this, container)
		processChildren{type="PBT", configTab=container, dataTab=_G.PowerRaidData.PaladinBuffs, lvl=0}
	end)
	self:SecureHook(_G.RaidItemsTab, "DrawRaidItems", function(this, container)
		processChildren{type="RIT", configTab=container, dataTab=_G.RaidItemsTab.raidItems, lvl=0}
	end)
	self:SecureHook(_G.ConsumablesTab, "DrawConsumables", function(this, container)
		processChildren{type="CT", configTab=container, dataTab=this:getConsumablesInfo(), lvl=0}
	end)

end
