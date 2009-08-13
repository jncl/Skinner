
function Skinner:_NPCScan()

	self:skinDropDown{obj=_NPCScanConfigSoundDropdown}
	
-->>-- Search Frame
	self:skinEditBox{obj=_NPCScanSearchName, regs={9}}
	self:skinEditBox{obj=_NPCScanSearchID, regs={9}}
	
	-- hook this to skin slider
	local function hookAndSkin()

		local obj = _NPCScan.Config.Search.Table.View
		if not self:getChild(obj, 2) then -- if not already created
			self:SecureHookScript(obj, "OnScrollRangeChanged", function(this)
				self:Debug("OnScrollRangeChanged: [%s, %s]", this, nil)
				self:ShowInfo(this, true, true)
				self:skinSlider(self:getChild(this, 2))
				self:Unhook(obj, "OnScrollRangeChanged")
			end)
		else
			self:skinSlider(self:getChild(obj, 2))
		end

	end
	if not _NPCScan.Config.Search.Table then
		self:SecureHookScript(_NPCScan.Config.Search, "OnShow", function(this)
			hookAndSkin()
			self:Unhook(_NPCScan.Config.Search, "OnShow")
		end)
	else
		hookAndSkin()
	end

end
