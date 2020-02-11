local _, aObj = ...
if not aObj:isAddonEnabled("Scrap") then return end
local _G = _G

aObj.lodAddons.Scrap_Merchant = function(self) -- v 8.3.0

	if self.modBtnBs then
		-- wait for button to be created
		_G.C_Timer.After(0.2, function()
			_G.Scrap.Merchant.border:SetTexture(nil)
			self:addButtonBorder{obj=_G.Scrap.Merchant, clr="grey", ofs=0}
		end)
	end

	self:SecureHookScript(_G.ScrapVisualizer, "OnShow", function(this)
		self:skinTabs{obj=this, regs={7, 8}, ignore=true, up=true, lod=true, y1=-3, y2=-3}
		self:skinSlider{obj=_G.ScrapVisualizerScrollBar, size=3}
		self:removeNineSlice(this.NineSlice)
		self:addSkinFrame{obj=this, ft="a", kfs=true, ri=true, noBdr=true}
		if self.modBtns then
			self:skinStdButton{obj=this.Button}
		end

		self:Unhook(this, "OnShow")
	end)

	if _G.Scrap.Tutorials then
		local frame = _G.LibStub:GetLibrary("CustomTutorials-2.1", true).frames[_G.Scrap.Tutorials]
		if frame then
			self:addSkinFrame{obj=frame, ft="a", kfs=true, ri=true}
			if self.modBtnBs then
				self:addButtonBorder{obj=frame.prev, ofs=-2, x1=1, clr=frame.prev:IsEnabled() and "gold" or "disabled"}
				self:addButtonBorder{obj=frame.next, ofs=-2, x1=1, clr=frame.next:IsEnabled() and "gold" or "disabled"}
				local function clrBtnBdr()
					local ppb, npb = frame.prev,frame.next
					aObj:clrBtnBdr(ppb, ppb:IsEnabled() and "gold" or "disabled", 1)
					aObj:clrBtnBdr(npb, npb:IsEnabled() and "gold" or "disabled", 1)
					ppb, npb = nil, nil
				end
				self:SecureHookScript(frame.prev, "OnClick", function(this)
					clrBtnBdr()
				end)
				self:SecureHookScript(frame.next, "OnClick", function(this)
					clrBtnBdr()
				end)
			end
		end
	end

end
