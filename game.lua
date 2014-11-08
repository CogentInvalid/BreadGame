local gamera = require "libs/gamera" --game camera lib
local bump = require "libs/bump" --rectangle collisions
require "collisions"
require "entities/player"
require "entities/platform"
require "entities/breadman"

--every entity requires:
--self.id - identifier (e.g. player, breadman)
--self.col - true if this collides with anything
--self.rcol - true if anything collides with this
--self.die - initialize to false; set to true to delete entity
--self:update(dt) - update function
--self:draw() - draw function

--if self.col or self.rcol is true, then you also need:
--self.x, self.y - position
--self.py, self.py - your position last frame
--self.w, self.h - width and height
--self.collideOrder - just make it {isReal}
--self:resolveCollision(entity, dir) - a function used to deal with collisions

game = class:new()

require "breadSlot"

function game:init()

	--game world (for collisions)
	self.world = bump.newWorld()

	--entities
	ent = {}
	p = self:addEnt(player,{20,20})
	p = ent[1]
	self:addEnt(platform,{0, gameHeight-20, gameWidth, 40})
	self:addEnt(breadman,{20, gameHeight - 80})
	self:addEnt(breadman,{100, gameHeight - 80})

	--camera
	cam = gamera.new(-10000,-10000,gameWidth+20000,gameHeight+20000)
	--cam:setScale(0.8)
	cam:setPosition(gameWidth/2, gameHeight/2)
	camx = round(cam.x,2); camy = round(cam.y,2)
	camAngle = 0
	screenShake = 0

	--bread slot
	breadSlots = {}
	for i=1, 3 do breadSlots[i] = breadSlot:new("none", gameWidth/2 + (i-2)*200-50, 50) end

	--bread spawning
	breadSpawnTimer = 3

	self.showHitboxes = false

	--timestep stuff
	dt = 0.01
	accum = 0
	frame = 0

	--debug
	img = {}
	img["gif2"] = love.graphics.newImage("resources/gif2.gif")
	grid = anim8.newGrid(20, 20, 20, 20, 0, 0, 0)
	anim = anim8.newAnimation(grid('1-1',1), 0.1)

end

function game:update(delta)

	accum = accum + delta
	if accum > 0.05 then accum = 0.05 end
	while accum >= delta do

		--camera stuff
		if screenShake > 0 then screenShake = screenShake - 20*dt end
		if screenShake < 0 then screenShake = 0 end
		local camx = cam.x; local camy = cam.y
		camx = camx + randSign()*0.5*screenShake
		camy = camy + randSign()*0.5*screenShake
		camx = camx - (camx - gameWidth/2)*3*dt
		camy = camy - (camy - gameHeight/2)*3*dt
		cam:setPosition(camx, camy)

		--bread slots
		self:updateBreadSlots(dt) --in breadSlot.lua

		--enemy spawning
		breadSpawnTimer = breadSpawnTimer - dt
		if breadSpawnTimer < 0 then
			--spawn breadman
		end

		--iterate over every entity "entity" in the game
		for i, entity in ipairs(ent) do
			entity:update(dt)
			--for i, comp in ipairs(entity.component) do comp:update(ent[num], dt) end
			if entity.col or entity.rcol then self.world:move(entity, entity.px, entity.py, entity.w, entity.h) end
			if entity.die then self:removeEnt(i) end
		end

		--collide stuff
		for i=1, #ent do
			if ent[i].col then genericCollide(ent[i], ent[i].collideOrder) end
		end

		--debug
		anim:update(dt)

		accum = accum - 0.01
	end
	if accum>0.1 then accum = 0 end
end

--find breadmen near ground pound at x, y and launch them into the air
function game:pound(x, y)
	for i,entity in ipairs(ent) do
		if entity.id == "breadman" then
			if math.abs(entity.y+entity.h - y) < 10 then
				entity.y = entity.y - 5
				local distance = math.abs(entity.x+entity.w/2-x)
				local magnitude = math.pow(2, -0.005*distance)
				entity.vy = -600*magnitude
			end
		end
	end
end

function game:addEnt(type, args)
	local entity = type:new(args)
	ent[#ent+1] = entity
	if entity.rcol then end-- rcol[#ent] = entity else rcol[#ent] = 0 end
	if entity.col or entity.rcol then self.world:add(entity, entity.x, entity.y, entity.w, entity.h) end
	return entity
end

function game:removeEnt(num)
	--for i, comp in ipairs(ent[num].component) do comp:die(ent[num]) end
	if ent[num].col or ent[num].rcol then self.world:remove(ent[num]) end
	table.remove(ent, num)
	--table.remove(rcol, num)
end

function game:draw()
	cam:draw(function(l,t,w,h)
		love.graphics.setColor(100,100,255)
		love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)
		for i=1, #ent do
			ent[i]:draw()
		end

		for i=1, 3 do
			breadSlots[i]:draw()
		end

		love.graphics.setColor(255,255,255)
		--love.graphics.draw(img["gif2"], 10, 10)
		anim:draw(img["gif2"], 100, 200)
	end)
end

function game:keypressed(key)
	if key == bind["jump"] then p:jump() end
	if key == bind["down"] and (not p.onGround) then p.pounding = true end
	if key == "p" then self.showHitboxes = not self.showHitboxes end
end