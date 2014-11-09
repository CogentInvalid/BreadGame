cupcake = class:new()

function cupcake:init(args)

	self.id = "cupcake"; self.drawLayer = "breadman"

	self.x = args[1]
	self.y = args[2]
	self.px = self.x; self.py = self.y --position last frame
	self.vx = 0; self.vy = 0 --velocity
	self.w = 40; self.h = 40 --width/height

	self.dir = args[3]
	self.onGround = false
	self.standingOn = 0

	self.angle = 0
	self.throwTimer = 1

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

function cupcake:update(dt)

	--"ai"
	if self.onGround then
		if self.x+self.w/2 < p.x+p.w/2 then
			self.dir = 1
		else
			self.dir = -1
		end

		local pt = self.throwTimer
		self.throwTimer = self.throwTimer - dt
		if pt > 0.8 and self.throwTimer <= 0.8 then
			--throw cupcake
			gameMode:addEnt(frosting, {self.x+self.w/2-10, self.y+self.w/2-10, self.dir*100, -200})
		end
		if self.throwTimer < 0 then
			self.throwTimer = 1.4
		end
	end

	--flip
	if self.x < 0 then
		if self.vx < 0 then self.vx = -self.vx/2 end
	end
	if self.x+self.w > gameWidth then
		if self.vx > 0 then self.vx = -self.vx/2 end
	end

	--level bounds
	if self.x+self.w+20 < 0 or self.x-20 > gameWidth or self.y-20 > gameHeight then
		self:kill()
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
		self.vx = self.vx - (self.vx)*5*dt
	else
		self.standingOn = 0
	end

	--rotate
	if self.dead then
		self.angle = self.angle + 2*dt
	end

	self.onGround = false

	self.px = self.x --magic
	self.py = self.y

	--magic
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt

end

function cupcake:land(ent)
	self.onGround = true
	self.standingOn = ent.num --id of current platform
	if self.vy > 10 then
		animation["cupcake-throwing"]:gotoFrame(1)
		self.throwTimer = 1.4
	end
end

function cupcake:kill()
	self.die = true
	numEnemies = numEnemies - 1
	numSpecial = numSpecial - 1
end

function cupcake:hitSide(ent, dir)
	--if dir == "left" then self.x = ent.x-self.w; self.vx = 0 end
	--if dir == "right" then self.x = ent.x+ent.w; self.vx = 0 end
	if dir == "up" and (not self.dead) then self.y = ent.y-self.h; self:land(ent); self.vy = 0 end
	--if dir == "down" then self.y = ent.y+ent.h; self.vy = 0 end
end

function cupcake:resolveCollision(entity, dir)
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
		if entity.id == "player" then
			if entity.supercharged and self.dead == false then
				self.dead = true
				self.vy = -200
			end
		end
	end
end

function cupcake:draw()
	love.graphics.setColor(255,255,255)
	if self.onGround then
		animation["cupcake-throwing"]:draw(img["cupcake-throwing"], self.x+20, self.y+10, self.angle, 0.5*-self.dir, 0.5, 75, 75)
	else
		animation["cupcake-falling"]:draw(img["cupcake-falling"], self.x+20, self.y+10, self.angle, 0.5*-self.dir, 0.5, 75, 75)
	end
	if gameMode.showHitboxes then
		love.graphics.setColor(255,0,0,150)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	end
end