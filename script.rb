#require 'pry'
class TicTacToe
    attr_accessor :board

    def initialize()
        puts 'Play TicTacToe. Have fun'
        values = [0, 1, 2, 3, 4, 5, 6, 7, 8]
        @board = GameBoard.new(values)
        creat_players
        start
        
    end
    def start()
        puts ''
        #until filled?(@board.spaces)
            #active_player.moves(@active_player, @board, @board.spaces)
        while !board.filled?(@board.spaces)
            @active_player.moves(@active_player, @board, @board.spaces)
            break if @board.beats?(@board.spaces, @active_player)
            switch_players(@active_player)
            
        end
        #binding.pry

        if @board.beats?(@board.spaces, @active_player)
            puts "Congratulations! #{@active_player.name}. You won!"
            replay?
        elsif @board.filled?(@board.spaces)
            puts ' Tie Game! Try again'
            replay?
        end
    end

    def creat_players()
        puts 'Please creat player1'
        player1_name = gets.to_s
        @player1 = Game.new(player1_name, 'O')
        puts 'please creat player2'
        player2_name = gets.to_s
        @player2 = Game.new(player2_name, 'X')
        @active_player= @player1
    end

    def switch_players(active_player)
        if active_player == @player1
            @active_player = @player2
        else
            @active_player = @player1
        end
    end

    def replay?
        res = ''
        while !%w[Y y].include?(res) || (!%w[N n].include?(res))
            puts 'Do you want to play again? (Y/N) PS: Not case sensitive'
            res = gets.chomp
            if %w[Y y].include?(res)
                game_logic = TicTacToe.new
            elsif %w[N n].include?(res)
                exit
            end
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
 
    def initialize(spaces)
       @spaces = spaces
       show_board
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

    def update_spaces(active_player, entry)
        @spaces[entry] = "#{active_player.token}"
        show_board
    end

    def filled?(board)
        board.all?{|i| i == 'O' || i == 'X'}
    end

    def beats?(board, active_player)
        COMPOSE_WINNING.any? do |check|
            check.all?{|cell| board[cell] == active_player.token}
                
        end
    end
                
end

class Game
    attr_accessor :name, :token

    def initialize(name, token)
        @name = name
        @token = token
    end

    def moves(active_player, board, entry)
        puts "It\'s #{name}\'s turn. \nSelect token position, [using numbers, 0 to 9]\n"
        token_position = gets.chomp
        idx = token_idx(token_position)
        while !correct_entry?(entry, idx)
            puts " That entry isn\'t valid. Make a valid entry!"
            token_position = gets.chomp
            idx = token_idx(token_position)
        end
        board.update_spaces(active_player, idx)
    end
    
    def correct_entry?(board, idx)
        idx.between?(0,8) && (!occupied_space?(board, idx))
    end

    def occupied_space?(board, idx)
        board[idx] == 'O' || board[idx] == 'Y'
    end

    def token_idx(input)
        input.to_i - 1
    end

end

       
game_logic = TicTacToe.new
#game = Game.new





    
  
   