require "UnLua"

local BP_AICharacter_C= Class("BP_CharacterBase_C")

function BP_AICharacter_C:Initialize(Initializer)
	self.Super.Initialize(self)
	self.Damage = 128.0
	--self.DamageType = UE4.UClass.Load("/Script/Engine.DamageType")
	self.DamageType = UE4.UClass.Load("UDamageType")
end

--function BP_AICharacter_C:UserConstructionScript()
--end

function BP_AICharacter_C:ReceiveBeginPlay()
	self.Super.ReceiveBeginPlay(self)
	self.Sphere.OnComponentBeginOverlap:Add(self, BP_AICharacter_C.OnComponentBeginOverlap_Sphere)
end

function BP_AICharacter_C:Died(DamageType)
	self.Super.Died(self, DamageType)
	self.Sphere:SetCollisionEnabled(UE4.ECollisionEnabled.NoCollision)
	local NewLocation = UE4.FVector(0.0, 0.0, self.CapsuleComponent.CapsuleHalfHeight)
	local SweepHitResult = UE4.FHitResult()
	self.Mesh:K2_SetRelativeLocation(NewLocation, false, SweepHitResult, false)
	self.Mesh:SetAllBodiesBelowSimulatePhysics(self.BoneName, true, true)
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	UE4.UBPI_Interfaces_C.NotifyEnemyDied(GameMode)
	--self.Sphere.OnComponentBeginOverlap:Remove(self, BP_AICharacter_C.OnComponentBeginOverlap_Sphere)
end

function BP_AICharacter_C:OnComponentBeginOverlap_Sphere(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep, SweepResult)
	local PlayerCharacter = OtherActor:Cast(UE4.ABP_PlayerCharacter_C)
	if PlayerCharacter then
		local Controller = self:GetController()
		UE4.UGameplayStatics.ApplyDamage(PlayerCharacter, self.Damage, Controller, self, self.DamageType)
	end
end

function BP_AICharacter_C:ReceiveDestroyed()
	self.Mesh:GetAnimInstance():Destroy()
end

return BP_AICharacter_C
