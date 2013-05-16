-- Kickstarter sample app
-- By yosuaTreeGames

-- You will recognize many words and symbols from Math class, but keep in mind that the meaning of some of these could be a little different than waht you are used to.
-- For example "=" symbol means "set the left equal to the right" not "the left is the same as the right". The right symbol for the second meaning is "==", two equals signs.

-- These lines starting with "--" are called comments. The computer just ignores them, so they are used for annotations.

-- The first line of real code will hide the status bar on your device. You know, the bar that has the time and battery life...
display.setStatusBar( display.HiddenStatusBar )
-- As we go on, I am going to write less comments, and more actual code.

-- Create variables for the width(W), and height(H) of the screen. This will save us from having to type the code for these values every time we want to reference it.
-- The keyword "local" means that the variable can only be referenced from this file
local W = display.contentWidth
local H = display.contentHeight

-- We can use these variables to define locations on the screen
-- The top left of the screen is (0,0). The bottom right is (W,H). So the middle of the screen is (.5 * W, .5 * H).

-- Create a white rectangle for the background.
-- Position it at 0,0 the top left corner, set its length equal to the length of the screen, and set its height equal to the height of the screen.
local background = display.newRect( 0, 0, W, H) --Each value in the parenthesis means something. 
-- Learn more about this at:
-- http://developer.coronalabs.com/content/displaynewrect 

--Set the color, right now it is white. Try changing the numbers to choose a different color background.
background:setFillColor( 255, 255, 255)

--Create a circle. Position it a third of the way across the screen, and halfway down.
local circle1 = display.newCircle(W * .33 , H * .5, 20)
--Color it green.
circle1:setFillColor(0, 255, 0)
--Give it a border.
circle1.strokeWidth = 2
--Color the border black.
circle1:setStrokeColor(0,0,0)

--Create a second circle, red this time.
local circle2 = display.newCircle(W * .66 , H * .5, 20)
circle2:setFillColor(255, 0, 0)
circle2.strokeWidth = 2
circle2:setStrokeColor(0,0,0)

--Create a text object that tells the player how to win, we will make this change if the player wins or loses, to display an appropriate message.
local text = display.newText("Click on the green circle to win.",.5 * W ,.2 * H, native.systemFont, 20)
text:setReferencePoint( display.CenterReferencePoint )
text.x = .5 * W --you can also move objects like this
text.y = .2 * H
text:setTextColor(0,0,0)
--Uncomment (delete the "--") the alpha value below to hide the text. Give it a value between 0 and 1 to make it transparent.
--text.alpha = 0

--Create a win function. This will be called if the player wins.
local function win(event)
	if event.phase == "began" then -- When the player touches the screen it's called "began", when they lift their finger off, it's called "ended".
		text.text = "You win!" 	   -- Changes the text to "You win!"
	end
	return true -- This means the touch was a success.
end
circle1:addEventListener("touch", win) -- This tells the the program: Every time the user touches circle1 call the win function. 

local function lose(event)
	if event.phase == "began" then
		text.text = "You lose!"
	end
end
circle2:addEventListener("touch", lose)

local physics = require "physics" -- This will let us use things like forces and gravity.
physics.start() -- Start the physics engine. 
physics.setGravity(0, 0) -- Let's turn off gravity. When we turn our two circles, which are just images, into physics bodies, they will want to fall. This will stop them.

--Give the circles a physics body. This will make them react to forces like gravity(except that we just turned it off) and anything else we throw at them (each other).
physics.addBody( circle1, { density = 1.0, friction = 0, bounce = 1, radius = 20 } )
physics.addBody( circle2, { density = 1.0, friction = 0, bounce = 1, radius = 20 } )

-- We want to make the game interesting, so we will use some random numbers to mix things up.
local randForce = math.random(500, 1000)
local randdisplacement = math.random( 1, 10)

--Apply an initial force to our circles. 
circle1:applyForce(randForce, randForce, circle1.x, circle1.y)
circle2:applyForce(-randForce * randdisplacement * .10 , -randForce *randdisplacement * .10, circle2.x, circle2.y)

-- Our circles just fly off the screen. That's no fun. Let's trap them in.
-- We could have also built a box out of physics bodies, but this is easier.
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
	
	-- Basically, we are setting the edges of the screen as boundaries, and if the circles hit the boundaries, we apply an opposite force.
end

-- Apply the effect to the circles on each frame, in other words, 30 times a second.
-- This is important. If we just apply the effect once. The computer will apply the effect as soon as it can,
-- which is a fraction of a second. Computers are very fast.

local runtimeFunction = function( event )
	circle1.x,circle1.y = invisibleWallEffect(circle1)
	circle2.x,circle2.y = invisibleWallEffect(circle2)
end
Runtime:addEventListener( "enterFrame", runtimeFunction )

-- To show how fast your computer is, lets try a quick experiment. 
-- These next two lines will make the circle1 turn invisible, and then visible again.
-- You might think that you would see the circle blink, but the computer is so fast, that you won't even notice. 
circle1.alpha = 0
circle1.alpha = 1

-- These guys will just keep bouncing around forever. No energy is lost to sound, light, warmth, ect in our imaginary world.
-- And that's it, were done! If you want, go back and change things like the color of the circles, strength of forces, text, ect.
-- See if you can add a new feature like score, or a title screen. Use the internet for help.