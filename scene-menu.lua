local composer = require( "composer" )
local scene = composer.newScene()


local backgroup = display.newGroup()
local foregroup = display.newGroup()


lvl = {
	field = {
		[0] = {
			[0] = {value = 30, border = "", buble = false}, [1] = {value = 0, border = "", buble = false},[2] = {value = 0, border = "", buble = false},[3] = {value = 0, border = "", buble = false},[4] = {value = 20, border = "", buble = false}},
		[1] = {
			[0] = {value = 0, border = "", buble = false}, [1] = {value = 40, border = "", buble = false},[2] = {value = 0, border = "", buble = false},[3] = {value = 10, border = "", buble = false},[4] = {value = 0, border = "", buble = false}},
		[2] = {
			[0] = {value = 0, border = "", buble = false}, [1] = {value = 30, border = "bottom", buble = false},[2] = {value = 0, border = "bottom", buble = false},[3] = {value = 20, border = "bottom", buble = false},[4] = {value = 0, border = "", buble = false}},
		[3] = {
			[0] = {value = 0, border = "", buble = false}, [1] = {value = 0, border = "bottom", buble = false},[2] = {value = 0, border = "bottom", buble = false},[3] = {value = 0, border = "bottom", buble = false},[4] = {value = 0, border = "", buble = false}},
		[4] = {
			[0] = {value = 0, border = "", buble = false}, [1] = {value = 10, border = "", buble = false},[2] = {value = 0, border = "", buble = false},[3] = {value = 40, border = "", buble = false},[4] = {value = 0, border = "", buble = false}},
		[5] = {
			[0] = {value = 0, border = "", buble = false}, [1] = {value = 20, border = "", buble = false},[2] = {value = 0, border = "", buble = false},[3] = {value = 30, border = "", buble = false},[4] = {value = 0, border = "", buble = false}},
		[6] = {
			[0] = {value = 10, border = "", buble = false}, [1] = {value = 0, border = "", buble = false},[2] = {value = 0, border = "", buble = false},[3] = {value = 0, border = "", buble = false},[4] = {value = 40, border = "", buble = false}},
	},
	goal = {
		-- monster's index | buble
		name = "1",
		count = 10
	},
	condition = {
		-- timer | steps
		name = "timer",
		count = 25
	}
}


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



	local button_play = {}
	button_play.image = display.newImageRect(foregroup, "assets/gui/simple/button.png",400, 166 )
	button_play.image.text = display.newText(foregroup, "Игра", 0, 0, "assets/fonts/12243.otf", 85)
	button_play.image.next_frame ="scene-game"
	button_play.image.params = {effect="slideLeft", params = lvl}
	
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