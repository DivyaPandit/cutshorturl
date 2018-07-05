if Rails.env.development?
  SHORT_API_URL = "http://localhost:3000/"
elsif Rails.env.production?
  SHORT_API_URL = "https://rocky-bastion-49113.herokuapp.com/"
end