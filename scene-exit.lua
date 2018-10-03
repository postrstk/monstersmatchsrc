local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view

	local collection = {}
	collection[1] = event.params[1]
	collection[2] = event.params[2]
	collection[3] = event.params[3]
	collection[4] = event.params[4]

	local total_score = 0

	local score = {}
	local help_text = {}
	local textGroup = {}

	local backgroup = display.newGroup()
	local foregroup = display.newGroup()

	backgroup.x = display.contentCenterX
	backgroup.y = display.contentCenterY

	foregroup.anchorChildren = true

	foregroup.x = display.contentCenterX
	foregroup.y = display.contentCenterY

	foregroup.anchorX = 0.5
	foregroup.anchorY = 0.5

	
	local bg = display.newImageRect(backgroup, "assets/backgrounds/filler_fail.png", 720, 1280)

	--local score_table = display.newImageRect(foregroup, "assets/backgrounds/exit_panel_1.png", 600, 600)

	--local help_panel = display.newImageRect(foregroup, "assets/backgrounds/exit_panel_1.png", 600, 200)

	--help_panel.y = 500
	
	--[[
	help_text[1] = display.newText(foregroup, "Кликни, чтобы", 0, 0,"assets/fonts/12243.otf", 50)
	help_text[2] = display.newText(foregroup, "продолжить", 0, 0,"assets/fonts/12243.otf", 50)
	help_text[1].isVisible = false
	help_text[2].isVisible = false

	for i=1, 2 do
		help_text[i].y = 470 + 60*(i-1)
	end

	for i=1, 4 do
		total_score = total_score + collection[i] / 10
	end

	
	textGroup[1] = display.newText(foregroup, "Отлично!", 0, 0,"assets/fonts/12243.otf", 50)
	textGroup[2] = display.newText(foregroup, "Давай посмотрим, ", 0, 0,"assets/fonts/12243.otf", 50)
	textGroup[3] = display.newText(foregroup, "что было собрано!", 0, 0,"assets/fonts/12243.otf", 50)

	for i=1, 3 do
		textGroup[i].y = -500 + 60*(i-1)
	end


	local function slide_monsters( index )
		print (index)
		if (index == 5) then
			transition.moveTo(score[index].image, {x = score[index].image.x - 1000, time = 1000})
			transition.moveTo(score[index].text, {x = score[index].text.x - 1000, time = 1000})
			help_text[1].isVisible = true
			help_text[2].isVisible = true
		else
			transition.moveTo(score[index].image, {x = score[index].image.x + 1000, time = 1000,
				onEnded=slide_monsters(index + 1)})
			transition.moveTo(score[index].text, {x = score[index].text.x + 1000, time = 1000})
		end
	end


	for i = 1, 4 do
		score[i] = {}
		score[i].image = display.newImageRect(foregroup, "assets/monsters/two/"..i..".png", 150, 150)
		score[i].image.y = -260 + 140 * (i - 1)
		score[i].image.x = -1180 + 50*(i-1)*0

		score[i].text = display.newText(foregroup, "x "..collection[i],
			0, 0, "assets/fonts/12243.otf", 40)
		score[i].text.y = score[i].image.y
		score[i].text.x = score[i].image.x + 170

	end
	score[5] = {}
	score[5].image = display.newImageRect(foregroup, "assets/gui/simple/coin.png", 150, 150)
	score[5].image.x = 1170
	score[5].image.y = 300

	score[5].text = display.newText(foregroup, 
		total_score.." x",
		0, 0, "assets/fonts/12243.otf", 40)
	score[5].text.y = score[5].image.y
	score[5].text.x = score[5].image.x - 170

	backgroup:addEventListener("tap", function ( )
		composer.hideOverlay( "fromBottom",1)
		composer.removeScene("scene-game")
		return composer.gotoScene("scene-menu", {effect="slideRight", params={coins=total_score}})
	end)

	slide_monsters(1)]]
	backgroup:addEventListener("tap", function ( )
		composer.hideOverlay( "fromBottom",1)
		composer.removeScene("scene-game")
		return composer.gotoScene("scene-menu", {effect="slideRight", params={coins=total_score}})
	end)
	sceneGroup:insert(backgroup)
	sceneGroup:insert(foregroup)
end

function scene:show( event )
	-- body
end

function scene:hide( event )
	-- body
end

function scene:destroy( event )
	-- body
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene