love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()
    -- sound effects initialization
    sound = {}
    sound.hit = love.audio.newSource("sounds/Hit_Hurt.wav")
    sound.win = love.audio.newSource("sounds/Pickup_Coin.wav")
  
    -- player1 initialization
    player1 = {}
    player1.w = 20
    player1.h = 100
    player1.x = 20
    player1.y = love.graphics.getHeight() / 2 - player1.h / 2
    player1.speed = 500
    
    -- player2 initialization
    player2 = {}
    player2.w = 20
    player2.h = 100
    player2.x = love.graphics.getWidth() - 40
    player2.y = love.graphics.getHeight() / 2 - player2.h / 2
    player2.speed = 500
    
    -- ball initialization
    ball = {}
    ball.x = love.graphics.getWidth() / 2
    ball.y = love.graphics.getHeight() / 2
    ball.radius = 10
    ball.speed = 300
    ball.bounce_down_left = true
    ball.bounce_up_left = false
    ball.bounce_down_right = false
    ball.bounce_up_right = false
    
    -- score initialization
    score = {}
    score.font = love.graphics.getFont()
    score.player1 = 0
    score.player2 = 0
    score.text = score.player1 .. " - " .. score.player2
    score.x = love.graphics.getWidth() / 2
    score.y = 10
    score.scale = 4
    
    -- credit initialization
    credit = {}
    credit.font = love.graphics.getFont()
    credit.text = "Programmed by: Ari Rahmadhika, sounds from: Bfxr"
    credit.x = love.graphics.getWidth() / 2
    credit.y = love.graphics.getHeight() - 30
    credit.scale = 2
end

function love.update(dt)
    -- player1 controller
    if love.keyboard.isDown('w') then
      player1.y = player1.y - player1.speed * dt
    end
    if love.keyboard.isDown('s') then
      player1.y = player1.y + player1.speed * dt
    end   
    if player1.y < 0 then
      player1.y = 0
    end
    if player1.y > love.graphics.getHeight() - player1.h then
      player1.y = love.graphics.getHeight() - player1.h
    end
    
    -- player2 controller
    if love.keyboard.isDown("up") then
      player2.y = player2.y - player2.speed * dt
    end
    if love.keyboard.isDown("down") then
      player2.y = player2.y + player2.speed * dt
    end
    if player2.y < 0 then
      player2.y = 0
    end
    if player2.y > love.graphics.getHeight() - player2.h then
      player2.y = love.graphics.getHeight() - player2.h
    end
    
    -- add 1 score for a player who can make the ball miss out from the enemy
    if ball.x < 0 then
      sound.win:play()
      ball.x = love.graphics.getWidth() / 2
      ball.y = love.graphics.getHeight() / 2
      score.player2 = score.player2 + 1
      score.text = score.player1 .. " - " .. score.player2
    end
    if ball.x > love.graphics.getWidth() then
      sound.win:play()
      ball.x = love.graphics.getWidth() / 2
      ball.y = love.graphics.getHeight() / 2
      score.player1 = score.player1 + 1
      score.text = score.player1 .. " - " .. score.player2
    end
    
    -- ball bounce check
    if ball.bounce_down_left == true then
      ball.x = ball.x - ball.speed * dt
      ball.y = ball.y + ball.speed * dt
    end
    if ball.bounce_up_left == true then
      ball.x = ball.x - ball.speed * dt
      ball.y = ball.y - ball.speed * dt
    end
    if ball.bounce_down_right == true then
      ball.x = ball.x + ball.speed * dt
      ball.y = ball.y + ball.speed * dt
    end
    if ball.bounce_up_right == true then
      ball.x = ball.x + ball.speed * dt
      ball.y = ball.y - ball.speed * dt
    end
    
    -- avoid the ball from getting out of the screen
    if ball.y > love.graphics.getHeight() - ball.radius then
      if ball.bounce_down_right == false and ball.bounce_up_right == false then
        ball.bounce_down_left = false
        ball.bounce_up_left = true
      end
      if ball.bounce_down_left == false and ball.bounce_up_left == false then
        ball.bounce_up_right = true
        ball.bounce_down_right = false
      end
    end
    if ball.y < 0 then
      if ball.bounce_down_right == false and ball.bounce_up_right == false then
        ball.bounce_down_left = true
        ball.bounce_up_left = false
      end
      if ball.bounce_down_left == false and ball.bounce_up_left == false then
        ball.bounce_down_right = true
        ball.bounce_up_right = false
      end
    end
    
    -- ball bounce controller on player1
    if ball.x < player1.x + player1.w and ball.y < player1.y + (player1.h / 2) and ball.y > player1.y then
      sound.hit:play()
      ball.bounce_down_left = false
      ball.bounce_up_left = false
      ball.bounce_up_right = true
    end
    if ball.x < player1.x + player1.w and ball.y > player1.y + (player1.h / 2) and ball.y < player1.y + player1.h then
      sound.hit:play()
      ball.bounce_down_left = false
      ball.bounce_up_left = false
      ball.bounce_down_right = true
    end
    
    --ball bounce controller on player2
    if ball.x > player2.x and ball.y < player2.y + (player2.h / 2) and ball.y > player2.y then
      sound.hit:play()
      ball.bounce_down_right = false
      ball.bounce_up_right = false
      ball.bounce_up_left = true
    end
    if ball.x > player2.x and ball.y > player2.y + (player2.h / 2) and ball.y < player2.y + player2.h then
      sound.hit:play()
      ball.bounce_down_right = false
      ball.bounce_up_right = false
      ball.bounce_down_left = true
    end
end

function love.draw()
    -- player drawing
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", player1.x, player1.y, player1.w, player1.h)
    love.graphics.rectangle("fill", player2.x, player2.y, player2.w, player2.h)
    
    -- ball drawing
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", ball.x, ball.y, ball.radius)
    
    -- score printing
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(score.text, score.x, score.y, 0, score.scale, score.scale, score.font:getWidth(score.text) / 2)
    
    -- credit printing
    love.graphics.setColor(255, 0, 0)
    love.graphics.print(credit.text, credit.x, credit.y, 0, credit.scale, credit.scale, credit.font:getWidth(credit.text) / 2)
end