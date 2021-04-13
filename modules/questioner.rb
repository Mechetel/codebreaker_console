module Questioner
  def ask_about_new_game(console)
    puts I18n.t('again')
    case gets.chomp
    when I18n.t('answers.agree')     then console.start_new_game
    when I18n.t('answers.disagree')  then console.leave
    else
      puts I18n.t('unexpected_command')
      ask_about_new_game(console)
    end
  end

  def ask_about_save_results(console, game, statistics)
    puts I18n.t('save')
    case gets.chomp
    when I18n.t('answers.agree')
      statistics.store(game)
      ask_about_new_game(console)
    when I18n.t('answers.disagree') then ask_about_new_game(console)
    else
      puts I18n.t('unexpected_command')
      ask_about_save_results(console, game, statistics)
    end
  end

  def ask_choose_game_option(console)
    puts I18n.t('commands_description')
    input = gets.chomp
    game_option_helper(console, input)
  end

  def ask_choose_command_in_game_process(console)
    puts I18n.t('enter_guess')
    input = gets.chomp
    case input
    when I18n.t('commands.hint') then console.hint
    when I18n.t('commands.exit') then console.leave
    else console.check_guess(input)
    end
  end

  private

  def game_option_helper(console, input)
    case input
    when I18n.t('commands.start') then console.start
    when I18n.t('commands.rules') then console.rules
    when I18n.t('commands.stats')
      console.stats
      ask_choose_game_option(console)
    when I18n.t('commands.exit') then console.leave
    else
      puts I18n.t('unexpected_command')
      console.choose_main_menu_option
    end
  end
end
