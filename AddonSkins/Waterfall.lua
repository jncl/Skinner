
function Skinner:Waterfall()

	local waterfallsSkinned = {}

	local function skinWaterfall(frame)

		local function skinControls(frame)

			for _, v in pairs(frame.controls) do
				if v.class == WaterfallTextBox and not v.skinned then
					Skinner:skinEditBox(v.frame, {9})
					v.skinned = true
				end
				if v.class == WaterfallDropdown and not v.skinned then
					if v.editbox then Skinner:skinEditBox(v.editbox, {9}) end
					if v.pullout then Skinner:applySkin(v.pullout)	end
					v.skinned = true
				end
			end

		end

		if not waterfallsSkinned[frame] then
			-- Main Frame
			frame.titlebar:Hide()
			frame.titlebar2:Hide()
			Skinner:applySkin(frame.frame)
			-- Treeview Frame
			local scrollframe = Skinner:getChild(frame.treeview.frame, 1)
			local scrollbar = Skinner:getChild(scrollframe, 2)
			Skinner:skinScrollBar(scrollframe, nil, scrollbar)
			Skinner:applySkin(frame.treeview.frame)
			-- Mainpane Frame
			-- hook this to skin the TextBox & Dropdown controls
			Skinner:SecureHook(frame.mainpane, "DoLayout", function(this)
--				Skinner:Debug("wfmp_dl")
				skinControls(frame.mainpane)
			end)
			scrollframe = Skinner:getChild(frame.mainpane.frame, 1)
			scrollbar = Skinner:getChild(scrollframe, 2)
			Skinner:skinScrollBar(scrollframe, nil, scrollbar)
			Skinner:getRegion(frame.mainpane.frame, 11):Hide()
			Skinner:getRegion(frame.mainpane.frame, 12):Hide()
			Skinner:applySkin(frame.mainpane.frame)
			waterfallsSkinned[frame] = true
		end

	end

	self:SecureHook(AceLibrary("Waterfall-1.0"), "Open", function(id, pane)
-- 		self:Debug("WaterfallOpen: [%s, %s]", id, pane)
		local wfinfo = AceLibrary("Waterfall-1.0").registry[pane]
		skinWaterfall(wfinfo.frame)
	end)

end
