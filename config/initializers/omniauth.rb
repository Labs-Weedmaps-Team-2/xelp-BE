Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '55b1b13c233b32fda1d8', '569dcfec391877ab21ff1318e449bb8711ba49e3', scope: "user,repo,gist"
end