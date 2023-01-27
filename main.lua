require("board")
require("ai")
require("menu")
require("gamedata")

local computer_turn_time = 1
local computer_turn_delta = 0


local restart_time = 3
local restart_delta = 0

function choiceGrid(grid)
      board = Board:init(grid)
      Game.gamestatus = "game"
end

function choiceMode(mode)
      Game.gamestatus = "grid_menu"
      Game.mode = mode
      if (Game.mode == "pvc" and love.math.random(0,1) == 0) or Game.mode == "pvp" then
            Game.is_player_turn = true
      end
      local buttons = {
            newButton("3x3", function() choiceGrid(3) end),
            newButton("5x5", function() choiceGrid(5) end),
      }
      Menu:loadNewMenu(buttons)
end

function love.load()
      local buttons = {
            newButton("Player vs Player", function() choiceMode("pvp") end),
            newButton("Player vs Computer", function() choiceMode("pvc") end),
            newButton("Computer vs Computer", function() choiceMode("cvc") end),
      }
      Menu:loadNewMenu(buttons)

end


function love.update(dt)
      if Game.gamestatus == "game"  then
            if checkWin(board) == " " then
                  if Game.mode == "pvc" and not Game.is_player_turn then
                        computer_turn_delta = computer_turn_delta + dt
                        if computer_turn_delta > computer_turn_time then
                              computer_turn_delta = 0
                              MCTSAi:makeMove(board, Game.current_token)
                              Game.is_player_turn = true
                              Game:swapToken()
                        end
                        
                  elseif Game.mode == "cvc" then
                        computer_turn_delta = computer_turn_delta + dt
                        if computer_turn_delta > computer_turn_time then
                              computer_turn_delta = 0
                              MCTSAi:makeMove(board, Game.current_token)
                              Game:swapToken()
                        end
                  end
            else
                  restart_delta = restart_delta + dt
                  if restart_delta > restart_time then
                        restart_delta = 0
                        love.load()
                        Game:resetData()
                  end
            end
      end
     
      Mouse:update()
end


function love.draw()
      if Game.gamestatus == "mode_menu" or Game.gamestatus == "grid_menu" then
            Menu:drawMenu()
      elseif Game.gamestatus == "game" then
            board:draw()
      end
end
