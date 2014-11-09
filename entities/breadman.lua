breadman = class:new()

function breadman:init(args)

	self.id = "breadman"; self.drawLayer = "breadman"

	self.x = args[1]
	self.y = args[2]
	self.px = self.x; self.py = self.y --player's position last frame
	self.vx = 0; self.vy = 0 --velocity
	self.w = 40; self.h = 40 --width/height

	self.moveDir = randSign()
	self.flipTimer = 5
	self.onGround = false
	self.standingOn = 0
	self.checkTimer = 0

	self.angle = 0

	self.hasParachute = args[3]

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

function breadman:update(dt)

	--"ai"
	if self.onGround then self.vx = self.vx - (self.vx - 100*self.moveDir)*3*dt end
	if self.standingOn ~= 0 then self.flipTimer = self.flipTimer - dt end
	if self.flipTimer < 0 then
		self.moveDir = -self.moveDir
		self.flipTimer = math.random()*4+3
	end

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
		self.die = true
		if not self.dead then numEnemies = numEnemies - 1 end
	end

	--gravity
	local maxFall = 600
	if self.hasParachute then maxFall = 150 end
	if self.vy < maxFall then
		--falling
		self.vy = self.vy + (400*dt)
	end
	if self.vy > maxFall then self.vy = maxFall end

	self.checkTimer = self.checkTimer - dt
	if self.checkTimer < 0 then self.checkTimer = 0 end

	--friction
	if self.onGround then
		self.hasParachute = false

		--check bottom
		if self.checkTimer <= 0 then
			local x = self.x+self.w/2
			local y = self.y+self.h+2
			local found = false
			for i=1, #ent do
				if ent[i].id == "platform" then
					if x > ent[i].x and x < ent[i].x+ent[i].w and y > ent[i].y and y < ent[i].y+ent[i].h then
						found = true
					end
				end
			end
			if not found then
				self.vx = 0
				self.moveDir = -self.moveDir
				self.x = self.x + self.moveDir
				self.checkTimer = 1
			end
		end
	else
		self.standingOn = 0
	end

	--spinning
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

function breadman:land(ent)
	self.onGround = true
	self.standingOn = ent.num --id of current platform
end

function breadman:hitSide(ent, dir)
	--if dir == "left" then self.x = ent.x-self.w; self.vx = 0 end
	--if dir == "right" then self.x = ent.x+ent.w; self.vx = 0 end
	if dir == "up" and (not self.dead) then self.y = ent.y-self.h; self.vy = 0; self:land(ent) end
	--if dir == "down" then self.y = ent.y+ent.h; self.vy = 0 end
end

function breadman:resolveCollision(entity, dir)
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

function breadman:draw()
	love.graphics.setColor(255,255,255)
	if self.hasParachute then love.graphics.draw(img["parachute-good"], self.x-30, self.y-50, 0, 0.5, 0.5) end
	if self.standingOn ~= 0 then
		animation["bread-running"]:draw(img["bread-running"], self.x+20, self.y+10, self.angle, 0.5*self.moveDir, 0.5, 75, 75)
	else
		if self.hasParachute then
			animation["bread-parachuting"]:draw(img["bread-parachuting"], self.x+20, self.y+10, self.angle, self.moveDir*0.5, 0.5, 75, 75)
		else
			animation["bread-falling"]:draw(img["bread-falling"], self.x+20, self.y+10, self.angle, self.moveDir, 1, 75/2, 75/2)
		end
	end
	if gameMode.showHitboxes then
		love.graphics.setColor(255,0,0,150)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	end
end