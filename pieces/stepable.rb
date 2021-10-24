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

  # Overwritten by subclass
  # Returns an array of [dx, dy] position changes
  # that a piece can make
  def move_diffs
    raise NotImplementedError
  end
end
