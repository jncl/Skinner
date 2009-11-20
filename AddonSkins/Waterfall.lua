
function Skinner:Waterfall()

	local function skinWaterfall(frame)

		local function skinControls(frame)

			for _, obj in pairs(frame.controls) do
				if obj.class == WaterfallTextBox and not Skinner.skinned[obj] then
					Skinner:skinEditBox(obj.frame, {9})
				elseif obj.class == WaterfallDropdown and not Skinner.skinned[obj] then
					if obj.editbox then Skinner:skinEditBox(obj.editbox, {9}) end
					if obj.pullout then Skinner:applySkin(obj.pullout)	end
				elseif obj.class == WaterfallButton and not Skinner.skinned[obj] then
					Skinner:skinButton{obj=obj.frame, as=true} -- just skin it otherwise text is hidden
				end
			end

		end

		local function checkTex(btn)

			local nTex = btn:GetNormalTexture() and btn:GetNormalTexture():GetTexture() or nil
--			Skinner:Debug("checkTex: [%s, %s, %s]", btn.skin, btn.obj.id, nTex)
			if not btn.skin then Skinner:skinButton{obj=btn, mp3=true} end -- add skin if required

			if btn:GetNormalTexture() then btn:GetNormalTexture():SetAlpha(0) end
			if btn:GetPushedTexture() then btn:GetPushedTexture():SetAlpha(0) end
			if btn:GetDisabledTexture() then btn:GetDisabledTexture():SetAlpha(0) end

			if nTex then
				btn:Show()
				if nTex:find("MinusButton") then
					btn:SetText(Skinner.minus)
				elseif nTex:find("PlusButton") then
					btn:SetText(Skinner.plus)
				end
				local btnText = btn:GetFontString()
				if btn.obj.disabled then
					btnText:SetTextColor(0.5, 0.5, 0.5) -- grey
				else
					btnText:SetTextColor(1, 0.82, 0) -- yellow
				end
			else -- not an expandable line
				btn:SetText("")
				btn:Hide()
			end

		end
		if not Skinner.skinned[frame] then
			-- Main Frame
			frame.titlebar:Hide()
			frame.titlebar2:Hide()
			Skinner:skinButton{obj=frame.closebutton, cb=true}
			Skinner:applySkin(frame.frame)
			-- Treeview Frame
			Skinner:skinSlider{obj=frame.treeview.scrollbar}
			-- skin minus/plus buttons
			for i = 1, #frame.treeview.scrollchild.lines do
				checkTex(frame.treeview.scrollchild.lines[i].expand)
			end
			Skinner:applySkin(frame.treeview.frame)
			-- hook refresh function to handle minus/plus buttons
			Skinner:SecureHook(frame.treeview, "Refresh", function(this, noupdate)
--				Skinner:Debug("WTV_Refresh: [%s, %s]", this, noupdate)
				for i = 1, #this.scrollchild.lines do
					checkTex(this.scrollchild.lines[i].expand)
				end
			end)
			-- Mainpane Frame
			-- hook this to skin the controls
			Skinner:SecureHook(frame.mainpane, "DoLayout", function(this)
--				Skinner:Debug("wfmp_dl:[%s]", this)
				skinControls(this)
			end)
			skinControls(frame.mainpane)
			Skinner:skinSlider{obj=frame.mainpane.scrollbar}
			Skinner:applySkin(frame.mainpane.frame)
		end

	end

	self:SecureHook(LibStub("Waterfall-1.0", true), "Open", function(this, pane)
 		self:Debug("WaterfallOpen: [%s, %s]", this, pane)
		skinWaterfall(this.registry[pane].frame)
	end)

end
