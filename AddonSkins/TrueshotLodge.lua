local _, aObj = ...
if not aObj:isAddonEnabled("TrueshotLodge") then return end
local _G = _G

aObj.addonsToSkin.TrueshotLodge = function(self) -- v 1.60.1.47

	self:add2Table(self.createFrames, {func = function(fObj)
		_G.RunNextFrame(function()

			self:SecureHookScript(fObj, "OnShow", function(this)
				if _G.InCombatLockdown() then
					self:add2Table(self.oocTab, {self.checkShown, {self, this}})
					return
				end

				-- find and identify frame objects
				local --[[badgeFrame, ]]filterGrp, abilityList, details, controls, stable, petProfile
				local searchTopBar--[[, searchTopList]], searchTopBox, searchTopScrollBar
				this.TabFrames = {}
				local titleBtns, filterBtns, clearBtn
				if self.modBtns then
					titleBtns, filterBtns = {}, {}
				end
				if this.TitleContainer then
					titleBtns = {this.TitleContainer:GetChildren()}
				end
				for idx, child in _G.ipairs{this:GetChildren()} do
					if child:GetSourceLocation():find("window.lua", 1, true) then
						if child:IsObjectType("Button")
						and self.modBtns
						then
							if child.section then
								self:add2Table(titleBtns, child)
							elseif child.filter then
								self:add2Table(filterBtns, child)
							end
						elseif child:IsObjectType("Frame") then
							-- if child:GetWidth() > 85
							-- and child:GetWidth() < 86
							-- then
							-- 	badgeFrame = child
							if child:GetFrameLevel() == this:GetFrameLevel() + 19 then
								filterGrp = child
							elseif child:GetWidth() > 268
							and child:GetWidth() < 269
							then
								abilityList = child
							elseif child:GetNumPoints() == 2
							and child:GetPoint(2) == "BOTTOMRIGHT"
							then
								details = child
								if self:getLastChild(details).Check then
									controls = self:getLastChild(details)
								end
							end
						end
					elseif child:GetSourceLocation():find("tab-collector.lua", 1, true)
					and self.modBtns
					and child:IsObjectType("Button")
					then
						clearBtn = child
					elseif child:GetSourceLocation():find("tab-search.lua", 1, true)
					and child:IsObjectType("Frame")
					and child.FamilyDropdown
					then
						searchTopBar = child
						-- searchTopList = self:getChild(this, idx + 1)
						searchTopBox = self:getChild(this, idx + 2)
						searchTopScrollBar = self:getChild(this, idx + 3)
					elseif child:GetSourceLocation():find("window-tabs", 1, true)
					and child:IsObjectType("Frame")
					and child.tooltipText
					then
						self:add2Table(this.TabFrames, child)
					elseif child:GetSourceLocation():find("tab-stable.lua", 1, true)
					and child:IsObjectType("Frame")
					then
						stable = child
					elseif child:GetSourceLocation():find("tab-pet.lua", 1, true)
					and child:IsObjectType("Frame")
					then
						petProfile = child
					end
				end

				local function skinControls()
					controls = controls or aObj:getLastChild(details)
					aObj:SecureHookScript(controls, "OnShow", function(_)
						aObj:skinObject("slider", {obj=controls.Slider.Slider, y1=-13, y2=13})
						if aObj.modBtns then
							aObj:skinStdButton{obj=controls.Reset}
						end
						if aObj.modChkBtns then
							aObj:skinCheckButton{obj=controls.Check}
							for _, cBtn in _G.pairs(controls.TabChecks.boxes) do
								aObj:skinCheckButton{obj=cBtn}
							end
							for _, cBtn in _G.pairs(controls.DebugChecks.boxes) do
								aObj:skinCheckButton{obj=cBtn}
							end
							local function skinFieldChecks()
								for _, cBtn in _G.pairs(controls.FieldChecks.boxes) do
									aObj:skinCheckButton{obj=cBtn}
								end
							end
							if controls.FieldChecks.boxes then
								skinFieldChecks()
							end
							aObj:SecureHook(controls.FieldChecks, "ShowFields", function(_, _, _)
								skinFieldChecks()
							end)
						end

						aObj:Unhook(controls, "OnShow")
					end)
					aObj:checkShown(controls)
				end
				self:getRegion(filterGrp, 2):SetTexture(nil)
				self:skinObject("sidetabs", {obj=this, tabs="TabFrames"})
				self:skinObject("frame", {obj=this, kfs=true, cb=true})
				if self.modBtns then
					for k, btn in _G.pairs(titleBtns) do
						self:skinStdButton{obj=btn, ofs=-3}
						self:moveObject{obj=btn, y=k==1 and -3 or nil}
						if btn.section == "OPTIONS"
						and not controls
						then
							self:SecureHookScript(btn, "OnClick", function(_)
								skinControls()
								self:Unhook(btn, "OnClick")
							end)
						end
					end
					for _, btn in _G.pairs(filterBtns) do
						self:skinStdButton{obj=btn}
					end
					self:skinStdButton{obj=clearBtn}
				end
				if controls then
					skinControls()
				end

				-- Ability List
				self:getChild(abilityList, 1):SetAlpha(0) -- border
				self:skinObject("editbox", {obj=self:getChild(abilityList, 2), si=true})
				self:skinObject("frame", {obj=abilityList, kfs=true, ofs=4, x2=2})
				if self.modBtns then
					local toggle = self:getChild(abilityList, 3)
					self:keepFontStrings(toggle)
					self:skinObject("button", {obj=toggle, ofs=1, y2=-2})
				end
				self:skinObject("scrollbar", {obj=self:getChild(abilityList, 5)})
				local function skinAbility(...)
					local _, element
					if _G.select("#", ...) == 2 then
						element, _ = ...
					else
						_, element, _ = ...
					end
				    aObj:keepFontStrings(element)
				end
				_G.ScrollUtil.AddInitializedFrameCallback(self:getChild(abilityList, 4), skinAbility, aObj, true)

				-- Details
				self:getChild(details, 1):SetAlpha(0) -- border
				if self:getLastChild(details).line then -- N.B. created in Window:ShowLearnableRow functions
					self:getLastChild(details).line:SetAlpha(0) -- learnableRow.line
				end
				self:skinObject("frame", {obj=details, kfs=true, ofs=4})
				self:skinObject("scrollbar", {obj=self:getChild(details, 5)})
				local function skinBeats(...)
					local _, element
					if _G.select("#", ...) == 2 then
						element, _ = ...
					else
						_, element, _ = ...
					end
				    aObj:keepFontStrings(element)
				end
				_G.ScrollUtil.AddInitializedFrameCallback(self:getChild(details, 4), skinBeats, aObj, true)

				-- Database Search
				self:skinObject("dropdown", {obj=searchTopBar.FamilyDropdown})
				self:skinObject("dropdown", {obj=searchTopBar.ClassDropdown})
				self:skinObject("dropdown", {obj=searchTopBar.DietDropdown})
				self:skinObject("dropdown", {obj=searchTopBar.TamingDropdown})
				self:skinObject("dropdown", {obj=searchTopBar.AbilityDropdown})
				self:skinObject("dropdown", {obj=searchTopBar.ZoneDropdown})
				self:skinObject("editbox", {obj=searchTopBar.MinBox})
				self:skinObject("editbox", {obj=searchTopBar.MaxBox})
				self:skinObject("editbox", {obj=searchTopBar.SearchBox, si=true})
				if self.modBtns then
					self:skinStdButton{obj=searchTopBar.ClearButton}
				end
				self:skinObject("scrollbar", {obj=searchTopScrollBar})
				local function skinSearch(...)
					local _, element
					if _G.select("#", ...) == 2 then
						element, _ = ...
					else
						_, element, _ = ...
					end
				    aObj:keepFontStrings(element)
				end
				_G.ScrollUtil.AddInitializedFrameCallback(searchTopBox, skinSearch, aObj, true)

				-- Stable
				-- TODO: skin right panel pet buttons
				local left = self:getChild(stable, 1)
				local right = self:getChild(stable, 2)
				self:getChild(left, 1):SetAlpha(0) -- border
				self:skinObject("frame", {obj=left, kfs=true, ofs=4, x2=2})
				self:getChild(right, 1):SetAlpha(0) -- border
				self:skinObject("frame", {obj=right, kfs=true, ofs=4})
				self:skinObject("scrollbar", {obj=self:getChild(left, 3)})
				local function skinStats(...)
					local _, element
					if _G.select("#", ...) == 2 then
						element, _ = ...
					else
						_, element, _ = ...
					end
				    aObj:keepFontStrings(element)
				end
				_G.ScrollUtil.AddInitializedFrameCallback(self:getChild(left, 2), skinStats, aObj, true)

				-- Pet Profile
				left = self:getChild(petProfile, 1)
				right = self:getChild(petProfile, 2)
				self:getChild(left, 1):SetAlpha(0) -- border
				self:skinObject("frame", {obj=left, kfs=true, ofs=4, x2=2})
				self:getChild(right, 1):SetAlpha(0) -- border
				self:skinObject("frame", {obj=right, kfs=true, ofs=4})
				self:skinObject("scrollbar", {obj=self:getChild(left, 5)})
				local function skinFacts(...)
					local _, element
					if _G.select("#", ...) == 2 then
						element, _ = ...
					else
						_, element, _ = ...
					end
				    aObj:keepFontStrings(element)
				end
				_G.ScrollUtil.AddInitializedFrameCallback(self:getChild(left, 4), skinFacts, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(fObj)

		end)
	end}, "TrueshotLodgeFrame")

end
