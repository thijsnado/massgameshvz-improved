Before do
  Timecop.return
  Fixtures.reset_cache
  fixtures_folder = File.join(RAILS_ROOT, 'test', 'fixtures')
  fixtures = Dir[File.join(fixtures_folder, '*.yml')].map {|f| File.basename(f, '.yml') }
  Fixtures.create_fixtures(fixtures_folder, fixtures)
  User.all.each do |user|
    Timecop.return
    user.password = 'password'
    user.password_confirmation = 'password'
    user.save(:validate => false)
  end
end