require 'spec_helper'

RSpec.describe RegistratorService do
  let(:difficulty) { Codebreaker::Difficulty.new('hell') }
  let(:user) { Codebreaker::User.new('validname') }

  describe '::create_user' do
    it 'creates new user' do
      allow(Codebreaker::User).to receive(:new).and_return(user)
      allow(described_class).to receive(:gets).and_return('validname')
      expect(described_class.create_user).to eq(user)
    end
  end

  describe '::create_difficulty' do
    it 'creates new difficulty' do
      allow(Codebreaker::Difficulty).to receive(:new).and_return(difficulty)
      allow(described_class).to receive(:gets).and_return('hell')
      expect(described_class.create_difficulty).to eq(difficulty)
    end
  end

  describe '#show_entities_error' do
    let(:invalid_user) { Codebreaker::User.new('qw') }
    let(:invalid_difficulty) { Codebreaker::Difficulty.new('eas1') }

    it 'returns error message when user in' do
      expect do
        described_class.send(:show_entities_error, invalid_user)
      end.to output("#{I18n.t('short_name_error')}\n").to_stdout
    end

    it 'returns error message when difficulty in' do
      expect do
        described_class.send(:show_entities_error, invalid_difficulty)
      end.to output("#{I18n.t('difficulty_error')}\n").to_stdout
    end
  end
end
