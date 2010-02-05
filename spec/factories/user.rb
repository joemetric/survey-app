Factory.define :user do |u|
  u.name 'Aaron'
  u.email 'aaron@example.com'
  u.login 'aaron'
  u.password 'monkey'
  u.password_confirmation 'monkey'
  u.password_salt '356a192b7913b04c54574d18c28d46e6395428ab'
  u.crypted_password 'df42adbd0b4f7d31af495bcd170d4496686aecb1'
  u.created_at '2008-11-22 12u.13u.59'
  u.active true
end