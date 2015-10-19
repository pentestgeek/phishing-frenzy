module IconDecorator
  
  def campaign_icon
    h.content_tag(:i, nil, class: 'glyphicon glyphicon-envelope')
  end

  def template_icon
    h.content_tag(:i, nil, class: 'glyphicon glyphicon-tags')
  end

  def report_icon
    h.content_tag(:i, nil, class: 'glyphicon glyphicon-stats')
  end

  def options_icon
    h.content_tag(:i, nil, class: 'glyphicon glyphicon-search')
  end

  def edit_icon
    h.content_tag(:i, nil, class: 'glyphicon glyphicon-edit')    
  end

end
