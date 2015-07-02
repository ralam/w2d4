class Piece

  def initialize(color, pos)
    @color = color
    @pos = pos
    @board = board
    @king = false
  end

  def make_king
    @king = true
  end

  def move_diffs
    if @king
      directions = [[-1, -1], [-1, 1],[1, -1], [1, 1]]
    else
      @color == :R ? directions = [[-1, -1], [-1, 1]] : directions = [[1, -1], [1, 1]]
    end

    directions
  end

  def perform_slide(finish_pos)
    row = @pos.first
    col = @pos.last
    col - finish_pos.first == -1 ? dir = move_diffs.first : dir = move_diffs.last
    @pos = [[row + dir.first], [col + dir.last]]
  end

  def render
    " U25CB ".encode('utf-8')
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
