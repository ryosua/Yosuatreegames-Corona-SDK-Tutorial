--Hide the status Bar
display.setStatusBar( display.HiddenStatusBar )
local W = display.contentWidth
local H = display.contentHeight
--Create a white rectangle for the background.
--Position it at 0,0 the top left corner, set its length equal to the length of the screen, 
--and set its height equal to the height of the screen.
local background = display.newRect( 0, 0, W, H)
--Set the color, right now it is white, try changing the numbers to choose a different color background.
background:setFillColor( 255, 255, 255)

--Create a circle. Position it a third of the way across the screen, and halfway down.
local circle1 = display.newCircle(W * .33 , H * .5, 15)
--Color it green.
circle1:setFillColor(0, 255, 0)
--Give it a border.
circle1.strokeWidth = 2
--Color the border black.
circle1:setStrokeColor(0,0,0)

--Create a second circle, red this time.
local circle2 = display.newCircle(W * .66 , H * .5, 15)
circle2:setFillColor(255, 0, 0)
circle2.strokeWidth = 2
circle2:setStrokeColor(0,0,0)

local text = display.newText("Click on the green circle to win.",.5 * W ,.2 * H, native.systemFont, 20)
text:setReferencePoint( display.CenterReferencePoint )
text.x = .5 * W
text.y = .2 * H
text:setTextColor(0,0,0)
--text.alpha = 0

local function win(event)
	if event.phase == "began" then
		text.text = "You win!"
	end
end
circle1:addEventListener("touch", win)

local function lose(event)
	if event.phase == "began" then
		text.text = "You lose!"
	end
end
circle2:addEventListener("touch", lose)

local physics = require "physics"
physics.start()
physics.setGravity(0, 0)

physics.addBody( circle1, { density = 1.0, friction = 0, bounce = 1, radius = 20 } )
physics.addBody( circle2, { density = 1.0, friction = 0, bounce = 1, radius = 20 } )

randForce = math.random(500, 1000)
randdisplacement = math.random( 1, 10)
circle1:applyForce(randForce, randForce, circle1.x, circle1.y)
circle2:applyForce(-randForce * randdisplacement * .10 , -randForce *randdisplacement * .10, circle2.x, circle2.y)

function invisibleWallEffect(object) 
	--sides
	if object.x > (W - .5 * object.contentWidth) or (object.x < (0 + .5 * object.contentWidth)) then
		xVelocity, yVelocity = object:getLinearVelocity()
		object:setLinearVelocity( -xVelocity, yVelocity )
		
	end
	--top and bottom
	if (object.y > (H - .5 * object.contentHeight)) or (object.y < (0 + .5 * object.contentHeight)) then
		xVelocity, yVelocity = object:getLinearVelocity()
		object:setLinearVelocity( xVelocity, -yVelocity )
	end
	
	return object.x , object. y 
end

local runtimeFunction = function( event )
	circle1.x,circle1.y = invisibleWallEffect(circle1)
	circle2.x,circle2.y = invisibleWallEffect(circle2)
end
Runtime:addEventListener( "enterFrame", runtimeFunction )