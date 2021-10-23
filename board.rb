# require 'byebug'

require_relative 'piece'
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
    raise ArgumentError unless val.is_a?(Piece) || val.nil?

    row, col = pos
    @rows[row][col] = val
  end

  def move_piece(start_pos, end_pos)
    raise ArgumentError if self[start_pos].nil?
    raise ArgumentError unless self[end_pos].nil?

    piece = self[start_pos]
    self[start_pos] = nil
    self[end_pos] = piece
  end

  private

  def setup_board
    # Black's pieces
    8.times { |col_index| @rows[0] << Piece.new(:black, self, [0, col_index]) }
    8.times { |col_index| @rows[1] << Piece.new(:black, self, [1, col_index]) }

    # Empty squares
    (2..5).each do |row_index|
      8.times { @rows[row_index] << nil }
    end

    # White's pieces
    8.times { |col_index| @rows[6] << Piece.new(:white, self, [6, col_index]) }
    8.times { |col_index| @rows[7] << Piece.new(:white, self, [7, col_index]) }
  end
end
