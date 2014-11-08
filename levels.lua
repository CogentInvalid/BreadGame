require "game"

--this is hacky but it'll work for us
function game:loadLevel(num)
	if num == 1 then

		--backgrounds
		self:addEnt(background, {400,370,0.15,0.15,"mountains2"})
		self:addEnt(background, {0,340,0.15,0.15,"tree1"})
		self:addEnt(background, {50,50,0.15,0.15,"cloud1"})
		self:addEnt(background, {600,150,0.15,0.15,"cloud2"})
		self:addEnt(background, {300-100,460,0.15,0.15,"pillar"})
		self:addEnt(background, {gameWidth-150-100,460,0.15,0.15,"pillar"})

		--platforms
		self:addEnt(platform,{-100, gameHeight-40, gameWidth+200, 40, 1, "ground", 0.8, 0.5, 0, 40})
		self:addEnt(platform,{150, 460, 150, 20, 2, "platform", 0.15, 0.15, 100, 10})
		self:addEnt(platform,{gameWidth-300, 460, 150, 20, 3, "platform", 0.15, 0.15, 100, 10})

		--enemies
		self:addEnt(breadman,{500, gameHeight - 80, false})
		self:addEnt(breadman,{200, gameHeight - 80, false})

	end
end