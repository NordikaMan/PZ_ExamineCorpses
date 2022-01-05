function ExamineCorpse(items, result, player)
	local sickMult = 1.0;
	local happyMult = 1.0;
	local doctorSkillMult = math.max(player:getPerkLevel(Perks.Doctor), 1.0);
	
	happyMult = happyMult - (doctorSkillMult / 15);
	sickMult = sickMult - (doctorSkillMult / 20);

	if player:HasTrait("Desensitized") then
		happyMult = 0.8;
		sickMult = 0.8;
	end
	
	if player:HasTrait("Hemophobic") then
		happyMult = 1.2;
		sickMult = 1.2;	
	end

	player:getXp():AddXP(Perks.Doctor, 9 * doctorSkillMult); -- xp is getting divided by 4 for some reason
	
	local bodyDamage = player:getBodyDamage();
	if bodyDamage:getFoodSicknessLevel() + 60 * sickMult >= 90 then
        bodyDamage:setFoodSicknessLevel(90);
    else
        bodyDamage:setFoodSicknessLevel(bodyDamage:getFoodSicknessLevel() + 60 * sickMult);
    end

	if bodyDamage:getUnhappynessLevel() + 35 * happyMult >= 100 then
        bodyDamage:setUnhappynessLevel(100);
    else
        bodyDamage:setUnhappynessLevel(bodyDamage:getUnhappynessLevel() + 35 * happyMult);
    end

end

function ExamineCorpseSurgically(items, result, player)
	local sickMult = 1.0;
	local happyMult = 1.0;
	local doctorSkillMult = math.max(player:getPerkLevel(Perks.Doctor), 1.0);
	
	happyMult = happyMult - (doctorSkillMult / 15);
	sickMult = sickMult - (doctorSkillMult / 20);
	
	if player:HasTrait("Desensitized") then
		happyMult = 0.55;
		sickMult = 0.55;
	end

	if player:HasTrait("Hemophobic") then
		happyMult = 1.1;
		sickMult = 1.1;
	end

	player:getXp():AddXP(Perks.Doctor, 20 * doctorSkillMult);

	local bodyDamage = player:getBodyDamage();
	if bodyDamage:getFoodSicknessLevel() + 25 * sickMult >= 90 then
        bodyDamage:setFoodSicknessLevel(90);
    else
        bodyDamage:setFoodSicknessLevel(bodyDamage:getFoodSicknessLevel() + 25 * sickMult);
    end

	if bodyDamage:getUnhappynessLevel() + 15 * happyMult >= 100 then
        bodyDamage:setUnhappynessLevel(100);
    else
        bodyDamage:setUnhappynessLevel(bodyDamage:getUnhappynessLevel() + 15 * happyMult);
    end
end