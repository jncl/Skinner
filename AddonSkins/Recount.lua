local aName, aObj = ...
if not aObj:isAddonEnabled("Recount") then return end
local _G = _G

function aObj:Recount()

	-- dafaults for RealTime frames
	local x1, y1, x2, y2 = -4, -8, 4, -4
	-- Hook this to get window objects and skin them
	self:SecureHook(_G.Recount, "AddWindow", function(this, window)
		if window:GetName() == "Recount_ReportWindow" then -- report window
			self:moveObject{obj=window.CloseButton, x=3}
			self:skinEditBox{obj=window.Whisper, regs={9}, noHeight=true}
			window.Whisper:SetHeight(window.Whisper:GetHeight() + 6)
			self:skinSlider{obj=window.slider}
			x1, x2, y2 = -2, 2, -2
		end
		self:addSkinFrame{obj=window, x1=x1, y1=y1, x2=x2, y2=y2}
	end)

	 -- config window(s)
	if _G.Recount_ConfigWindow then
		self:moveObject{obj=_G.Recount_ConfigWindow.CloseButton, x=6}
		self:skinSlider{obj=_G.Recount_ConfigWindow_Scaling_Slider}
		self:skinSlider{obj=_G.Recount_ConfigWindow_RowHeight_Slider}
		self:skinSlider{obj=_G.Recount_ConfigWindow_RowSpacing_Slider}
		-- Colour subframe
		if _G.Recount_ConfigWindow.ColorOpt then
			for _, child in _G.pairs{_G.Recount_ConfigWindow.ColorOpt:GetChildren()} do
				if child.ResetColButton then
					self:skinButton{obj=child.ResetColButton}
				end
			end
		end
		x2, y2 = 5, -2
		self:addSkinFrame{obj=_G.Recount_ConfigWindow, x1=x1, y1=y1, x2=x2, y2=y2}
	end

	-- Windows, don't skin all buttons
	for _, type	in _G.pairs{"Main", "Detail", "Graph"} do
		self:addSkinFrame{obj=_G.Recount[type.."Window"], kfs=true, nb=true, x1=-2, y1=y1, x2=2, y2=-2}
		self:skinButton{obj=_G.Recount[type.."Window"].CloseButton, cb=true}
		self:moveObject{obj=_G.Recount[type.."Window"].CloseButton, x=2}

	end

	-- skin Realtime frames already created
	self.RegisterCallback("Recount", "UIParent_GetChildren", function(this, child)
		if child:IsObjectType("Frame")
		and child:GetName() == nil
		and child.Graph
		then
			self:addSkinFrame{obj=child, kfs=true, nb=true, x1=x1, y1=y1, x2=x2, y2=y2}
			self:skinButton{obj=child.CloseButton, cb=true}
			self:moveObject{obj=child.CloseButton, x=5}
		end
	end)

end
