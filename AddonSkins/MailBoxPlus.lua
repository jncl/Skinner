local _, aObj = ...
if not aObj:isAddonEnabled("MailBoxPlus")
and not aObj:isAddonEnabled("MailBoxPlusMOP")
and not aObj:isAddonEnabled("MailBoxPlusTBC")
then
	return
end
local _G = _G

local function skinMBP()
	if aObj.modBtnBs then
		aObj:addButtonBorder{obj=_G.MBP_SettingsButton, ofs=0}
	end

	local function checkMod(name, mod)
		if name == "OpenAll" then
			if aObj.modBtns then
				 aObj:skinStdButton{obj=_G.MBP_OpenAllButton}
			end
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=_G.MBP_OpenAllMenuBtn, ofs=-2}
			end
		elseif name == "BulkSelect" then
			if aObj.modBtns then
				aObj:skinStdButton{obj=_G.MBP_SelectOpenBtn}
				aObj:skinStdButton{obj=_G.MBP_SelectReturnBtn}
			end
			if aObj.modChkBtns then
				for i = 1, 7 do
					aObj:skinCheckButton{obj=_G["MBP_InboxCB" .. i]}
				end
			end
		elseif name == "AddressBook" then
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=_G.MBP_AddressBookBtn, ofs=0}
			end
			aObj:SecureHook(mod, "HandleAutoComplete", function(this, editbox)
				aObj:SecureHookScript(_G.MBP_ACDropdown, "OnShow", function(this)
					if _G.InCombatLockdown() then
						aObj:add2Table(aObj.oocTab, {aObj.checkShown, {aObj, this}})
						return
					end

					aObj:skinObject("frame", {obj=this, kfs=true, ofs=0})

					aObj:Unhook(this, "OnShow")
				end)
				aObj:checkShown(_G.MBP_ACDropdown)

				aObj:Unhook(this, "HandleAutoComplete")
			end)
		-- QuickSend
		-- EnhancedUI
		elseif name == "CarbonCopy" then
			aObj:add2Table(aObj.createFrames, {func = function(fObj)
			    _G.RunNextFrame(function()
					aObj:SecureHookScript(fObj, "OnShow", function(frame)
						if _G.InCombatLockdown() then
							aObj:add2Table(aObj.oocTab, {aObj.checkShown, {aObj, frame}})
							return
						end

						aObj:skinObject("slider", {obj=_G.MBP_CopyScrollFrameScrollBar})
						aObj:skinObject("frame", {obj=fObj, kfs=true, ofs=-2})
						if aObj.modBtns then
							aObj:skinCloseButton{obj=aObj:getChild(fObj, 1)}
						end

						aObj:Unhook(frame, "OnShow")
					end)
					aObj:checkShown(fObj)
			    end)
			end}, "MBP_CopyFrame")
		-- DoNotWant
		elseif name == "Forward" then
			if aObj.modBtns then
				aObj:skinStdButton{obj=_G.MBP_ForwardButton, schk=true}
			end
		-- QuickAttach
		-- Rake
		-- TradeBlock
		elseif name == "MailBag" then
			aObj:SecureHookScript(_G.MBP_MailBagFrame, "OnShow", function(this)
				if _G.InCombatLockdown() then
					aObj:add2Table(aObj.oocTab, {aObj.checkShown, {aObj, this}})
					return
				end

				aObj:keepFontStrings(this)
				aObj:skinObject("editbox", {obj=_G.MBP_MailBagSearch})
				if aObj.modChkBtns then
					aObj:skinCheckButton{obj=_G.MBP_MailBagGroupStacks}
				end

				aObj:Unhook(this, "OnShow")
			end)
			aObj:checkShown(_G.MBP_MailBagFrame)
		elseif name == "InboxBar" then
			aObj:SecureHookScript(_G.MBP_InboxBarContainer, "OnShow", function(this)
				if _G.InCombatLockdown() then
					aObj:add2Table(aObj.oocTab, {aObj.checkShown, {aObj, this}})
					return
				end

				aObj:skinObject("frame", {obj=this, kfs=true, x1=-3, y2=2})
				if aObj.modBtns then
					-- N.B. keys from FILTER_DEFS table
					for _, key in _G.pairs{"sold", "bought", "cancelled", "expired", "other"} do
						aObj:skinStdButton{obj=_G["MBP_FilterBtn_" .. key], sechk=true}
					end
				end

				aObj:Unhook(this, "OnShow")
			end)
			aObj:checkShown(_G.MBP_InboxBarContainer)
		end
	end

	for name, mod in _G.pairs(_G["MailBoxPlus"].modules) do
		if not mod.enabled then
			aObj:SecureHook(mod, "OnEnable", function(this)
					checkMod(this.name, this)
				aObj:Unhook(this, "OnEnable")
			end)
		else
			checkMod(name, mod)
		end
	end
end

if aObj:isAddonEnabled("MailBoxPlus") then
	aObj.addonsToSkin.MailBoxPlus = function(_) -- v 1.7.0

		skinMBP()

	end
elseif aObj:isAddonEnabled("MailBoxPlusMOP") then
	aObj.addonsToSkin.MailBoxPlusMOP = function(_) -- v 1.1.0

		skinMBP()

	end
else
	aObj.addonsToSkin.MailBoxPlusTBC = function(_) -- v 1.3.6

		skinMBP()

	end
end
