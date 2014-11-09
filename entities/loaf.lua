loaf = class:new()

function loaf:init(args)

	self.id = "loaf"; self.drawLayer = "breadman"

	self.x = args[1]
	self.y = args[2]
	self.px = self.x; self.py = self.y --position last frame
	self.vx = 0; self.vy = 0 --velocity
	self.w = 100; self.h = 60 --width/height
	self.y = self.y - 20

	self.moveDir = args[3]
	self.onGround = false
	self.standingOn = 0

	self.hp = 6

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

function loaf:update(dt)

	--"ai"
	if self.onGround then
		if self.x+self.w/2 < p.x+p.w/2 then
			self.moveDir = 1
		else
			self.moveDir = -1
		end
		self.vx = self.vx + 20*self.moveDir*dt
	end
	if self.vx > 5 then self.vx = 5 end
	if self.vx < -5 then self.vx = -5 end

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
		self:kill()
	end

	--check bottom
	local x = self.x+self.w/2+50*self.moveDir
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
	end

	if self.vy < -100 then self.vy = -100 end
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

	if self.hp <= 0 then self:kill() end

end

function loaf:land(ent)
	self.onGround = true
	self.standingOn = ent.num --id of current platform
end

function loaf:kill()
	self.die = true
	numEnemies = numEnemies - 1
	numSpecial = numSpecial - 1
end

function loaf:hitSide(ent, dir)
	--if dir == "left" then self.x = ent.x-self.w; self.vx = 0 end
	--if dir == "right" then self.x = ent.x+ent.w; self.vx = 0 end
	if dir == "up" and (not self.dead) then self.y = ent.y-self.h; self.vy = 0; self:land(ent) end
	--if dir == "down" then self.y = ent.y+ent.h; self.vy = 0 end
end

function loaf:resolveCollision(entity, dir)
	if not love.keyboard.isDown("c") then
		if entity.id == "platform" then
			self:hitSide(entity, dir)
		end
		if entity.id == "projectile" then
			if entity.friendly and self.dead == false then
				self.hp = self.hp - 1
				entity.die = true
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

function loaf:draw()
	love.graphics.setColor(255,255,255)
	if self.vx == 0 then
		love.graphics.draw(img["loaf-idle"], self.x+50, self.y+20, 0, 0.5*-self.moveDir, 0.5, 200, 87)
	else
		animation["loaf-loafing"]:draw(img["loaf-loafing"], self.x+50, self.y+20, 0, 0.5*-self.moveDir, 0.5, 200, 87)
	end
	if gameMode.showHitboxes then
		love.graphics.setColor(255,0,0,150)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	end
end