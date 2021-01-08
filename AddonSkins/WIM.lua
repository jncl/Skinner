local _, aObj = ...
if not aObj:isAddonEnabled("WIM") then return end
local _G = _G

aObj.addonsToSkin.WIM = function(self) -- v 3.8.15

	local function skinWindow(msgFrame)
		msgFrame.widgets.class_icon:SetAlpha(1)
		aObj:moveObject{obj=msgFrame.widgets.class_icon, x=1, y=-6}
		aObj:skinObject("editbox", {obj=msgFrame.widgets.msg_box, ofs=0})
		aObj:skinObject("frame", {obj=msgFrame.widgets.Backdrop, kfs=true, ofs=1, y1=-2})
		if aObj.modBtns then
			aObj:skinOtherButton{obj=msgFrame.widgets.close, font=self.fontS, text="⌵"}
		end
	end
	self:RawHook(_G.WIM, "CreateWhisperWindow", function(playerName)
		local msgFrame = self.hooks[_G.WIM].CreateWhisperWindow(playerName)
		skinWindow(msgFrame)
		return msgFrame
	end, true)
	self:RawHook(_G.WIM, "CreateChatWindow", function(chatName)
		local msgFrame = self.hooks[_G.WIM].CreateChatWindow(chatName)
		skinWindow(msgFrame)
		return msgFrame
	end, true)
	self:RawHook(_G.WIM, "CreateW2WWindow", function(w2wname)
		local msgFrame = self.hooks[_G.WIM].CreateW2WWindow(w2wname)
		skinWindow(msgFrame)
		return msgFrame
	end, true)

	if _G.WIM.modules["History"]
	and _G.WIM.modules["History"].enabled
	then
		self:SecureHook(_G.WIM, "ShowHistoryViewer", function(this, ...)
			local hvFrame = _G.WIM3_HistoryFrame
			hvFrame.title:SetPoint("TOPLEFT", 50 , -7)
			hvFrame.close:SetPoint("TOPRIGHT", -4, -4)
		    hvFrame.resize:SetPoint("BOTTOMRIGHT", 0, 0)
			hvFrame.nav.border:SetTexture(nil)
			self:skinObject("dropdown", {obj=hvFrame.nav.user})
			self:skinObject("slider", {obj=hvFrame.nav.filters.scroll.ScrollBar})
			hvFrame.nav.filters.border:SetTexture(nil)
			self:skinObject("frame", {obj=hvFrame.nav.filters, fb=true})
			self:skinObject("slider", {obj=hvFrame.nav.userList.scroll.ScrollBar})
			hvFrame.nav.userList.border:SetTexture(nil)
			self:skinObject("frame", {obj=hvFrame.nav.userList, fb=true})
			hvFrame.search.bg:SetTexture(nil)
			self:keepFontStrings(hvFrame.search.text)
			self:skinObject("editbox", {obj=hvFrame.search.text, ofs=4})
			hvFrame.content.border:SetTexture(nil)
			self:skinObject("slider", {obj=hvFrame.content.textFrame.ScrollBar})
			self:skinObject("frame", {obj=hvFrame.content, fb=true})
			if self.modBtnBs then
				self:addButtonBorder{obj=hvFrame.content.chatFrame.up, ofs=-1, x1=0}
				self:addButtonBorder{obj=hvFrame.content.chatFrame.down, ofs=-1, x1=0}
				self:SecureHook(hvFrame.content.chatFrame, "update", function(this)
					self:clrBtnBdr(this.up)
					self:clrBtnBdr(this.down)
				end)
			end
			self:keepFontStrings(hvFrame.progressBar)
			self:skinObject("frame", {obj=hvFrame.progressBar})
			self:skinObject("frame", {obj=hvFrame})
			hvFrame = nil

			self:Unhook(_G.WIM, "ShowHistoryViewer")
		end)
	end

	if _G.WIM.modules["Menu"]
	and _G.WIM.modules["Menu"].enabled
	then
		self:SecureHook(_G.WIM.Menu, "Show", function(this, ...)
			for _, group in _G.pairs(this.groups) do
				group:SetBackdrop(nil)
				group.title:SetPoint("TOPLEFT", 10, -8)
				group.title:SetPoint("TOPRIGHT", -10, -8);
			end
			self:SecureHook(this, "Refresh", function(this)
				self:adjWidth{obj=this, adj=-30}
				self:adjHeight{obj=this, adj=-20}
			end)
			self:adjWidth{obj=this, adj=-30}
			self:adjHeight{obj=this, adj=-20}
			self:skinObject("frame", {obj=this})

			self:Unhook(_G.WIM.Menu, "Show")
		end)
	end

	local mFrame
	for i = 1, 10 do
		mFrame = _G["WIM3_msgFrame" .. i]
		if mFrame then
			skinWindow(mFrame)
		end
	end
	mFrame = nil

	self.mmButs["WIM"] = _G.WIM3MinimapButton

	self:checkAndRun("WIM_Options", "o")

end

aObj.otherAddons.WIM_Options = function(self) -- v 3.8.15

	local function checkKids(obj)
		if obj.sknd then
			return
		else
			obj.sknd = true
		end
		for _, child in _G.ipairs{obj:GetChildren()} do
			if aObj:isDropDown(child) then
				aObj:skinObject("dropdown", {obj=child, x2=obj.mf and 110})
			elseif child.backdrop then
				child.backdrop.top:SetColorTexture(self.bbClr:GetRGBA())
				child.backdrop.bottom:SetColorTexture(self.bbClr:GetRGBA())
				child.backdrop.left:SetColorTexture(self.bbClr:GetRGBA())
				child.backdrop.right:SetColorTexture(self.bbClr:GetRGBA())
				child.backdrop.bg:SetTexture(nil)
				aObj:adjHeight{obj=child, adj=4}
			elseif child:IsObjectType("ScrollFrame") then
				aObj:skinObject("slider", {obj=child.ScrollBar})
			elseif child:IsObjectType("Slider") then
				aObj:skinObject("slider", {obj=child})
			elseif child:IsObjectType("CheckButton") then
				aObj:Debug("checkKids: [%s, %s]", child, child.menu)
				if child.menu
				and aObj.modBtnBs
				then
					aObj:addButtonBorder{obj=child.menu, ofs=-1, x1=0}
				end
				if aObj.modChkBtns then
					aObj:skinCheckButton{obj=child}
				end
				checkKids(child)
			elseif child:IsObjectType("Button") then
				if child:GetName()
				and not child:GetNormalTexture()
				and aObj.modBtns
				then
					aObj:skinStdButton{obj=child}
					aObj:SecureHook(child, "Disable", function(this, _)
						aObj:clrBtnBdr(this)
					end)
					aObj:SecureHook(child, "Enable", function(this, _)
						aObj:clrBtnBdr(this)
					end)
				else
					checkKids(child)
				end
			elseif child:GetParent().list then -- filter list
				local fl = child:GetParent().list
				aObj:skinObject("slider", {obj=fl.scroll.ScrollBar})
				checkKids(fl)
				fl = nil
				checkKids(child)
			else checkKids(child)
			end
		end
	end
	self:SecureHook(_G.WIM.options, "OnShow", function(this)
		this.title:SetPoint("TOPLEFT", 50 , -7)
		this.close:SetPoint("TOPRIGHT", -4, -4)
		this.nav.bg:Hide()
		self:skinObject("frame", {obj=this, y2=8})
		-- if frame is a function then hook it, otherwise check it
		for _, cat in _G.pairs(_G.WIM.options.frame.nav.category) do
			for _, subCat in _G.pairs(cat.info.subCategories) do
				if _G.type(subCat["frame"]) == "function" then -- if the frame hasn't been created yet
					self:RawHook(subCat, "frame", function()
						local catFrame = self.hooks[subCat].frame()
						checkKids(catFrame)
						self:Unhook(subCat, "frame")
						return catFrame
					end, true)
				elseif subCat.frame then
					checkKids(subCat.frame) -- it is a frame
				end
			end
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHook(_G.WIM.options, "createDropDownFrame", function()
		self:skinObject("frame", {obj=_G.WIM_DropDownFrame})
		self:SecureHook(_G.WIM_DropDownFrame, "SetParent", function(this, parent)
			_G.RaiseFrameLevelByTwo(this)
		end)

		self:Unhook(_G.WIM.options, "createDropDownFrame")
	end)

	if _G.WIM.modules["Filters"]
	and _G.WIM.modules["Filters"].enabled
	then
		local function clrBD(obj)
			for _, tex in _G.pairs(obj.backdrop) do
				tex:SetTexture(nil)
			end
		end
		self:SecureHook(_G.WIM, "ShowFilterFrame", function(this, ...)
			local fFrame = _G.WIM3_FilterFrame
			if fFrame then
				fFrame.title:SetPoint("TOPLEFT", 50 , -7)
				fFrame.close:SetPoint("TOPRIGHT", -4, -4)
				clrBD(fFrame.name)
				self:skinObject("editbox", {obj=fFrame.name})
				self:skinObject("dropdown", {obj=fFrame.by, x2=109})
				self:skinObject("slider", {obj=fFrame.patternContainer.ScrollBar})
				clrBD(fFrame.patternContainer)
				self:skinObject("frame", {obj=fFrame.patternContainer, fb=true, ofs=6})
				clrBD(fFrame.user)
				-- clrBD(fFrame.level)
				-- self:skinObject("slider", {obj=fFrame.level.slider})
				-- self:skinObject("dropdown", {obj=fFrame.level.class, x2=109})
				self:skinObject("dropdown", {obj=fFrame.action, x2=109})
				fFrame.border:SetTexture(nil)
				self:skinObject("frame", {obj=fFrame})
				if self.modBtns then
					self:skinStdButton{obj=fFrame.cancel}
					self:skinStdButton{obj=fFrame.save}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=fFrame.user.friend}
					self:skinCheckButton{obj=fFrame.user.guild}
					self:skinCheckButton{obj=fFrame.user.party}
					self:skinCheckButton{obj=fFrame.user.raid}
					self:skinCheckButton{obj=fFrame.user.xrealm}
					self:skinCheckButton{obj=fFrame.user.all}
					self:skinCheckButton{obj=fFrame.received}
					self:skinCheckButton{obj=fFrame.sent}
					self:skinCheckButton{obj=fFrame.actionNotify}
				end
				fFrame = nil

				self:Unhook(this, "ShowFilterFrame")
			end
		end)
	end

end
