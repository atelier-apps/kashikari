task :notice_task => :environment do
    puts 'done.'
    redirect_to(notice_path)
end
