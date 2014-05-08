require 'spec_helper'

describe ScalrApi::Calls do

let(:url) { 'https://ecoslab.karmalab.net' }
let(:key) { 'f1c08edc5245b07d' }
let(:secret) { 'EmBDHCl3W+d8RrjIvtLT5pAcXOSMf+B965d9trw3mzr5PBO5CxmKaAqnnzB3HVMusM7yDVYWuqePwP+LT4kN2/BxP+uxqcchEqxvATXA29zfkcNBn7a5uxXOXP5IbIU0' }


  before :each do
    ScalrApi.reset!

    ScalrApi.configure do |c|
      c.key = key
      c.secret = secret
      c.url = url
    end
  end


  
end
