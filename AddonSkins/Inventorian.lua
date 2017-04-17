local aName, aObj = ...
if not aObj:isAddonEnabled("Inventorian") then return end
local _G = _G

function aObj:Inventorian()

	local Inventorian = _G.LibStub("AceAddon-3.0"):GetAddon("Inventorian", true)

	local function skinFrame(frame)

		aObj:skinEditBox{obj=frame.SearchBox, regs={1, 6, 7}, mi=true}
		aObj:addButtonBorder{obj=frame.SortButton}
		-- N.B. item is named incorrectly
		_G[frame:GetName()].BagToggle = aObj:getChild(frame, 8)
		aObj:addButtonBorder{obj=frame.BagToggle, relTo=frame.BagToggle.Icon}
		frame.BagToggle.Border:SetTexture(nil)
		aObj:addSkinFrame{obj=frame, kfs=true, ri=true, ofs=2, y1=3, y2=-3}
		-- Bags
		if #frame.bagButtons == 0 then
			-- hook this when no buttons have been created yet
			aObj:SecureHook(frame, "UpdateBags", function(this)
				if #this.bagButtons > 0 then
					for _, bag in pairs(this.bagButtons) do
						aObj:addButtonBorder{obj=bag}
					end
					aObj:Unhook(this, "UpdateBags")
				end
			end)
		else
			for _, bag in pairs(frame.bagButtons) do
				aObj:addButtonBorder{obj=bag}
			end
		end
		frame = nil
	end

	-- BagFrame
	skinFrame(Inventorian.bag)

	-- BankFrame
	skinFrame(Inventorian.bank)
	self:skinTabs{obj=Inventorian.bank, lod=true}

	-- hook this to handle item border changes
	self:SecureHook("SetItemButtonTextureVertexColor", function(btn, r, g, b)
		if btn:IsObjectType("Button")
		and btn.sbb
		then
			btn.sbb:SetBackdropBorderColor(self.bbColour[1], self.bbColour[2], self.bbColour[3], self.bbColour[4])
		end
	end)

end
