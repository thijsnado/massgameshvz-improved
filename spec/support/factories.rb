#Define base factories
Factory.define :email_domain do |f|
end

Factory.define :event do |f|
end

Factory.define :game_participation do |f|
end

Factory.define :game do |f|
end

Factory.define :human do |f|
end

Factory.define :living_area do |f|
end

Factory.define :user do |f|
end

Factory.define :vaccine do |f|
end

Factory.define :zombie do |f|
end

#Define games
Factory.define :current_game, :parent => :game do |f|
  f.start_at "2011-01-10 00:00:00"
  f.end_at "2011-01-20 23:59:59"
  f.signup_start_at "2011-01-08 00:00:00"
  f.signup_end_at "2011-01-11 23:59:59"
  f.time_per_food 1.day
  f.bite_shares_per_food 1
end


