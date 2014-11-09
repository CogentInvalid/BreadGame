ash = class:new()

function ash:init()
	self.img = img["ash" .. math.random(3)]
	self.x = 262+235+40+(math.random()*20-10)
	self.y = 50+40+(math.random()*20-10)
	self.vx = math.random()*80-40
	self.vy = math.random()*80-40
	self.timer = 0
	self.die = false
end

function ash:update(dt)
	self.timer = self.timer + dt
	if self.timer > 2 then
		local tx = 218+(p.hp/100)*368
		local ty = 158-5
		self.x = self.x - (self.x - tx)*0.5*dt
		self.y = self.y - (self.y - ty)*0.5*dt
		if math.abs(self.x-tx) < 10 and math.abs(self.y-ty) < 10 then self.die = true end
	end
	self.vx = self.vx - (self.vx)*dt
	self.vy = self.vy - (self.vy)*dt
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt
end

function ash:draw()
	love.graphics.draw(self.img, self.x, self.y)
end