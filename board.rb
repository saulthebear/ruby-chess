# require 'byebug'

require_relative 'piece'
require_relative 'errors'

# Holds a 2D array of board positions
# Holds Pieces
class Board

  # Validates position arrays
  def self.vaild_position?(pos)
    return false unless pos.is_a?(Array)
    return false unless pos.length == 2

    return false unless pos.each do |index|
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
    raise PositionError unless Board.vaild_position?(pos)

    row, col = pos

    @rows[row][col]
  end

  def []=(pos, val)
    raise PositionError unless Board.vaild_position?(pos)
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
    8.times { @rows[0] << Piece.new }
    8.times { @rows[1] << Piece.new }

    # Empty squares
    (2..5).each do |row_index|
      8.times { @rows[row_index] << nil }
    end

    # White's pieces
    8.times { @rows[6] << Piece.new }
    8.times { @rows[7] << Piece.new }
  end
end
