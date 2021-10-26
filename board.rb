require_relative 'pieces'
require_relative 'errors'

# Holds a 2D array of board positions
# Holds Pieces
# Moves Pieces
class Board
  # Validates that pos is a correctly formated position array
  # and that the position is within the bounds of the board
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
    raise ArgumentError unless val.is_a?(Piece) || val.is_a?(NullPiece)

    row, col = pos
    @rows[row][col] = val
  end

  # only_valid is used to avoid recursion when a piece creates valid_moves
  def move_piece(start_pos, end_pos, only_valid: true)
    error_message = "There's no piece at #{start_pos}"
    raise MoveError, error_message if self[start_pos].is_a?(NullPiece)

    piece = self[start_pos]
    valid_ends = possible_end_positions(piece, only_valid)
    raise MoveError unless valid_ends.include?(end_pos)

    # Capture opponent's piece
    self[end_pos] = NullPiece.instance
    self[start_pos] = NullPiece.instance
    self[end_pos] = piece
    piece.pos = end_pos
  end

  def in_check?(color)
    king_pos = find_king(color)
    opponent_color = color == :white ? :black : :white
    under_threat = attacked_positions(opponent_color)
    under_threat.include?(king_pos)
  end

  def checkmate?(color)
    return false unless in_check?(color)

    pieces_by_color(color).all? { |piece| piece.valid_moves.empty? }
  end

  private

  def setup_board
    place_pieces(:black)
    place_pieces(:white)
    place_null_pieces
  end

  def place_null_pieces
    (2..5).each do |row_index|
      8.times { @rows[row_index] << NullPiece.instance }
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
    place_major_pieces(color, outer_row)
    place_pawns(color, outer_row)
  end

  def place_major_pieces(color, outer_row)
    8.times do |col_index|
      pos = [outer_row, col_index]
      piece = piece_classes_in_order[col_index]
      self[pos] = piece.new(color, self, pos)
    end
  end

  def place_pawns(color, outer_row)
    8.times do |col_index|
      row_index = color == :white ? outer_row - 1 : outer_row + 1
      pos = [row_index, col_index]
      self[pos] = Pawn.new(color, self, pos)
    end
  end

  def possible_end_positions(piece, only_valid)
    return piece.valid_moves if only_valid

    piece.moves
  end

  def find_king(color)
    @rows.each_with_index do |row, row_index|
      row.each_with_index do |piece, col_index|
        return [row_index, col_index] if piece.is_a?(King) && piece.color == color
      end
    end
  end

  def attacked_positions(color)
    pieces_by_color(color).reduce(Set.new) { |set, piece| set + piece.threatens }
  end

  def pieces_by_color(color)
    all_pieces.select { |piece| piece.color == color }
  end

  def all_pieces
    pieces = []
    @rows.each do |row|
      row.each do |piece|
        pieces << piece unless piece.is_a?(NullPiece)
      end
    end
    pieces
  end

  # dup will create a deep dup, duplicating pieces, too
  def initialize_copy(original_board)
    @rows = original_board.rows.map do |row|
      row.map do |piece|
        if piece.is_a?(NullPiece)
          NullPiece.instance
        else
          new_piece = piece.dup
          new_piece.board = self
          new_piece
        end
      end
    end
  end
end
