local geocoder = require "opencage.geocoder"
local baseurl = "http://127.0.0.1:" .. PORT

describe('Tests the OpenCage client', function()

  it('Test successful reverse geocoding', function()
    local gc = geocoder.new({
      key = "1234",
      url = baseurl .. "/test-reverse"
    })

    local res, status, err = gc:reverse_geocode(52.5162767, 13.3777025)

    if not res then
       error("Test failed with error: " .. err)
    else
       assert.same(res.status.code, 200)
       assert.same(res.total_results, 1)
       assert.same(res.results[1].geometry.lat, 52.5162767)
       assert.same(res.results[1].geometry.lng, 13.3777025)
       assert.same(res.results[1].formatted, "Brandenburg Gate, Pariser Platz 1, 10117 Berlin, Germany")
    end
  end)

  it('Test successful forward geocoding', function()
    local gc = geocoder.new({
      key = "1234",
      url = baseurl .. "/test-forward"
    })

    local res, status, err = gc:geocode("Brandenburg Gate")

    if not res then
       error("Test failed with error: " .. err)
    else
       assert.same(res.status.code, 200)
       assert.same(res.total_results, 1)
       assert.same(res.results[1].geometry.lat, 52.5162767)
       assert.same(res.results[1].geometry.lng, 13.3777025)
       assert.same(res.results[1].formatted, "Brandenburg Gate, Pariser Platz 1, 10117 Berlin, Germany")
    end
  end)

  it('Test successful forward geocoding with extra parameters', function()
    local gc = geocoder.new({
      key = "1234",
      url = baseurl .. "/test-forward-params"
    })

    local res, status, err = gc:geocode("Brandenburg Gate", { abbrv = 1 })

    if not res then
       error("Test failed with error: " .. err)
    else
       assert.same(res.status.code, 200)
       assert.same(res.total_results, 1)
       assert.same(res.results[1].geometry.lat, 52.5162767)
       assert.same(res.results[1].geometry.lng, 13.3777025)
       assert.same(res.results[1].formatted, "Brandenburg Gate, Pariser Platz 1, 10117 Berlin, Germany")
    end
  end)

  it('Test error handling, in this example, rate exceeded', function()
    local gc = geocoder.new({
      key = "1234",
      url = baseurl .. "/test-rate-exceeded"
    })

    local res, status, err = gc:geocode("Brandenburg Gate", { abbrv = 1 })

    if not res then
       error("Test failed with error: " .. err)
    else
       assert.same(res.status.code, 429)
       assert.same(res.rate.reset, 1519516800)
    end
  end)


end)
