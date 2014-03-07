desc "Output the top 15 committers"
task :top_committers do
  sh "cd ruby && git shortlog -s | sort -rn | head -15"
end
