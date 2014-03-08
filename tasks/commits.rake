desc "Output number of commits grouped by lines changed for everyone"
task :lines_changed_everyone do
  commits = Commits.new("./ruby")
  commits.calculate!
  commits.report
end

desc "Output number of commits grouped by lines changed"
task :by_lines_changed do
  commits = Commits.new("./ruby", "zzak")
  commits.calculate!
  commits.report
end

desc "Output the number of commits by lines changed for the smallest group"
task :smallest_group_by_lines_changed do
  commits = Commits.new("./ruby", "zzak")
  commits.smallest = true
  commits.calculate!
  commits.report
end
