class Console
  include Questioner
  include Beautifier

  FILE_PATH = './db/statistics.yml'.freeze

  def initialize
    @statistics = Codebreaker::StatisticsService.new(FILE_PATH)
  end

  def choose_main_menu_option
    puts I18n.t('introduction')
    ask_choose_game_option(self)
  end

  def start
    @user = RegistratorService.create_user
    @difficulty = RegistratorService.create_difficulty
    @game = Codebreaker::Game.new(@user, @difficulty)
    start_game_process
  end

  def start_new_game
    @difficulty = RegistratorService.create_difficulty
    @game = Codebreaker::Game.new(@user, @difficulty)
    start_game_process
  end

  def stats
    return puts I18n.t('no_stats') unless File.exist? FILE_PATH

    puts I18n.t('stats_prev_line')
    show_stats_with_beauty(@statistics)
    ask_choose_game_option(self)
  end

  def rules
    puts I18n.t('rules')
    ask_choose_game_option(self)
  end

  def leave
    puts I18n.t('bye')
    exit true
  end

  def hint
    return puts I18n.t('no_hints') if @game.no_hints?

    puts(I18n.t('show_hint') + @game.use_hint.to_s)
  end

  def check_guess(guess)
    return won if @game.win?(guess)

    error = error_message { Codebreaker::GuessChecker.validate(guess) }
    return if error.nil?

    puts @game.check_attempt(guess)
  end

  def lost
    puts(I18n.t('lose') + @game.secret_code.join)
    ask_about_new_game(self)
  end

  def won
    puts(I18n.t('win') + @game.secret_code.join)
    ask_about_save_results(self, @game, @statistics)
  end

  private

  def start_game_process
    until @game.lose?
      show_current_state
      ask_choose_command_in_game_process(self)
    end
    lost
  end

  def show_current_state
    puts(I18n.t('difficulty') + @game.difficulty.level.to_s)
    show_attempts_and_hints
  end

  def show_attempts_and_hints
    puts(I18n.t('attempts') + @game.attempts.to_s)
    puts(I18n.t('hints') + @game.hints.to_s)
  end

  def error_message
    yield
    true
  rescue Codebreaker::ValidationError => e
    puts e.message
  end
end
