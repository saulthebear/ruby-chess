require 'colorize'

require_relative 'board'
require_relative 'display'
require_relative 'human_player'

class Game
  def initialize(debug: false)
    @board = Board.new
    @display = Display.new(@board, debug: debug)
    @players = { p1: HumanPlayer.new(:white, @display), p2: HumanPlayer.new(:black, @display) }
    @current_player = :p1
  end

  def play
    notify_current_player
    until checkmate?
      render
      handle_input
      swap_turn!
    end
  end

  private

  def handle_input
    start_pos, end_pos = receive_start_and_end

    @board.move_piece(start_pos, end_pos)
  rescue MoveError => e
    notify_players("#{e.message} Try again.", :error)
    retry
  end

  def receive_start_and_end
    start_pos = player_selection until correct_color?(piece_at(start_pos))

    end_pos = player_selection

    [start_pos, end_pos]
  end

  def player_selection
    player_input = nil
    until Board.valid_position?(player_input)
      player_input = @players[@current_player].make_move(@board)
      render
    end
    player_input
  end

  def correct_color?(piece)
    return false if piece.nil?

    if piece.is_a?(NullPiece)
      notify_players('Select a piece!', :error)
      return false
    end

    correct = piece.color == current_player_color
    notify_players("That's not your piece! Try again", :error) unless correct
    correct
  end

  def current_player_color
    @players[@current_player].color
  end

  def render
    system('clear')
    notify_current_player
    @display.render
  end

  def checkmate?
    @players.each do |player_symbol, player|
      color = player.color
      if @board.checkmate?(color)
        render
        notify_checkmate(player_symbol)
        return true
      end
    end
    false
  end

  def notify_checkmate(loser_symbol)
    winner_symbol = loser_symbol == :p1 ? :p2 : :p1
    winner = @players[winner_symbol]
    loser = @players[loser_symbol]
    message = "Congratulations #{winner.color.to_s.upcase}!
    #{loser.color.to_s.upcase} is in checkmate."
    notify_players(message, :success)
  end

  def notify_players(message, style)
    case style
    when :info
      colored_message = message.yellow
    when :error
      colored_message = message.red
    when :success
      colored_message = message.green
    end
    puts colored_message
  end

  def notify_current_player
    notify_players("#{current_player_color.to_s.upcase} to move", :info)
  end

  def swap_turn!
    @current_player = @current_player == :p1 ? :p2 : :p1
  end

  def piece_at(pos)
    return nil if pos.nil?

    @board[pos]
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
