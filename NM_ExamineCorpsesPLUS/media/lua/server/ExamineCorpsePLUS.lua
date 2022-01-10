local lvlcurveXPValues = {20,20,20,20,25,50,60,60,80,80}; -- XP given depending on current level of firstaid
local xpRequiredPerLevel = {75,150,300,750,1500,3000,4500,6000,7500,9000}; -- XP needed for next level

local modSettings = ExamineCorpses_global.SETTINGS
local ExaminationsRequiredFactorSettings = {5,2,1,0.5}; -- must match up to the array from mod settings

function ExamineCorpse(items, result, player)
	local action_type = "examine"
	AwardExamineXP(items, result, player, action_type);
	AffectPlayerMood(items, result, player, action_type);
end

function ExamineCorpseSurgically(items, result, player)
	local action_type = "examine_surgically"
	AwardExamineXP(items, result, player, action_type);
	AffectPlayerMood(items, result, player, action_type);
end

function AwardExamineXP(items, result, player, type_of_action)
	
	-- Get Base XP reward for current First Aid level and mod settings
	local actionType = type_of_action;
	local ExaminationsRequiredFactor = tonumber(ExaminationsRequiredFactorSettings[tonumber(modSettings.options.dropdown1)]);

	local XPAward = tonumber(lvlcurveXPValues[tonumber(player:getPerkLevel(Perks.Doctor)) + 1]);
	XPAward = XPAward / ExaminationsRequiredFactor;
	-- surgical examinations earn more XP (double)
	if type_of_action == "examine_surgically" then
		XPAward = XPAward * 2;
	end

	-- Apply Skillbook multipliers to XP award
	XPAward = XPAward * (1 + player:getXp():getMultiplier(Perks.Doctor)); -- Skillbook multiplier is additive so multiplier of 3 means times 4

	-- Get maximum XP to give for current First Aid level and mod settings so we force a minimum number of examinations per level of firstaid earned
	local xpRequiredForLevel = tonumber(xpRequiredPerLevel[tonumber(player:getPerkLevel(Perks.Doctor) + 1)]);
	local clampXP = xpRequiredForLevel / (10 * ExaminationsRequiredFactor);

	-- Adjust Clamp XP to make up for profression / trait perk bonuses
	local perkBoostLevel = player:getXp():getPerkBoost(Perks.Doctor)
	if perkBoostLevel == 0 then
		clampXP = clampXP * 4; -- 25% XP gain, so clamp should be 4 times higher
	elseif perkBoostLevel == 1 then
		clampXP = clampXP * 1; -- 100% XP gain, so clamp is already the right value
	elseif perkBoostLevel == 2 then
		clampXP = clampXP * 0.8; -- 125% XP gain, so clamp should be 80%
	elseif perkBoostLevel == 3 then
		clampXP = clampXP * 0.66; -- 150% XP gain, so clamp should be 66%
	end

	-- XP Award to be no more than clampXP
	XPAward = math.min(XPAward, clampXP);

	-- Give XP to player -- This will not apply skillbook modifier but it does apply the Perk modifier hence why we adjusted clamping
	player:getXp():AddXPNoMultiplier(Perks.Doctor, XPAward);

end

function AffectPlayerMood(items, result, player, type_of_action)
	local sickMult = 1.0;
	local happyMult = 1.0;
	local doctorSkillMult = math.max(player:getPerkLevel(Perks.Doctor), 1.0);

	if player:HasTrait("Desensitized") then
		happyMult = 0.8;
		sickMult = 0.8;
	end
	
	if player:HasTrait("Hemophobic") then
		happyMult = 1.2;
		sickMult = 1.2;	
	end

	local sickValue = 60;
	local happyValue = 35;

	if type_of_action == 'examine_surgically' then
		sickValue = 25;
		happyValue = 15;
	end

	happyMult = happyMult - (doctorSkillMult / 15);
	sickMult = sickMult - (doctorSkillMult / 20);
	
	local bodyDamage = player:getBodyDamage();
	if bodyDamage:getFoodSicknessLevel() + (sickValue * sickMult) >= 90 then
        bodyDamage:setFoodSicknessLevel(90);
    else
        bodyDamage:setFoodSicknessLevel(bodyDamage:getFoodSicknessLevel() + (sickValue * sickMult));
    end

	if bodyDamage:getUnhappynessLevel() + (happyValue * happyMult) >= 100 then
        bodyDamage:setUnhappynessLevel(100);
    else
        bodyDamage:setUnhappynessLevel(bodyDamage:getUnhappynessLevel() + (happyValue * happyMult));
    end

end