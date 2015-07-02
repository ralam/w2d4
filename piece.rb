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

  def move_diffs
    directions = []
    if @king
      directions += [[-1, -1], [-1, 1],[1, -1], [1, 1]]
    else
      @color == :R ? directions += [[-1, -1], [-1, 1]] : directions += [[1, -1], [1, 1]]
    end

  end

  def perform_slide
  end

  def perform_jump
  end

  def moves
    valid_moves = []
    @dir.each do |dir|

  end

  def perform_moves(list_of_moves)
  end

end

class EmptyPiece < Piece

  def initialize
  end

  def perform_moves
  end

  def perform_jump
  end

end
