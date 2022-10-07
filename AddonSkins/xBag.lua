local _, aObj = ...
if not aObj:isAddonEnabled("xBag") then return end
local _G = _G

aObj.addonsToSkin.xBag = function(self) -- v 1.8

	-- if xBag is loaded but not being used then leave
	if not _G.xBagPerDB.xBagLoaded then
		return
	end

	-- N.B. Bag Item button borders skinned in ContainerFrames skin

	local maxBags = 30
	local function skinBag(fObj, cb)
		aObj:keepFontStrings(fObj.Header)
		aObj:moveObject{obj=fObj.Title, y=-6}
		aObj:skinObject("frame", {obj=fObj, kfs=true, cbns=true, clr="gold"})
		if cb
		and aObj.modChkBtns
		then
			aObj:skinCheckButton{obj=fObj.AlwaysShow}
		end
	end
	local function skinMainBag(fObj)
		skinBag(fObj)
		if aObj.modBtns then
			fObj.ToggleAll:SetSize(14, 14)
			aObj:skinExpandButton{obj=fObj.ToggleAll, plus=true, clr="gold"}
		end
		if aObj.modBtnBs then
			for i = 1, maxBags do
				aObj:addButtonBorder{obj=fObj.BagSelectionButton[i], clr="grey"}
			end
			aObj:addButtonBorder{obj=fObj.SequenceUp, ofs=-1, clr="gold"}
			aObj:addButtonBorder{obj=fObj.SequenceDown, ofs=-1, clr="gold"}
			aObj:addButtonBorder{obj=fObj.Sort, clr="grey"}
			if fObj.OpenChest then
				aObj:addButtonBorder{obj=fObj.OpenChest, clr="grey"}
				aObj:addButtonBorder{obj=fObj.EmptyBags, clr="grey"}
			end
		end
		fObj.Money:DisableDrawLayer("BACKGROUND")
	end

	if self.modBtnBs then
		for i = 0, 5 do
			self:addButtonBorder{obj=_G["xBagUIBagButton" .. i], clr="grey"}
		end
	end

	self:SecureHookScript(_G.xBagHelp, "OnShow", function(this)
		self:skinObject("slider", {obj=this.ScrollBar})
		this.Close:SetSize(28, 28)
		self:skinObject("frame", {obj=this, kfs=true, cb=true, ofs=6, x2=8})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.xBagMain, "OnShow", function(this)
		skinMainBag(this)
		self:skinObject("editbox", {obj=_G.BagItemSearchBox, fType=ftype, si=true, ca=true})
		-- FIXME: workaround for UnSkin function
		_G._G.BagItemSearchBox.seb = _G.CopyTable(_G._G.BagItemSearchBox.sf)
		_G._G.BagItemSearchBox.sf = nil

		self:Unhook(this, "OnShow")
	end)

	for i = 1, maxBags do
		self:SecureHookScript(_G["xBagBag" .. i], "OnShow", function(this)
			skinBag(this, true)

			self:Unhook(this, "OnShow")
		end)
	end

	self:SecureHookScript(_G.xBagBank, "OnShow", function(this)
		skinMainBag(this)
		self:skinObject("editbox", {obj=_G.BankItemSearchBox, fType=ftype, si=true, ca=true})
		-- FIXME: workaround for UnSkin function
		_G._G.BankItemSearchBox.seb = _G.CopyTable(_G._G.BankItemSearchBox.sf)
		_G._G.BankItemSearchBox.sf = nil
		if self.modBtns then
			self:skinStdButton{obj=this.ToggleReagentBank}
		end

		self:Unhook(this, "OnShow")
	end)
	-- get bank extra bags
	local fCnt = 0
	self.RegisterCallback("xBag", "UIParent_GetChildren", function(_, child, _)
		if child.AlwaysShow
		and child.Header
		and child.Title
		and child.Close
		and child.Display
		and not child:GetName()
		then
			skinBag(child, true)
			fCnt = fCnt + 1
		end
		if fCnt == 30 then
			self:UnregisterCallback("xBag", "UIParent_GetChildren")
		end
	end)
	self:scanUIParentsChildren()

	self:SecureHookScript(_G.xBagReagent, "OnShow", function(this)
		skinBag(this)
		if self.modBtnBs then
			self:addButtonBorder{obj=this.Sort, clr="grey"}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.xBagSetBinding, "OnShow", function(this)
		this.Close:SetSize(28, 28)
		self:skinObject("frame", {obj=this, kfs=true, cb=true})
		if self.modBtns then
			for _, btn in _G.pairs(this.Edit) do
				self:skinStdButton{obj=btn}
			end
		end

		self:Unhook(this, "OnShow")
	end)

end
