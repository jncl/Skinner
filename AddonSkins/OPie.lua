local _, aObj = ...
if not aObj:isAddonEnabled("OPie") then return end
local _G = _G
-- luacheck: ignore 631 (line is too long)

aObj.addonsToSkin.OPie = function(self) -- v Zeta 4.5b

	-- tooltip
	_G.C_Timer.After(0.1, function()
		aObj:add2Table(aObj.ttList, _G.NotGameTooltip1)
	end)

	local skinKids, skinFrameOverlay, skinAlternateFrame = _G.nop, _G.nop, _G.nop
	local cW, trackObj
	function skinKids(frame)
		for _, child in _G.ipairs{frame:GetChildren()} do
			cW = _G.Round(child:GetWidth())
			if aObj:isDropDown(child) then
				aObj:skinObject("dropdown", {obj=child})
			elseif child:IsObjectType("EditBox") then
				aObj:skinObject("editbox", {obj=child})
			elseif child:IsObjectType("Slider") then
				aObj:skinObject("slider", {obj=child})
			elseif child:IsObjectType("CheckButton")
			and aObj.modChkBtns
			then
				aObj:skinCheckButton{obj=child}
			elseif child:IsObjectType("Button")
			and cW > 64
			and aObj.modBtns
			then
				if not child.ico then
					aObj:skinStdButton{obj=child, schk=true, sechk=true}
				end
				-- hook this to skin TenSettings FrameOverlay
				if frame.OnBindingAltClick then
					aObj:SecureHookScript(child, "OnClick", function(this)
						if _G.IsAltKeyDown() then
							skinAlternateFrame(this)
						end
						if _G.IsShiftKeyDown() then
							skinFrameOverlay(this:GetParent():GetParent())
						end
					end)
				end
			elseif child:IsObjectType("Button")
			and cW <= 64
			and aObj.modBtnBs
			then
				-- TODO: add button borders to small buttons on LHS of Custom Rings panel
				--@debug@
				-- _G.Spew("btn bds", child)
				--@end-debug@
			elseif child:IsObjectType("Frame") then
				if child.slices then -- ringContainer
					aObj:skinObject("frame", {obj=child, kfs=true, fb=true})
				elseif child.exportFrame then -- ringDetail.exportBg
					aObj:skinObject("frame", {obj=child.exportFrame, kfs=true, fb=true})
				elseif child.slider2 then -- newSlice
					trackObj = aObj:getChild(child.slider, 1)
					aObj:removeRegions(trackObj, {1, 2, 3})
					aObj:skinObject("frame", {obj=child, kfs=true, cb=true, fb=true})
				end
				skinKids(child)
			end
		end
	end
	local container, overlayFrame
	function skinFrameOverlay(frame)
		container = aObj:getLastChild(frame)
		overlayFrame = aObj:getLastChild(container)
		aObj:skinObject("frame", {obj=container, kfs=true, ofs=-3})
		if aObj.modBtns then
			aObj:skinCloseButton{obj=aObj:getChild(container, 4)}
		end
		skinKids(overlayFrame)
		-- hook this to skin other overlayFrame(s)
		aObj:SecureHook(container, "Show", function(this)
			_G.C_Timer.After(0.025, function()
				overlayFrame = aObj:getLastChild(this)
				skinKids(overlayFrame)
			end)
		end)
		-- prevent function from being called again
		skinFrameOverlay = _G.nop
	end
	local alternateFrame
	function skinAlternateFrame(frame)
		alternateFrame = aObj:getLastChild(frame)
		aObj:skinObject("slider", {obj=alternateFrame.scroll.ScrollBar})
		aObj:skinObject("frame", {obj=alternateFrame, kfs=true, ofs=-4})
	end

	local atlas
	local function selectTab(tab)
		atlas = aObj:getRegion(tab, 2):GetAtlas()
		if atlas == "Options_Tab_Active_Left" then
			aObj:setActiveTab(tab.sf)
		else
			aObj:setInactiveTab(tab.sf)
		end
	end
	self:SecureHookScript(_G.TenSettingsFrame, "OnShow", function(this)
		local vTabs, view = {}, self:getChild(self:getChild(self:getChild(this, 4), 1), 1)
		for _, child in _G.ipairs{view:GetChildren()} do
			if child:IsObjectType("Button") then
				vTabs[#vTabs + 1] = child
			end
		end
		self:skinObject("frame", {obj=view, kfs=true, fb=true, y1=-24})
		self:skinObject("tabs", {obj=this, tabs=vTabs, regions={1}, ignoreHLTex=false, offsets={x1=-2, y1=-6, x2=2, y2=-4}, track=false, func=self.isTT and function(tab)
			selectTab(tab)
			self:SecureHook(aObj:getRegion(tab, 2), "SetAtlas", function(tObj, _)
				selectTab(tObj:GetParent())
			end)
		end})
		self:skinObject("frame", {obj=this, kfs=true, rns=true, ofs=1})
		if self.modBtns then
			self:skinCloseButton{obj=this.ClosePanelButton}
			self:skinStdButton{obj=this.Cancel}
			self:skinStdButton{obj=this.Save}
			self:skinStdButton{obj=this.Reset}
			self:skinStdButton{obj=this.Revert, sechk=true}
		end

		-- hook this to skin TenSettings FrameOverlay
		self:SecureHookScript(this.Reset, "OnClick", function(bObj)
			skinFrameOverlay(bObj:GetParent())

			self:Unhook(bObj, "OnClick")
		end)

		self:Unhook(this, "OnShow")
	end)

	local OPieOptions = _G.OPC_Profile:GetParent()
	self:SecureHookScript(OPieOptions, "OnShow", function(this)
		skinKids(this)

		-- hook these to skin TenSettings FrameOverlay
		self:SecureHook(_G.OPC_Profile, "initialize", function(ddObj)
			self:SecureHook(_G.DropDownList1Button3, "func", function(bObj, _, frame)
				skinFrameOverlay(frame)

				self:Unhook(bObj, "func")
			end)

			self:Unhook(ddObj, "initialize")
		end)

		self:Unhook(this, "OnShow")
	end)

	local OPieBindings = _G.OBC_Profile:GetParent()
	self:SecureHookScript(OPieBindings, "OnShow", function(this)
		skinKids(this)

		-- hook these to skin TenSettings FrameOverlay
		self:SecureHook(_G.OBC_Profile, "initialize", function(ddObj)
			self:SecureHook(_G.DropDownList1Button3, "func", function(bObj, _, frame)
				skinFrameOverlay(frame)

				self:Unhook(bObj, "func")
			end)

			self:Unhook(ddObj, "initialize")
		end)

		self:Unhook(this, "OnShow")
	end)

	local CustomRings = _G.RKC_RingSelectionDropDown:GetParent()
	self:SecureHookScript(CustomRings, "OnShow", function(this)
		skinKids(this)

		self:Unhook(this, "OnShow")
	end)

end
