require_relative '../board'

module Stepable
  def moves
    moves = []
    move_diffs.each do |diff|
      dx = diff[1]
      dy = diff[0]
      curr_pos = @pos
      new_pos = [curr_pos[0] + dx, curr_pos[1] + dy]
      
      moves << new_pos if can_move_here(new_pos)
    end
    moves
  end

  private

  def can_move_here(pos)
    return false unless pos_in_range(pos)
    return false unless pos_empty?(pos) || pos_takeable(pos)
    
    true
  end

  def pos_in_range(pos)
    Board.valid_position?(pos)
  end

  def pos_empty?(pos)
    @board[pos] == NullPiece
  end

  def pos_takeable(pos)
    @board[pos].color != @color
  end

  # Overwritten by subclass
  # Returns an array of [dx, dy] position changes
  # that a piece can make
  def move_diffs
    raise NotImplementedError
  end
end
