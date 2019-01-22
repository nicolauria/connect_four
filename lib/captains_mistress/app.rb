require 'captains_mistress'

module CaptainsMistress

  class App
    attr_reader :verbose
    attr_accessor :board

    def initialize(options = {})
      @verbose = options.fetch(:verbose, false)
      @width = options.fetch(:width, 7)
      @height = options.fetch(:height, 6)
      @winning_streak_length = options.fetch(:length, 4)
      @strict_winning_streak = options.fetch(:strict, false)
      @turn_count = 0
      @winner = nil
      @board = Array.new(@width) { [] }
    end

    def run
      system('clear')
      puts "--- Welcome to Captains Mistress ---"
      sleep(2)
      get_player_names
      @current_player = @player_one

      # use simple counter instead of checking whether array is full every turn
      until @turn_count == (@width * @height) || @winner
        play_turn
      end

      # final display of board on game end
      system('clear')
      display_board

      if @winner
        puts "The winner is #{@winner}!"
      else
        puts "The board is full! No one wins."
      end
    end

    def get_player_names
      puts "The game will have two players..."
      sleep(2)

      print "Player one please enter your name: "
      @player_one = STDIN.gets.chomp
      puts "Thanks #{@player_one}! Your squares will be marked with a 1."
      sleep(2)
      system('clear')

      print "Player two please enter your name: "
      @player_two = STDIN.gets.chomp;
      puts "Thanks #{@player_two}! Your squares will be marked with a 2."
      sleep(2)
      system('clear');
    end

    def play_turn
      @turn_count += 1
      display_board
      col = get_move
      add_move_to_board(col)
      # returns either @current_player or false
      @winner = check_board_for_winner?(col)
      switch_players
    end

    def display_board
      system('clear');
      puts " " + ("1"..@width.to_s).to_a.join("  ")
      (@width * 3).times { print "-" }
      puts
      # start with top row and move down
      (@height - 1).downto(0) do |row|
        # display value of box (1 or 2) or 0 if empty
        (0..@width - 1).each do |col|
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
        # were indexing into @board array so subtract one
        col = (STDIN.gets.chomp.to_i - 1)
        if (col < 0 || col > (@width - 1))
          print "Move out of bounds. \nPlease enter a valid column number: "
          next
        elsif @board[col].length == @height
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
      # do not need to check until player has had enough minimum possible turns
      return false if @turn_count < (@winning_streak_length * 2 - 1)
      
      # directions builds all horizontal, vertical, and diagonal combinations
      directions = [[1, 1], [1, -1], [-1, 1], [-1, -1],
                    [1, 0], [-1, 0], [0, 1], [0, -1]]
      directions.each do |dir|
        length = 1

        next_col = col + dir[0]
        # we push new moves into a col so @board[col].length - 1 = current row
        next_row = (@board[col].length - 1) + dir[1]
        # added_val = the move we just added to @board
        added_val = @board[col][-1]

        # we break the loop as soon as a row or col is out of bounds
        # we also break as soon as two consecutive values are not matching
        while valid_matching_next_val(next_col, next_row, added_val)
          length += 1
          # continue moving in that direction while valid
          next_col += dir[0]
          next_row += dir[1]
        end

        # check length and return @current_player as winner if conidtion is met
        if @strict_winning_streak
          return @current_player if length == @winning_streak_length
        elsif length >= @winning_streak_length
          return @current_player
        end

      end
      false
    end

    def valid_matching_next_val(next_col, next_row, added_val)
      (next_col > -1 && next_col < @width) &&
      (next_row > -1 && next_row < @height) &&
      added_val == @board[next_col][next_row]
    end

    def switch_players
      @current_player =
        @current_player == @player_one ? @player_two : @player_one
    end
  end
end
