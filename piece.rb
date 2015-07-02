class Piece

  def inititalize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
    @king = false
  end

  def make_king
    @king = true
  end

  def move
  end
  
  def perform_moves(list_of_moves)
  end

end
