--[[
应用配置文件
--]]
mysql = {
    host = "172.17.20.224",
    port = "3306",
    user = "luastar_user",
    password = "5Nnjg0kPcziZGfXD",
    database = "luastar_db",
    timeout = 30000,
    pool_size = 1000
}
redis = {
    host = "172.17.20.224",
    port = "6379",
    auth = {
        username = "opentresty_user",
        password = "G0HHCczDhRQSZlnk"
    },
    db_index = 9,
    timeout = 30000,
    pool_size = 1000
}
