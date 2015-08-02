local aName, aObj = ...
if not aObj:isAddonEnabled("AtlasLoot") then return end
local _G = _G

function aObj:AtlasLoot()

	local function skinDropDown(obj)
		obj.frame:SetBackdrop(nil)
		if aObj.db.profile.TexturedDD then
			-- add texture
			obj.frame.ddTex = obj.frame:CreateTexture(nil, "ARTWORK")
			obj.frame.ddTex:SetTexture(aObj.db.profile.TexturedDD and aObj.itTex or nil)
			obj.frame.ddTex:SetPoint("LEFT", obj.frame, "RIGHT", -5, 2)
			obj.frame.ddTex:SetPoint("RIGHT", obj.frame, "LEFT", 5, 2)
			obj.frame.ddTex:SetHeight(18)
		end
		if aObj.db.profile.DropDownButtons then
			aObj:addSkinFrame{obj=obj.frame, aso={ng=true}, nb=true}
		end
		aObj:addButtonBorder{obj=obj.frame.button, es=12, ofs=-2}
		-- hook this to skin dropdown frame(s)
		aObj:SecureHookScript(obj.frame.button, "OnClick", function(this)
			local kids = {this.par.frame:GetChildren()}
			for _, child in _G.ipairs(kids) do
				if child.label
				and child.buttons
				and child.type == "frame"
				then
					aObj:addSkinFrame{obj=child}
				end
			end
			kids = nil
			aObj:Unhook(obj.frame.button, "OnClick")
		end)
	end
	local function skinSelect(obj)
		aObj:addSkinFrame{obj=obj.frame}
		aObj:skinSlider{obj=obj.frame.scrollbar}--, adj=-4, size=3}
	end
-->>-- GUI
	local GUI = _G.AtlasLoot.GUI
	local frame = GUI.frame
	frame.titleFrame:SetBackdrop(nil)
	skinDropDown(frame.moduleSelect)
	skinDropDown(frame.subCatSelect)
	skinSelect(frame.difficulty)
	skinSelect(frame.boss)
	skinSelect(frame.extra)
	self:addSkinFrame{obj=frame}

	-- ItemFrame
	local iF = frame.contentFrame
	iF:DisableDrawLayer("BACKGROUND")
	self:addButtonBorder{obj=iF.nextPageButton, ofs=-2, x1=1, y2=1}
	self:addButtonBorder{obj=iF.mapButton, ofs=-1, x1=2, x2=-2}
	self:addButtonBorder{obj=iF.prevPageButton, ofs=-2, x1=1, y2=1}
	self:addButtonBorder{obj=iF.clasFilterButton}

-->>-- Tooltip(s)
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then
			_G.AtlasLootTooltip:SetBackdrop(self.backdrop)
		end
		self:SecureHookScript(_G.AtlasLootTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
		-- skin Mount tooltip
		local mTT = _G.AtlasLoot.Button:GetType("Mount")
		if mTT then
			self:SecureHook(mTT, "ShowToolTipFrame", function(button)
				self:addSkinFrame{obj=mTT.tooltipFrame}
				self:Unhook(mTT, "ShowToolTipFrame")
			end)
		end
		-- skin Pet tooltip
		local pTT = _G.AtlasLoot.Button:GetType("Pet")
		if pTT then
			self:SecureHook(pTT, "ShowToolTipFrame", function(button)
				self:addSkinFrame{obj=pTT.tooltipFrame}
				self:Unhook(pTT, "ShowToolTipFrame")
			end)
		end
		-- skin Faction tooltip
		local fTT = _G.AtlasLoot.Button:GetType("Faction")
		if fTT then
			self:SecureHook(fTT, "ShowToolTipFrame", function(button)
				fTT.tooltipFrame.standing:SetBackdrop(nil)
				self:glazeStatusBar(fTT.tooltipFrame.standing.bar, 0,  nil)
				self:addSkinFrame{obj=fTT.tooltipFrame}
				self:Unhook(fTT, "ShowToolTipFrame")
			end)
		end
	end

	-->>-- Minimap Button
	if _G.AtlasLoot.MiniMapButton.frame then
		self:removeRegions(_G.AtlasLoot.MiniMapButton.frame, {2, 3}) -- Border & Background
		self:addSkinButton{obj=_G.AtlasLoot.MiniMapButton.frame, parent=_G.AtlasLoot.MiniMapButton.frame, sap=true}
	end

end
