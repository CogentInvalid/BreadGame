player = class:new()

function player:init(args)

	self.id = "player"; self.drawLayer = "player"

	self.x = args[1]
	self.y = args[2]
	self.px = self.x; self.py = self.y --player's position last frame
	self.vx = 0; self.vy = 0 --velocity
	self.w = 60; self.h = 40 --width/height

	self.moveDir = 1
	self.maxSpeed = 180 --horizontal movement speed
	self.airControl = false --can player use variable jump height?
	self.onGround = false
	self.standingOn = 0

	self.supercharged = false
	self.flashTimer = 0.1
	self.tr = 255; self.tg = 255; self.tb = 255
	self.r = 255; self.g = 255; self.b = 255

	self.hp = 100
	self.invuln = 0

	--does it collide with things
	self.col = true
	--do other things collide with it
	self.rcol = true
	self.collideOrder = {isReal} --no need to prioritize certain collisions

	--delete this next frame?
	self.die = false
	self.dead = false
end

function player:update(dt)

	--level bounds
	if self.x < 0 then
		self.x = 0
		self.vx = -self.vx
	end
	if self.x+self.w > gameWidth then
		if numEnemies > 0 then
			self.x = gameWidth-self.w
			self.vx = -self.vx
		else
			gameMode:nextLevel()
		end
	end

	--movement
	if not love.keyboard.isDown("c") then
		if love.keyboard.isDown(bind["left"]) and self.vx > -self.maxSpeed then
			self.vx = self.vx-1500*dt
			self.moveDir = -1
			if self.vx < -self.maxSpeed then self.vx = -self.maxSpeed end
		end
		if love.keyboard.isDown(bind["right"]) and self.vx < self.maxSpeed then
			self.vx = self.vx+1500*dt
			self.moveDir = 1
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

	--invulnerability
	if self.invuln > 0 then
		self.invuln = self.invuln - dt
	end
	if self.invuln < 0 then self.invuln = 0 end

	--supercharge
	if self.supercharged then
		self.flashTimer = self.flashTimer - dt
		if self.flashTimer < 0 then
			self.tr, self.tg, self.tb = randHue()
			self.flashTimer = 0.2
		end
		self.r = self.r - (self.r - self.tr)*5*dt
		self.g = self.g - (self.g - self.tg)*5*dt
		self.b = self.b - (self.b - self.tb)*5*dt
	else
		self.r = 255; self.g = 255; self.b = 255
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

	if self.hp < 0 then self.hp = 0; self.dead = true end

end

function player:jump()
	if self.onGround then
		self.vy = -400
		playSound("Jump")
	end
end

function player:pound(ent)
	if self.pounding then
		self.pounding = false
		screenShake = 10*(self.vy/1000)
		gameMode:pound(self.x+self.w/2, self.y+self.h, ent.num)
		playSound("Pound")
	end
end

function player:getHit(ent)
	local dx = (self.x+self.w/2)-(ent.x+ent.w/2)
	local dy = (self.y+self.h/2)-(ent.y+ent.h/2)
	local ang = angle:new({dx, dy})
	p.vx = ang.xPart * 400
	p.vy = ang.yPart * 400 - 100
	self.hp = self.hp - 10
	self.invuln = 2
	playSound("Hit")
end

function player:gainHP(amt)
	self.hp = self.hp + amt
	if self.hp > 100 then self.hp = 100 end
end

function player:hitSide(ent, dir)
	--if dir == "left" then self.x = ent.x-self.w; self.vx = 0 end
	--if dir == "right" then self.x = ent.x+ent.w; self.vx = 0 end
	if dir == "up" then
		self.y = ent.y-self.h
		if self.vy > 10 then playSound("Land") end
		self:pound(ent); self.vy = 0
		self.onGround = true
	end
	--if dir == "down" then self.y = ent.y+ent.h; self.vy = 0 end
end

function player:resolveCollision(entity, dir)
	if not love.keyboard.isDown("c") then
		if entity.id == "platform" then
			self:hitSide(entity, dir)
		end
		if entity.drawLayer == "breadman" and (not entity.dead) then
			if (dir ~= "down" and dir ~= "in") or entity.standingOn ~= 0 then
				if self.invuln <= 0 and (not self.supercharged) then self:getHit(entity) end
			else
				if math.abs((entity.x+entity.w/2)-(self.x+self.w/2)) < 20 and entity.id ~= "loaf" then
					entity:kill()
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

	love.graphics.setColor(self.r,self.g,self.b)
	--animation
	if not self.pounding then
		if (love.keyboard.isDown(bind["left"]) or love.keyboard.isDown(bind["right"])) and (self.onGround) then
			animation["toaster-running"]:draw(img["toaster-running"], self.x+30, self.y+10, 0, 0.5*self.moveDir, 0.5, 100, 75)
		else
			love.graphics.draw(img["toaster-still"], self.x+30, self.y+10, 0, 0.5*self.moveDir, 0.5, 100, 75)
		end
	else
		animation["toaster-groundpound"]:draw(img["toaster-groundpound"], self.x+30, self.y+10, 0, 0.5*self.moveDir, 0.5, 100, 75)
	end

	if gameMode.showHitboxes then
		love.graphics.setColor(255,0,0,150)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	end
end