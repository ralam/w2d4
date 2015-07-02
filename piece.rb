class Piece

  def inititalize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
    @king = false
    @dir = [-1, 1]
  end

  def make_king
    @king = true
  end

  def perform_slide
    @pos = [@pos.first + dir.first], [@pos.last + dir.last]
  end

  def perform_jump
    @pos =
  end

  def moves
    i
  end

  def perform_moves(list_of_moves)
  end

end

class EmptyPiece < Piece
end
