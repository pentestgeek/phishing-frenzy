class TemplateDecorator < Draper::Decorator
  include IconDecorator

  def owner
    object.admin ? object.admin.username : "Unknown"
  end

end
