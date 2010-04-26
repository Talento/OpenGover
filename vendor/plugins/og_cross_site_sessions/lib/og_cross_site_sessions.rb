Rails.configuration.after_initialize do
      Rails.configuration.middleware.use 'OgSetCookieDomain'
end