local _, aObj = ...
if not aObj:isAddonEnabled("BuffomatClassic") then return end
local _G = _G

aObj.addonsToSkin.BuffomatClassic = function(self) -- v 2021.4.1-ab922375

	self:SecureHookScript(_G.BomC_MainWindow, "OnShow", function(this)
		self:skinObject("slider", {obj=_G.BomC_SpellTab_Scroll.ScrollBar})
		self:skinObject("tabs", {obj=this, tabs=this.Tabs, lod=self.isTT and true, ignoreHLTex=false, offsets={x1=7, y1=self.isTT and 2 or 0, x2=-6, y2=self.isTT and 4 or 2}})
		self:skinObject("frame", {obj=this, kfs=true, ofs=0})
		if self.modBtns then
			_G.BomC_MainWindow_CloseButton:SetSize(27, 27)
			self:skinCloseButton{obj=_G.BomC_MainWindow_CloseButton}
			_G.BomC_MainWindow_SettingsButton:SetSize(20, 20)
			self:skinStdButton{obj=_G.BomC_MainWindow_SettingsButton}
			_G.BomC_MainWindow_MacroButton:SetSize(40, 20)
			self:skinStdButton{obj=_G.BomC_MainWindow_MacroButton}
			self:skinStdButton{obj=_G.BomC_ListTab_Button, sec=true}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.BomC_MainWindow)

	-- Options panels
	self.RegisterCallback("BuffomatClassic", "IOFPanel_Before_Skinning", function(this, panel)
		if self:hasTextInDebugNameRE(panel, "O_OptionFrame") then
			local sFrame = _G[panel:GetDebugName() .. "Scroll"]
			self:skinObject("slider", {obj=sFrame.ScrollBar})
			for _, child in _G.ipairs{sFrame:GetScrollChild():GetChildren()} do
				if child:IsObjectType("CheckButton") then
					if self.modChkBtns then
						self:skinCheckButton{obj=child}
					end
				elseif child:IsObjectType("EditBox") then
					self:skinObject("editbox", {obj=child})
				elseif child:IsObjectType("Button") then
					if self.modBtns then
						self:skinStdButton{obj=child}
					end
				end
			end
			sFrame = nil
		end
	end)

end
