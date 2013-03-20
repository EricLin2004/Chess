# encoding: utf-8
require 'colorize'
require 'debugger'

class Piece
  attr_reader :symbol
  attr_accessor :color

  def initialize(symbol)
    @symbol = symbol
  end

  def display_piece
    @symbol.colorize(@color)
  end

  def move(from_pos, to_pos, board)
    if possible_move?(from_pos, to_pos, board)
      board[to_pos[0]][to_pos[1]] = board[from_pos[0]][from_pos[1]]
      board[from_pos[0]][from_pos[1]] = '*'
    else
      false
    end
  end

  def possible_move?(from_pos, to_pos, board)
    destination_object = board[to_pos[0]][to_pos[1]]
    from_object = board[from_pos[0]][from_pos[1]]
    unless destination_object == '*'
      return false if from_object.color == destination_object.color
    end

    possible_position = nil
    end_pos = nil
    pos_moves_array = possible_moves(from_pos)
    pos_moves_array.each_with_index do |hash, i|
      if hash.has_value?(to_pos)
        possible_position = true
        end_pos = i
        break
      end
    end
    return false unless possible_position

    until pos_moves_array[end_pos][:prev_pos] == from_pos
      check_location = pos_moves_array[end_pos][:prev_pos]
      if board[check_location[0]][check_location[1]] != '*'
        return false
      end
      end_pos -= 1
    end

    true
  end

  def possible_moves(from_pos)
    possible_moves = []
    if @move_mult
      move_deltas.each do |delta|
        vec = delta

        from = from_pos.dup
        while in_bounds?(from, delta)
          hash = {}
          hash[:prev_pos] = from.dup
          hash[:cur_pos] = [from[0] + vec[0], from[1] + vec[1]]
          from[0], from[1] = from[0] + vec[0], from[1] + vec[1]
          possible_moves << hash
        end
      end
    else
      move_deltas.each do |delta|
        if in_bounds?(from_pos, delta)
          hash = {prev_pos: from_pos,
                  cur_pos: [from_pos[0] + delta[0], from_pos[1] + delta[1]]}
          possible_moves << hash
        end
      end
    end
    possible_moves
  end

  def in_bounds?(from, delta)
    return true if from[0] + delta[0] < 8 && from[1] + delta[1] < 8 &&
    from[0] + delta[0] >= 0 && from[1] + delta[1] >= 0
    false
  end

end

class King < Piece

  def initialize
    super('♔')
    @move_mult = false
  end

  def move_deltas
    [[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1],[0,-1],[1,-1]]
  end

end

class Queen < Piece

  def initialize
    super('♕')
    @move_mult = true
  end

  def move_deltas
    [[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1],[0,-1],[1,-1]]
  end
end

class Bishop < Piece

  def initialize
    super('♗')
    @move_mult = true
  end

  def move_deltas
    [[1,1],[-1,-1],[1,-1],[-1,1]]
  end
end

class Knight < Piece

  def initialize
    super('♘')
    @move_mult = false
  end

  def move_deltas
    [[2,1],[2,-1],[-2,1],[-2,-1],[1,2],[1,-2],[-1,2],[-1,-2]]
  end
end

class Rook < Piece

  def initialize
    super('♖')
    @move_mult = true
  end

  def move_deltas
    [[0,1],[0,-1],[1,0],[-1,0]]
  end
end

class Pawn < Piece

  def initialize
    super('♙')
    @move_mult = false
  end

  def move_deltas
    if color == :white
      [[1,0],[1,1],[1,-1]]
    elsif color == :blue
      [[-1,0],[-1,-1],[-1,1]]
    end
  end

  def possible_move?(from_pos, to_pos, board)
    destination_object = board[to_pos[0]][to_pos[1]]
    possible_position = nil
    pos_moves_array = possible_moves(from_pos)
    pos_moves_array.each_with_index do |hash, i|
      if hash.has_value?(to_pos)
        possible_position = true
      end
    end

    return false unless possible_position


    if destination_object == '*' && from_pos[1] != to_pos[1]
      return false
    elsif destination_object != '*' && from_pos[1] == to_pos[1]
      return false
    end

    return false unless in_bounds?(from_pos, move_deltas)

    true
  end

  def move(from_pos, to_pos, board)
    if possible_move?(from_pos, to_pos, board)
      board[to_pos[0]][to_pos[1]] = board[from_pos[0]][from_pos[1]]
      board[from_pos[0]][from_pos[1]] = '*'
    else
      false
    end
  end
end