background = class:new()

function background:init(args)
	self.id = "background"; self.drawLayer = "background"

	self.x = args[1]
	self.y = args[2]
	self.sx = args[3]
	self.sy = args[4]
	self.img = img[args[5]]

	self.col = false
	self.rcol = false
	self.die = false
end

function background:update(dt)

end

function background:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.img, self.x, self.y, 0, self.sx, self.sy)
end