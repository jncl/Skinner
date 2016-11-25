local aName, aObj = ...
if not aObj:isAddonEnabled("MoveAnything") then return end
local _G = _G

function aObj:MoveAnything()

	local function skinPortDialog()

		if not _G.MAPortDialog.sf then
			aObj:addSkinFrame{obj=_G.MAPortDialog, y1=2, x2=1}
		end

	end

	local function skinFrameEditors()

		local i = 1

		while true do
			if not _G["MA_FE" .. i] then break end

			aObj:skinDropDown{obj=_G["MA_FE" .. i .. "Point"]}
			aObj:skinDropDown{obj=_G["MA_FE" .. i .. "RelPoint"]}
			aObj:skinEditBox{obj=_G["MA_FE" .. i .. "RelToEdit"], regs={6}, noHeight=true} -- 6 is text
			aObj:skinEditBox{obj=_G["MA_FE" .. i .. "XEdit"], regs={6}, noHeight=true} -- 6 is text
			aObj:skinEditBox{obj=_G["MA_FE" .. i .. "YEdit"], regs={6}, noHeight=true} -- 6 is text
			aObj:skinEditBox{obj=_G["MA_FE" .. i .. "ScaleEdit"], regs={6}, noHeight=true} -- 6 is text
			aObj:skinEditBox{obj=_G["MA_FE" .. i .. "AlphaEdit"], regs={6}, noHeight=true} -- 6 is text
			aObj:skinDropDown{obj=_G["MA_FE" .. i .. "Strata"]}
			aObj:addSkinFrame{obj=_G["MA_FE" .. i], y1=2, x2=1}
			-- hook these to skin PortDialog
			if not aObj:IsHooked(_G["MA_FE" .. i .. "ExportButton"], "OnClick") then
				aObj:SecureHookScript(_G["MA_FE" .. i .. "ExportButton"], "OnClick", function(this)
					skinPortDialog()
					aObj:Unhook(this, "OnClick")
				end)
				aObj:SecureHookScript(_G["MA_FE" .. i .. "ImportButton"], "OnClick", function(this)
					skinPortDialog()
					aObj:Unhook(this, "OnClick")
				end)
			end
			i =  i + 1

		end
		i = nil

	end

	local function skinMoveFrames()

		local i, frameBD = 1

		while true do
			if not _G["MAMover" .. i] then break end

			frameBD = _G["MAMover" .. i .. "Backdrop"]
			frameBD.bgFile = aObj.Backdrop[1].bgFile
			frameBD.edgeFile = aObj.Backdrop[1].edgeFile
			frameBD:SetBackdropColor(aObj.bColour[1], aObj.bColour[2], aObj.bColour[3], aObj.bColour[4])
			frameBD:SetBackdropBorderColor(aObj.bbColour[1], aObj.bbColour[2], aObj.bbColour[3], aObj.bbColour[4])
			i =  i + 1

		end
		i, frameBD = nil, nil

	end

	self:skinButton{obj=_G.GameMenuButtonMoveAnything}

	-- Options frame
	self:skinSlider{obj=_G.MAScrollFrame.ScrollBar}
	_G.MAScrollBorder:SetAlpha(0)
	self:skinEditBox{obj=_G.MA_Search, regs={6}, noHeight=true} -- 6 is text
	self:addSkinFrame{obj=_G.MAOptions, kfs=true, hdr=true}
	-- category buttons
	for i = 1, 18 do
		_G["MAMove" .. i .. "Backdrop"]:SetBackdrop(nil)
		self:skinButton{obj=_G["MAMove" .. i .. "Reset"]}
		-- hook this to skin FrameEditor frames
		self:SecureHookScript(_G["MAMove" .. i .. "FrameName"], "OnMouseUp", function(this)
			skinFrameEditors()
		end)
		-- hook this to skin Move frames
		self:SecureHookScript(_G["MAMove" .. i .. "Move"], "OnClick", function(this)
			skinMoveFrames()
		end)
	end
	-- hook these to skin PortDialog
	self:SecureHookScript(_G.MAOptExportProfile, "OnClick", function(this)
		skinPortDialog()
		self:Unhook(_G.MAOptExportProfile, "OnClick")
	end)
	self:SecureHookScript(_G.MAOptImportProfile, "OnClick", function(this)
		skinPortDialog()
		self:Unhook(_G.MAOptImportProfile, "OnClick")
	end)

	-- Nudger frame
	self:skinAllButtons{obj=_G.MANudger, x1=-1, x2=1}
	self:addSkinFrame{obj=_G.MANudger, nb=true}

end
