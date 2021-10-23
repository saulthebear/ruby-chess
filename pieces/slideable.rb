# Mixin for pieces that move diagonally or vertically/horizontally
module Slideable
  def horizontal_dirs
    HORIZONTAL_DIRS
  end

  def diagonal_dirs
    DIAGONAL_DIRS
  end

  def moves
    move_dirs.reduce([]) do |moves, dir|
      dx, dy = dir
      moves.concat(grow_unblocked_moves_in_dir(dx, dy))
    end
  end

  private

  HORIZONTAL_DIRS = [
    [-1, 0],
    [1, 0],
    [0, -1],
    [0, 1]
  ].freeze
  DIAGONAL_DIRS = [
    [-1, -1],
    [1, -1],
    [-1, 1],
    [1, 1]
  ].freeze

  # Overwritten by subclass
  # Returns HORIZONTAL_DIRS or DIAGONAL_DIRS
  def move_dirs()
    raise NotImplementedError
  end

  public
  def grow_unblocked_moves_in_dir(dx, dy)
    # debugger
    moves = []
    curr_pos = @pos.dup
    loop do
      next_pos = change_pos(curr_pos, [dx, dy])
      break unless Board.valid_position?(next_pos)

      unless @board[next_pos] == NullPiece
        break if @board[next_pos].color == @color

        # Other color, so can be taken
        moves << next_pos
        break
      end

      moves << next_pos

      curr_pos = next_pos
    end
    moves
  end

  def change_pos(pos, change)
    new_pos = pos.dup
    new_pos[0] += change[0]
    new_pos[1] += change[1]
    new_pos
  end
end
