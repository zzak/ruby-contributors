require 'git'

class Commits
  attr_accessor :sizes, :target, :author

  def initialize(path, target, author=nil)
    @path = path
    @target = target
    @author = author
    @sizes = {
      :small => 0,
      :medium => 0,
      :large => 0,
      :xtra_large => 0,
      :xxtra_large => 0,
      :xxxtra_large => 0
    }
  end

  def calculate!
    commits.each do |commit|
      stat = lines_changed(commit)
      increment_sizes!(stat)
    end
  end

  def commits
    @author ? open_log : open_log.author(@author)
  end

  def lines_changed(commit)
    stat = 0
    `git show --numstat #{commit.sha}`.scan(/^(\d+)\t(\d+)/).flatten.each { |lines|
      stat += lines.to_i
    }
    return stat
  end

  def report
    puts <<-eol
    Commits by number of lines changed by #{@author ? @author : "everyone"}
      1-20        : #{sizes[:small]}
      20-50       : #{sizes[:medium]}
      50-100      : #{sizes[:large]}
      100-1000    : #{sizes[:xtra_large]}
      1000-10000  : #{sizes[:xxtra_large]}
      10000-∞     : #{sizes[:xxxtra_large]}
    eol
  end

  private
    def open_log
      Git.open(@path).log(@target)
    end

    def increment_sizes!(stat)
      case stat
      when 1..20
        @sizes[:small] += 1
      when 20..50
        @sizes[:medium] += 1
      when 50..100
        @sizes[:large] += 1
      when 100..1000
        @sizes[:xtra_large] += 1
      when 1000..10000
        @sizes[:xxtra_large] += 1
      else
        @sizes[:xxxtra_large] += 1
      end
    end
end
