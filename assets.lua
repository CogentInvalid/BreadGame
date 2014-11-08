--load all .png files from the "resources/img" folder
--and put them into the table "img"
function loadAssets()
	local imgFiles = love.filesystem.getDirectoryItems("resources/img")

	img = {} --load images from img folder
	for i,name in ipairs(imgFiles) do
		if string.find(name, ".png") then
			name = string.gsub(name, ".png", "")
			img[name] = love.graphics.newImage("resources/img/" .. name .. ".png")
		end
	end

	grid = {}
	animation = {}

	--bread-running
	--150 by 150
	grid["bread-running"] = anim8.newGrid(150, 150, 600, 600)
	animation["bread-running"] = anim8.newAnimation(grid["bread-running"]('1-4','1-4'), 0.04)
	grid["bread-falling"] = anim8.newGrid(75, 75, 300, 300)
	animation["bread-falling"] = anim8.newAnimation(grid["bread-falling"]('1-4',1,'1-4',2,'1-4',3,'1-3',4), 0.04)
	grid["toaster-running"] = anim8.newGrid(200, 150, 400, 600)
	animation["toaster-running"] = anim8.newAnimation(grid["toaster-running"]('1-2','1-4'), 0.04)
	grid["toaster-groundpound"] = anim8.newGrid(200, 150, 400, 450)
	animation["toaster-groundpound"] = anim8.newAnimation(grid["toaster-groundpound"]('1-2','1-3'), 0.04, 'pauseAtEnd')

end

--this should return an array of quads with each image
--consisting of "name" and then a number
function getAnimation(name, num)
	local quadArray = {}
	for i=1, num do
		local image = img[name .. num]
		--make a quad, add it to quadArray
	end
end