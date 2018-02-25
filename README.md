# lua-opencage-geocoder

This Lua module provides a simple client for the OpenCage forward/reverse geocoding API.
If you'd like to call the geocoding API from an OpenResty installation, check out the [sister library](https://github.com/nmdguerreiro/lua-resty-opencage-geocoder).

# Installation

To install this module, run the following command using the [luarocks package manager](https://luarocks.org/):

```bash
luarocks install lua-opencage-geocoder
```

# Forward geocoding

To perform a forward geocoding request, all you need to do is instantiate the client and make the `geocode` call as is shown below:

```lua
local geocoder = require "opencage.geocoder"

local gc = geocoder.new({
  key = "REPLACE WITH YOUR KEY"
})

local res, status, err = gc:geocode("Brandenburg Gate")
```

# Reverse geocoding

Similarly, to issue a reverse geocoding request, all you need to do is instantiate the client and make the `reverse_geocode` call as is shown below:

```lua
local geocoder = require "opencage.geocoder"

local lat, long = 52.5162767, 13.3777025

local gc = geocoder.new({
  key = "REPLACE WITH YOUR KEY"
})

local res, status, err = gc:reverse_geocode(lat, long)
```

# Error handling

Calls to `geocode` and `reverse_geocode` return three values:
* The table that represents the JSON returned by the OpenCage API.
* A status code
* An error message, if applicable

For convenience, the status codes are available on the client object itself and are defined as per below (and in-line with the [API guide](https://geocoder.opencagedata.com/api#codes)):

```lua
gc.status_ok = 200
gc.status_invalid_request = 400
gc.status_quota_exceeded = 402
gc.status_invalid_key = 403
gc.status_timeout = 408
gc.status_request_too_long = 410
gc.status_rate_exceeded = 429
gc.status_internal_server_error = 503
```

# Parameters

You can supply any additional parameters to help improve your results, as is described in the [API guide](https://geocoder.opencagedata.com/api#forward-opt). For example:
```lua
local geocoder = require "opencage.geocoder"

local gc = geocoder.new({
  key = "REPLACE WITH YOUR KEY"
})

params = { abbrv = 1 }
local res, status, err = gc:geocode("Brandenburg Gate", params)

```

# Dependencies

This library depends on the following `luarocks` packages:

* `luasocket`
* `cjson`
* `net-url`
* `busted` (for running tests locally)

If you're running tests locally, you'll also need to install [docker](https://docker.com).

# Licence
MIT
