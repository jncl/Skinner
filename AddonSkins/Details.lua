local aName, aObj = ...
if not aObj:isAddonEnabled("Details") then return end
local _G = _G

-- used by all contained functions
local Details = _G.LibStub("AceAddon-3.0"):GetAddon("_detalhes", true)

function aObj:Details()

	-- N.B. Welcome panel, Profiler panel created early
	-- not going to skin them

	-- Options frame
	self:SecureHook(Details, "OpenOptionsWindow", function(this)
		local frame
		-- TODO remove title backdrop, skin closebutton
		-- frame6
		self:skinButton{obj=_G.DetailsDeleteInstanceButton}
		-- frame15
		frame = _G.DetailsOptionsWindow15CustomSpellsAddPanel
		self:addSkinFrame{obj=frame}
		frame:SetBackdrop(nil)
		frame.SetBackdropColor = _G.nop
		frame.SetBackdropBorderColor = _G.nop
		self:skinSlider{obj=_G.SpellCacheBrowserFrame.ScrollBar}
		self:addSkinFrame{obj=_G.SpellCacheBrowserFrame, ofs=3}
		-- frame16
		frame = _G.DetailsOptionsWindow16UserTimeCapturesAddPanel
		self:addSkinFrame{obj=frame}
		frame:SetBackdrop(nil)
		frame.SetBackdropColor = _G.nop
		frame.SetBackdropBorderColor = _G.nop
		--
		frame = nil
		self:addSkinFrame{obj=_G.DetailsOptionsWindow, nb=true, ofs=4}
		self:Unhook(this, "OpenOptionsWindow")
	end)
	-- Forge frame
	self:SecureHook(Details, "OpenForge", function(this)
		self:addSkinFrame{obj=_G.DetailsForge, kfs=true, ri=true, ofs=2, x2=1}
		self:Unhook(this, "OpenForge")
	end)
	-- History frame
	self:SecureHook(Details, "OpenRaidHistoryWindow", function(this)
		self:addSkinFrame{obj=_G.DetailsRaidHistoryWindow, kfs=true, ri=true, ofs=2, x2=1}
		self:Unhook(this, "OpenRaidHistoryWindow")
	end)
	-- Version Notes frame
	self:SecureHook(Details, "CreateOrOpenNewsWindow", function(this)
		self:addSkinFrame{obj=_G.DetailsNewsWindow, kfs=true, ri=true, ofs=2, x2=1}
		self:Unhook(this, "CreateOrOpenNewsWindow")
	end)
	-- Feedback Panel
	self:SecureHook(Details, "OpenFeedbackWindow", function(this)
		self:addSkinFrame{obj=_G.DetailsFeedbackPanel, kfs=true, ri=true, ofs=2, x2=1}
		self:Unhook(this, "OpenFeedbackWindow")
	end)
	-- -- ClassColorManager frame
	-- self:SecureHook(Details, "OpenClassColorsConfig", function(this)
	-- 	-- _G.DetailsClassColorManager reset_texture
	-- 	self:Unhook(this, "OpenClassColorsConfig")
	-- end)

	-- CopyPaste Panel
	local eb = _G.DetailsCopy.text.editbox
	eb:SetBackdrop(nil)
	self:skinEditBox{obj=eb, regs={3}, noHeight=true}
	eb.SetBackdropColor = _G.nop
	eb.SetBackdropBorderColor = _G.nop
	eb = nil
	self:addSkinFrame{obj=_G.DetailsCopy, kfs=true, ri=true, ofs=2, x2=1}

	-- Player Details Window
	self:addSkinFrame{obj=_G.DetailsPlayerDetailsWindow, nb=true, ofs=4}

	-- Report Window
	if not _G.DetailsReportWindow then
		self:SecureHook(Details.gump, "CriaJanelaReport", function(this)
			self:addSkinFrame{obj=_G.DetailsReportWindow, nb=true, ofs=4}
			self:Unhook(this, "CriaJanelaReport")
		end)
	else
		self:addSkinFrame{obj=_G.DetailsReportWindow, nb=true, ofs=4}
	end

	local function skinInstance(frame)

		self:addSkinFrame{obj=frame, ofs=4, y1=22}

	end

	-- Base frame(s)
	self:SecureHook(Details.gump, "CriaJanelaPrincipal", function(this, ID, instancia, criando)
		-- aObj:Debug("Details.gump CriaJanelaPrincipal: [%s, %s, %s, %s]", this, ID, instancia, criando)
		skinInstance(_G["DetailsBaseFrame" .. ID])
	end)
	-- skin existing instance(s)
	for _, v in _G.ipairs(Details.tabela_instancias) do
		-- aObj:Debug("Details tabela_instancias: [%s]", v)
		if v.baseframe then
			skinInstance(v.baseframe)
		end
	end

	-->>-- Plugins
	for _, v in _G.pairs{"DmgRank", "DpsTuning", "TimeAttack", "Vanguard"} do
		-- print("checking plugin:", v)
		self:checkAndRunAddOn("Details_" .. v)
	end

	-- Plugin Options Panel
	self:RawHook(Details, "CreatePluginOptionsFrame", function(this, name, title, template)
		local frame = self.hooks[Details].CreatePluginOptionsFrame(this, name, title, template)
		self:addSkinFrame{obj=frame, ofs=4}
		return frame
	end, true)

end

function aObj:Details_DmgRank()

	local DmgRank = Details:GetPlugin("DETAILS_PLUGIN_DAMAGE_RANK")

	self:skinButton{obj=self:getChild(DmgRank.Frame, 1), cb=true} -- close button
	DmgRank.BackgroundTex:SetTexture(nil)
	_G.DetailsDmgRankBadgeBackground:SetBackdrop(nil)
	_G.DetailsDmgRankLeftBackground:SetBackdrop(nil)
	_G.DetailsDmgRankRightBackground:SetBackdrop(nil)
	DmgRank = nil

end
function aObj:Details_DpsTuning()

	local DpsTuning = Details:GetPlugin("DETAILS_PLUGIN_DPS_TUNING")

	self:skinButton{obj=self:getChild(DpsTuning.Frame, 1), cb=true} -- close button
	DpsTuning = nil

end
function aObj:Details_TimeAttack()

	local TimeAttack = Details:GetPlugin("DETAILS_PLUGIN_TIME_ATTACK")

	self:skinButton{obj=self:getChild(TimeAttack.Frame, 1), cb=true} -- close button
	TimeAttack.BackgroundTex:SetAlpha(0) -- texture is changed in code
	self:getRegion(TimeAttack.Frame, 3):SetTexture(nil) -- title background texture
	TimeAttack = nil

end
function aObj:Details_Vanguard()

	local Vanguard = Details:GetPlugin("DETAILS_PLUGIN_VANGUARD")

	if not Vanguard.db.first_run then
		self:SecureHook(Vanguard, "OnDetailsEvent", function(this, event, ...)
			-- help frame displayed on 1st show
			if event == "SHOW" then
				local frame = self:findFrame2(_G.UIParent, "Frame", 175, 400)
				if frame then self:addSkinFrame{obj=frame, ofs=4} end
			end
			self:Unhook(this, "OnDetailsEvent")
		end)
	end
	Vanguard = nil

end
