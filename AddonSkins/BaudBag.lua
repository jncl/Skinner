local aName, aObj = ...
if not aObj:isAddonEnabled("BaudBag") then return end

function aObj:BaudBag()
	if not self.db.profile.ContainerFrames.skin then return end

	-- hook this to skin the bag frames
	self:SecureHook("BaudBagUpdateContainer", function(Container)
		local frame = Container:GetName()
		_G[frame.."BackdropTextures"]:Hide()
		if not self.skinned[Container] then
			self:skinButton{obj=_G[frame.."MenuButton"], mp=true, plus=true}
			self:skinAllButtons{obj=Container}
			self:addSkinFrame{obj=_G[frame.."Backdrop"], nb=true}
			-- hook this to skin the Search Frame
			self:SecureHookScript(_G[frame.."SearchButton"], "OnClick", function(this, ...)
				if not aObj.skinned[BaudBagSearchFrame] then
					self:skinEditBox{obj=BaudBagSearchFrameEditBox, regs={9}, noHeight=true}
					self:adjHeight{obj=BaudBagSearchFrameEditBox, adj=10}
					self:skinButton{obj=BaudBagSearchFrameCloseButton, cb=true}
					self:addSkinFrame{obj=BaudBagSearchFrameBackdrop, y1=1, y2=25}
				end
				BaudBagSearchFrameEditBox:SetPoint("TOPLEFT", -3, 23)
				self:keepFontStrings(BaudBagSearchFrameBackdropTextures)
			end)
		end
	end)
	self:skinDropDown{obj=BaudBagContainerDropDown, x2=-10}
	self:addSkinFrame{obj=BaudBagContainer1_1BagsFrame}
	self:addSkinFrame{obj=BaudBagContainer2_1BagsFrame}

-->>-- Options Frame
	self:skinDropDown{obj=BaudBagOptionsSetDropDown, x2=-10}
	self:skinEditBox(BaudBagOptionsNameEditBox, {9})
	self:skinDropDown{obj=BaudBagOptionsBackgroundDropDown, x2=-10}

end
