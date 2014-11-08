breadman = class:new()

function breadman:init(args)

	self.id = "breadman"

	self.x = args[1]
	self.y = args[2]
	self.px = self.x; self.py = self.y --player's position last frame
	self.vx = 0; self.vy = -300 --velocity
	self.w = 40; self.h = 40 --width/height

	self.moveDir = randSign()
	self.flipTimer = 5
	self.onGround = false

	--does it collide with things
	self.col = true
	--do other things collide with it
	self.rcol = true
	self.collideOrder = {isReal} --no need to prioritize certain collisions

	--delete this next frame?
	self.die = false
end

function breadman:update(dt)

	--"ai"
	if self.onGround then self.vx = self.vx - (self.vx - 100*self.moveDir)*3*dt end
	--if self.onGround then self.flipTimer = self.flipTimer - dt end
	if self.flipTimer < 0 then
		self.moveDir = -self.moveDir
		self.flipTimer = math.random()*4+3
	end

	--flip
	if self.x < 0 then
		self.x = 0
		if self.vx < 0 then self.vx = -self.vx/2 end
		self.moveDir = 1
		self.flipTimer = math.random()*4+3
	end
	if self.x+self.w > gameWidth then
		self.x = gameWidth - self.w
		if self.vx > 0 then self.vx = -self.vx/2 end
		self.moveDir = -1
		self.flipTimer = math.random()*4+3
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
		--nothing
	else
		self.flipTimer = math.random()*4+3
	end

	self.onGround = false

	self.px = self.x --magic
	self.py = self.y

	--magic
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt

end

function breadman:land() --ehhhh
	self.onGround = true
end

function breadman:hitSide(ent, dir)
	if dir == "left" then self.x = ent.x-self.w; self.vx = 0 end
	if dir == "right" then self.x = ent.x+ent.w; self.vx = 0 end
	if dir == "up" then self.y = ent.y-self.h; self.vy = 0; self:land() end
	if dir == "down" then self.y = ent.y+ent.h; self.vy = 0 end
end

function breadman:resolveCollision(entity, dir)
	if not love.keyboard.isDown("c") then
		if entity.id == "platform" then
			self:hitSide(entity, dir)
		end
	end
end

function breadman:draw()
	love.graphics.setColor(100,100,100)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end