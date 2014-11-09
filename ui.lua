function game:updateUI()
	self.uiFlash = self.uiFlash - 350*dt
	if self.uiFlash < 0 then self.uiFlash = 0 end
end

function game:drawUI()

	--thing
	love.graphics.setColor(255,255,255,180)
	love.graphics.draw(img["hud"], 175, 25, 0, 0.25, 0.25)

	--bread slots
	for i=1, 3 do
		breadSlots[i]:draw()
	end

	--hp bar
	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("fill", 218, 148, (p.hp/100)*368, 20)

	--ejection flash
	love.graphics.setColor(255,255,255,self.uiFlash)
	love.graphics.rectangle("fill", ((3-1)*131)+235, 50, 80, 80)

	--arrow
	if numEnemies <= 0 and #spawnQueue <= 0 then
		love.graphics.setColor(255,255,255)
		love.graphics.draw(img["arrow"], gameWidth-100, gameHeight/2-20, 0, 0.15, 0.15)
	end

	for i=1, #self.ash do
		love.graphics.setColor(255,255,255)
		self.ash[i]:draw()
	end

end