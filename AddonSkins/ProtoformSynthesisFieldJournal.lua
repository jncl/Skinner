local _, aObj = ...
if not aObj:isAddonEnabled("ProtoformSynthesisFieldJournal") then return end
local _G = _G

aObj.addonsToSkin.ProtoformSynthesisFieldJournal = function(self) -- v 1.2.1

	self:SecureHookScript(_G.ProtoformSynthesisFieldJournal, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, tabs=this.PanelTabs.Tabs, ignoreSize=true, lod=self.isTT and true, regions={5}, offsets={x1=10, y1=4, x2=-10, y2=4, track=false}})
		if self.isTT then
			local function skinTabs(tfObj)
				for _, tab in _G.ipairs(tfObj.Tabs) do
					if tab.isActive then
						aObj:setActiveTab(tab.sf)
					else
						aObj:setInactiveTab(tab.sf)
					end
				end
			end
			self:SecureHook(this, "UpdateTabs", function(fObj)
				skinTabs(fObj.PanelTabs)
			end)
			skinTabs(this.PanelTabs)
		end
		self:removeInset(this.List.Background)
		self:skinObject("slider", {obj=this.List.ScrollFrame.ScrollBar})
		local function skinList(sfObj)
			for _, btn in _G.pairs(sfObj.ScrollFrame.Buttons) do
				aObj:removeNineSlice(btn.NineSlice)
				aObj:skinObject("frame", {obj=btn, fb=true, ofs=1, clr="grey"})
			end
		end
		if not this.List.ScrollFrame.Buttons then
			self:SecureHook(this.List, "Update", function(fObj)
				skinList(fObj)
			end)
		else
			skinList(this.List)
		end
		self:removeInset(this.Settings.Background)
		self:skinObject("slider", {obj=this.Settings.ScrollFrame.ScrollBar})
		local function skinCBs(sfObj)
			for _, btn in _G.pairs(sfObj.ScrollFrame.Buttons) do
				if aObj.modChkBtns then
					aObj:skinCheckButton{obj=btn.CheckButton}
				end
			end
		end
		if not this.Settings.ScrollFrame.Buttons then
			self:SecureHook(this.Settings, "Update", function(fObj)
				skinCBs(fObj)
			end)
		else
			skinCBs(this.Settings)
		end
		self:skinObject("frame", {obj=this, kfs=true, cb=true, x2=1})

		self:Unhook(this, "OnShow")
	end)

end
