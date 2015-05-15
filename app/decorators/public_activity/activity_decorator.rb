class PublicActivity::ActivityDecorator < Draper::Decorator
  include IconDecorator

  def owner
    object.owner ? object.owner.name : 'Unknown'
  end

end