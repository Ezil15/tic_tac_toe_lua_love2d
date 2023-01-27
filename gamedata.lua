Game = {}
Game.is_player_turn = false
Game.current_token = "X"
Game.gamestatus = "mode_menu"
Game.mode = ""

Mouse = {}
Mouse.pressed = false

function Game:resetData()
      self.is_player_turn = false
      self.current_token = "X"
      self.gamestatus = "mode_menu"
      self.mode = ""
end

function Game:swapToken()
      self.current_token = self.current_token == "X" and "O" or "X"
end

function checkWin(board)
      if board:checkWinInRow("X") or board:checkWinInColumn("X") or board:checkWinInDiagonals("X") then
            return "X"
      end
      if board:checkWinInRow("O") or board:checkWinInColumn("O") or board:checkWinInDiagonals("O") then
            return "O"
      end
      local draw = not board:isMovesLeft()
      if draw then
            return "draw"
      end

      return " "
end


function Mouse:update()
      if self.pressed then
            self.pressed = love.mouse.isDown(1)
      end
end