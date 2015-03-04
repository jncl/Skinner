local aName, aObj = ...
if not aObj:isAddonEnabled("Bagnon") then return end
local _G = _G

function aObj:Bagnon(LoD) -- 6.1.3
	if not self.db.profile.ContainerFrames or self.initialized.Bagnon then return end
	self.initialized.Bagnon = true

	local Bagnon = _G.Bagnon
	-- hide empty slot background
	Bagnon.sets['emptySlots'] = false
	-- skin the bag frames
	local function skinFrame(frame)
		aObj:addSkinFrame{obj=frame}
		frame.SetBackdropColor = function() end
		frame.SetBackdropBorderColor = function() end
		if not aObj:IsHooked(frame, "OnShow") then
			aObj:SecureHookScript(frame, "OnShow", function(this)
				if aObj.modBtnBs then
					for i = 1, #this.menuButtons do
						aObj:addButtonBorder{obj=this.menuButtons[i], ofs=3}
					end
					-- bag/tab buttons
					if this.bagFrame then
						local kids = {this.bagFrame:GetChildren()}
						for _, child in _G.ipairs(kids) do
							if child:IsObjectType("CheckButton") then
								aObj:addButtonBorder{obj=child, ofs=3}
							end
						end
						kids = nil
					end
					if this:HasOptionsToggle() then
						aObj:addButtonBorder{obj=this.optionsToggle, ofs=3}
					end
					if this:HasBrokerDisplay() then
						aObj:addButtonBorder{obj=this.brokerDisplay, relTo=this.brokerDisplay.icon, ofs=3}
					end
					-- VoidStorage Transfer button
					if this:HasMoneyFrame()
					and this.moneyFrame.icon
					then
						aObj:addButtonBorder{obj=this.moneyFrame.icon:GetParent(), relTo=this.moneyFrame.icon, ofs=3}
					end
				end
				if this.closeButton then aObj:skinButton{obj=this.closeButton, cb=true} end
				aObj:Unhook(frame, "OnShow")
			end)
		end
	end
	-- prevent gradient whiteout
	self:RawHook(Bagnon["Frame"], "FadeInFrame", function(this, frame, alpha)
		frame:Show()
	end)
	-- skin the Search EditBox
	self:RawHook(Bagnon["SearchFrame"], "New", function(this, ...)
		local eb = self.hooks[Bagnon["SearchFrame"]].New(this, ...)
		self:skinEditBox{obj=eb, regs={9}}
		return eb
	end)
	-- skin frames
	skinFrame(Bagnon.frames["inventory"])
	-- hook this to skin new frames
	self:RawHook(Bagnon["Frame"], "New", function(this, id)
		local frame = self.hooks[Bagnon["Frame"]].New(this, id)
		skinFrame(frame)
		return frame
	end)

end

-- Bagnon_Config: Sushi objects are managed in IOP checkKids function
-- Bagnon_GuildBank frame handled in above skinFrame function
-- Bagnon_VoidStorage frame handled in above skinFrame function
