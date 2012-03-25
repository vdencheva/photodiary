token_file = Rails.root.join('config/secret_token.txt')

if not token_file.exist? and Rails.env.production?
  raise "#{token_file} must contain a secret token"
end

secret_token = if token_file.exist?
  token_file.read.strip
else
  '7b8d15a241cf382aaed7bbfe79493c924d1ef8ebaa83b147a3239c924b7f37d63cff8997ac02969e0fe713d57f0ce35ed277d4106db9704968a1144c23ca8a93'
end

Photodiary::Application.config.secret_token = secret_token
