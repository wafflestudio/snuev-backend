namespace :crawler do |tasks_namespace|
  desc "Download lectures from sugang.snu.ac.kr in .xls"
  task :download, [:year, :season] => [:environment] do |task, args|
    year = args.year
    season = args.season

    @xls_path = Crawler::Downloader.download(year, season)
  end

  desc "Convert .xls to .csv"
  task :convert, [:xls_path] => [:environment] do |task, args|
    xls_path = args.xls_path

    @csv_path = Crawler::Converter.convert(xls_path)
  end

  desc "Migrate lectures from .csv to DB"
  task :migrate, [:year, :season] => [:environment] do |task, args|
    Rake::Task['crawler:download'].invoke(args.year, args.season)
    Rake::Task['crawler:convert'].invoke(@xls_path)
    Crawler::Migrator.migrate(@csv_path, args.year, args.season)
  end

end
