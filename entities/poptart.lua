poptart = class:new()

function poptart:init(args)

	self.id = "poptart"; self.drawLayer = "breadman"

	self.x = args[1]
	self.y = args[2]
	self.px = self.x; self.py = self.y --player's position last frame
	self.vx = 0; self.vy = 0 --velocity
	self.w = 40; self.h = 40 --width/height

	self.moveDir = args[3]
	self.onGround = false
	self.standingOn = 0

	self.jumpTimer = 1
	self.angle = 0

	--does it collide with things
	self.col = true
	--do other things collide with it
	self.rcol = true
	self.collideOrder = {isReal} --no need to prioritize certain collisions

	--display death animation?
	self.dead = false
	--delete this next frame?
	self.die = false
end

function poptart:update(dt)

	--"ai"
	if self.onGround then self.vx = self.vx - (self.vx - 100*self.moveDir)*3*dt end

	--level bounds
	if self.x+self.w+20 < 0 or self.x-20 > gameWidth or self.y-20 > gameHeight then
		self.die = true
	end

	if self.onGround then self.jumpTimer = self.jumpTimer - dt end
	if self.jumpTimer < 0 then
		self.vy = -600
		self.jumpTimer = 1
	end

	--gravity
	local maxFall = 600
	if self.vy < maxFall then
		--falling
		self.vy = self.vy + (600*dt)
	end
	if self.vy > maxFall then self.vy = maxFall end

	--friction
	if self.onGround then
	else
		self.standingOn = 0
	end

	self.onGround = false

	self.px = self.x --magic
	self.py = self.y

	--magic
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt

end

function poptart:land(ent)
	self.onGround = true
	self.standingOn = ent.num --id of current platform
end

function poptart:hitSide(ent, dir)
	--if dir == "left" then self.x = ent.x-self.w; self.vx = 0 end
	--if dir == "right" then self.x = ent.x+ent.w; self.vx = 0 end
	if dir == "up" and (not self.dead) then self.y = ent.y-self.h; self.vy = 0; self:land(ent) end
	--if dir == "down" then self.y = ent.y+ent.h; self.vy = 0 end
end

function poptart:resolveCollision(entity, dir)
	if not love.keyboard.isDown("c") then
		if entity.id == "platform" then
			self:hitSide(entity, dir)
		end
		if entity.id == "projectile" then
			if entity.friendly and self.dead == false then
				self.dead = true
				numEnemies = numEnemies - 1
				self.vy = -200
			end
		end
	end
end

function poptart:draw()
	love.graphics.setColor(255,255,255)
	animation["poptart-running"]:draw(img["poptart-running"], self.x+20, self.y+10, self.angle, 0.5*self.moveDir, 0.5, 87, 87)
	if gameMode.showHitboxes then
		love.graphics.setColor(255,0,0,150)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	end
end