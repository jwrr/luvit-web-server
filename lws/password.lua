-- password.lua

local argon2=require'argon2'

password = {}

password.config = function()
  argon2.t_cost(3)
  argon2.m_cost(4096)
  argon2.parallelism(1)
  argon2.hash_len(32)
  argon2.variant(argon2.variants.argon2_i)
end

password.encode = function(password, k)
  return assert(argon2.hash_encoded(password, k..
  "salti9QI8ZvQVg7UlaBg/xLoT1d51D60nd5y9sTJHDBumHUX4wcabUimezwQhp9vFJ8o"))
end


password.check = function(encodedPassword, password)
  local ok, err = argon2.verify(encodedPassword, password)
  if err then
    print("password.check Error: could not verify: " .. err)
  end
  return ok
end

password.config()

return password

