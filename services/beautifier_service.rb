module Beautifier
  def show_stats_with_beauty(statistics)
    decorated_stats = stats_beautify(statistics.sort_statistics)
    decorated_stats.each_with_index do |user, index|
      puts(I18n.t('rating') + index.next.to_s)
      user.each { |key, value| puts "#{key} #{value}" }
      puts '=' * 25
    end
  end

  def stats_beautify(statistics)
    statistics.each do |user|
      user.transform_keys! { |k| k.to_s.capitalize.tr('_', ' ').insert(-1, ':') }
    end
  end
end

