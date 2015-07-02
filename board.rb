require "colorize"
require_relative "piece"
require "byebug"

class Board

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

  def [](row, col)
    @grid[row][col]
  end

  def []=(row,col, mark)
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

  def move(from, to)
    @grid[from.first][from.last].perform_slide(to)
    @grid[to.first][to.last], @grid[from.first][from.last] = @grid[from.first][from.last], @grid[to.first][to.last]
  end
end

pawn = Piece.new(:W, [3,4])
b = Board.new
b[3, 4] = pawn
b.render
b.move([3, 4], [2, 5])
p pawn.pos
b.render
