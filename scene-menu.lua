local composer = require( "composer" )
local scene = composer.newScene()

local coins = {}
local backgroup = display.newGroup()
local foregroup = display.newGroup()
coins.value = 0

function scene:create( event )
	local sceneGroup = self.view



	local function next_frame( btn )
		return composer.gotoScene(btn.next_frame, btn.params)
	end

	local function button_unpressed( btn )
		transition.to(btn, {y=btn.y-5, onComplete=next_frame, time=100})
		transition.to(btn.text, {y=btn.text.y-5, time=100})
	end

	local function button_pressed( event )
		btn = event.target
		transition.to(btn, {y=btn.y+5, onComplete=button_unpressed, time=100})
		transition.to(btn.text, {y=btn.text.y+5, time=100})
	end
 


	backgroup.x = display.contentCenterX
	backgroup.y = display.contentCenterY

	foregroup.x = display.contentCenterX
	foregroup.y = display.contentCenterY

	foregroup.anchorX = 0.5
	foregroup.anchorY = 0.5
	
	local bg = display.newImageRect(backgroup, "assets/backgrounds/2.png", 720, 1280)

	coins.image = display.newImageRect(foregroup, "assets/gui/simple/coin.png", 140, 140)
	coins.image.x = -250
	coins.image.y = -550

	coins.text = display.newText(foregroup, ""..coins.value, 0, 0, "assets/fonts/12243.otf", 50)
	coins.text.x = coins.image.x 
	coins.text.y = coins.image.y + 100


	local button_play = {}
	button_play.image = display.newImageRect(foregroup, "assets/gui/simple/button.png",400, 166 )
	button_play.image.text = display.newText(foregroup, "Игра", 0, 0, "assets/fonts/12243.otf", 85)
	button_play.image.next_frame ="scene-game"
	button_play.image.params = {effect="slideLeft"}
	
	local button_progress = {}
	button_progress.image = display.newImageRect(foregroup, "assets/gui/simple/button.png",400, 166 )
	button_progress.image.text = display.newText(foregroup, "Улучшения", 0, 0,"assets/fonts/12243.otf", 70)
	button_progress.image.next_frame = "scene-exit"
	button_progress.image.params = {effect="slideLeft", params={[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0}}
	
	local button_challenge = {}
	button_challenge.image = display.newImageRect(foregroup, "assets/gui/simple/button.png",400, 166 )
	button_challenge.image.text = display.newText(foregroup, "Турнир", 0, 0,"assets/fonts/12243.otf", 70)
	button_challenge.image.next_frame = "scene-progress"

	button_play.image.y = -200
	button_play.image.text.y = -200

	--button_progress.image.y = 100
	--button_progress.image.text.y = 100

	button_challenge.image.y = 200
	button_challenge.image.text.y = 200

	button_play.image:addEventListener("tap", button_pressed)
	button_progress.image:addEventListener("tap", button_pressed)
	button_challenge.image:addEventListener("tap", button_pressed)



	sceneGroup:insert(backgroup)
	sceneGroup:insert(foregroup)
end

function scene:show( event )
	if (nil ~= event.params and "will" == event.phase) then 
		coins.value = coins.value + event.params.coins

		display.remove(coins.text)

		coins.text = display.newText(foregroup, ""..coins.value, 0, 0, "assets/fonts/12243.otf", 50)
		coins.text.x = coins.image.x 
		coins.text.y = coins.image.y + 100
	end
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