  desc 'Compile .rb file from Qt Designer Form (.ui)'
  task(:build) do
    Dir['*.ui'].each do |i|
      system("rbuic4 -x #{i} -o #{File.basename(i, '.ui')}_ui.rb")
      puts "#{i} -> #{File.basename(i, '.ui')}_ui.rb"
    end
  end

  desc 'Launch application from start.rb'
  task (:launch) => [:build, :translations]  do
    puts 'Launching...'
    system('ruby start.rb')
  end

  desc 'Compile translations (.ts) into Qt message files (.qm)'
  task(:translations) do
    Dir['translations/*.ts'].each do |i|
      system("lrelease #{i} -qm #{i.sub(/\.ts$/, '.qm')}")
      puts "#{i} -> #{i.sub(/\.ts$/, '.qm')}"
    end
  end
  
  task (:default) => :launch do end