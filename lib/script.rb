#require 'pry'
class TicTacToe
    attr_accessor :board, :active_player, :res, :player1, :player2

    def initialize()
        @board = GameBoard.new
        @res = res
        @player1 = nil
        @player2 = nil
        @active_player = nil
    end

    def start()
        puts 'Let have fun playing Tictactoe on the console!'
        #puts ''
        set_up
        board.show_board
        playing_turns
        the_end?
    end

    def enter_player_name(arg)
        "Enter #{arg}'s name"
    end


    def creat(arg, to_ken = nil)
        puts enter_player_name(arg)
        name = gets.chomp
        token = token_gen(to_ken)
        Game.new(name, token)
    end

    def set_up
        @player1 = creat('player1')
        @player2 = creat('palyer2', player1.token)
    end


    def token_gen(repeated)
        puts 'select any letter or spacial character for your game token'
        input = gets.chomp
        if input.match?(/^[^0-8]$/) && input != repeated
            return input 
        elsif input == repeated
            puts 'token already in use! Try again.'
            token_gen(repeated)
        else
            puts 'invalid input! Try again.'
            token_gen(repeated)
        end
    end


    def chance(player)
        space = play_number(player)
        board.update_spaces(space, player.token)
        board.show_board
    end

    def playing_turns
        @active_player = player1
        while !board.filled?
            chance(active_player)
            break if board.beats?
            @active_player = switch_players
        end
    end

    def play_number(player)
        puts play(player.name, player.token)
        choices = gets.chomp.to_i
        return choices if board.occupied_space?(choices)

        puts 'Invalid choice. Try again'
        play_number(player)
    end

    def play(name, token)
        "#{name} play with numbers [0-8] to place #{token} on the board"
    end

    def switch_players
        if active_player == @player1
            @active_player = @player2
        else
            @active_player = @player1
        end
    end


        #binding.pry
    def validate_input(input)
        return input if %w[Y y].include?(input) || %w[N n].include?(input)
    end

    def player_decision
        loop do
            @res = validate_input(replay?)
            break if @res
        puts 'Invalid input'
        end
    end

    def replay?
        puts "Enter [y] to play again or [n] to end game. PS: Not case sensitive"
        loop do
            @res = gets.chomp
            if %w[Y y].include?(@res)
                game_logic = TicTacToe.new
                game_logic.start
            elsif %w[N n].include?(@res)
               exit
            end
            
        end
    end

    def the_end?
        if board.beats?
            puts "Congrats #{active_player.name}! You won."
            puts ''
            player_decision
        else
            puts 'That\'s a tie!'
            puts ''
            player_decision
        end
    end

end

  
class GameBoard
    attr_accessor :spaces
    COMPOSE_WINNING = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [6, 4, 2],
        [0, 4, 8]
     ]
 
    def initialize
       @spaces = [0, 1, 2, 3, 4, 5, 6, 7, 8]
       
       #show_board
    end
        

    def show_board()
        puts '---Game User Interface---'
        puts ''
        puts '-------------'
        puts "| #{@spaces[0]} | #{@spaces[1]} | #{@spaces[2]} |"
        puts '-------------'
        puts "| #{@spaces[3]} | #{@spaces[4]} | #{@spaces[5]} |"
        puts '-------------'
        puts "| #{@spaces[6]} | #{@spaces[7]} | #{@spaces[8]} |"
        puts '-------------'
        puts ''
    end

    def update_spaces(entry, token)
        @spaces[entry] = token
        show_board
    end

    def filled?()
        spaces.all? {|space| space =~ /[^0-8]/}
    end

    def occupied_space?(entry)
        spaces[entry] == entry
    end

    def beats?()
        COMPOSE_WINNING.any? do |cell|
            [spaces[cell[0]], spaces[cell[1]], spaces[cell[2]]].uniq.length == 1
                
        end
    end
                
end

class Game
    attr_accessor :name, :token

    def initialize(name, token)
        @name = name
        @token = token
    end
end

#game_logic = TicTacToe.new
#game_logic.start





    
  
   