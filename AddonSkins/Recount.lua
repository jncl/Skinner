local aName, aObj = ...
if not aObj:isAddonEnabled("Recount") then return end
local _G = _G

aObj.addonsToSkin.Recount = function(self) -- v 7.3.0c

	-- defaults for RealTime frames
	-- Hook this to get window objects and skin them
	self:SecureHook(_G.Recount, "AddWindow", function(this, window)
		if window.YesButton then -- Reset popup
			self:skinStdButton{obj=window.YesButton}
			self:skinStdButton{obj=window.NoButton}
		else
			self:skinCloseButton{obj=window.CloseButton, x1=-1, y1=0, x2=1, y2=0}
		end
		self:addSkinFrame{obj=window, ft="a", nb=true, x1=-2, y1=-9, x2=0, y2=-2}
	end)

	self:SecureHookScript(_G.Recount_ConfigWindow, "OnShow", function(this)
		self:moveObject{obj=_G.Recount_ConfigWindow.CloseButton, x=5}
		self:skinCloseButton{obj=_G.Recount_ConfigWindow.CloseButton, x1=-1, y1=0, x2=1, y2=0}
		self:addSkinFrame{obj=_G.Recount_ConfigWindow, ft="a", nb=true, x1=-4, y1=-9, x2=5, y2=-2}
		self:skinSlider{obj=_G.Recount_ConfigWindow_Scaling_Slider}
		self:skinStdButton{obj=_G.Recount_ConfigWindow_Scaling_Slider:GetParent().ResetWinButton}
		self:skinSlider{obj=_G.Recount_ConfigWindow_RowHeight_Slider}
		self:skinSlider{obj=_G.Recount_ConfigWindow_RowSpacing_Slider}
		if self.modBtns then
			local frame
			if _G.Recount_ConfigWindow.Data then
				frame = self:getChild(_G.Recount_ConfigWindow.Data, 1) -- FilterOptions
				-- filter rows
				for _, row in pairs{"Self", "Grouped", "Ungrouped", "Hostile", "Pet", "Trivial", "Nontrivial", "Boss", "Unknown"} do
					for _, type in pairs{"ShowData", "RecordData", "RecordTime", "TrackDeaths", "TrackBuffs"} do
						self:skinCheckButton{obj=frame.Filters[row][type]}
					end
				end
				self:skinCheckButton{obj=frame.MergePets}
				self:skinCheckButton{obj=frame.MergeAbsorbs}
				self:skinCheckButton{obj=frame.MergeDamageAbsorbs}
				frame = self:getChild(_G.Recount_ConfigWindow.Data, 2) -- MiscOptions
				self:skinStdButton{obj=frame.VerChkButton}
				self:skinCheckButton{obj=frame["none"]}
				self:skinCheckButton{obj=frame["scenario"]}
				self:skinCheckButton{obj=frame["party"]}
				self:skinCheckButton{obj=frame["raid"]}
				self:skinCheckButton{obj=frame["pvp"]}
				self:skinCheckButton{obj=frame["arena"]}
				self:skinCheckButton{obj=frame[1]}
				self:skinCheckButton{obj=frame[2]}
				self:skinCheckButton{obj=frame[3]}
				self:skinCheckButton{obj=frame.GlobalData}
				self:skinCheckButton{obj=frame.HideCollect}
				self:skinCheckButton{obj=frame.HidePetBattle}
				frame = self:getChild(_G.Recount_ConfigWindow.Data, 3) -- DeletionOptions
				self:skinCheckButton{obj=frame.Autodelete}
				self:skinCheckButton{obj=frame.AutodeleteI}
				self:skinCheckButton{obj=frame.AutodeleteINew}
				self:skinCheckButton{obj=frame.AutodeleteIConf}
				self:skinCheckButton{obj=frame.AutodeleteG}
				self:skinCheckButton{obj=frame.AutodeleteGConf}
				self:skinCheckButton{obj=frame.AutodeleteR}
				self:skinCheckButton{obj=frame.AutodeleteRConf}
				self:skinCheckButton{obj=frame.SegmentBosses}
			end
			if _G.Recount_ConfigWindow.Window then
				frame = self:getChild(_G.Recount_ConfigWindow.Window, 1) -- ButtonOptions
				self:skinCheckButton{obj=frame.ReportButton}
				self:skinCheckButton{obj=frame.ConfigButton}
				self:skinCheckButton{obj=frame.FileButton}
				self:skinCheckButton{obj=frame.ResetButton}
				self:skinCheckButton{obj=frame.LeftButton}
				self:skinCheckButton{obj=frame.RightButton}
				self:skinCheckButton{obj=frame.CloseButton}
				self:skinCheckButton{obj=frame.TotalBar}
				self:skinCheckButton{obj=frame.ShowSB}
				self:skinCheckButton{obj=frame.AutoHide}
				frame = self:getChild(_G.Recount_ConfigWindow.Window, 2) -- WindowOptions
				self:skinStdButton{obj=frame.ResetWinButton}
				self:skinCheckButton{obj=frame.LockWin}
				frame = self:getChild(_G.Recount_ConfigWindow.Window, 3) -- RealtimeOptions
				self:skinStdButton{obj=frame.RDPSButton}
				self:skinStdButton{obj=frame.RDTPSButton}
				self:skinStdButton{obj=frame.RHPSButton}
				self:skinStdButton{obj=frame.RHTPSButton}
				self:skinStdButton{obj=frame.FPSButton}
				self:skinStdButton{obj=frame.LATButton}
				self:skinStdButton{obj=frame.UPTButton}
				self:skinStdButton{obj=frame.DOTButton}
				self:skinStdButton{obj=frame.BWButton}
			end
			if _G.Recount_ConfigWindow.Appearance then
				frame = self:getChild(_G.Recount_ConfigWindow.Appearance, 1) -- BarSelection
				self:skinCheckButton{obj=frame.RankNum}
				self:skinCheckButton{obj=frame.ServerName}
				self:skinCheckButton{obj=frame.PerSec}
				self:skinCheckButton{obj=frame.Percent}
				self:skinCheckButton{obj=frame.Standard}
				self:skinCheckButton{obj=frame.Commas}
				self:skinCheckButton{obj=frame.Short}
				self:skinCheckButton{obj=frame.BarTextColorSwap}
			end
			if _G.Recount_ConfigWindow.ColorOpt then
				for _, child in _G.pairs{_G.Recount_ConfigWindow.ColorOpt:GetChildren()} do
					if child.ResetColButton then
						self:skinStdButton{obj=child.ResetColButton}
					end
				end
			end
			if _G.Recount_ConfigWindow.ModuleOpt then
				frame = self:getChild(_G.Recount_ConfigWindow.ModuleOpt, 1)
				self:skinCheckButton{obj=frame.HealingTaken}
				self:skinCheckButton{obj=frame.OverhealingDone}
				self:skinCheckButton{obj=frame.Deaths}
				self:skinCheckButton{obj=frame.DOTUptime}
				self:skinCheckButton{obj=frame.HOTUptime}
				self:skinCheckButton{obj=frame.Activity}
			end
			frame = nil
		end
		self:Unhook(this, "OnShow")
	end)

	self:SecureHook(_G.Recount, "ShowReport", function(this)
		self:skinEditBox{obj=_G.Recount_ReportWindow.Whisper, regs={9}, noHeight=true}
		_G.Recount_ReportWindow.Whisper:SetHeight(_G.Recount_ReportWindow.Whisper:GetHeight() + 6)
		self:skinStdButton{obj=_G.Recount_ReportWindow.ReportButton}
		self:skinSlider{obj=_G.Recount_ReportWindow.slider}
		-- TODO: skin report rows checkbox
		aObj:Debug("Recount ShowReport: [%s]", _G.Recount_ReportWindow:GetNumChildren())
		for i = 6, _G.Recount_ReportWindow:GetNumChildren() do
			self:skinCheckButton{obj=self:getChild(_G.Recount_ReportWindow, i).Enabled}
			self:getChild(_G.Recount_ReportWindow, i).Enabled:SetSize(20, 20)
		end
		self:Unhook(this, "ShowReport")
	end)

	for _, type	in _G.pairs{"Main", "Detail", "Graph"} do
		self:addSkinFrame{obj=_G.Recount[type .. "Window"], ft="a", kfs=true, nb=true, x1=-2, y1=-9, x2=2, y2=-2}
		self:skinCloseButton{obj=_G.Recount[type .. "Window"].CloseButton, x1=-1, y1=0, x2=1, y2=0}
		self:moveObject{obj=_G.Recount[type .. "Window"].CloseButton, x=2}
	end

	-- skin Realtime frames already created
	self.RegisterCallback("Recount", "UIParent_GetChildren", function(this, child)
		if child.TitleText
		and child.DragBottomRight
		and child.Graph
		then
			self:addSkinFrame{obj=child, ft="a", kfs=true, nb=true, x1=-4, y1=-9, x2=4, y2=-4}
			self:skinCloseButton{obj=child.CloseButton, x1=-1, y1=0, x2=1, y2=0}
			self:moveObject{obj=child.CloseButton, x=5}
		end
	end)

end
