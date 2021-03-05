require_relative '../lib/script.rb'

describe TicTacToe do
    describe '#creat' do
        subject(:creat_players) {described_class.new}
        context 'when creating players' do
            it 'creat player1' do
                player = 'Felicity'
                player_token = 'O'
                allow(creat_players).to receive(:puts)
                allow(creat_players).to receive(:enter_player_name).with('player1')
                allow(creat_players).to receive(:gets).and_return(player)
                allow(creat_players).to receive(:token_gen).and_return(player_token)
                expect(Game).to receive(:new).with(player, player_token)
                creat_players.creat('player1')
            end

            it 'creat player2' do
                player = 'Fels'
                player_token = 'X'
                allow(creat_players).to receive(:puts)
                allow(creat_players).to receive(:enter_player_name).with('player2')
                allow(creat_players).to receive(:gets).and_return(player)
                allow(creat_players).to receive(:token_gen).and_return(player_token)
                expect(Game).to receive(:new).with(player, player_token)
                creat_players.creat('player2')
            end
        end
    end

    describe '#start' do
        subject(:start_game) {described_class.new}
        
        before do
            start_game.instance_variable_set(:@board, instance_double(GameBoard))
        end

        it 'Starts game' do
            info = 'Let have fun playing Tictactoe on the console!'
            allow(start_game).to receive(:puts).with(info)
            allow(start_game).to receive(:set_up)
            allow(start_game).to receive(:playing_turns)
            allow(start_game).to receive(:the_end?)
            expect(start_game.board).to receive(:show_board)
            start_game.start
        end
    end



    describe "#switch_players" do
        subject(:switch) {described_class.new}
        context 'when active player is player1' do
            it 'switch to player2' do
                player2 = 'Benedict'
               expect(player2).to eq('Benedict')
               switch.switch_players
            end
        end

        context 'when active player is player2' do
            it 'switch to player1' do
                player1 = 'Irene'
                expect(player1).to eq('Irene')
                switch.switch_players
            
            end
        end
    end

    describe "#player_decision" do
        subject(:play_again) {described_class.new}
        context 'when player input is valid' do
            it 'stops loop and replay with input [y] for Yes' do
                input =  'y'
                msg = 'Invalid input'
                allow(play_again).to receive(:replay?).and_return(input)
                expect(play_again).not_to receive(:puts).with(msg)
                play_again.player_decision
            end

            it 'stops loop and exit with input [n] for No' do
                input =  'n'
                msg = 'Invalid input'
                allow(play_again).to receive(:replay?).and_return(input)
                expect(play_again).not_to receive(:puts).with(msg)
                play_again.player_decision
            end
        end

        context ' when player inputs one invalid input and then a valid input ' do
            before do
                invalid = 't'
                valid_input = 'y'
                allow(play_again).to receive(:replay?).and_return(invalid, valid_input)
                
            end

            it 'finishes the loop and return error message once' do
                msg = 'Invalid input'
                expect(play_again).to receive(:puts).with(msg).once
                play_again.player_decision
            end
        end
       

        context ' when player inputs two invalid input and then a valid input ' do
            before do
                invalid = 't'
                invalid_again = '9'
                valid_input = 'y'
                allow(play_again).to receive(:replay?).and_return(invalid, invalid_again, valid_input)
            end
            it 'finishes the loop and return error message twice' do
                msg = 'Invalid input'
                expect(play_again).to receive(:puts).with(msg).twice
                play_again.player_decision
            end
        end

    end

    describe "#chance" do
        subject(:play_chances) {described_class.new}

        it 'update board real time with respective player token' do
            play_chances.instance_variable_set(:@player1, instance_double(Game))
            player_entry = 7
            player_token = 'O'
            allow(play_chances).to receive(:play_number).with(play_chances.player1).and_return(player_entry)
            allow(play_chances.player1).to receive(:token).and_return(player_token)
            allow(play_chances.board).to receive(:show_board)
            expect(play_chances.board).to receive(:update_spaces).with(player_entry, player_token)
            play_chances.chance(play_chances.player1)
        end
    end

end


describe GameBoard do
    describe "#filled?" do
        subject(:game_board) {described_class.new}
        context 'When the board is filled up' do
            before do
                game_board.instance_variable_set(:@spaces, %w[O O X O X X O X O])
                
            end
          it ' is filled up' do
            expect(game_board).to be_filled
          end
        end

        context 'When board is empty' do
            it 'There is no token on the board' do
                expect(game_board).not_to be_filled
            end
        end

        context 'When board is partially filled up' do
            before do
                game_board.instance_variable_set(:@spaces, %w[O X X 3 4 O X O 6])
            end

            it 'is not filled up' do
                expect(game_board).not_to be_filled
            end
        end
    end

    describe '#beats?' do
        subject(:winner) {described_class.new}

        context 'When a token is repeated thrice horizontaly, vertically or diagonally' do
            before do
                winner.instance_variable_set(:@spaces, ['O', 'O', 'O', 3, 6, 'X', 'X', 7, 'X'])
            end

            it 'returns the active player has the winner' do
                expect(winner).to be_beats
            end
        end
    end

    describe "#update_spaces" do
        subject(:space_update) {described_class.new}

        context ' when there is a new entry' do

            it ' updates spaces with new entry' do
                player_token = 'X'
                player_entry = 6
                space_update.update_spaces(player_entry, player_token )
                updated = space_update.spaces
                update_at_index_6 = [0, 1, 2, 3, 4, 5, 'X', 7, 8]
                expect(updated).to eq(update_at_index_6)
            end
        end
    end

    describe '#occupied_space?' do
        subject(:valid_entry) {described_class.new}
        context 'when board is new' do
            it 'valid entry' do
                entry = valid_entry.occupied_space?(6)
                expect(entry).to be true
            end
        end

        context 'When an entry is already taken' do
            before do
                valid_entry.instance_variable_set(:@spaces, ['O', 1, 2, 'O', 4, 5, 'X', 7, 8])
            end

            it ' is an invalid entry' do
                entry = valid_entry.occupied_space?(0)
                expect(entry).not_to be true
            end
        end
    end

end

