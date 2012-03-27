local aName, aObj = ...
if not aObj:isAddonEnabled("_NPCScan") then return end

function Skinner:_NPCScan()

-->>-- NPC Alert Button
	self:getRegion(_NPCScanButton, 4):SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_NPCScanButton, kfs=true}
	_NPCScanButton.SetBackdropBorderColor = function() end

-->>-- Config settings
	self:skinDropDown{obj=_NPCScanConfigSoundDropdown, x2=-6}
	self:addSkinFrame{obj=_NPCScanConfigAlert}

-->>-- Search Frame
	self:skinEditBox{obj=_NPCScanSearchNpcName, regs={9}}
	self:skinEditBox{obj=_NPCScanSearchNpcID, regs={9}}
	self:skinEditBox{obj=_NPCScanSearchNpcWorld, regs={9}}
	self:addSkinFrame{obj=_NPCScan.Config.Search.TableContainer, ofs=4}

	--hook this to skin slider
	local function hookAndSkin()

		local obj = _NPCScan.Config.Search.Table.View
		if not self:getChild(obj, 2) then -- if not already created
			self:SecureHookScript(obj, "OnScrollRangeChanged", function(this)
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
