require "rspec"
require_relative "../app/methods"

describe "resulting_string" do

  before (:all) do
    @string = rl_str_gen
  end


  it "should return a string" do
    expect(@string).to be_an_instance_of(String)
  end


  it "should contain only valid symbols" do
    expect(@string.match?(/[^а-яё ,\.:;!\?\"\-]/i)).to be false
  end

  
  it "should not be over 300 symbols" do
    expect(@string.size).to be <= 300
  end

  
  it "should contain from 2 to 15 words" do 
    str = @string

    expect(str.size).to be <= 300
    expect(str.gsub("- ","").match?(/\A *(?:[^ ]+ +){1,14}[^ ]+\z/))
          .to be true
  end

  
  it "should not contain word over 15 letters" do
    words = @string.scan(/[а-яё]+(?:-[а-яё]+)?/i)

    expect(words.count{ |el| el.size > 15}).to eq(0)
  end
  
  
  it "should allow only particular signs after words within sentence" do
   withing = @string.split.reject{|el| el == "-"}[0..-2] # удаляем тире
   expect(withing.reject{|el| el.match? /[а-яё][\"]?[,:;]?\z/i}
                 .size)
                 .to eq(0)
  end

  
  it "should allow particular sings at the end of the sentence" do
    expect(@string.match? /.*[а-яё]+[\"]?(\.|\?|!|!\?|\.\.\.)\z/)
                     .to be true
  end

  
  it "should not allow unwanted symbols inside words" do
    expect(@string.match?(/[а-яё\-][^а-яё \-]+[а-яё\-]/i)).to be false
  end

  
  it "should not allow multiply punctuation marks" do
    expect(@string.match?(/([^а-яё\.]) *\1/i)).to be false
  end

  
  it "should exclude unwanted symbols before word's " do
  expect(@string.match?(/(?<![а-яё])[^ \"а-яё]+\b[а-яё]/i))
                       .to be false
  end

  
  it "should corretly use quotation marks" do
    expect(@string.scan(/\"/).size.even?).to be true
    expect(@string.scan(/\".+?\"/)               # нежадный +
                     .reject{|el| el.match?(/\"[а-яё].+[а-яё]\"/i)}
                     .size).to eq(0)

  end

  
  it "should not allow words starting from: ь,ы,ъ" do
    expect(@string.match(/\b[ьыъ]/i)).to be nil
  end


  it "should not contain capital letters inside words if not an acronim" do
    expect(@string.match?(/\b([А-ЯЁ]+)?[а-яё]+[А-ЯЁ]+/)).to be false
  end
  

  it "should allow acronims only from 2 to 5 letters" do
    expect(@string.match?(/\b\"?[А-ЯЁ]{6,}\b/)).to be false
  end

  
  it "should not allow one-letter words with a capital letter" do
    expect(@string.match(/\b[А-ЯЁ]\b/)).to be nil
  end


  it "should always have a vowel after й at the beginning of the world" do
    expect(@string.match?(/\bй[^ео]/i)).to be false
  end
  

  it "should allow only particular letters after й inside words" do
    expect(@string.match(/\Bй[ьъыёуиаэюяжй]/i)).to be nil
  end
  

  it "should always be vowel in 2- and 3- letter words" do
    @string.gsub(/[^а-яё ]/i, "")
              .split
              .select { |el| el.size == 2 or el.size == 3}
              .reject { |el| el.match?(/\A[А-ЯЁ]+\z/)}
    .each do |w|
      expect(w).to match(/[аоуэыияеёю]/i)
    end
  end


  it "should allow only particular one-letter words" do
    @string.scan(/\b[а-яё]\b/i).each do |word|
      expect(word).to match(/[аявуоикс]/i) # отказались от ж и б
    end
  end


  it "should not allow more than 4 consonant letters in a row" do
    @string.gsub(/[^а-яё ]/i, "").split.each do |el|
      unless el.match? /\A[А-ЯЁ]{2,}\z/
        expect(el.match /[^аоуэыияеёю ]{5,}/i).to be_nil
      end
    end

  end


  it "should not allow more than 2 vowel letters in a row" do
    @string.gsub(/[^а-яё ]/i, "").split.each do |el|
      unless el.match? /\A[А-ЯЁ]{2,}\z/
        expect(el.match /[аоуэыияеёю]{3,}/i).to be_nil
      end
    end
  end
  

  # возможно сделать проверку сразу на все буквы, т.к. больше 2-х гласных 
  # подряд тоже не следует допускать. исключение еее на конце слова
  it "should not allow more than 2 same consonant letters in a row" do
    expect(@string.match?(/([^аеёиоуыэюя])\1\1/)).to be false
  end


  it "should start with a capital letter" do
    expect(@string).to be match(/\A\"?[А-ЯЁ]/)
  end


  it "should contain at least 40% vowels in multisyllable words" do
    @string.gsub(/[^а-яё ]/i, "")
      .split
      .select{|w| w.match?(/[аеёиоуыэюя].*[аеёиоуыэюя]/i)}
      .each do |el|
        unless el.match?(/\A[А-ЯЁ]{2,}\z/)
          found = el.scan(/[аеёиоуыэюя]/i).size
          calc  = ((el.size - (el.scan(/[ъь]/i).size))*0.40).to_i
          res   = found >= calc ? ">=#{calc} vowels" : "#{found} vowels"
          expect([res, el]).to eq([">=#{calc} vowels", el])
        end
      end
  end


  it "should contain 5 or less consonant letters in single-syllable words" do
    @string.gsub(/[^а-яё -]/i, "").split
              .reject{|w| w.match?(/-|([аеёиоуыэюя].*[аеёиоуыэюя])/i)||
                          w.match?(/\b[А-ЯЁ]{2,}\b/) }
              .each do |w|
                expect(w.size).to be <= 6
              end
  end


  it "should allow я,е,ё,ю after ъ" do
    expect(@string.gsub(/\b[А-ЯЁ]{2,}\b/, "")
                     .match(/ъ[^яеёю]/i)).to be nil
  end


  it "should not allow a vowel at the beginning of the word"\
     "in single-syllable words if they have 3 or more letters" do
    @string.gsub(/[^а-яё -]/i,"").split
              .reject{|w| w.match?(/-|([аеёиоуыэюя].*[аеёиоуыэюя])/i) ||
                          w.match?(/\A[А-ЯЁ]{2,}\z/) ||
                          w.size < 3 }
              .each do |w|
                expect(w).to match(/\A[^аеёиоуыэюя]/i)
              end
  end  

  
  it "should forbit Ь and Ъ in acronims" do
    expect(@string.match(/(?=\b[А-ЯЁ]{2,}\b)\b[А-ЯЁ]*[ЬЪ][А-ЯЁ]*\b/))
                     .to be nil
  end

  # it "should contain vowels if more then 1 letters and not acronim"

end


describe "get_no_insert_range" do
  it "should corretly find 4 consonants in a row groups" do
    1001.times do
      x_word = Array.new(12) {rand(1072..1103)}
      check  = x_word.chunk {|el| VOWELS.any?(el)}.to_a
                     .select{|el| el[1].size > 3 && el[0] == false}
                     .map{|el| el[1][0..3]}

      test  = get_no_insert_range(x_word).map{ |r| x_word[r][0,4]}
      expect(test).to eq(check)
    end
  end
end