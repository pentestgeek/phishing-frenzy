class CampaignDecorator < Draper::Decorator
  include IconDecorator

  def owner
    object.admin ? object.admin.username : "Unknown"
  end

  def active_icon
    object.active ? 
      h.image_tag('green-light.png', size: '11x11', alt: 'actives') : 
      h.image_tag('red-light.png', size: '11x11', alt: 'inactives')
  end

  def emails_icon
    object.victims.present? ? 
      h.image_tag('green-light.png', :size => '11x11', alt: 'emails') : 
      h.image_tag('red-light.png', :size => '11x11', alt: 'noemails')
  end

end
