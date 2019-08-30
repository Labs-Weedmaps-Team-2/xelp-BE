# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  # Local development frontend
  allow do
    origins 'http://localhost:4000'
    resource '*',
      credentials: true,
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options]
  end
  # Deployed staging frontend (development branch on GitHub)
  allow do
    origins 'https://pensive-mclean-75bb36.netlify.com/'
    resource '*', 
      credentials: true,
      headers: :any, 
      methods: [:get, :post, :put, :patch, :delete, :options]
  end
  # Deployed production frontend (master branch on GitHub)
  allow do
    origins 'https://goofy-edison-2eb1f5.netlify.com'
    resource '*',
      credentials: true,
      headers: :any, 
      methods: [:get, :post, :put, :patch, :delete, :options]
  end
end