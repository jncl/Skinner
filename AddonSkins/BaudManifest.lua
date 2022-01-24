local _, aObj = ...
if not aObj:isAddonEnabled("BaudManifest") then return end
local _G = _G

aObj.addonsToSkin.BaudManifest = function(self) -- v 2.64

	local function skinFrame(fObj)
		aObj:skinObject("editbox", {obj=fObj.FilterEdit})
		aObj:skinObject("dropdown", {obj=fObj.SortDrop})
		aObj:skinObject("dropdown", {obj=fObj.FilterDrop})
		aObj:skinObject("slider", {obj=fObj.ScrollBar.ScrollBar})
		aObj:skinObject("frame", {obj=fObj, kfs=true, cb=true})
		-- $parentOptionsButton
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=fObj.Reset, x1=6, y1=-3, x2=-4, y2=7}
			if fObj.BagsButton then
				aObj:addButtonBorder{obj=fObj.BagsButton, ofs=0, clr="gold"}
			end
		end
	end
	-- Bags
	self:SecureHookScript(_G.BaudManifestDisplay1, "OnShow", function(this)
		skinFrame(this)
		self:skinObject("frame", {obj=this.BagsFrame})

		self:Unhook(this, "OnShow")
	end)
	-- Bank
	self:SecureHookScript(_G.BaudManifestDisplay2, "OnShow", function(this)
		skinFrame(this)
		self:skinObject("frame", {obj=this.BagsFrame})
		if self.modBtns then
			self:skinStdButton{obj=_G.BaudManifestBankSlotPurchaseButton}
		end

		self:Unhook(this, "OnShow")
	end)
	-- Reagent Bank
	self:SecureHookScript(_G.BaudManifestDisplay3, "OnShow", function(this)
		skinFrame(this)

		self:Unhook(this, "OnShow")
	end)
	-- Selected Character Bags
	self:SecureHookScript(_G.BaudManifestDisplay4, "OnShow", function(this)
		skinFrame(this)

		self:Unhook(this, "OnShow")
	end)
	-- Selected Character Bank
	self:SecureHookScript(_G.BaudManifestDisplay5, "OnShow", function(this)
		skinFrame(this)

		self:Unhook(this, "OnShow")
	end)

	-- hook this to skin expand buttons
	self:SecureHook("BaudManifestDisplay_OnSizeChanged", function(frame)
		for _, btn in _G.pairs(frame.Entry) do
			self:skinExpandButton{obj=btn, noddl=true, onSB=true, plus=true}
		end
		_G.BaudManifestScrollBar_Update(frame)
	end)

	self:SecureHookScript(_G.BaudManifestCharacters, "OnShow", function(this)
		local fName = this:GetName()
		self:skinObject("frame", {obj=_G[fName .. "ScrollBox"], kfs=true, fb=true})
		self:skinObject("frame", {obj=this, kfs=true, cb=true})
		if self.modBtns then
			self:skinStdButton{obj=_G[fName .. "Close"]}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BaudManifestProperties, "OnShow", function(this)
		local fName = this:GetName()
		self:skinObject("editbox", {obj=_G[fName .. "EditBox1"]})
		self:skinObject("editbox", {obj=_G[fName .. "EditBox2"]})
		self:skinObject("frame", {obj=_G[fName .. "Restock"], kfs=true, fb=true})
		self:skinObject("frame", {obj=this, kfs=true, hdr=true, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=_G[fName .. "Okay"]}
		end
		if self.modChkBtns then
			for i = 1, 5 do
				self:skinCheckButton{obj=_G[fName .. "Check" .. i]}
			end
		end

		self:Unhook(this, "OnShow")
	end)

	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.BaudManifestTooltip)
	end)

end
