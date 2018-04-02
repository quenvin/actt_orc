class ExtractImageValuesService
  def initialize(template_id, raw)
    @template = Template.find_by(id: template_id)
    @raw = raw
    @result = {}
  end
  def call
    @template.fields.each do |field|
      values = []
      @raw.raw_data.each do |id, data|
        values << data[:text] if data[:bounds][0].between?(field.value_bound[0], field.value_bound[2]) && data[:bounds][1].between?(field.value_bound[1], field.value_bound[3])
      end
      values = values.join(' ')
      @result[field.label_name] = values
    end
    @result
  end
end