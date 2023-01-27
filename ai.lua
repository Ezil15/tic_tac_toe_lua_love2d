require("mcts")
MCTSAi = {}


function MCTSAi:makeMove(board, player_id)
      local move = {-1, -1}
      local root = Node:init(board, player_id, {-1, -1})
      local start = love.timer.getTime()
      local turn_length = 0.3
      while love.timer.getTime() < start + turn_length do
            mcts(root)
      end

      local best_score = -math.huge

      for i, child in ipairs(root.children) do
            if child.wins / child.games > best_score then
                  move = child.move
                  best_score = child.wins / child.games
            end
      end

      if move == {-1, -1} then
            move = {love.math.random(1, #board.grid), love.math.random(1, #board.grid)}
      end
      board.grid[move[1]][move[2]] = player_id
end
