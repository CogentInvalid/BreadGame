local gamera = require "gamera" --game camera lib
local bump = require "bump" --rectangle collisions
require "collisions"
require "player"
require "platform"
require "breadman"

game = class:new()

function game:init()

	--game world (for collisions)
	self.world = bump.newWorld()

	--entities
	ent = {}
	p = self:addEnt(player,{20,20})
	p = ent[1]
	self:addEnt(platform,{0, gameHeight-20, gameWidth, 40})
	self:addEnt(breadman,{20, gameHeight - 80})

	--camera
	cam = gamera.new(-10000,-10000,gameWidth+20000,gameHeight+20000)
	--cam:setScale(0.8)
	cam:setPosition(gameWidth/2, gameHeight/2)
	camx = round(cam.x,2); camy = round(cam.y,2)
	camAngle = 0
	screenShake = 0

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

		--cam:setPosition(love.mouse.getX(), love.mouse.getY())

		--camAngle = camAngle + dt
		cam:setAngle(camAngle)

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
		love.graphics.setColor(0,20,0)
		love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)
		for i=1, #ent do
			ent[i]:draw()
		end
	end)
end

function game:keypressed(key)
	if key == bind["jump"] then p:jump() end
	if key == bind["down"] and (not p.onGround) then p.pounding = true end
	if key == "p" then self.showHitboxes = not self.showHitboxes end
end