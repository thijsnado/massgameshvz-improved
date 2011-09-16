#Define base factories
Factory.define :bite_event do |f|
end

Factory.define :bite_share do |f|
end

Factory.define :email_domain do |f|
  f.description 'umass'
  f.rule 'umass'
end

Factory.define :event do |f|
end

Factory.define :game_participation do |f|
  f.association :user, :factory => :user
  f.association :game, :factory => :game
end

Factory.define :game do |f|
  f.start_at "2010-01-10 00:00:00"
  f.end_at "2010-01-20 23:59:59"
  f.signup_start_at "2010-01-08 00:00:00"
  f.signup_end_at "2010-01-11 23:59:59"
  f.time_per_food 1.day
  f.bite_shares_per_food 1
end

Factory.define :human do |f|
end

Factory.define :living_area do |f|
end

Factory.define :pseudo_bite do |f|
end

Factory.sequence :email_address do |n|
  "email#{n}@umass.edu"
end

Factory.define :squad do |f|
  f.squad_name "The crazy cary killers"
end

Factory.sequence :username do |n|
  "bob#{n}"
end

Factory.define :user do |f|
  f.email_address { Factory.next(:email_address) }
  f.username { Factory.next(:username) }
  f.password 'password'
  f.password_confirmation 'password'
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



