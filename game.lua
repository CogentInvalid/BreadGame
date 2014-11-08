local gamera = require "libs/gamera" --game camera lib
local bump = require "libs/bump" --rectangle collisions
require "collisions"
require "entities/player"
require "entities/platform"
require "entities/breadman"
require "entities/background"
require "entities/projectile"

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
require "ui"

function game:init()

	--game world (for collisions)
	self.world = bump.newWorld()

	--entities
	ent = {}
	p = self:addEnt(player,{20,20}) --"p" always refers to the player

	--draw order
	self.drawOrder = {"background", "platform", "breadman", "player", "projectile"}

	--load level
	self:loadLevel(1) --in levels.lua

	--camera
	cam = gamera.new(-10000,-10000,gameWidth+20000,gameHeight+20000)
	--cam:setScale(0.8)
	cam:setPosition(gameWidth/2, gameHeight/2)
	camx = round(cam.x,2); camy = round(cam.y,2)
	camAngle = 0
	screenShake = 0

	--bread slot
	breadSlots = {}
	for i=1, 3 do breadSlots[i] = breadSlot:new("none", ((i-1)*131)+235, 50) end
	self.uiFlash = 0

	--bread spawning
	breadSpawnTimer = 3

	self.showHitboxes = false

	--timestep stuff
	dt = 0.01
	accum = 0
	frame = 0

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

		--ui
		self:updateUI()

		--enemy spawning
		breadSpawnTimer = breadSpawnTimer - dt
		if breadSpawnTimer < 0 then
			local xPos = math.random(0, gameWidth - 40)
			self:addEnt(breadman,{xPos, -40, true})
			breadSpawnTimer = 3

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

		--update animations
		for i, anim in pairs(animation) do
			anim:update(dt)
		end

		accum = accum - 0.01
	end
	if accum>0.1 then accum = 0 end
end

--find breadmen near ground pound at x, y and launch them into the air
function game:pound(x, y, num)
	for i,entity in ipairs(ent) do
		if entity.id == "breadman" and entity.standingOn == num then
			if math.abs(entity.y+entity.h - y) < 10 then
				entity.y = entity.y - 5
				local distance = math.abs(entity.x+entity.w/2-x)
				local magnitude = math.pow(2, -0.005*distance)
				entity.vy = -450*magnitude
				entity.vx = entity.vx*magnitude*2
				entity.moveDir = getSign(entity.vx)
			end
		end
	end
end

--eject bread from last slot
function game:ejectBread()
	if breadSlots[3].type ~= "none" then
		if breadSlots[3].health < 33 then
			self:addEnt(projectile,{p.x, p.y, 40, 40, true, "bread-dead-black", p.moveDir*400+p.vx/2, -10+p.vy/2, 100})
		else
			self:addEnt(projectile,{p.x, p.y, 40, 40, false, breadSlots[3].imgName, p.moveDir*40+p.vx/2, -200+p.vy/2, 500})
		end
		self:removeBread(3)
		self.uiFlash = 255
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

		--love.graphics.setColor(100,100,255)
		--love.graphics.rectangle("fill", -20, -20, gameWidth+40, gameHeight+40)

		love.graphics.setColor(255,255,255)
		love.graphics.draw(img["sky-blue"], -20, -20, 0, 0.5, 0.5)

		for j,layer in ipairs(self.drawOrder) do
			for i=1, #ent do
				if ent[i].id == layer then ent[i]:draw() end
			end
		end

		--ui
		self:drawUI()

		--debug
		love.graphics.setColor(0,0,0)
		love.graphics.print(love.mouse.getX(), 10, 10)
		love.graphics.print(love.mouse.getY(), 10, 25)
	end)
end

function game:keypressed(key)
	if key == bind["jump"] then p:jump() end
	if key == bind["down"] and (not p.onGround) then
		p.pounding = true
		animation["toaster-groundpound"]:gotoFrame(1)
		animation["toaster-groundpound"]:resume()
	end
	if key == bind["attack"] then self:ejectBread() end
	if key == "p" then self.showHitboxes = not self.showHitboxes end
end