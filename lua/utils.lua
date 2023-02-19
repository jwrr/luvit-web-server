-- utils.lua

local utils = {}

function utils.slurp(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end


function utils.fileExists(name)
   local f=io.open(name, "r")
   if f~=nil then io.close(f) return true else return false end
end

return utils
