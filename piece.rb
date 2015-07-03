require "byebug"

class Piece
  attr_reader :pos, :color, :king, :board

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

  def valid_slide?(start, finish_pos)
    move_diffs.include?([finish_pos[0] - start[0], finish_pos[1] - start[1]]) &&
      finish_pos.all? { |el| el.between?(0,7) } &&
      @board[finish_pos].empty_piece?
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
    temp_board = @board.dup
    temp_piece = temp_board[@pos]
    temp_piece.board.render

    if list_of_moves.length == 1
      if valid_slide?(temp_piece.pos, list_of_moves[0])
        temp_piece.perform_slide(list_of_moves[0])
        temp_board.render
        @board = temp_board
      else
        false
      end
    else
      list_of_moves.each do |move|
        if valid_jump?(temp_piece.pos, move)
          temp_piece.perform_jump(move)
          temp_board.render
        else
          false
        end
      end
    end

  end

  def dup(empty_board)
    Piece.new(@color, @pos, empty_board)
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

  def enemy?(piece)
    false
  end

  def dup
    EmptyPiece.new()
  end
end
