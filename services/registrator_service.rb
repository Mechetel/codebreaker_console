class RegistratorService
  class << self
    def create_user
      puts I18n.t('enter_name')
      input = gets.chomp
      user = Codebreaker::User.new(input)
      return user if user.valid?

      show_entities_error(user)
      create_user
    end

    def create_difficulty
      puts I18n.t('enter_difficulty')
      input = gets.chomp
      difficulty = Codebreaker::Difficulty.new(input)
      return difficulty if difficulty.valid?

      show_entities_error(difficulty)
      create_difficulty
    end

    private

    def show_entities_error(obj)
      raise obj.errors.last unless obj.valid?
    rescue Codebreaker::ValidationError => e
      puts e.message
    end
  end
end
