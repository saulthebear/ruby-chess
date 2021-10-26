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
    notify_players
    until checkmate?
      render
      handle_input
      swap_turn!
    end
  end

  private

  def handle_input
    piece_to_move = nil
    until correct_color?(piece_to_move)
      start_pos, end_pos = get_start_and_end
      piece_to_move = @board[start_pos]
    end

    @board.move_piece(start_pos, end_pos)
  rescue MoveError => e
    puts "ERROR: #{e.message} Try again.".red
    retry
  end

  def correct_color?(piece)
    return false if piece.nil?

    current_player_color
    correct = piece.color == current_player_color
    puts "That's not your piece! Try again".red unless correct
    correct
  end

  def current_player_color
    @players[@current_player].color
  end

  def get_start_and_end
    start_pos = nil
    end_pos = nil
    2.times do |selection_number|
      player_input = nil
      until Board.valid_position?(player_input)
        player_input = @players[@current_player].make_move(@board)
        render
      end
      if selection_number.zero?
        start_pos = player_input
      else
        end_pos = player_input
      end
    end
    [start_pos, end_pos]
  end

  def render
    system('clear')
    notify_players
    @display.render
  end

  def checkmate?
    @players.each do |player_symbol, player|
      color = player.color
      if @board.checkmate?(color)
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
    puts "Congratulations #{winner.color.to_s.upcase}!
    #{loser.color.to_s.upcase} is in checkmate.".green
  end

  def notify_players
    puts "#{current_player_color.to_s.upcase} to move".yellow
  end

  def swap_turn!
    @current_player = @current_player == :p1 ? :p2 : :p1
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
