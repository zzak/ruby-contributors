require 'git'

desc "Output number of commits grouped by lines changed"
task :by_lines_changed do
  num_commits = 20000
  sizes = {:s => 0, :m => 0, :l => 0, :xl => 0, :xxl => 0}
  smalls = {}
  (1..20).each { |i| smalls[i] = 0 }

  Git.open('./ruby').log(num_commits).author('zzak').each do |commit|
    log = `git show --numstat #{commit.sha}`
    stat = 0
    log.scan(/^(\d+)\t(\d+)/).flatten.each { |i| stat += i.to_i }

    case stat
    when 1..20
      smalls[stat] += 1
      sizes[:s] += 1
    when 20..50
      sizes[:m] += 1
    when 50..100
      sizes[:l] += 1
    when 100..1000
      sizes[:xl] += 1
    else
      sizes[:xxl] += 1
    end
  end

  puts <<-eol
  Commits by number of lines changed by zzak
    1-20     : #{sizes[:s]}
    20-50    : #{sizes[:m]}
    50-100   : #{sizes[:l]}
    100-1000 : #{sizes[:xl]}
    1000+    : #{sizes[:xxl]}
  eol
end

desc "Output the number of commits by lines changed for the smallest group"
task :smallest_group_by_lines_changed do
  num_commits = 20000
  sizes = {:s => 0, :m => 0, :l => 0, :xl => 0, :xxl => 0}
  smalls = {}
  (1..20).each { |i| smalls[i] = 0 }

  Git.open('./ruby').log(num_commits).author('zzak').each do |commit|
    log = `git show --numstat #{commit.sha}`
    stat = 0
    log.scan(/^(\d+)\t(\d+)/).flatten.each { |i| stat += i.to_i }

    case stat
    when 1..20
      smalls[stat] += 1
      sizes[:s] += 1
    when 20..50
      sizes[:m] += 1
    when 50..100
      sizes[:l] += 1
    when 100..1000
      sizes[:xl] += 1
    else
      sizes[:xxl] += 1
    end
  end

  puts "Commits size 1..20:"
  smalls.each { |key, value| puts "#{key}: #{value}" }
end
