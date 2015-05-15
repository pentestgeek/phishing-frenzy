class PublicActivity::ActivityDecorator < Draper::Decorator
  include IconDecorator

  def owner
    object.owner ? object.owner.name : 'Unknown'
  end

  def format_date
    h.content_tag :span, class: "small pull-right" do
      object.created_at.strftime("%m/%d %H:%M %p")
    end
  end

end