require "game"

--this is hacky but it'll work for us
function game:loadLevel(num)
	breadSpawnTimer = 3
	if num == 1 then

		--backgrounds
		self:addEnt(background, {200,410,0.15,0.15,"mountains1"})
		self:addEnt(background, {500,400,0.15,0.15,"tree2"})
		self:addEnt(background, {50,50,0.15,0.15,"cloud1"})
		self:addEnt(background, {600,150,0.15,0.15,"cloud2"})

		--platforms
		self:addEnt(platform,{-100, gameHeight-40, gameWidth+200, 40, 1, "ground", 0.8, 0.5, 0, 40})

		--enemies
		self:addEnt(breadman,{500, gameHeight - 80, false})
		self:addEnt(breadman,{200, gameHeight - 80, false})
		numEnemies = 2
		self:addEnt(poptart,{gameWidth/2-250, gameHeight - 200, 1})
		numEnemies = 3
		numSpecial = 0

	end

	if num == 2 then

		--backgrounds
		--{x, y, scalex, scaley, img}
		self:addEnt(background, {400,370,0.15,0.15,"mountains2"})
		self:addEnt(background, {0,340,0.15,0.15,"tree1"})
		self:addEnt(background, {50,50,0.15,0.15,"cloud1"})
		self:addEnt(background, {600,150,0.15,0.15,"cloud2"})
		self:addEnt(background, {300-100,460,0.15,0.15,"pillar"})
		self:addEnt(background, {gameWidth-150-100,460,0.15,0.15,"pillar"})

		--platforms
		--{x, y, width, height, unique number, img, scalex, scaley, x-offset, y-offset}
		self:addEnt(platform,{-100, gameHeight-40, gameWidth+200, 40, 1, "ground", 0.8, 0.5, 0, 40})
		self:addEnt(platform,{150, 460, 150, 20, 2, "platform", 0.15, 0.15, 100, 10})
		self:addEnt(platform,{gameWidth-300, 460, 150, 20, 3, "platform", 0.15, 0.15, 100, 10})

		--enemies
		--{x, y, hasParachute}
		self:addEnt(breadman,{500, gameHeight - 180, false})
		self:addEnt(breadman,{200, gameHeight - 180, false})
		numEnemies = 2
		numSpecial = 0

		spawnQueue = {"top", "side"}

	end

	if num == 3 then

		--backgrounds
		--{x, y, scalex, scaley, img}
		self:addEnt(background, {400,370,0.15,0.15,"mountains2"})
		self:addEnt(background, {0,340,0.15,0.15,"tree1"})
		self:addEnt(background, {50,50,0.15,0.15,"cloud1"})
		self:addEnt(background, {600,150,0.15,0.15,"cloud2"})
		self:addEnt(background, {380,350,0.15,0.3,"pillar"})
		self:addEnt(background, {gameWidth-100,460,0.15,0.15,"pillar"})

		--platforms
		--{x, y, width, height, unique number, img, scalex, scaley, x-offset, y-offset}
		self:addEnt(platform,{-100, gameHeight-40, gameWidth/2, 40, 1, "ground", 0.8, 0.5, 890, 40})
		self:addEnt(platform,{gameWidth/2+100, gameHeight-40, gameWidth/2, 40, 1, "ground", 0.8, 0.5, 0, 40})
		self:addEnt(platform,{250, 350, 310, 20, 2, "platform", 0.3, 0.15, 100, 10})
		self:addEnt(platform,{gameWidth-150, 460, 150, 20, 3, "platform", 0.15, 0.15, 100, 10})

		--enemies
		--{x, y, hasParachute}
		self:addEnt(breadman,{500, gameHeight - 180, false})
		self:addEnt(breadman,{200, gameHeight - 180, false})
		numEnemies = 2
		numSpecial = 0

		spawnQueue = {"top", "top", "side", "top", "side"}

	end

	if num == 4 then

		--backgrounds
		--{x, y, scalex, scaley, img}
		self:addEnt(background, {450,415,0.15,0.15,"mountains1"})--Mountain1 needs 45 more vertical
		self:addEnt(background, {0,370,0.15,0.15,"mountains2"})
		self:addEnt(background, {0,400,0.15,0.15,"tree2"}) --tree2 are short and need 60 extra vertical
		self:addEnt(background, {150,340,0.15,0.15,"tree1"})
		self:addEnt(background, {420,340,0.15,0.15,"tree1"})
		self:addEnt(background, {80,80,0.15,0.15,"cloud2"})
		self:addEnt(background, {700,200,0.15,0.15,"cloud1"})
		self:addEnt(background, {630,300,0.15,0.15,"cloud1"})
		self:addEnt(background, {280,450,0.15,0.3,"pillar"})
		self:addEnt(background, {520,450,0.15,0.3,"pillar"})
		self:addEnt(background, {gameWidth-100,400,0.15,0.15,"tree2"})

		--platforms
		--{x, y, width, height, unique number, img, scalex, scaley, x-offset, y-offset}
		self:addEnt(platform,{-100, gameHeight-40, gameWidth+200, 40, 1, "ground", 0.8, 0.5, 0, 40})
		self:addEnt(platform,{200, 450, 250, 20, 2, "platform", 0.2, 0.15, 100, 10})
		self:addEnt(platform,{430, 450, 207, 20, 2, "platform", 0.2, 0.15, 100, 10})

		--enemies
		--{x, y, hasParachute}
		self:addEnt(breadman,{gameWidth-400, gameHeight - 220, false})
		numEnemies = 1
		numSpecial = 0

		spawnQueue = {"bagel","side","side","side","poptart","side","side","side"}
		--goes in reverse order because i'm lazy

	end


	if num == 5 then

		--backgrounds
		--{x, y, scalex, scaley, img}
		self:addEnt(background, {500,370,0.15,0.15,"mountains2"})
		self:addEnt(background, {0,340,0.15,0.15,"tree1"})
		self:addEnt(background, {50,50,0.15,0.15,"cloud1"})
		self:addEnt(background, {600,150,0.15,0.15,"cloud2"})
		self:addEnt(background, {gameWidth-150,430,0.15,0.15,"pillar"})

		--platforms
		--{x, y, width, height, unique number, img, scalex, scaley, x-offset, y-offset}
		self:addEnt(platform,{0, gameHeight-40, gameWidth/2, 40, 1, "ground", 0.8, 0.5, 890, 40})
		self:addEnt(platform,{gameWidth/2+100, gameHeight-40, gameWidth/2, 40, 1, "ground", 0.8, 0.5, 0, 40})
		self:addEnt(platform,{gameWidth-250, 400, 300, 20, 3, "platform", 0.25, 0.15, 100, 10})

		--enemies
		--{x, y, hasParachute}
		--TODO: ADD LOAF
		--self:addEnt(loaf,{gameWidth-159, 459, false})
		self:addEnt(breadman,{500, gameHeight - 180, false})
		self:addEnt(breadman,{200, gameHeight - 180, false})
		numEnemies = 2
		numSpecial = 1

		spawnQueue = {"loaf","blank","blank","bagel"}

	end


--Second Set of Stages (forest) begins here:

	if num == 6 then

		--backgrounds
		--{x, y, scalex, scaley, img}
		self:addEnt(background, {-50,-25,1,1.25,"sky-green"})
		--large trees
		self:addEnt(background, {-20,-30,0.75,0.4,"vine1"})
		self:addEnt(background, {-75,-25,0.25,0.4,"ftree1"})
		self:addEnt(background, {-10,-25,0.25,0.4,"ftree3"})
		self:addEnt(background, {55,-25,0.25,0.4,"ftree1"})	
		self:addEnt(background, {110,-25,0.25,0.4,"ftree3"})
		self:addEnt(background, {175,-25,0.25,0.4,"ftree1"})
		self:addEnt(background, {240,-25,0.25,0.4,"ftree3"})
		self:addEnt(background, {530,-25,0.25,0.4,"ftree1"})
		self:addEnt(background, {595,-25,0.25,0.4,"ftree3"})
		self:addEnt(background, {650,-25,0.25,0.4,"ftree1"})
		--Now begins closer background objects
		self:addEnt(background, {0,340,0.15,0.15,"ftree1"})



		self:addEnt(background, {100,520,0.15,0.15,"wheat1"})

		self:addEnt(background, {200,440,0.15,0.15,"ftree3"})

		self:addEnt(background, {300,420,0.15,0.15,"wheat3"})

		self:addEnt(background, {699,440,0.15,0.15,"ftree5"})

		self:addEnt(background, {550,440,0.15,0.15,"ftree2"})
		self:addEnt(background, {500,370,0.15,0.15,"ftree1"})
		self:addEnt(background, {50,-10,0.15,0.15,"vine1"})
		self:addEnt(background, {100,-10,0.15,0.2,"vine2"})
		self:addEnt(background, {600,-10,0.15,0.15,"vine2"})
		self:addEnt(background, {500,420,0.15,0.15,"wheat2"})

		--platforms
		--{x, y, width, height, unique number, img, scalex, scaley, x-offset, y-offset}
		self:addEnt(platform,{0, gameHeight-40, gameWidth/2, 40, 1, "ground3", 1.4, 0.4, 890, 40})
		self:addEnt(platform,{gameWidth/2+100, gameHeight-40, gameWidth/2, 40, 1, "ground3", 0.8, 0.35, 0, 40})
		self:addEnt(platform,{gameWidth-250, 460, 300, 20, 3, "platform", 0.25, 0.15, 100, 10})
		self:addEnt(platform,{-100, gameHeight-40, gameWidth+200, 40, 1, "ground2", 0.8, 0.5, 0, 40})

		--enemies
		--{x, y, hasParachute}
		--TODO: ADD LOAF
		--self:addEnt(loaf,{gameWidth-159, 459, false})
		self:addEnt(breadman,{500, gameHeight - 180, false})
		self:addEnt(breadman,{200, gameHeight - 180, false})
		numEnemies = 2
		numSpecial = 0

		--spawnQueue = {"RIGHTSIDEINFINITE", "TOPINFINITE", "LOAF"}

	end


end

function game:nextLevel()
	currentLevel = currentLevel + 1
	for i=2, #ent do ent[i].die = true end
	p.x = 0
	self:loadLevel(currentLevel)
end