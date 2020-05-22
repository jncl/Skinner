local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["LibBlueOption-1.0"] = function(self) -- v LibBlueOption-1.0, 5
	if self.initialized.LibBlueOption then return end
	self.initialized.LibBlueOption = true

	local LBO = _G.LibStub:GetLibrary("LibBlueOption-1.0", true)

	if LBO then
		local function skinDD(frame)
			aObj:removeRegions(frame, {1, 2, 3})
			-- return if not to be skinned
			if not aObj.prdb.TexturedDD
			and not aObj.prdb.DropDownButtons
			then
				return
			end
			frame.ddTex = frame:CreateTexture(nil, "ARTWORK", -5) -- appear behind text
			frame.ddTex:SetTexture(aObj.prdb.TexturedDD and aObj.itTex or nil)
			-- align it to the middle texture
			frame.ddTex:SetPoint("LEFT", frame.left, "RIGHT", -4, 1)
			frame.ddTex:SetPoint("RIGHT", frame.right, "LEFT", 4, -1)
			frame.ddTex:SetHeight(18)

			-- skin the frame
			if aObj.prdb.UIDropDownMenu then
				aObj:addSkinFrame{obj=frame, ft="a", aso={ng=true, bd=5}, ofs=-1, y1=-19}
			end
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.button, es=12, ofs=-1, x1=0}
			end
			xOfs1, yOfs1, xOfs2, yOfs2 = nil, nil, nil, nil
		end
		local function skinCB(frame)
			frame.bg:SetTexture(nil)
			self:addButtonBorder{obj=frame, ofs=-2, relTo=frame.bg, reParent={frame.check, frame.highlight}, clr="grey"}
		end
		local function skinObjects(obj, name)
			if name == "DropDown" then
				skinDD(obj)
			elseif name == "CheckBox"
			and aObj.modChkBtns
			then
				skinCB(obj)
			elseif name == "Slider" then
				aObj:skinSlider{obj=obj.slider}
			elseif name == "Button"
			and aObj.modBtns
			then
				aObj:skinStdButton{obj=obj.button}
			elseif name == "List" then
				aObj:addSkinFrame{obj=obj.scrollframe, ft="a", kfs=true, nb=true, ofs=0, x1=-2, x2=1}
			end

		end

		self:RawHook(LBO, "CreateDropDown", function(this, ...)
			local dropdown = self.hooks[this].CreateDropDown(this, ...)
			skinDD(dropdown)
			return dropdown
		end, true)

		self:RawHook(LBO, "CreateDropDownMenu", function(this, ...)
			local menu = self.hooks[this].CreateDropDownMenu(this, ...)
			self:addSkinFrame{obj=menu, ft="a", kfs=true, nb=true}
			return menu
		end, true)

		-- hook this to handle other widget types
		self:RawHook(LBO, "CreateWidget", function(this, name, ...)
			local obj = self.hooks[this].CreateWidget(this, name, ...)
			skinObjects(obj, name)
			return obj
		end, true)

		-- skin existing widgets
		for name, num in _G.pairs(LBO.widgetsNum) do
			for i = 1, num do
				skinObjects(_G["LibBlueOption10" .. name .. i], name)
			end
		end

	end

end
