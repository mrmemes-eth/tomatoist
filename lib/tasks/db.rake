namespace :db do
  desc 'delete old sessions'
  task :prune_sessions => :environment do
    puts "Inspecting #{Session.count} documents"
    sessions = Session.where(:created_at.gte => 30.days.ago)
    puts "Removing #{sessions.count} documents"
    sessions.delete_all
    puts "So fresh 'n so clean-clean..."
  end
end
