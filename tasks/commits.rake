desc "Output number of commits grouped by lines changed"
task :by_lines_changed do
  commits = Commits.new("./ruby", ENV["author"], ENV["since"])
  commits.smallest = ENV["smallest"]
  commits.calculate!
  commits.report_by_lines_changed
end

desc "Output number of commits"
task :total do
  commits = Commits.new("./ruby", ENV["author"], ENV["since"])
  commits.report_total
end
end
