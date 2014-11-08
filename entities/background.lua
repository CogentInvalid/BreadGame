background = class:new()

function background:init(args)
	self.id = "background"

	self.x = args[1]
	self.y = args[2]
	self.img = img[args[3]]

	self.col = false
	self.rcol = false
	self.die = false
end

function background:update(dt)

end

function background:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.img, self.x, self.y)
end