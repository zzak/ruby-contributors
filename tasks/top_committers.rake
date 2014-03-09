desc "Output the top 15 committers"
task :top_committers do
  options = []
  options << "-n#{ENV["number"]}" if ENV["number"]
  options << "--since='#{ENV["since"]}'" if ENV["since"]
  sh "cd ruby && git shortlog -s #{options.join(" ")} | sort -rn | head -15"
end
