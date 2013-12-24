class TemplateValidator < ActiveModel::Validator
  def validate(record)
    if multiples_indices?(record.website_files)
      record.errors[:attachments] << 'There can be at most one index file'
    end
  end

  def multiples_indices?(pages)
    pages.select{|p| p.function == 'website - index'}.size > 1
  end

end