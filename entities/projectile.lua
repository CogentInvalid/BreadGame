projectile = class:new()

function projectile:init(args)
	self.id = "projectile"

	self.x = args[1]
	self.y = args[2]
	self.w = args[3]
	self.h = args[4]
	self.friendly = args[5]
	self.img = img[args[6]]
	self.vx = args[7]
	self.vy = args[8]
	self.gravity = args[9]

	self.col = false
	self.rcol = true
end

function projectile:update(dt)

	self.vy = self.vy + self.gravity*dt

	--level bounds
	if self.x+self.w < 0 or self.x > gameWidth or self.y+self.h < 0 or self.y > gameHeight then
		self.die = true
	end

	self.px = self.x --magic
	self.py = self.y

	--magic
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt
end

function projectile:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.img, self.x-20, self.y-20, 0, 0.5, 0.5)

	if gameMode.showHitboxes then
		love.graphics.setColor(255,0,0,150)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	end
end