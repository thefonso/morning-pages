module MorningPages
  TARGET = 750
  class Folder
    def initialize(options = {})
      @dir = options[:dir]
      if (@dir && !File.exists?(@dir))
        FileUtils.mkdir_p(@dir)
      end
    end

    class Stats < Struct.new(:words)
      def count
        words.count
      end
    end

    def stats_for_today
      words = get_words_for(today_path).split(" ")
      stats = Stats.new(words)
      [
        target(stats),
        "You have written #{stats.count} words today.",
        average_word_length(words)
      ].join("\n")
    end

    def average_word_length(words)
      words.count > 0 ?
        "Average word length: %.2f." % [ words.average_length ] :
        ""
    end

    def target(stats)
      stats.count >= TARGET ?
        "Congratulations! You have reached the target today -- you are awesome!" :
        "You have written %.2f%% of the target today." % [stats.count * 100.0 / TARGET]
    end

    def today_path
      File.expand_path([@dir, Time.now.strftime("%Y\-%m\-%d")].join('/'))
    end

    def get_words_for(path)
      File.exists?(path) ? File.read(path) : ""
    end
  end
end
