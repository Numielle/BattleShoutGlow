if UnitClass("player") == "Warrior" then

local BSA_Texture = "Interface\\Icons\\Ability_Warrior_BattleShout";
local BSA_HaveBS = false;
local BSA_InCombat = false;

local function BSA_Add(button)
	if BSA_InCombat and not BSA_HaveBS then
		ABG_AddOverlay(button);
	end
end

local function BSA_Remove(button)
	ABG_RemoveOverlay(button);
end

local BSA_Frame = CreateFrame("Frame", nil, UIParent);
BSA_Frame:SetScript("OnEvent", function() 
	if event == "PLAYER_REGEN_DISABLED" then
		BSA_InCombat = true;

		ABI_Trigger(BSA_Texture, BSA_Add);
	elseif event == "PLAYER_REGEN_ENABLED" then
		BSA_InCombat = false;

		ABI_Trigger(BSA_Texture, BSA_Remove);
	elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
		if arg1 == "You gain Battle Shout." then
			BSA_HaveBS = true;

			ABI_Trigger(BSA_Texture, BSA_Remove);
		end
	elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" then
		if arg1 == "Battle Shout fades from you." then
			BSA_HaveBS = false;

			ABI_Trigger(BSA_Texture, BSA_Add);
		end
	elseif event == "PLAYER_LOGIN" then
		ABI_Register(BSA_Texture, BSA_Add, BSA_Remove);

		-- initial scan during login/reload to determine if battle shout is active
		for n = 1, 40 do
			local texture = UnitBuff("player", n);

			if texture and texture == BSA_Texture then
				BSA_HaveBS = true;
			end
		end
	end
end);
BSA_Frame:RegisterEvent("PLAYER_REGEN_ENABLED");
BSA_Frame:RegisterEvent("PLAYER_REGEN_DISABLED");
BSA_Frame:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF");
BSA_Frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS");
BSA_Frame:RegisterEvent("PLAYER_LOGIN");

end
