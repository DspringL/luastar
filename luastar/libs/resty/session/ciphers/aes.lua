local setmetatable = setmetatable
local tonumber     = tonumber
local aes          = require "resty.aes"
local cip          = aes.cipher
local hashes       = aes.hash
local var          = ngx.var

local CIPHER_MODES = {
    ecb    = "ecb",
    cbc    = "cbc",
    cfb1   = "cfb1",
    cfb8   = "cfb8",
    cfb128 = "cfb128",
    ofb    = "ofb",
    ctr    = "ctr"
}

local CIPHER_SIZES = {
    ["128"] = 128,
    ["192"] = 192,
    ["256"] = 256
}

local defaults = {
    size   = CIPHER_SIZES[var.session_aes_size] or 256,
    mode   = CIPHER_MODES[var.session_aes_mode] or "cbc",
    hash   = hashes[var.session_aes_hash]       or "sha256",
    rounds = tonumber(var.session_aes_rounds)   or 1
}

local cipher = {}

cipher.__index = cipher

function cipher.new(config)
    local a = config and config.aes or defaults
    return setmetatable({
        size   = CIPHER_SIZES[a.size or defaults.size]   or 256,
        mode   = CIPHER_MODES[a.mode or defaults.mode]   or "cbc",
        hash   = hashes[a.hash       or defaults.hash]   or hashes.sha256,
        rounds = tonumber(a.rounds   or defaults.rounds) or 1
    }, cipher)
end

-- 处理salt长度，salt要么为nil要么长度为8
local function salt_substring(str)
    if str == nil or string.len(str) < 8 then
        return nil
    end

    local str_len = string.len(str)
    if str_len == 8 then
        return str
    else
        return string.sub(str, 1, 8)
    end
end

function cipher:encrypt(content, key, salt)
    -- 适配salt超过8位出错
    salt = salt_substring(salt)
    local _aes,err = aes:new(key, salt, cip(self.size, self.mode), self.hash, self.rounds)
    if err then
        ngx.log(ngx.ERR,"aes.new error: ",err)
    end
    return _aes:encrypt(content)
end

function cipher:decrypt(content, key, salt)
    -- 适配salt超过8位出错
    salt = salt_substring(salt)
    local _aes,err = aes:new(key, salt, cip(self.size, self.mode), self.hash, self.rounds)
    if err then
        ngx.log(ngx.ERR,"aes.new error: ",err)
    end
    return _aes:decrypt(content)
end

return cipher