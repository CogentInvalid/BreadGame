menu = class:new()

function menu:init()
	self.enterTimer = 1
	self.entering = false
	self.mode = "main"
end

function menu:update(dt)
	if self.mode == "main" then
		if self.entering then
			self.enterTimer = self.enterTimer - dt
			if self.enterTimer < 0 then
				mode = gameMode
				self.enterTimer = 1
				self.entering = false
			end
		else
			if not sound["BreadTheme2"]:isPlaying() then
				love.audio.play(sound["BreadTheme2"])
			end
		end
	end
	if self.mode == "dead" then
		if self.entering then
			self.enterTimer = self.enterTimer - dt
			if self.enterTimer < 0 then
				self.mode = "main"
				self.enterTimer = 1
				self.entering = false
			end
		else
			if not sound["GameOver"]:isPlaying() then
				love.audio.play(sound["GameOver"])
			end
		end
	end
	if self.mode == "win" then
		if self.entering then
			self.enterTimer = self.enterTimer - dt
			if self.enterTimer < 0 then
				self.mode = "main"
				self.enterTimer = 1
				self.entering = false
			end
		else
			if not sound["BreadTheme2"]:isPlaying() then
				love.audio.play(sound["BreadTheme2"])
			end
		end
	end
end

function menu:draw()
	if self.mode == "main" then
		love.graphics.setColor(255,255,255)
		love.graphics.draw(img["sky-blue"], -20, -20, 0, 0.5, 0.6)
		love.graphics.draw(img["ground"], 0, gameHeight-60, 0, 0.8, 0.5)
		love.graphics.draw(img["title"], 235, 50, 0, 0.15, 0.15)
		love.graphics.setColor(0,0,0)
		love.graphics.draw(img["start"], 225, 200)
	end
	if self.mode == "dead" then
		love.graphics.setColor(255,255,255)
		love.graphics.draw(img["sky-grey"], -20, -20, 0, 0.5, 0.6)
		love.graphics.draw(img["ground"], 0, gameHeight-60, 0, 0.8, 0.5)
		love.graphics.draw(img["gameover"], 235, 50, 0, 0.15, 0.15)
		love.graphics.setColor(0,0,0)
		love.graphics.draw(img["start"], 225, 300)
	end
	if self.mode == "win" then
		love.graphics.setColor(255,255,255)
		love.graphics.draw(img["sky-blue"], -20, -20, 0, 0.5, 0.6)
		love.graphics.draw(img["ground"], 0, gameHeight-60, 0, 0.8, 0.5)
		love.graphics.draw(img["win"], 235, 50, 0, 1, 1)
		love.graphics.setColor(0,0,0)
		love.graphics.draw(img["start"], 225, 300)
	end
end

function menu:keypressed(key)
	if key == "return" then
		if self.mode == "main" then
			sound["BreadTheme2"]:stop()
		end
		if self.mode == "dead" then
			sound["GameOver"]:stop()
		end
		self.entering = true
		playSound("Enter")
	end
end