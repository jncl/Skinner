local _, aObj = ...
if not aObj:isAddonEnabled("ForeverBestiaryPetHunter") then return end
local _G = _G

aObj.addonsToSkin.ForeverBestiaryPetHunter = function(self) -- v 1.2.0

	for _, suffix in _G.pairs{"Changelog", "Toast", "Copy", "Reload", "Confirm", "Frame", "Report", "Tracker", "Update"} do
		self:add2Table(self.createFrames, {func = function(fObj)
			_G.RunNextFrame(function()
				self:skinObject("frame", {obj=fObj, kfs=true, ofs=4})
			end)
		end}, "FBPetHunter" .. suffix)
	end

end
