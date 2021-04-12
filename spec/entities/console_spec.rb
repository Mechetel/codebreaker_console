require 'spec_helper'

RSpec.describe Console do
  let(:user) { Codebreaker::User.new('Mechetel') }
  let(:difficulty) { Codebreaker::Difficulty.new('hell') }
  let(:game) { Codebreaker::Game.new(user, difficulty) }
  let(:console) { described_class.new }

  before do
    console.instance_variable_set(:@game, game)
  end

  describe '#choose_main_menu_option' do
    it 'calls #ask_choose_game_option with console object' do
      allow(console).to receive(:ask_choose_game_option).with(console)
      console.choose_main_menu_option
    end
  end

  describe '#rules' do
    it 'puts rules' do
      allow(console).to receive(:ask_choose_game_option)
      expect { console.rules }.to output("#{I18n.t('rules')}\n").to_stdout
    end
  end

  describe '#start' do
    it 'sets game instance variable' do
      allow(console).to receive(:start_game_process)
      allow(RegistratorService).to receive(:create_user)
      allow(RegistratorService).to receive(:create_difficulty)
      allow(Codebreaker::Game).to receive(:new)
      console.start
    end
  end

  describe '#start_new_game' do
    it 'sets game instance variable' do
      allow(console).to receive(:start_game_process)
      allow(RegistratorService).to receive(:create_difficulty)
      allow(Codebreaker::Game).to receive(:new)
      console.start_new_game
    end
  end

  describe '#start_game_process' do
    context 'when loses the game' do
      it 'receive lost method' do
        game.instance_variable_set(:@attempts, 1)
        console.instance_variable_set(:@game, game)
        allow(console).to receive(:gets).and_return('1234')
        allow(console).to receive(:lost)
        console.send(:start_game_process)
      end
    end
  end

  describe '#stats' do
    context 'when file exist' do
      before do
        stub_const('Console::FILE_PATH', './db/test.yml')
        console.instance_variable_set(:@statistics, Codebreaker::StatisticsService.new(Console::FILE_PATH))
        file = File.open(Console::FILE_PATH, 'w')
        data = [{ player: 'Mechetel', difficulty: 'hell', attempts_total: 5,
                  attempts_used: 1, hints_total: 1, hints_used: 0 }]
        file.write(data.to_yaml)
        file.close
      end

      after { File.delete(Console::FILE_PATH) }

      it 'puts statistics header' do
        allow(console).to receive(:ask_choose_game_option)
        expect { console.stats }.to output("#{I18n.t('stats_prev_line')}" \
                      "\nRating: #1\nPlayer: Mechetel\nDifficulty: hell\n" \
                      "Attempts total: 5\nAttempts used: 1\nHints total: 1\nHints used: 0\n" \
                      "=========================\n").to_stdout
      end

      it "puts user's statistics" do
        allow(console).to receive(:ask_choose_game_option)
        allow(console).to receive(:show_stats_with_beauty).with(console.instance_variable_get(:@statistics))
        console.stats
      end
    end

    context 'when file not exist' do
      it 'puts no statistics message' do
        stub_const('Console::FILE_PATH', './db/test.yml')
        expect { console.stats }.to output("#{I18n.t('no_stats')}\n").to_stdout
      end
    end
  end

  describe '#leave' do
    it 'puts bye message and exit' do
      expect { console.leave }.to raise_error(SystemExit)
    end
  end

  describe '#hint' do
    context 'when no hints' do
      it 'shows no_hints message' do
        game.instance_variable_set(:@hints, 0)
        expect { console.hint }.to output("#{I18n.t('no_hints')}\n").to_stdout
      end
    end

    context 'when hints exist' do
      it 'shows hint' do
        game.instance_variable_set(:@hints, 2)
        game.instance_variable_set(:@hints_list, [1, 2])
        expect { console.hint }.to output("#{I18n.t('show_hint')}2\n").to_stdout
      end
    end
  end

  describe '#check_guess' do
    context 'when guess equals to secret code' do
      it 'calls won method' do
        allow(console).to receive(:won)
        console.check_guess(game.secret_code.join)
      end
    end

    context 'when incorrect guess passed' do
      let(:unright_guess) { 'abra' }

      it 'puts error message' do
        allow(console).to receive(:error_message)
        console.check_guess(unright_guess)
      end
    end

    context 'when error not exist' do
      it 'shows output to check_attempt method' do
        console.instance_variable_set(:@error_exist, false)
        game.instance_variable_set(:@secret_code, [1, 2, 3, 5])
        expect { console.check_guess('1234') }.to output("+++\n").to_stdout
      end
    end
  end

  describe '#lost' do
    it 'puts lose message' do
      allow(console).to receive(:ask_about_new_game)
      expect { console.lost }.to output("#{I18n.t('lose')}#{game.secret_code.join}\n").to_stdout
    end
  end

  describe '#won' do
    it 'puts win message' do
      allow(console).to receive(:ask_about_save_results)
      allow(console).to receive(:ask_about_new_game)
      expect { console.won }.to output("#{I18n.t('win')}#{game.secret_code.join}\n").to_stdout
    end
  end
end
