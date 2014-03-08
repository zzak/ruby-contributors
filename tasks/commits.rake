desc "Output number of commits grouped by lines changed"
task :by_lines_changed do
  commits = Commits.new("./ruby", ENV["author"], ENV["target"])
  commits.smallest = ENV["smallest"]
  commits.calculate!
  commits.report
end
