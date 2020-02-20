--- Operation Bornholm
--- https://github.com/operation-bornholm/bornholm
--- (C) Copyright Vilhelm Prytz & Pontus Liedgren 2020

-- see all settings here https://love2d.org/wiki/Config_Files

require "version"

function love.conf(t)
    t.version = "11.3"
    t.window.title = "Operation Bornholm " .. version
    t.window.fullscreen = true
    t.window.vsync = false
end
