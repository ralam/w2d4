require "colorize"
require_relative "piece"
require "byebug"

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) { EmptyPiece.new } }
  end

  def render
    @grid.each_with_index do |row, r_idx|
      row.each_with_index do |cell, c_idx|
        color = (r_idx + c_idx) % 2 == 0? :black : :red
        print cell.render.colorize(:background => color)
      end
      puts
    end
    puts
  end



  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    @grid[row][col] = mark
  end

  def pieces
    @grid.flatten.select { |piece| !piece.pos.nil? }
  end

  def valid_move?
  end

  def dup
    empty_board = Board.new

    pieces.each do |piece|
      empty_board[piece.pos] = piece.dup(empty_board)
    end

    empty_board
  end
end

b = Board.new
piece = Piece.new(:B, [0, 3], b)
oppo = Piece.new(:W, [1, 4], b)
oppo2 = Piece.new(:W, [3, 4], b)
b.[]=([0, 3], piece)
b.[]=([1, 4], oppo)
b.[]=([3, 4], oppo2)
b.render
p piece.valid_move_seq?([[2, 5], [4, 3]])
b.render
