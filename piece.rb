require "byebug"
# require_relative 'board'

class Piece
  attr_reader :pos, :perform_slide, :color

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
    else
      @color == :W ? directions = [[-1, -1], [-1, 1]] : directions = [[1, -1], [1, 1]]
    end

    directions
  end

  def perform_slide(finish_pos)
    if valid_slide?(@pos, finish_pos)
      start = @pos
      @pos = finish_pos
      @board[start.first, start.last] = EmptyPiece.new()
      @board[finish_pos.first, finish_pos.last] = self
    end
  end

  def valid_slide?(start, finish)
    move_diffs.include?([finish.first - start.first, finish.last - start.last])
    finish.all? { |el| el.between?(0,7) }
    @board[finish.first, finish.last].empty_piece? || enemy?(@board[finish.first, finish.last])
  end

  def empty_piece?
    false
  end

  def enemy?(piece)
    @color != piece.color
  end

  def render
    @color == :B ? " \u25CF ".encode('utf-8').colorize(:color => :black) : " \u25CF ".encode('utf-8').colorize(:color => :white)
  end

  def perform_jump
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
