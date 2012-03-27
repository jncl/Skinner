local aName, aObj = ...
if not aObj:isAddonEnabled("FeedMachine") then return end
if not aObj.uCls == "HUNTER" then return end

function aObj:FeedMachine()

	self:SecureHook(FeedMachine, "FMUI_Show", function()
		-- Main Frame
		self:keepRegions(FMUIMainFrame, {6, 7, 8, 9, 10}) -- N.B. 6 - 9 are the background textures
		self:addSkinFrame{obj=FMUIMainFrame, x1=10, y1=-12, x2=-31, y2=71}
		-- Food Tab
		for i = 4, 17 do
			self:getChild(FeedMachineUI_Food_Frame, i):DisableDrawLayer("BACKGROUND")
		end
		self:skinDropDown(FMFoodButtonDropDown)
		self:skinScrollBar(FeedMachineUI_ScrollFrame)
		for i = 1, 7 do
			self:addButtonBorder{obj=_G["FMFoodButton"..i.."Button"]}
		end
		-- Diets Tab
		for i = 2, 15 do
			self:getChild(FeedMachineUI_Diets_Frame, i):DisableDrawLayer("BACKGROUND")
		end
		self:skinScrollBar(FeedMachineUI_Diets_ScrollFrame)
		for i = 1, 7 do
			self:addButtonBorder{obj=_G["FMDietButton"..i.."Button"]}
		end
		-- Tabs
		self:skinTabs{obj=FMUIMainFrame, lod=true}
		self:Unhook(FeedMachine, "FMUI_Show")
	end)

end
