local aName, aObj = ...
if not aObj:isAddonEnabled("ProspectBar") then return end

function aObj:ProspectBar()

	self:skinButton{obj=ProspectBarToggle}
	-- skin buttons, if required
	if self.modBtnBs then
		self:SecureHook("SetItemButtonCount", function(btn, cnt)
			for bag, data in pairs(ProspectBar.buttons) do
				for slot, info in pairs(data) do
					if not info.button.sbb then
						self:addButtonBorder{obj=info.button, ibt=true, sec=true}
					end
				end
			end
		end)
	end

end
