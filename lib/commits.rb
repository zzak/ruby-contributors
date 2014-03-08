require 'git'

class Commits
  attr_accessor :sizes, :since, :author, :smallest, :count

  def initialize(path, author=nil, since=nil)
    @path = path
    @author = author
    @since = since
    @count = 0
    @sizes = {
      :small => {:total => 0, :breakdown => ->{
        smalls = {}
        (1..20).each { |i| smalls[i] = 0 }
        return smalls}.call
      },
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

  # Introduced [DOC] tag on 2013-10-16
  def for_docs
    commits.each do |commit|
      @count += 1 if doc_commit?(commit.message)
    end
    self
  end

  def commits
    query = @since ? open_log.since(@since) : open_log
    return @author ? query.author(@author) : query
  end

  def lines_changed(commit)
    stat = 0
    `git show --numstat #{commit.sha}`.scan(/^(\d+)\t(\d+)/).flatten.each { |lines|
      stat += lines.to_i
    }
    return stat
  end

  def report_total
    puts "Total commits by #{@author ? @author : "everyone"}#{@since ? " since #{@since}" : ""}: #{commits.size}"
  end

  def report_doc_total
    puts "Total documentation commits by #{@author ? @author : "everyone"}#{@since ? " since #{@since}" : ""}: #{@count}"
  end

  def report_by_lines_changed
    puts <<-eol
Commits by number of lines changed by #{@author ? @author : "everyone"}
1-20        : #{sizes[:small][:total]}
20-50       : #{sizes[:medium]}
50-100      : #{sizes[:large]}
100-1000    : #{sizes[:xtra_large]}
1000-10000  : #{sizes[:xxtra_large]}
10000-∞     : #{sizes[:xxxtra_large]}

    eol

    if @smallest
      puts "Breakdown of smallest commits by #{@author ? @author : "everyone"}"
      sizes[:small][:breakdown].each { |key, value| puts "#{key}: #{value}" }
    end
  end

  def since_doc_tag
    @since = "2013-10-16"
    self
  end

  private
    def open_log(n=nil)
      Git.open(@path).log(n)
    end

    def increment_sizes!(stat)
      case stat
      when 1..20
        @sizes[:small][:breakdown][stat] += 1 if @smallest
        @sizes[:small][:total] += 1
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

    def doc_commit?(message)
      message =~ /\[DOC\]/
    end
end
