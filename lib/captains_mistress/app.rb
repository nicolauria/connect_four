require 'captains_mistress'

module CaptainsMistress
  # The application object. Create it with options for the game, then run by
  # calling #run.
  class App
    attr_reader :verbose
    attr_accessor :board

    def initialize(options = {})
      @verbose = options.fetch(:verbose, false)
      @turn_count = 0
      @winner = nil
      @board = Array.new(7) { [] }
    end

    def run
      puts "--- Welcome to Captains Mistress ---"
      sleep(2)
      get_player_names
      @current_player = @player_one

      # use simple counter instead of checking whether array is full every turn
      until @turn_count == 42 || @winner
        play_turn
      end

      # final display of board on game end
      system('clear')
      display_board

      if @winner
        puts "The winner is #{@current_player}!"
      else
        puts "The board is full! No one wins."
      end
    end

    def get_player_names
      puts "The game will have two players..."
      sleep(2)
      print "Player one please enter your name: "
      @player_one = gets.chomp;
      puts "Thanks #{@player_one}! Your squares will be marked with a 1."
      sleep(2)
      system('clear')

      print "Player two please enter your name: "
      @player_two = gets.chomp;
      puts "Thanks #{@player_two}! Your squares will be marked with a 2."
      sleep(2)
      system('clear');
    end

    def play_turn
      display_board
      col = get_move
      add_move_to_board(col)
      return if check_board_for_winner?(col)
      switch_players
    end

    def display_board
      system('clear');
      puts " 1  2  3  4  5  6  7"
      puts "--------------------"
      5.downto(0) do |row|
        (0..6).each do |col|
          if @board[col][row]
            print " #{@board[col][row]} "
          else
            print " 0 "
          end
        end
        puts
      end
    end

    def get_move
      puts "#{@current_player} it's your turn."
      print "Please select a column: "
      while true
        col = (gets.chomp.to_i - 1)
        if (col < 0 || col > 6)
          print "Move out of bounds. \nPlease enter a valid column number: "
          next
        elsif @board[col].length == 6
          print "Column is full. \nPlease select a different column: "
          next
        end
        break
      end
      return col
    end

    def add_move_to_board(col)
      val = @current_player == @player_one ? 1 : 2
      @board[col].push(val)
    end

    def check_board_for_winner?(col)
      # directions builds all horizontal, vertical, and diagonal combinations
      directions = [[1, 1], [1, -1], [-1, 1], [-1, -1],
                    [1, 0], [-1, 0], [0, 1], [0, -1]]
      directions.each do |dir|
        length = 1

        next_col = col + dir[0]
        next_row = (@board[col].length - 1) + dir[1]
        added_val = @board[col][-1]

        # we break the loop as soon as a row or col is out of bounds
        # we also break as soon as two consecutive values are not matching
        while valid_matching_next_val(next_col, next_row, added_val)
          length += 1
          if length == 4
            @winner = @current_player
            return true
          end
          next_col += dir[0]
          next_row += dir[1]
        end
      end
      false
    end

    def valid_matching_next_val(next_col, next_row, added_val)
      (next_col > -1 && next_col < 7) &&
      (next_row > -1 && next_row < 6) &&
      added_val == @board[next_col][next_row]
    end

    def switch_players
      @current_player =
        @current_player == @player_one ? @player_two : @player_one
      @turn_count += 1
    end
  end
end
