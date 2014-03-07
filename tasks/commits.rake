desc "Output number of commits grouped by lines changed for everyone"
task :lines_changed_everyone do
  commits = Commits.new("./ruby", 2000000)
  commits.calculate!
  commits.report
end

desc "Output number of commits grouped by lines changed"
task :by_lines_changed do
  commits = Commits.new("./ruby", 20000, "zzak")
  commits.calculate!
  commits.report
end

desc "Output the number of commits by lines changed for the smallest group"
task :smallest_group_by_lines_changed do
  commits = Commits.new("./ruby", 20000, "zzak")
  commits.calculate!
  commits.report

  smalls = {}
  (1..20).each { |i| smalls[i] = 0 }

  Git.open('./ruby').log(num_commits).author('zzak').each do |commit|
    case stat
    when 1..20
      smalls[stat] += 1
      sizes[:s] += 1
    end
  end
  puts "Commits size 1..20:"
  smalls.each { |key, value| puts "#{key}: #{value}" }
end
