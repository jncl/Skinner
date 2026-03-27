local _, aObj = ...
if not aObj:isAddonEnabled("WhereLoot") then return end
local _G = _G

aObj.addonsToSkin.WhereLoot = function(self) -- v 1.5.1

	local function skinWLFrame()

		local MainFrame = _G.WhereLootFrame
		local contentFrame = aObj:getChild(MainFrame, 6)

		aObj:SecureHookScript(MainFrame, "OnShow", function(this)
			local chartBtn = aObj:getChild(this, 1)
			local closeBtn = aObj:getChild(this, 2)
			local specBar = aObj:getChild(this, 4)

			aObj:skinObject("frame", {obj=this, kfs=true, ofs=0})
			if aObj.modBtns then
				aObj:removeBackdrop(chartBtn)
				aObj:skinStdButton{obj=chartBtn, ofs=2, clr="gold"}
				aObj:skinCloseButton{obj=closeBtn}
				for _, btn in _G.ipairs{specBar:GetChildren()} do
					aObj:removeBackdrop(btn)
					aObj:skinStdButton{obj=btn, ofs=2, clr="gold"}
				end
			end

			aObj:SecureHookScript(chartBtn, "OnClick", function(_)
				local IlvlChartFrame = aObj:getChild(contentFrame, 3)
				aObj:SecureHookScript(IlvlChartFrame, "OnShow", function(fObj)
					aObj:getRegion(fObj, 1):SetTexture(nil)
					aObj:skinObject("slider", {obj=aObj:getChild(fObj, 1).ScrollBar})


					aObj:Unhook(IlvlChartFrame, "OnShow")
				end)
				aObj:checkShown(IlvlChartFrame)

				aObj:Unhook(chartBtn, "OnClick")
			end)

			aObj:Unhook(MainFrame, "OnShow")
		end)
		aObj:checkShown(MainFrame)

		local SlotSelectFrame = aObj:getChild(contentFrame, 1)
		aObj:SecureHookScript(SlotSelectFrame, "OnShow", function(this)
			if aObj.modBtns then
				for _, btn in _G.ipairs{this:GetChildren()} do
					aObj:removeBackdrop(btn)
					aObj:skinStdButton{obj=btn, ofs=2, clr="gold"}
				end
			end

			aObj:Unhook(SlotSelectFrame, "OnShow")
		end)
		aObj:checkShown(SlotSelectFrame)

		local LootDisplayFrame = aObj:getChild(contentFrame, 2)
		aObj:SecureHookScript(LootDisplayFrame, "OnShow", function(this)
			aObj:skinObject("slider", {obj=aObj:getChild(this, 1).ScrollBar})

			aObj:Unhook(LootDisplayFrame, "OnShow")
		end)
		aObj:checkShown(LootDisplayFrame)

		skinWLFrame = _G.nop

	end

	self.RegisterCallback("WhereLoot", "EncounterJournal_Skinned", function(_, _)
		if _G.WhereLootEJButton then
			self:removeBackdrop(_G.WhereLootEJButton)
			self:skinObject("button", {obj=_G.WhereLootEJButton, ofs=2, clr="gold"})
			self:SecureHookScript(_G.WhereLootEJButton, "OnClick", function(_)
				if _G.InCombatLockdown() then
					return
				end
				skinWLFrame()
				self:Unhook(_G.WhereLootEJButton, "OnClick")
			end)
		end
	end)

	self:SecureHook(_G.SlashCmdList, "WHERELOOT", function(_, _)
		if _G.InCombatLockdown() then
			return
		end
		skinWLFrame()
		self:Unhook(_G.SlashCmdList, "WHERELOOT")
	end)

end
