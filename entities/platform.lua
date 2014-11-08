platform = class:new()

function platform:init(args)

	self.id = "platform"

	self.x = args[1]; self.y = args[2]
	self.px = self.x; self.py = self.y
	self.w = args[3]; self.h = args[4]

	self.col = false
	self.rcol = true
	self.die = false
end

function platform:update(dt)

end

function platform:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end