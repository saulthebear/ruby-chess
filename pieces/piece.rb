require_relative '../board'

# Holds functionality common to all chess pieces
class Piece
  attr_reader :color
  attr_accessor :board

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
  end

  def pos
    @pos.dup
  end

  def pos=(new_pos)
    Board.valid_position?(new_pos)

    @pos = new_pos
  end

  def to_s() end

  def empty?() end

  # @returns [Array] positions this piece can move to
  def moves() end

  # @returns [Array] positions being threatened by this piece
  # Seperate from Piece#moves so that it can be overwritten by Pawn
  def threatens
    moves
  end

  def valid_moves
    if @board.in_check?(@color)
      moves.reject { |new_pos| move_results_in_check?(new_pos) }
    else
      moves.select { |new_pos| move_stops_check?(new_pos) }
    end
  end

  def inspect
    "<#{color} #{symbol} #{pos}>"
  end

  private

  def move_results_in_check?(new_pos)
    verify_move_on_simulated_board(new_pos) do |new_board|
      new_board.in_check?(@color)
    end
  end

  def move_stops_check?(new_pos)
    verify_move_on_simulated_board(new_pos) do |new_board|
      !new_board.in_check?(@color)
    end
  end

  def verify_move_on_simulated_board(new_pos, &prc)
    old_board = @board
    new_board = @board.dup
    @board = new_board

    new_board.move_piece(@pos, new_pos, only_valid: false)
    result = prc.call(new_board)

    @board = old_board
    result
  end

  def can_move_here(pos)
    return false unless pos_in_range?(pos)
    return false unless pos_empty?(pos) || pos_takeable(pos)

    true
  end

  def pos_in_range?(pos)
    Board.valid_position?(pos)
  end

  def pos_empty?(pos)
    @board[pos] == NullPiece.instance
  end

  def pos_takeable(pos)
    @board[pos].color != @color
  end
end
