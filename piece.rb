require "byebug"

class Piece
  attr_reader :pos, :color, :king

  def initialize(color, pos, board)
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
    elsif @color == :W
      directions = [[-1, -1], [-1, 1]]
    else
      directions = [[1, -1], [1, 1]]
    end

    directions
  end

  def perform_slide(finish)
    start = @pos
    @pos = finish
    @board[start] = EmptyPiece.new()
    @board[finish] = self
    maybe_promote(self)
  end

  def valid_slide?(start, finish)
    move_diffs.include?([finish.first - start.first, finish.last - start.last]) &&
      finish.all? { |el| el.between?(0,7) } &&
      @board[finish].empty_piece?
  end

  def maybe_promote(piece)
    if @pos.first == 0 && @color == :W || @pos.first == 7 && @color == :B
      make_king
    end
  end

  def perform_jump(finish)
    start = @pos
    middle = find_jumped_cell(start, finish)
    @pos = finish
    @board[start] = EmptyPiece.new()
    @board[middle] = EmptyPiece.new()
    @board[finish] = self
    maybe_promote(self)
  end

  def find_jumped_cell(start, finish)
    delta_x = (finish.first - start.first) / 2
    delta_y = (finish.last - start.last) / 2
    jumped_cell = [start.first + delta_x, start.last + delta_y]
  end

  def valid_jump?(start, finish)
    finish.all? { |el| el.between?(0,7) } &&
      enemy?(@board[find_jumped_cell(start, finish)]) &&
      @board[finish].empty_piece?
  end

  def empty_piece?
    false
  end

  def enemy?(piece)
    @color != piece.color
  end

  def render
    if @king
      if @color == :B
        " \u25CB ".encode('utf-8').colorize(:color => :black)
      else
        " \u25CB ".encode('utf-8').colorize(:color => :white)
      end
    elsif @color == :B
      " \u25CF ".encode('utf-8').colorize(:color => :black)
    else
      " \u25CF ".encode('utf-8').colorize(:color => :white)
    end
  end

  def perform_moves(list_of_moves)
  end

  def dup(empty_board)
    Piece.new(@color, @pos, new_board)
  end
end

class EmptyPiece < Piece

  def initialize
  end

  def render
    "   "
  end

  def empty_piece?
    true
  end

  def dup
    EmptyPiece.new()
  end
end
