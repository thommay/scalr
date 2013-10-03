#!/usr/bin/env ruby
#

$:.unshift("lib")
require 'scalr'
require 'awesome_print'

API_KEY_ID = 'f1c08edc5245b07d'
API_SECRET = 'EmBDHCl3W+d8RrjIvtLT5pAcXOSMf+B965d9trw3mzr5PBO5CxmKaAqnnzB3HVMusM7yDVYWuqePwP+LT4kN2/BxP+uxqcchEqxvATXA29zfkcNBn7a5uxXOXP5IbIU0'
API_URL = 'https://ecoslab.karmalab.net'

scalr = Scalr.new(url: API_URL, key: API_KEY_ID, secret: API_SECRET)

resp = scalr.farm_stats(3,114)
ap resp.body

