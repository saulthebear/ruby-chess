class Pawn < Piece
  def symbol
    'P'
  end

  def moves
    forward_steps.concat(side_attacks)
  end

  private

  def at_start_row?
    pos[0] == start_row
  end

  def start_row
    @color == :white ? 6 : 1
  end

  # @return [1, -1] Forward direction based on color
  def forward_dir
    @color == :white ? -1 : 1
  end

  def forward_steps
    moves = []
    steps = at_start_row? ? 2 : 1
    steps.times do |step|
      new_row = @pos[0] + (forward_dir * (step + 1))
      new_pos = [new_row, @pos[1]]
      moves << new_pos if can_move_here(new_pos)
    end
    moves
  end

  # Override since pawns cannot take in front
  def pos_takeable(target_pos)
    if attackable_positions.include?(target_pos)
      return false if @board[target_pos] == NullPiece

      return @board[target_pos].color != @color
    end

    false
  end

  def attackable_positions
    current_col = @pos[1]
    current_row = @pos[0]

    left_attackable_pos = [current_row + forward_dir, current_col - 1]
    right_attackable_pos = [current_row + forward_dir, current_col + 1]

    [left_attackable_pos, right_attackable_pos]
  end

  def side_attacks
    attackable_positions.select do |new_pos|
      pos_in_range?(new_pos) && pos_takeable(new_pos)
    end
  end
end
