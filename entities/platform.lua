platform = class:new()

function platform:init(args)

	self.id = "platform"

	self.x = args[1]; self.y = args[2]
	self.px = self.x; self.py = self.y
	self.w = args[3]; self.h = args[4]

	self.num = args[5]

	self.img = img[args[6]]
	self.sx = args[7]
	self.sy = args[8]
	self.ox = args[9]
	self.oy = args[10]

	self.col = false
	self.rcol = true
	self.die = false
end

function platform:update(dt)

end

function platform:draw()

	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.img, self.x, self.y, 0, self.sx, self.sy, self.ox, self.oy)

	if gameMode.showHitboxes then
		love.graphics.setColor(255,0,0,150)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	end
end