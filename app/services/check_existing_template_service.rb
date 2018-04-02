class CheckExistingTemplateService
  def initialize(raw_data)
    @raw_data = raw_data
    @templates = Template.all
  end

  def call
    template_id = nil
    @templates.each do |template|
      template.fields.each do |field|
        words = []
        values = []
        words_found = false
        # check if label matches
        @raw_data.each do |id, data|
          words << data[:text] if data[:bounds][0].between?(field.label_bound[0], field.label_bound[2]) && data[:bounds][1].between?(field.label_bound[1], field.label_bound[3])
        end
        words = words.join(' ')
        if field.label_name == words
          words_found = true
        else
          template_id = nil
          break
        end
        template_id = template.id
      end
      break if template_id
    end
    template_id
  end

end
