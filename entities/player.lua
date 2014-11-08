player = class:new()

function player:init(args)

	self.id = "player"

	self.x = args[1]
	self.y = args[2]
	self.px = self.x; self.py = self.y --player's position last frame
	self.vx = 0; self.vy = 0 --velocity
	self.w = 60; self.h = 40 --width/height

	self.maxSpeed = 200 --horizontal movement speed
	self.airControl = false --can player use variable jump height?
	self.onGround = false
	self.standingOn = 0

	self.hp = 100

	--does it collide with things
	self.col = true
	--do other things collide with it
	self.rcol = true
	self.collideOrder = {isReal} --no need to prioritize certain collisions

	--delete this next frame?
	self.die = false
end

function player:update(dt)

	--level bounds
	if self.x < 0 then
		self.x = 0
		self.vx = -self.vx
	end
	if self.x+self.w > gameWidth then
		self.x = gameWidth-self.w
		self.vx = -self.vx
	end

	--movement
	if not love.keyboard.isDown("c") then
		if love.keyboard.isDown(bind["left"]) and self.vx > -self.maxSpeed then
			self.vx = self.vx-1500*dt
			if self.vx < -self.maxSpeed then self.vx = -self.maxSpeed end
		end
		if love.keyboard.isDown(bind["right"]) and self.vx < self.maxSpeed then
			self.vx = self.vx+1500*dt
			if self.vx > self.maxSpeed then self.vx = self.maxSpeed end
		end
	end

	if not love.keyboard.isDown(bind["down"]) then self.pounding = false end

	local maxFall = 600
	--falling
	if not love.keyboard.isDown("c") then
		local fallSpeed = 1
		--holding down
		if self.pounding then
			self.vy = self.vy + 3000*dt
		elseif self.vy < maxFall then
			--falling downwards
			if self.vy >= 0 then self.vy = self.vy + (600*fallSpeed*dt) end
			--holding jump
			if self.vy < 0 and love.keyboard.isDown(bind["jump"]) and self.airControl then
				self.vy = self.vy + (600*fallSpeed*dt)
			end
			--not holding jump
			if self.vy < 0 and not love.keyboard.isDown(bind["jump"]) and self.airControl then
				self.vy = self.vy + (3000*dt)
			end
			--no air control
			if self.vy < 0 and not self.airControl then
				self.vy = self.vy + (600*fallSpeed*dt)
			end
		end
		if self.vy > maxFall then self.vy = maxFall end
	end

	--friction
	if self.onGround then
		self.allowJump = true
		self.airControl = true
		if self.vx > 0 then self.vx = self.vx - (700*dt)
		else if self.vx < 0 then self.vx = self.vx + (700*dt) end end
		if self.vx > -7 and self.vx < 7 then self.vx = 0 end
	end

	self.px = self.x --magic
	self.py = self.y

	--magic
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt

	--determining collisions
	if self.y+self.h > gameHeight then --overhaul this when we've got platforms
		self.onGround = true
		self.y = gameHeight - self.h
		self.airControl = true
	else
		self.onGround = false
	end

end

function player:jump()
	if self.onGround then
		self.vy = -400
	end
end

function player:pound(ent)
	if self.pounding then
		self.pounding = false
		screenShake = 10*(self.vy/1000)
		gameMode:pound(self.x+self.w/2, self.y+self.h, ent.num)
	end
end

function player:hitSide(ent, dir)
	--if dir == "left" then self.x = ent.x-self.w; self.vx = 0 end
	--if dir == "right" then self.x = ent.x+ent.w; self.vx = 0 end
	if dir == "up" then self.y = ent.y-self.h; self:pound(ent); self.vy = 0; self.onGround = true end
	--if dir == "down" then self.y = ent.y+ent.h; self.vy = 0 end
end

function player:resolveCollision(entity, dir)
	if not love.keyboard.isDown("c") then
		if entity.id == "platform" then
			self:hitSide(entity, dir)
		end
		if entity.id == "breadman" then
			if dir ~= "down" or entity.standingOn ~= 0 then
				--get hurt
			else
				if math.abs((entity.x+entity.w/2)-(self.x+self.w/2)) < 20 then
					entity.die = true
					gameMode:addBread(entity.id)
				else
					entity.vx = ((entity.x+entity.w/2)-(self.x+self.w/2))*5
					entity.moveDir = getSign(entity.vx)
					entity.vy = -150
					self.vy = 0
				end
			end
		end
	end
end

function player:draw()
	love.graphics.setColor(100,100,100)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end