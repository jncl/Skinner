local aName, aObj = ...
if not aObj:isAddonEnabled("G15Buttons") then return end

function aObj:G15Buttons()

	if self.modBtnBs then
		local function skinBtns()

			for i = 1, objG15.LastGiveId do
				local btn = _G[objG15.UIObjectPrefix..objG15.UIButtonPrefix..i]
				if btn
				and not btn.sbb
				then
					aObj:addButtonBorder{obj=btn, abt=true}
				end
			end

		end
		-- hook this to skin new buttons
		self:SecureHook(objG15, "CreateButton", function(parent)
			skinBtns()
		end)
		-- skin existing buttons
		skinBtns()
	end

	-- Options frame
	self:skinDropDown{obj=G15Buttons_OptionsForm_LBGroups, x2=110}
	self:skinEditBox{obj=G15Buttons_OptionsForm_edtSpacePerRow, regs={9}, y=-8}
	self:skinEditBox{obj=G15Buttons_OptionsForm_edtSpacePerColumn, regs={9}, y=-8}
	self:addSkinFrame{obj=G15Buttons_OptionsForm, hdr=true}

end
