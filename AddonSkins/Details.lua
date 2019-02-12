local aName, aObj = ...
if not aObj:isAddonEnabled("Details") then return end
local _G = _G

-- used by all contained functions
local Details = _G.LibStub("AceAddon-3.0"):GetAddon("_detalhes", true)

aObj.addonsToSkin.Details = function(self) -- v8.1.0.6891.135

	-- CopyPaste Panel
	local eb = _G.DetailsCopy.text.editbox
	eb:SetBackdrop(nil)
	self:skinEditBox{obj=eb, regs={3}, noHeight=true}
	eb.SetBackdropColor = _G.nop
	eb.SetBackdropBorderColor = _G.nop
	eb = nil
	self:addSkinFrame{obj=_G.DetailsCopy, ft="a", kfs=true, ri=true, ofs=2, x2=1}

	-- Player Details Window
	self:addSkinFrame{obj=_G.DetailsPlayerDetailsWindow, ft="a", kfs=true, nb=true, ofs=4}

	-- Report Window
	if not _G.DetailsReportWindow then
		self:SecureHook(Details.gump, "CriaJanelaReport", function(this)
			self:addSkinFrame{obj=_G.DetailsReportWindow, ft="a", kfs=true, nb=true, ofs=4}
			self:Unhook(this, "CriaJanelaReport")
		end)
	else
		self:addSkinFrame{obj=_G.DetailsReportWindow, ft="a", kfs=true, nb=true, ofs=4}
	end

	-- News Window
	local function skinNews()
		aObj:addSkinFrame{obj=_G.DetailsNewsWindow, ft="a", kfs=true, ri=true, ofs=2}
		aObj:skinSlider{obj=_G.DetailsNewsWindowSlider, wdth=-2}
		aObj:skinStdButton{obj=_G.DetailsNewsWindowForumButton}
	end
	if not _G.DetailsNewsWindow then
		self:SecureHook(Details, "CreateOrOpenNewsWindow", function(this)
			skinNews()
			self:Unhook(this, "CreateOrOpenNewsWindow")
		end)
	else
		skinNews()
	end

	-- Base frame(s)
	local function skinInstance(frame)
		frame.cabecalho.top_bg:SetTexture(nil)
		aObj:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true, ofs=4, y1=22}
	end
	self:SecureHook(Details.gump, "CriaJanelaPrincipal", function(this, ID, instancia, criando)
		skinInstance(_G["DetailsBaseFrame" .. ID])
	end)
	-- skin existing instance(s)
	for _, v in _G.ipairs(Details.tabela_instancias) do
		if v.baseframe then
			skinInstance(v.baseframe)
		end
	end

	-- Plugins
	for _, v in _G.pairs{"DmgRank", "DpsTuning", "TimeAttack", "Vanguard"} do
		self:checkAndRunAddOn("Details_" .. v)
	end

	-- OptionsWindow
	if self.modBtns
	or self.modChkBtns
	then
		self:SecureHook(Details, "OpenOptionsWindow", function(this, ...)
			if self.modBtns then
				self:skinStdButton{obj=_G.DetailsDeleteInstanceButton}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.DetailsOptionsWindowGroupEditing}
			end
			self:Unhook(this, "OpenOptionsWindow")
		end)
	end

end

function aObj:Details_DmgRank()

	local DmgRank = Details:GetPlugin("DETAILS_PLUGIN_DAMAGE_RANK")

	if not DmgRank then
		self.Details_DmgRank = nil
		return
	end

	self:skinButton{obj=self:getChild(DmgRank.Frame, 1), cb=true} -- close button
	DmgRank.BackgroundTex:SetTexture(nil)
	_G.DetailsDmgRankBadgeBackground:SetBackdrop(nil)
	_G.DetailsDmgRankLeftBackground:SetBackdrop(nil)
	_G.DetailsDmgRankRightBackground:SetBackdrop(nil)
	DmgRank = nil

end
function aObj:Details_DpsTuning()

	local DpsTuning = Details:GetPlugin("DETAILS_PLUGIN_DPS_TUNING")

	if not DpsTuning then
		self.Details_DpsTuning = nil
		return
	end

	self:skinButton{obj=self:getChild(DpsTuning.Frame, 1), cb=true} -- close button
	DpsTuning = nil

end
function aObj:Details_TimeAttack()

	local TimeAttack = Details:GetPlugin("DETAILS_PLUGIN_TIME_ATTACK")

	if not TimeAttack then
		self.Details_TimeAttack = nil
		return
	end

	self:skinButton{obj=self:getChild(TimeAttack.Frame, 1), cb=true} -- close button
	TimeAttack.BackgroundTex:SetAlpha(0) -- texture is changed in code
	self:getRegion(TimeAttack.Frame, 3):SetTexture(nil) -- title background texture
	TimeAttack = nil

end
function aObj:Details_Vanguard()

	local Vanguard = Details:GetPlugin("DETAILS_PLUGIN_VANGUARD")

	if not Vanguard then
		self.Details_Vanguard = nil
		return
	end

	if not Vanguard.db.first_run then
		self:SecureHook(Vanguard, "OnDetailsEvent", function(this, event, ...)
			-- help frame displayed on 1st show
			if event == "SHOW" then
				local frame = self:findFrame2(_G.UIParent, "Frame", 175, 400)
				if frame then self:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true, ofs=4} end
			end
			self:Unhook(this, "OnDetailsEvent")
		end)
	end
	Vanguard = nil

end
