local AimbotEnabled = CreateClientConVar("aimbot_enabled", "0", false, false)
local Aimbot_WorldTrace = CreateClientConVar("aimbot_worldtrace", "0", false, false);

local CurrentTarget = nil;
local TargetBone = "ValveBiped.Bip01_Head1";
local DefaultAimbotPos = Vector(0,35,0);


local function GetTarget(dotRange)
	dotRange = (dotRange ~= nil and dotRange or .985);
	if ( CurrentTarget) then 
		return CurrentTarget;
	end
	if Aimbot_WorldTrace:GetInt() > 0 then 
		return LocalPlayer():GetEyeTrace().Entity;
	else 
		local temporaryTarget;
		local aimVec = LocalPlayer():GetAimVector()
		local lDot = -1;
		for i, v in pairs( player.GetAll() ) do
			if ( v ~= LocalPlayer() ) then
				local Dir = v:GetShootPos() - lp:GetShootPos();
				Dir:Normalize();
				local Dot = Dir:Dot(aimVec);
				
				if Dot > lDot and Dot > dotRange and v:Alive() then
					lDot = Dot;
					temporaryTarget = v;
				end
			end
		end
		return temporaryTarget;
	end
end

hook.Add("CreateMove", "Somebody once told me the world was gonna roll me, I ain't the sharpest tool in the shed. She was lookin' kinda dumb with her finger and her thumb in the shape of an L on her forehead", function(cmd) 
	local Target = GetTarget();
	
	if ( AimbotEnabled:GetInt() > 0 and cmd:KeyDown( IN_USE ) ) then 
		CurrentTarget = Target;
		local Bone = CurrentTarget:LookupBone( TargetBone );
		local Pos = Target:GetBonePosition( Bone ) or DefaultAimbotPos;
		
		cmd:SetViewAngles( (Pos - LocalPlayer():GetShootPos()):Angle() )
		
	else
		CurrentTarget = nil;
	end
	
end)
