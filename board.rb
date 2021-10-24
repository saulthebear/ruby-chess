require_relative 'pieces'
require_relative 'errors'

# Holds a 2D array of board positions
# Holds Pieces
class Board
  # Validates position arrays
  def self.valid_position?(pos)
    return false unless pos.is_a?(Array)
    return false unless pos.length == 2

    return false unless pos.all? do |index|
      return false unless index.is_a?(Integer)

      !index.negative? && index < 8
    end

    true
  end

  attr_reader :rows

  def initialize
    @rows = Array.new(8) { [] }
    setup_board
  end

  def [](pos)
    raise PositionError unless Board.valid_position?(pos)

    row, col = pos

    @rows[row][col]
  end

  def []=(pos, val)
    raise PositionError unless Board.valid_position?(pos)
    raise ArgumentError unless val.is_a?(Piece) || val == NullPiece

    row, col = pos
    @rows[row][col] = val
  end

  def move_piece(start_pos, end_pos)
    err = "There's no piece at #{start_pos}"
    raise MoveError.new(err) if self[start_pos] == NullPiece

    piece = self[start_pos]
    possible_end_positions = piece.moves

    raise MoveError unless possible_end_positions.include?(end_pos)

    # Take piece
    self[end_pos] = NullPiece
    self[start_pos] = NullPiece
    self[end_pos] = piece
    piece.pos = end_pos
  end

  private

  def setup_board
    place_pieces(:black)
    place_pieces(:white)
    place_null_pieces
  end

  def place_null_pieces
    (2..5).each do |row_index|
      8.times { @rows[row_index] << NullPiece }
    end
  end

  def piece_classes_in_order
    [
      Rook,
      Knight,
      Bishop,
      Queen,
      King,
      Bishop,
      Knight,
      Rook
    ].freeze
  end

  def place_pieces(color)
    outer_row = color == :white ? 7 : 0

    8.times do |col_index|
      pos = [outer_row, col_index]
      piece = piece_classes_in_order[col_index]
      self[pos] = piece.new(color, self, pos)
    end

    8.times do |col_index|
      row_index = color == :white ? outer_row - 1 : outer_row + 1
      pos = [row_index, col_index]
      self[pos] = Pawn.new(color, self, pos)
    end
  end
end
