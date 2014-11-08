function game:updateUI()

end

function game:drawUI()
	--bread slots
	for i=1, 3 do
		breadSlots[i]:draw()
	end

	--hp bar
	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("fill", gameWidth/2 + (1-2)*150-50, 180, (p.hp/100)*400, 20)
end