local aName, aObj = ...
if not aObj:isAddonEnabled("MacroToolkit") then return end
local _G = _G

function aObj:MacroToolkit()

	self:skinTabs{obj=_G.MacroToolkitFrame, ignore=true, up=true, lod=true, x1=-2, y1=-6, x2=2, y2=-7}
	self:skinSlider{obj=_G.MacroToolkitButtonScroll.ScrollBar, rt="ARTWORK"}
	self:addSkinFrame{obj=_G.MacroToolkitButtonScroll, ofs=6, x2=27} -- add skin frame around buttons scroll frame

	self:skinButton{obj=_G.MacroToolkitCustom}
	self:skinButton{obj=_G.MacroToolkitAddScript}
	self:skinButton{obj=_G.MacroToolkitAddSlot}
	self:skinButton{obj=_G.MacroToolkitBackup}

	self:applySkin{obj=_G.MacroToolkitTextBg}
	self:skinSlider{obj=_G.MacroToolkitScrollFrame.ScrollBar}

	self:applySkin{obj=_G.MacroToolkitErrorBg}
	self:skinSlider{obj=_G.MacroToolkitErrorScrollFrame.ScrollBar}

	self:addSkinFrame{obj=_G.MacroToolkitFrame, kfs=true, ri=true, ofs=1, y1=2, y2=-2}

	if self.modBtnBs then
		self:addButtonBorder{obj=_G.MacroToolkitCopyButton, ofs=-2, y1=-3, x2=-3}
		self:addButtonBorder{obj=_G.MacroToolkitFlyout, ofs=-2, y1=-3, x2=-3}
		_G.MacroToolkitSelMacroButton:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=_G.MacroToolkitSelMacroButton}
		local btn
		for i = 1, _G.max(_G.MAX_ACCOUNT_MACROS, _G.MAX_CHARACTER_MACROS) do
			btn = _G["MacroToolkitButton" .. i]
			btn:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=btn, y2=-3}
		end
		btn = nil
	end

	-- hook these to skin frames created on demand
	self:SecureHook(_G.MacroToolkit, "CreateSharePopup", function(this)
		self:skinEditBox{obj=_G.MacroToolkitShareEdit, regs={6}} -- 6 is text
		self:addSkinFrame{obj=_G.MacroToolkitSharePopup}
		self:Unhook(this, "CreateSharePopup")
	end)
	self:SecureHook(_G.MacroToolkit, "CreateBindingFrame", function(this)
		self:addSkinFrame{obj=_G.MacroToolkitBindingFrame}
		self:Unhook(this, "CreateBindingFrame")
	end)
	self:SecureHook(_G.MacroToolkit, "CreateRestoreFrame", function(this)
		self:addSkinFrame{obj=_G.MacroToolkitRestoreFrame, kfs=true}
		self:Unhook(this, "CreateRestoreFrame")
	end)
	self:SecureHook(_G.MacroToolkit, "CreateBuilderFrame", function(this)
		self:addSkinFrame{obj=_G.MacroToolkitBuilderFrame, kfs=true, ri=true, ofs=1, y1=2, y2=-2}
		self:Unhook(this, "CreateBuilderFrame")
	end)
	self:SecureHook(_G.MacroToolkit, "CreateScriptFrame", function(this)
		self:applySkin{obj=_G.MacroToolkitScriptScrollBg}
		self:skinSlider{obj=_G.MacroToolkitScriptScroll.ScrollBar}
		self:applySkin{obj=_G.MacroToolkitScriptErrorBg}
		self:skinSlider{obj=_G.MacroToolkitScriptErrors.ScrollBar}
		self:addSkinFrame{obj=_G.MacroToolkitScriptFrame, kfs=true, ri=true, ofs=1, y1=2, y2=-2}
		self:Unhook(this, "CreateScriptFrame")
	end)
	self:SecureHook(_G.MacroToolkit, "CreateMTPopup", function(this)
		self:skinEditBox{obj=_G.MacroToolkitPopupEdit, regs={6}} -- 6 is text
		self:skinSlider{obj=_G.MacroToolkitPopupIcons.scrollFrame.ScrollBar}
		self:skinEditBox{obj=_G.MacroToolkitSearchBox, regs={6}, noHeight=true} -- 6 is text
		self:addSkinFrame{obj=_G.MacroToolkitPopup, kfs=true}
		if self.modBtnBs then
			local function skinBtns(cnt)
				local btn
				for i = cnt == 36 and 1 or 37, cnt do
					btn = _G["MTAISButton" .. i]
					btn:DisableDrawLayer("BACKGROUND")
					aObj:addButtonBorder{obj=btn, x1=-3, y2=-3}
				end
				btn = nil
			end
			self:SecureHookScript(_G.MacroToolkitPopupIcons.internalFrame, "OnSizeChanged", function(this)
				skinBtns(#_G.MacroToolkitPopupIcons.icons)
				if #_G.MacroToolkitPopupIcons.icons == 110 then
					self:Unhook(this, "OnSizeChanged")
				end
			end)
		end
		self:Unhook(this, "CreateMTPopup")
	end)
	self:SecureHook(_G.MacroToolkit, "CreateCopyFrame", function(this)
		self:applySkin{obj=_G.MacroToolkitCTextBg}
		self:skinSlider{obj=_G.MacroToolkitCScrollFrame.ScrollBar}
		self:addSkinFrame{obj=_G.MacroToolkitCopyFrame, kfs=true, ri=true, ofs=1, y1=2, y2=-2}
		if self.modBtnBs then
			_G.MacroToolkitCSelMacroButton:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=_G.MacroToolkitCSelMacroButton}
			local btn
			for i = 1, _G.MAX_CHARACTER_MACROS do
				btn = _G["MacroToolkitCButton" .. i]
				btn:DisableDrawLayer("BACKGROUND")
				self:addButtonBorder{obj=btn, y2=-3}
			end
			btn = nil
		end
		self:Unhook(this, "CreateCopyFrame")
	end)

end
