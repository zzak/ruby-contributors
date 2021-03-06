namespace :commits do
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

  desc "Output number of commits by non-core contributors"
  task :contributions do
    commits = Commits.new("./ruby", ENV["author"], ENV["since"])
    commits.contributions.report_contributions
  end

  desc "Output total number of commits since the [DOC] tag convention was added"
  task :since_doc_tag do
    commits = Commits.new("./ruby", ENV["author"])
    commits.since_doc_tag.report_total
  end

  desc "Output number of documentation related commits"
  task :docs do
    commits = Commits.new("./ruby", ENV["author"], ENV["since"])
    commits.since_doc_tag.for_docs.report_doc_total
  end
end
