local http = require "socket.http"
local url = require "net.url"
local cjson = require "cjson"

local _M = {
    _VERSION = '0.1',
}

local mt = { __index = _M }

function _M._request(self, q, params)
    local query = { key = self.key; q = q; no_annotations="1" }

    if params then
        for k,v in pairs(params) do query[k] = v end
    end

    local url = url.parse(self.url)

    for k,v in pairs(query) do url.query[k] = v end

    local res, code = http.request(url:build())

    if not res then
        return nil, self.status_unexpected_error, err
    else
        local decoded = cjson.decode(res)
        if decoded then
            return decoded, decoded.status.code, err
        else
            return nil, self.status_unexpected_error, err
        end
    end
end

-- Builds a new client.
-- @param options a table with two entries: 'key' as the API key and 'url' if you'd like to use a custom URL
function _M.new(options)
    local params = {
        key = options.key,
        url = options.url or "https://api.opencagedata.com/geocode/v1/json",
    }

    -- set error code aliases
    params.status_unexpected_error = -1
    params.status_ok = 200
    params.status_invalid_request = 400
    params.status_quota_exceeded = 402
    params.status_invalid_key = 403
    params.status_timeout = 408
    params.status_request_too_long = 410
    params.status_rate_exceeded = 429
    params.status_internal_server_error = 503

    return setmetatable(params, mt)
end

-- Reverse geocodes a position (i.e. converts a latitude/longitude to a set of identifiers and codes that represent that position).
-- @param lat latitude
-- @param lng longitude
-- @return a tuple with 3 elements: the JSON response as a table if successful, the status code and an optional error message.
function _M.reverse_geocode(self, lat, lng, params)
    return self:_request(lat .. "," .. lng, params)
end

-- Forward geocodes an address (i.e. converts a textual address to a set of positions and returns information about those positions).
-- @param address place or address to lookup (e.g. Branderburg Gate)
-- @return a tuple with 3 elements: the JSON response as a table if successful, the status code and an optional error message.
function _M.geocode(self, address, params)
    return self:_request(address, params)
end

return _M
