require 'rack'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  res['Content-Type'] = 'text/html'
  # res.redirect(req.base_url + req.fullpath + content, status = 302)
  res.write(req.path)
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)