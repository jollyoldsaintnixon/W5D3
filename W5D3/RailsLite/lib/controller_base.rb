require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'active_support/inflector'


class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Double Render/Redirect" if already_built_response?
    @res['Location'] = url
    @res.status = 302
    @already_built_response = true
        session.store_session

  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Double Render/Redirect" if already_built_response?
    @res['Content-Type'] = content_type
    @res.write(content)
    @already_built_response = true
        session.store_session

  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    # debugger
    # paths = @req.template_name.split("/")
    # controller = paths[1].underscore
    controller = self.class.to_s.underscore
    path = "views/#{controller}/#{template_name}.html.erb"
    content = File.read(path)
    new_content = ERB.new(content).result(binding)
    render_content(new_content, 'text/html')
    # debugger
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)

  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

