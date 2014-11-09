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

	local imgFiles = love.filesystem.getDirectoryItems("resources/sound")
	sound = {} --load images from img folder
	for i,name in ipairs(imgFiles) do
		if string.find(name, ".ogg") then
			name = string.gsub(name, ".ogg", "")
			sound[name] = love.audio.newSource("resources/sound/" .. name .. ".ogg")
		end
	end

	sound["BreadTheme1"]:setLooping(true)
	sound["BreadTheme1"]:setVolume(0.6)
	sound["BreadTheme2"]:setLooping(true)
	sound["BreadTheme2"]:setVolume(0.6)
	sound["GameOver"]:setLooping(true)
	sound["GameOver"]:setVolume(0.6)

	--animations
	grid = {}
	animation = {}

	grid["bread-running"] = anim8.newGrid(150, 150, 600, 600)
	animation["bread-running"] = anim8.newAnimation(grid["bread-running"]('1-4','1-4'), 0.04)

	grid["bread-falling"] = anim8.newGrid(75, 75, 300, 300)
	animation["bread-falling"] = anim8.newAnimation(grid["bread-falling"]('1-4',1,'1-4',2,'1-4',3,'1-3',4), 0.04)

	grid["bread-parachuting"] = anim8.newGrid(150, 150, 900, 450)
	animation["bread-parachuting"] = anim8.newAnimation(grid["bread-parachuting"]('1-6','1-3'), 0.04)

	grid["toaster-running"] = anim8.newGrid(200, 150, 400, 600)
	animation["toaster-running"] = anim8.newAnimation(grid["toaster-running"]('1-2','1-4'), 0.04)

	grid["toaster-groundpound"] = anim8.newGrid(200, 150, 400, 450)
	animation["toaster-groundpound"] = anim8.newAnimation(grid["toaster-groundpound"]('1-2','1-3'), 0.04, 'pauseAtEnd')

	grid["poptart-running"] = anim8.newGrid(175, 175, 700, 700)
	animation["poptart-running"] = anim8.newAnimation(grid["poptart-running"]('1-4','1-4'), 0.04)

	grid["bagel-rolling"] = anim8.newGrid(150, 150, 450, 300)
	animation["bagel-rolling"] = anim8.newAnimation(grid["bagel-rolling"]('1-3','1-2'), 0.04)

	grid["bagel-falling"] = anim8.newGrid(150, 150, 450, 300)
	animation["bagel-falling"] = anim8.newAnimation(grid["bagel-falling"]('1-3','1-2'), 0.04)

	grid["loaf-loafing"] = anim8.newGrid(400, 175, 2400, 1575)
	animation["loaf-loafing"] = anim8.newAnimation(grid["loaf-loafing"]('1-6','1-9'), 0.04)

	grid["cupcake-falling"] = anim8.newGrid(150, 150, 600, 450)
	animation["cupcake-falling"] = anim8.newAnimation(grid["cupcake-falling"]('1-4','1-3'), 0.04)

	grid["cupcake-throwing"] = anim8.newGrid(150, 150, 750, 1050)
	animation["cupcake-throwing"] = anim8.newAnimation(grid["cupcake-throwing"]('1-5','1-7'), 0.04)

	grid["cupcake-projectile"] = anim8.newGrid(40, 40, 120, 80)
	animation["cupcake-projectile"] = anim8.newAnimation(grid["cupcake-projectile"]('1-3','1-2'), 0.04)

	grid["fire"] = anim8.newGrid(150, 150, 600, 750)
	animation["fire"] = anim8.newAnimation(grid["fire"]('1-4',1,'1-4',2,'1-4',3,'1-4',4,'1-3',5), 0.04)

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