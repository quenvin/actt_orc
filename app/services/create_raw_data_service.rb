class CreateRawDataService
  def initialize(vision_data)
    @raw_words = vision_data.document.words
  end

  def call
    raw_data = {}
    @raw_words.each_with_index do |word, index|
      word_bound = {text: word.text, bounds: [word.bounds[0].x, word.bounds[0].y, word.bounds[2].x, word.bounds[2].y]}
      raw_data[index] = word_bound
    end 
    Raw.create(image: Image.last, raw_data: raw_data)
  end
end