require("gamedata")

Board = {}

Game.is_player_turn = false
Game.current_token = "X"

local token_font = love.graphics.newFont(15)
local label_font = love.graphics.newFont(20)
local victory_font = love.graphics.newFont(25)
function Board:init(size)
      self.grid = {}
      for i = 1, size do
            local row = {}
            for j = 1, size do
                  table.insert(row, " ")
            end
            table.insert(self.grid, row)
      end
      return self
end

function Board:prettyPrint()
      local board_string = ""
      for i, row in ipairs(self.grid) do
            local row_string = ""
            for i, column in ipairs(row) do
                  row_string = row_string.."["..column.."]"
            end
            board_string = board_string..row_string.."\n"
      end
      print(board_string)
end

function Board:gridSame(otherGrid)
      local is_same = true
      for row = 1, #self.grid do
            for column = 1, #self.grid do
                  if self.grid[row][column] ~= otherGrid[row][column] then
                        is_same = false
                  end
            end
      end
      return is_same
end


function Board:isMovesLeft()
      for row = 1, #self.grid do
            for column = 1, #self.grid do
                  if self.grid[row][column] == " " then
                        return true
                  end
            end
      end
      return false
end


function Board:checkWinInRow(token)
      for row = 1, #self.grid do
            local check_row = true
            for column = 1, #self.grid do
                  if self.grid[row][column] ~= token then
                        check_row = false
                  end
            end
            if check_row then
                  return true
            end
      end
      return false
end


function Board:checkWinInColumn(token)
      for column = 1, #self.grid do
            local check_column = true
            for row = 1, #self.grid do
                  if self.grid[row][column] ~= token then
                        check_column = false
                  end
            end
            if check_column then
                  return true
            end
      end
      return false
end


function Board:checkWinInDiagonals(token)
      local main_diagonal = true
      for i = 1, #self.grid do
            if self.grid[i][i] ~= token then
                  main_diagonal = false
            end
      end

      local side_diagonal = true
      for i = 1, #self.grid do
            if self.grid[i][#self.grid + 1 - i] ~= token then
                  side_diagonal = false
            end
      end

      return side_diagonal or main_diagonal
end

function Board:draw()
      local c_size = 60
      local c_padding = 5

      local win_w = love.graphics.getWidth()
      local win_h = love.graphics.getHeight()

      local token_turn_label = Game.current_token.." turn"

      local victory_token = checkWin(self) 

      love.graphics.setColor(1, 1, 1, 1)
      if victory_token == " " then
            love.graphics.print(
                  token_turn_label,
                  label_font,
                  win_w * 0.5 - (label_font:getWidth(token_turn_label))*0.5,
                  30
            )   
      end
      

      if Game.mode == "pvc" and victory_token == " " then
            local turn_label = Game.is_player_turn and "You turn" or "Computer turn"

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print(
                  turn_label,
                  label_font,
                  win_w * 0.5 - (label_font:getWidth(turn_label))*0.5,
                  55
            )
      end

      if victory_token ~= " " then
            local victory_label = victory_token == "draw" and "Draw" or victory_token.." wins!"

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print(
                  victory_label,
                  victory_font,
                  win_w * 0.5 - (victory_font:getWidth(victory_label))*0.5,
                  30
            )
      end

      local grid_size = #self.grid
      local grid_center_x = win_w * 0.5
      local grid_center_y = win_h * 0.5

      for row = 1, grid_size do
            for column = 1, grid_size do
                  local bx = grid_center_x - (c_padding * grid_size) / 2 - (c_size * grid_size) / 2 + ((column - 1) * (c_size + c_padding))
                  local by = grid_center_y - (c_padding * grid_size) / 2 - (c_size * grid_size) / 2 + ((row - 1) * (c_size + c_padding))

                  local mx, my = love.mouse.getPosition()

                  local is_hover = mx > bx and mx < bx + c_size and my > by and my < by + c_size

                  local c_color = {0.8, 0.8, 0.8, 1}
                  local c_hover_color = {0.8, 1, 0.8, 1}
                  local color = c_color
                  if is_hover and self.grid[row][column]  == " " and Game.is_player_turn then
                        color = c_hover_color
                  end

                  love.graphics.setColor(unpack(color))
                  love.graphics.rectangle("fill", bx, by, c_size, c_size)

                  local tokenW = token_font:getWidth(self.grid[row][column])
                  local tokenH = token_font:getHeight()

                  love.graphics.setColor(0, 0, 0, 1)
                  love.graphics.print(
                        self.grid[row][column],
                        token_font,
                        bx + (c_size - tokenW) * 0.5,
                        by + (c_size - tokenW) * 0.5
                  )
                  if is_hover and victory_token == " " and love.mouse.isDown(1) and not Mouse.pressed and self.grid[row][column]  == " " and Game.is_player_turn then
                        Mouse.pressed = true
                        self.grid[row][column] = Game.current_token
                        Game:swapToken()
                        if Game.mode == "pvc" then
                              Game.is_player_turn = false
                        end
                  end
            end
      end
end



-- function Board:evaluate(currentPlayer, nextPlayer)
--       if Board:checkWin(currentPlayer) then
--             return 10
--       elseif Board:checkWin(nextPlayer) then
--             return -10
--       else
--             return 0
--       end
-- end

-- function Board:minimax(currentPlayer, nextPlayer, depth, isMax, alpha, beta, depthLimit)
--       local score = self:evaluate(currentPlayer,nextPlayer)
  
--       if score == 10 or score == -10  or depth >= depthLimit then
--           return score
--       end
  
--       if not self:isMovesLeft() then
--           return 0
--       end
  
--       local best
--       if (isMax) then
--           best = -math.huge
--       else
--           best = math.huge
--       end
  
--       for row = 1, #self.grid do
--           for column = 1, #self.grid do
--               if self.grid[row][column] == " " then
--                   if isMax then
--                       self.grid[row][column] = currentPlayer
--                       best = math.max(best, self:minimax(currentPlayer, nextPlayer, depth + 1, not isMax, alpha, beta, depthLimit))
--                       alpha = math.max(alpha, best)
--                       self.grid[row][column] = " "
--                       if beta <= alpha then
--                           break
--                       end
--                   else
--                       self.grid[row][column] = nextPlayer
--                       best = math.min(best, self:minimax(currentPlayer, nextPlayer, depth + 1, not isMax, alpha, beta, depthLimit))
--                       beta = math.min(beta, best)
--                       self.grid[row][column] = " "
--                       if beta <= alpha then
--                           break
--                       end
--                   end
--               end
--           end
--       end
  
--       return best
-- end

