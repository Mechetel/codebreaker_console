RSpec.describe Console do
  let(:user) { Codebreaker::User.new('Mechetel') }
  let(:difficulty) { Codebreaker::Difficulty.new('hell') }
  let(:game) { Codebreaker::Game.new(user, difficulty) }
  let(:console) { described_class.new }
  let(:file_path) { './db/statistics.yml' }
  let(:statistics) { Codebreaker::StatisticsService.new(file_path) }

  before do
    console.instance_variable_set(:@game, game)
  end

  describe '#ask_about_save_results' do
    after do
      console.ask_about_save_results(console, game, statistics)
    end

    context 'when answer is agree' do
      it 'store statistics' do
        allow(console).to receive(:gets).once.and_return(I18n.t('answers.agree'))
        allow(console).to receive(:ask_about_new_game).with(console)
        expect(statistics).to receive(:store).with(game)
      end
    end

    context 'when answer is disagree' do
      it 'return and do nothing' do
        allow(console).to receive(:gets).once.and_return(I18n.t('answers.disagree'))
        expect(console).to receive(:ask_about_new_game).with(console)
      end
    end

    context 'when passed unallowed command' do
      it 'puts unallowed command message' do
        allow(console).to receive(:gets).exactly(3).times.and_return(
          '123qwe',
          I18n.t('answers.disagree')
        )
        expect(console).to receive(:leave)
      end
    end
  end

  describe '#ask_choose_game_option' do
    it 'call game_option_helper' do
      allow(console).to receive(:gets).once.and_return('something')
      expect(console).to receive(:game_option_helper)
      console.ask_choose_game_option(console)
    end
  end

  describe '#game_option_helper' do
    context 'when choosed start' do
      it 'call start method' do
        expect(console).to receive(:start)
        console.send(:game_option_helper, console, I18n.t('commands.start'))
      end
    end

    context 'when choosed rules' do
      it 'call rules method' do
        expect(console).to receive(:rules)
        console.send(:game_option_helper, console, I18n.t('commands.rules'))
      end
    end

    context 'when choosed stats' do
      it 'calls stats method' do
        allow(console).to receive(:ask_choose_game_option).with(console)
        expect(console).to receive(:stats)
        console.send(:game_option_helper, console, I18n.t('commands.stats'))
      end
    end

    context 'when choosed exit' do
      it 'leave from game' do
        expect(console).to receive(:leave)
        console.send(:game_option_helper, console, I18n.t('commands.exit'))
      end
    end

    context 'when passed unallowed command' do
      it 'puts unallowed command message' do
        expect(console).to receive(:choose_main_menu_option)
        console.send(:game_option_helper, console, '123qwe')
      end
    end
  end

  describe '#ask_choose_command_in_game_process' do
    after do
      console.ask_choose_command_in_game_process(console)
    end

    context 'when answer is hint' do
      it 'calls hint method' do
        allow(console).to receive(:gets).once { I18n.t('commands.hint') }
        expect(console).to receive(:hint)
      end
    end

    context 'when answer is exit' do
      it 'leave from game' do
        allow(console).to receive(:gets).once { I18n.t('commands.exit') }
        expect(console).to receive(:leave)
      end
    end
  end

  describe '#ask_about_new_game' do
    after do
      console.ask_about_new_game(console)
    end

    context 'when answer is agree' do
      it 'strarts new game' do
        allow(console).to receive(:gets).once.and_return(
          I18n.t('answers.agree')
        )
        expect(console).to receive(:start_new_game)
      end
    end

    context 'when answer is disagree' do
      it 'leave from game' do
        allow(console).to receive(:gets).once { I18n.t('answers.disagree') }
        expect(console).to receive(:leave)
      end
    end

    context 'when passed unallowed command' do
      it 'puts unallowed command message' do
        allow(console).to receive(:gets).twice.and_return(
          '123qwe',
          I18n.t('answers.disagree')
        )
        expect(console).to receive(:leave)
      end
    end
  end
end
