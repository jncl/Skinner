-- This is a Library

function Skinner:Waterfall()
	if self.initialized.Waterfall then return end
	self.initialized.Waterfall = true

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

	local checkTex
	if self.modBtns then
		function checkTex(btn)

			if not btn.skin then
				Skinner:skinButton{obj=btn, mp2=true, as=true}
			end

			Skinner:checkTex{obj=btn, mp2=true}

			local btnText = btn:GetFontString()
			if btn.obj.disabled then
				btnText:SetTextColor(0.5, 0.5, 0.5) -- grey
			else
				btnText:SetTextColor(1, 0.82, 0) -- yellow
			end

		end
	end
	local function skinWaterfall(frame)

		if not Skinner.skinned[frame] then
			-- Main Frame
			frame.titlebar:Hide()
			frame.titlebar2:Hide()
			Skinner:skinButton{obj=frame.closebutton, cb=true}
			Skinner:applySkin(frame.frame)
			Skinner:applySkin(frame.treeview.frame)
			-- Treeview Frame
			Skinner:skinSlider{obj=frame.treeview.scrollbar}
			if self.modBtns then
				-- skin minus/plus buttons
				for i = 1, #frame.treeview.scrollchild.lines do
					checkTex(frame.treeview.scrollchild.lines[i].expand)
				end
				-- hook refresh function to handle minus/plus buttons
				Skinner:SecureHook(frame.treeview, "Refresh", function(this, noupdate)
					for i = 1, #this.scrollchild.lines do
						checkTex(this.scrollchild.lines[i].expand)
					end
				end)
			end
			-- Mainpane Frame
			-- hook this to skin the controls
			Skinner:SecureHook(frame.mainpane, "DoLayout", function(this)
				skinControls(this)
			end)
			skinControls(frame.mainpane)
			Skinner:skinSlider{obj=frame.mainpane.scrollbar}
			Skinner:applySkin(frame.mainpane.frame)
		end

	end

	self:SecureHook(LibStub("Waterfall-1.0", true), "Open", function(this, pane)
		skinWaterfall(this.registry[pane].frame)
	end)

end
