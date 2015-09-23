ROOT_URLS = {"development" => "http://localhost:3000",
             "test" => "http://localhost:3000",
             "production" => "http://beehive.berkeley.edu"}
ROOT_URL = ROOT_URLS[Rails.env]
