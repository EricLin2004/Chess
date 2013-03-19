require './chess_pieces'
require 'debugger'

class Chess
  def initialize
    @board = Board.new
    @player = :white
  end

  def run
    until @board.over?
      @board.display
      play_turn
    end
  end

  def play_turn


    @player = (@player == :white ? :blue : :white)
  end

  def get_move
    puts "Player #{@player.to_s.capitalize}, pick your piece (ex. a2)."
    from_pos = parse(gets.chomp)
    puts "Where would you like to more?"
    to_pos = parse(gets.chomp)
    until

  end

  def parse

  end
end

class Board

  def initialize
    make_board
  end

  def make_board
    @board = []
    royalty_w, royalty_b = make_royalty_row

    @board << royalty_w
    @board << make_pawn_row(:white)
    4.times do
      @board << ['*'] * 8
    end
    @board << make_pawn_row(:blue)
    @board << royalty_b
    @board
  end

  def make_royalty_row
    royalty_column_w = [Rook.new, Knight.new, Bishop.new, King.new,
                       Queen.new, Bishop.new, Knight.new, Rook.new]
    royalty_column_w.each {|piece| piece.color = :white }
    royalty_column_b = [Rook.new, Knight.new, Bishop.new, Queen.new,
                        King.new, Bishop.new, Knight.new, Rook.new]
    royalty_column_b.each {|piece| piece.color = :blue }
    [royalty_column_w, royalty_column_b]
  end

  def make_pawn_row(color)
    pawn_row = []
    8.times { pawn_row << Pawn.new }
    pawn_row.each { |pawn| pawn.color = color }
    pawn_row
  end

  def display
    print '  '
    'a'.upto('h') { |let| print " #{let} " }
    puts
    @board.each_with_index do |row, row_index|
      print "#{row_index} "
      row.each do |piece|
       if piece == '*'
         print ' * '
       else
         print " #{piece.display_piece} "
       end
     end
     print " #{row_index}"
     puts
    end
    print '  '
    'a'.upto('h') { |let| print " #{let} " }
    puts
  end

  def over?

  end
end

board = Board.new
board.display

