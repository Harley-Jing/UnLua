require "UnLua"

local UMG_Main_C = Class()

function UMG_Main_C:Construct()
	self.ExitButton.OnClicked:Add(self, UMG_Main_C.OnClicked_ExitButton)	
	--self.ExitButton.OnClicked:Add(self, function(Widget) UE4.UKismetSystemLibrary.ExecuteConsoleCommand(Widget, "exit") end )
end

function UMG_Main_C:OnClicked_ExitButton()
	UE4.UKismetSystemLibrary.ExecuteConsoleCommand(self, "exit")
end

function UMG_Main_C:Destruct()
	self:Destroy()
end

return UMG_Main_C
