frosting = class:new()

function frosting:init(args)
	self.id = "frosting"; self.drawLayer = "projectile"

	self.x = args[1]
	self.y = args[2]
	self.px = self.x
	self.py = self.y
	self.w = 20
	self.h = 20
	self.vx = args[3]
	self.vy = args[4]
	self.angle = 0

	self.col = false
	self.rcol = true
end

function frosting:update(dt)

	self.vy = self.vy + 300*dt

	--level bounds
	if self.x+self.w < 0 or self.x > gameWidth or self.y+self.h < 0 or self.y > gameHeight then
		self.die = true
	end

	--self.angle = self.angle + self.angleSpeed*dt

	self.px = self.x --magic
	self.py = self.y

	--magic
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt
end

function frosting:draw()

	love.graphics.setColor(255,255,255)
	animation["cupcake-projectile"]:draw(img["cupcake-projectile"], self.x+10, self.y+10, 0, -1*getSign(self.vx), 1, 20, 20)
	--love.graphics.draw(self.img, self.x-20, self.y-20, 0, 0.5, 0.5)

	if gameMode.showHitboxes then
		love.graphics.setColor(255,0,0,150)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	end
end