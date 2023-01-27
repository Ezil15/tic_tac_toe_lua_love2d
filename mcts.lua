require("board")
require("gamedata")
Node = {}


function deepcopy(orig)
      local orig_type = type(orig)
      local copy
      if orig_type == 'table' then
            copy = {}
            for orig_key, orig_value in next, orig, nil do
                  copy[deepcopy(orig_key)] = deepcopy(orig_value)
            end
            setmetatable(copy, deepcopy(getmetatable(orig)))
      else -- number, string, boolean, etc
            copy = orig
      end
      return copy
end

function Node:init(board, player_token, move)
      local node = {}

      node.wins = 0.0
      node.games = 0.0
      node.move = move
      node.board = board
      node.player_token = player_token
      node.children = {}

      return node
end


function mcts(node, expanding)
      local expanding = expanding or false

      node.games = node.games + 1
      if checkWin(node.board) ~= " " then
            if checkWin(node.board) == "X" or checkWin(node.board) == "O" then
                  node.wins = node.wins + 1
            end
            return
      end
      local move = {-1,-1}
      local next_player = node.player_token == "X" and "O" or "X"
      local next_board = deepcopy(node.board)
      if #node.children == #node.board.grid * #node.board.grid then
            local max_uct = -math.huge
            for i, child in ipairs(node.children) do
                  local uct = child.wins / child.games + math.sqrt(math.log(node.games) / child.games)
                  if uct > max_uct then
                        max_uct = uct
                        move = {child.move[1], child.move[2]}
                  end
            end
      elseif not expanding then
            for row = 1, #node.board.grid do
                  for column = 1, #node.board.grid do
                        local move_expansion = {row, column}
                        if node.board.grid[row][column] == " " then
                              next_board = deepcopy(node.board)
                              next_board.grid[row][column] = node.player_token
                              local next_node = Node:init(next_board, next_player, move_expansion)
                              local is_child = false
                              for i, child in ipairs(node.children) do
                                    if child.board:gridSame(next_board.grid) then
                                          next_node = child
                                          is_child = true
                                    end
                              end
                              if not is_child then
                                    table.insert(node.children, next_node)
                              end
                              mcts(next_node, true)
                        end
                  end
            end
      else
            move = {love.math.random(1, #node.board.grid), love.math.random(1, #node.board.grid)}

            while node.board.grid[move[1]][move[2]] ~= " " do
                  move = {love.math.random(1, #node.board.grid),love.math.random(1, #node.board.grid)}
            end
            next_board.grid[move[1]][move[2]] = node.player_token
            local next_node = Node:init(next_board, next_player, move)
            local is_child = false
            for i, child in ipairs(node.children) do
                  if child.board:gridSame(next_board.grid) then
                        next_node = child
                        is_child = true
                  end
            end
            if not is_child then
                  table.insert(node.children, next_node)
            end
            mcts(next_node, expanding)
      end

      node.wins = 0
      node.games = 0

      if node.children then
            for i, child in ipairs(node.children) do
                  node.wins = node.wins + child.games - child.wins
                  node.games = node.games + child.games
            end
      end
end