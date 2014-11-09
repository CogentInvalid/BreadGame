menu = class:new()

function menu:init()
	self.enterTimer = 1
	self.entering = false
end

function menu:update(dt)
	if self.entering then
		self.enterTimer = self.enterTimer - dt
		if self.enterTimer < 0 then
			mode = gameMode
		end
	else
		if not sound["BreadTheme2"]:isPlaying() then
			love.audio.play(sound["BreadTheme2"])
		end
	end
end

function menu:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(img["sky-blue"], -20, -20, 0, 0.5, 0.6)
	love.graphics.draw(img["ground"], 0, gameHeight-60, 0, 0.8, 0.5)
	love.graphics.draw(img["title"], 235, 50, 0, 0.15, 0.15)
	love.graphics.setColor(0,0,0)
	love.graphics.draw(img["start"], 225, 200)
end

function menu:keypressed(key)
	if key == "return" then
		self.entering = true
		sound["BreadTheme2"]:stop()
		playSound("Enter")
	end
end