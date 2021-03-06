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
      # do not need to check until players have had enough minimum possible turns
      return false if @turn_count < (@winning_streak_length * 2 - 1)

      # directions builds all horizontal, vertical, and diagonal combinations
      directions = [[1, 1], [1, -1], [1, 0], [0, 1]]
      directions.each do |dir|
        # start at 1 to count for added move
        length = 1

        # pos represents the colmumn and row of the added move
        pos = [col, @board[col].length - 1]
        # the value of the added move
        added_val = @board[col][-1]

        # using dir, traverse @board both left/right or up/down
        length += streak_in_positive_direction(pos, dir, added_val)
        length += streak_in_negative_direction(pos, dir, added_val)

        # check length and return @current_player as winner if conidtion is met
        if @strict_winning_streak
          return @current_player if length == @winning_streak_length
        elsif length >= @winning_streak_length
          return @current_player
        end

      end
      false
    end

    # returns a number representing the length of the streak
    # traveral ends as soon as in_bounds_matching_val? == false
    def streak_in_positive_direction(pos, dir, added_val)
      next_pos = [pos[0] + dir[0], pos[1] + dir[1]]
      return 0 unless in_bounds_matching_val?(next_pos, added_val)
      return 1 + streak_in_positive_direction(next_pos, dir, added_val)
    end

    def streak_in_negative_direction(pos, dir, added_val)
      next_pos = [pos[0] - dir[0], pos[1] - dir[1]]
      return 0 unless in_bounds_matching_val?(next_pos, added_val)
      return 1 + streak_in_negative_direction(next_pos, dir, added_val)
    end

    def in_bounds_matching_val?(pos, added_val)
      col, row = pos
      (col > -1 && col < @width) &&
      (row > -1 && row < @height) &&
      @board[col][row] == added_val
    end

    def switch_players
      @current_player =
        @current_player == @player_one ? @player_two : @player_one
    end
  end
end
