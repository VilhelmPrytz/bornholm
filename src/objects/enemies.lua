--- Operation Bornholm
---
--- Copyright (C) 2020, Vilhelm Prytz <vilhelm@prytznet.se>, Pontus Liedgren <pop2strong4u@gmail.com>, et. al.
--- This game is licensed under the terms of the GNU GPL v3.0 license, see LICENSE
---
--- https://github.com/VilhelmPrytz/bornholm

require "src/lib/physics"

enemies = {}

function enemies:load()
    enemies.width = 32
    enemies.height = 32
    enemies.movement_speed = 150

    enemies.amount = 1

    enemy_objects = {}
end

function enemies:spawn()
    enemy_test = {}
    enemy_test.x = 300
    enemy_test.y = 200
    enemy_test.horizontal_velocity = 0
    enemy_test.vertical_velocity = 0
    table.insert( enemy_objects, enemy_test )
end

local function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function enemies:update(dt)
    enemies.amount = math.floor(score.score/10) + 1

    -- if the amount of enemies present are less than the amount supposed to be present, spawn new
    while tablelength(enemy_objects) < enemies.amount do
        enemies:spawn()
    end

    for i,enemy in ipairs(enemy_objects) do
        -- decide direction of velocity
        if enemy.x - player.x > 0 then
            enemy.horizontal_velocity = -enemies.movement_speed
        end
        if enemy.x - player.x < 0 then
            enemy.horizontal_velocity = enemies.movement_speed
        end

        if enemy.y - player.y > 0 then
            enemy.vertical_velocity = -enemies.movement_speed
        end
        if enemy.y - player.y < 0 then
            enemy.vertical_velocity = enemies.movement_speed
        end

        -- if player has collided with enemy then the player has died
        if CheckCollision(enemy.x,enemy.y,enemies.width,enemies.height, player.x,player.y,player.width,player.height) then
            player.dead = true
            game.state = "dead"
        end

        -- fixme: this is hard coded to check if bullets travel outside (bad)
        if enemy.y < -800 or enemy.y > 2000 or enemy.x < -800 or enemy.x > 8000 then
            table.remove(enemy_objects, i)
        end

        -- check if bullets
        for n,bullet in ipairs(bullet_objects) do
            if CheckCollision(bullet.x,bullet.y,bullets.width,bullets.height, enemy.x,enemy.y,enemies.width,enemies.height) then
                table.remove(bullet_objects, n)
                table.remove(enemy_objects, i)
                score.score = score.score + 1
            end
        end


        -- update x and y using the velocity
        enemy.x = enemy.x+enemy.horizontal_velocity*dt
        enemy.y = enemy.y+enemy.vertical_velocity*dt
    end 
end

function enemies:draw()
    local screen_width = love.graphics.getWidth()
    local screen_height = love.graphics.getHeight()

    for i,enemy in ipairs(enemy_objects) do
        local x = enemy.x - (player.x - screen_width/2 + player.width/2)
        local y = enemy.y - (player.y - screen_height/2 + player.height/2)

        love.graphics.rectangle("fill", x, y, enemies.width, enemies.height)
    end
end
