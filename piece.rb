require "byebug"

class Piece
  attr_reader :pos

  def initialize(color, pos)
    @color = color
    @pos = pos
#    @board = board
    @king = false
  end

  def make_king
    @king = true
  end

  def move_diffs
    if @king
      directions = [[-1, -1], [-1, 1],[1, -1], [1, 1]]
    else
      @color == :W ? directions = [[-1, -1], [-1, 1]] : directions = [[1, -1], [1, 1]]
    end

    directions
  end

  def perform_slide(finish_pos)
    start = @pos
    row = start.first
    col = start.last
    finish_pos.last - col < 0 ? dir = move_diffs.first : dir = move_diffs.last

    pos = [[row + dir.first], [col + dir.last]]

  end

  def render
    @color == :B ? " \u25CF ".encode('utf-8').colorize(:color => :black) : " \u25CF ".encode('utf-8').colorize(:color => :white)
  end

  def valid_slide?
    true
  end

  def perform_jump
  end

  def perform_moves(list_of_moves)
  end

end

class EmptyPiece < Piece

  def initialize
  end

  def render
    "   "
  end
end

piece = Piece.new(:W, [4, 4])
piece.perform_slide([3, 5])
p piece.pos
