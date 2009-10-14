local ipairs = ipairs

function Skinner:LauncherMenu()

	-- first get the ldb dataobject
	local lm = LibStub('LibDataBroker-1.1'):GetDataObjectByName("LauncherMenu")
	
	-- then hook the OnClick function, where the frame is created
	-- N.B. DON'T use SecureHook it doesn't work here
	self:Hook(lm, "OnClick", function(frame)
--		self:Debug("LauncherMenu OnClick: [%s]", frame)
		self.hooks[lm].OnClick(frame)
		-- now find the menu frame
		local kids = {UIParent:GetChildren()}
		for _, child in ipairs(kids) do
			if child and child:GetName() == nil and child.buttons and child.numButtons then
				self:applySkin{obj=child}
				-- hook the frame's OnShow script to adjust gradient as required
				self:HookScript(child, "OnShow", function(this)
					self.hooks[child].OnShow(this)
					self:applyGradient(child)
				end)
				break
			end
		end
		kids = nil
		self:Unhook(lm, "OnClick")
	end)
	
end
