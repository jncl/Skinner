
function Skinner:LauncherMenu()

	-- first get the ldb dataobject
	local lm = LibStub('LibDataBroker-1.1'):GetDataObjectByName("LauncherMenu")
	
	-- then hook the OnClick function, where the frame is created
	-- N.B. DON'T use SecureHook it doesn't work here
	self:Hook(lm, "OnClick", function(frame)
--		self:Debug("LauncherMenu OnClick: [%s]", frame)
		self.hooks[lm].OnClick(frame)
		-- now find the menu frame
		for i = 1, UIParent:GetNumChildren() do
			local obj = select(i, UIParent:GetChildren())
			if obj and obj:GetName() == nil and obj.buttons and obj.numButtons then
				self:applySkin{obj=obj}
				-- hook the frame's OnShow script to adjust gradient as required
				self:HookScript(obj, "OnShow", function(this)
					self.hooks[obj].OnShow(this)
					self:applyGradient(obj)
				end)
				break
			end
		end
		self:Unhook(lm, "OnClick")
	end)
	
end
