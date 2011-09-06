ROOT_URLS = {"development" => "http://localhost:3000/research",
             "test" => "http://localhost:3000/research",
             "production" => "http://upe.cs.berkeley.edu/research"}
ROOT_URL = ROOT_URLS[Rails.env]
