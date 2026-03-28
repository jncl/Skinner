local _, aObj = ...
if not aObj:isAddonEnabled("WhereLoot") then return end
local _G = _G

aObj.addonsToSkin.WhereLoot = function(self) -- v 1.8

	local function skinBtn(btn, ofs)
		aObj:removeBackdrop(btn)
		aObj:skinStdButton{obj=btn, ofs=ofs or 2, clr="gold"}
	end
	local function skinWLFrame()

		local MainFrame = _G.WhereLootFrame
		-- v 1.8 children: 5 Buttons, 6 Frames and 1 Button
			-- themeBtn
			-- vaultBtn
			-- chartBtn
			-- wishlistBtn
			-- closeBtn
			-- dragArea
			-- specBar
				-- classBtn
			-- dropdown
			-- statBar
			-- slotBar
			-- content
			-- resizeHandle

		local contentFrame = aObj:getChild(MainFrame, 11)

		aObj:SecureHookScript(MainFrame, "OnShow", function(this)
			local themeBtn = aObj:getChild(this, 1)
			local vaultBtn = aObj:getChild(this, 2)
			local chartBtn = aObj:getChild(this, 3)
			local wishlistBtn = aObj:getChild(this, 4)
			local closeBtn = aObj:getChild(this, 5)
			local specBar = aObj:getChild(this, 7)
			local statBar = aObj:getChild(this, 9)

			aObj:keepFontStrings(statBar)

			aObj:skinObject("frame", {obj=this, kfs=true, ofs=0, clr="gold"})
			if aObj.modBtns then
				skinBtn(vaultBtn)
				skinBtn(chartBtn)
				skinBtn(wishlistBtn)
				aObj:skinCloseButton{obj=closeBtn, noSkin=true}
				for idx, btn in _G.ipairs{specBar:GetChildren()} do
					if idx ~= 5 then
						skinBtn(btn)
					end
				end
			end
			local classBtn =aObj:getChild(specBar, 5)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=themeBtn, clr="grey"}
				aObj:removeBackdrop(classBtn)
				classBtn:SetSize(30, 30)
				classBtn.icon:SetSize(30, 30)
				aObj:addButtonBorder{obj=classBtn, clr="gold"}
			end

			aObj:SecureHookScript(_G.WhereLootClassDropdown, "OnShow", function(fObj)
				aObj:skinObject("frame", {obj=fObj, kfs=true, ofs=0, clr="gold"})

				aObj:Unhook(fObj, "OnShow")
			end)

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

			aObj:SecureHookScript(wishlistBtn, "OnClick", function(_)
				aObj:SecureHookScript(_G.WhereLootWishlistPopout, "OnShow", function(fObj)
					aObj:skinObject("frame", {obj=fObj, kfs=true, ofs=0, clr="gold"})

					aObj:Unhook(fObj, "OnShow")
				end)
				aObj:checkShown(_G.WhereLootWishlistPopout)

			end)

			-- NO need to skin WhereLootWishlistTracker

			aObj:Unhook(MainFrame, "OnShow")
		end)
		aObj:checkShown(MainFrame)

		local SlotSelectFrame = aObj:getChild(contentFrame, 1)
		aObj:SecureHookScript(SlotSelectFrame, "OnShow", function(this)
			if aObj.modBtns then
				for _, btn in _G.ipairs{this:GetChildren()} do
					skinBtn(btn, 0)
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
