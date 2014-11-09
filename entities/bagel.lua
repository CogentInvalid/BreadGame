bagel = class:new()

function bagel:init(args)

	self.id = "bagel"; self.drawLayer = "breadman"

	self.x = args[1]
	self.y = args[2]
	self.px = self.x; self.py = self.y --position last frame
	self.vx = 0; self.vy = 0 --velocity
	self.w = 40; self.h = 40 --width/height

	self.moveDir = args[3]
	self.onGround = false
	self.standingOn = 0

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

function bagel:update(dt)

	--"ai"
	if self.onGround then
		if self.x+self.w/2 < p.x+p.w/2 then
			self.moveDir = 1
		else
			self.moveDir = -1
		end
		self.vx = self.vx + 200*self.moveDir*dt
	end
	if self.vx > 300 then self.vx = 300 end
	if self.vx < -300 then self.vx = -300 end

	--flip
	if self.x < 0 then
		if self.vx < 0 then self.vx = -self.vx/2 end
		self.moveDir = 1
	end
	if self.x+self.w > gameWidth then
		if self.vx > 0 then self.vx = -self.vx/2 end
		self.moveDir = -1
	end

	--level bounds
	if self.x+self.w+20 < 0 or self.x-20 > gameWidth or self.y-20 > gameHeight then
		self:die()
	end

	--gravity
	local maxFall = 600
	if self.vy < maxFall then
		--falling
		self.vy = self.vy + (400*dt)
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

function bagel:land(ent)
	self.onGround = true
	self.standingOn = ent.num --id of current platform
end

function bagel:kill()
	self.die = true
	numEnemies = numEnemies - 1
end

function bagel:hitSide(ent, dir)
	--if dir == "left" then self.x = ent.x-self.w; self.vx = 0 end
	--if dir == "right" then self.x = ent.x+ent.w; self.vx = 0 end
	if dir == "up" and (not self.dead) then self.y = ent.y-self.h; self.vy = 0; self:land(ent) end
	--if dir == "down" then self.y = ent.y+ent.h; self.vy = 0 end
end

function bagel:resolveCollision(entity, dir)
	if not love.keyboard.isDown("c") then
		if entity.id == "platform" then
			self:hitSide(entity, dir)
		end
		if entity.id == "projectile" then
			if entity.friendly and self.dead == false then
				self.dead = true
				self.vy = -200
			end
		end
	end
end

function bagel:draw()
	love.graphics.setColor(255,255,255)
	if self.onGround then
		animation["bagel-rolling"]:draw(img["bagel-rolling"], self.x+20, self.y+10, 0, 0.5*self.moveDir, 0.5, 75, 75)
	else
		animation["bagel-rolling"]:draw(img["bagel-falling"], self.x+20, self.y+10, 0, 0.5*self.moveDir, 0.5, 75, 75)
	end
	if gameMode.showHitboxes then
		love.graphics.setColor(255,0,0,150)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	end
end