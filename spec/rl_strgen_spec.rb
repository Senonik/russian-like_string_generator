require "rspec"
require_relative "../app/methods"

describe "rl_string_generator" do

  it "should return a string" do
    1001.times do
      expect(rl_str_gen).to be_an_instance_of(String)
    end
  end

  it "should contain only valid symbols" do
    1001.times do
      expect(rl_str_gen.match?(/[^а-яё ,\.:;!\?\"\-]/i)).to be false
    end
  end

  
  it "should not be over 300 symbols" do
    1001.times do
      expect(rl_str_gen.size).to be <= 300
    end
  end

  
  it "should contain from 2 to 15 words" do 
    1001.times do
      str = rl_str_gen

      expect(str.size).to be <= 300
      expect(str.gsub("- ","").match?(/\A *(?:[^ ]+ +){1,14}[^ ]+\z/)).to be true
    end
  end

  
  it "should not contain word over 15 letters" do
    1001.times do
      words = rl_str_gen.scan(/[а-яё]+(?:-[а-яё]+)?/i)

      expect(words.count{ |el| el.size > 15}).to eq(0)
    end
  end
  
  
  it "should allow only particular signs after words within sentence" do
    1001.times do
     withing = rl_str_gen.split.reject{|el| el == "-"}[0..-2] # удаляем тире
     expect(withing.reject{|el| el.match? /[а-яё][\"]?[,:;]?\z/i}
                   .size)
                   .to eq(0)
    end
  end

  
  it "should allow particular sings at the end of the sentence" do
    1001.times do
    expect(rl_str_gen.match? /.*[а-яё]+[\"]?(\.|\?|!|!\?|\.\.\.)\z/)
                     .to be true
    end
  end

  
  it "should not allow unwanted symbols inside words" do
    1001.times do
      expect(rl_str_gen.match?(/[а-яё\-][^а-яё \-]+[а-яё\-]/i)).to be false
    end
  end

  
  it "should be allow multiply punctuation marks" do
    1001.times do
      expect(rl_str_gen.match?(/([^а-яё.])*\1/i)).to be false
    end
  end

  
  it "should exclude unwanted symbols before word's " do
    1001.times do
      expect(rl_str_gen.match?(/(?<![а-яё])[^ \"а-яё]+\b[а-яё]/i))
                       .to be false
    end
  end

  
  it "should be corretly use quotes" do
    1001.times do
      expect(rl_str_gen.scan(/\"/).size.even?).to be true
      expect(rl_str_gen.scan(/\".+?\"/)               # нежадный +
                       .reject{|el| el.match?(/\"[а-яё].+[а-яё]\"/i)}
                       .size).to eq(0)

    end
  end

  
  it "should not allow words starting from: ь,ы,ъ" do
    1001.times do
      expect(rl_str_gen.match(/\b[ьыъ]/i)).to be nil
    end
  end

  #
  it "should not contain capital letters inside words if not an acronim" do
    1001.times do
      expect(rl_str_gen.match?(/\b[а-яё]+[А-ЯЁ]+/)).to be false
    end
  end
  
  
  it "should always have a vowel after й at the beginning of the world" do
    1001.times do
      expect(rl_str_gen.match?(/\bй[^ео]/i)).to be false
    end
  end
  
  
  it "should not allow more than 4 consonant letters in a row" do
  end
  
  it "should not allow more than 2 vowel letters in a row" do
  end
  
  # возможно сделать проверку сразу на все буквы, т.к. больше 2-х гласных 
  # подряд тоже не следует допускать. исключение еее на конце слова
  it "should not allow more than 2 same consonant letters in a row" do
    1001.times do
      expect(rl_str_gen.match?(/([а-яё])\1\1+/)).to be false
    end
  end

  
  it "should contain vowels if more then 1 letters and not acronim" do
  end

  # more than 5 letters
  it "should allow acronims only from 2 to 5 letters" do
    1001.times do
      expect(rl_str_gen.match?(/\b[А-ЯЁ]{6,}\b/)).to be false
    end
  end

  #
  it "should not allow one-letter words with a capital letter
      exept preposition at the beginning of the sentence" do
    1001.times do
      expect(rl_str_gen.match(/(\A[ЯВКОСУИА]\b)?.*?(?=\b[А-ЯЁ]\b)/)).to be nil
      # expect(rl_str_gen.match?(/\b[А-ЯЁ]\b/)).to be false
    end
  end


  it "should contain at least 40% vowels in multisyllable words" do
    1001.times do
      rl_str_gen.gsub(/[^а-яё ]/i, "")
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
  end


  it "should contain 5 or less consonant letters in single-syllable words" do
      1001.times do
      rl_str_gen.gsub(/[^а-яё -]/i, "").split
                .reject{|w| w.match?(/-|([аеёиоуыэюя].*[аеёиоуыэюя])/i)||
                            w.match?(/\b[А-ЯЁ]{2,}\b/) }
                .each do |w|
                  expect(w.size).to be <= 6
                end
      end
  end


  it "should allow я,е,ё,ю after ъ" do
    1001.times do
      expect(rl_str_gen.gsub(/\b[А-ЯЁ]{2,}\b/, "")
                       .match(/ъ[^яеёю]/i)).to be nil
    end
  end


  it "should not allow add the beginning of the word in single-syllable"\
     " words if they have 3 or more letters" do
      1001.times do
         rl_str_gen.gsub(/[^а-яё -]/i,"").split
                    .reject{|w| w.match?(/-|([аеёиоуыэюя].*[аеёиоуыэюя])/i) ||
                                w.match?(/\A[А-ЯЁ]{2,}\z/) ||
                                w.size < 3 }
                    .each do |w|
                      expect(w).to match(/\A[^аеёиоуыэюя]/i)
                    end
      end
  end  

  
  it "should forbit Ь and Ъ in acronims" do
    1001.times do
      expect(rl_str_gen.match(/(?=\b[А-ЯЁ]{2,}\b)\b[А-ЯЁ]*[ЬЪ][А-ЯЁ]*\b/))
                       .to be nil
    end
  end

end


    # expect(str.match(/(/[а-яё]+(?:-[а-яё]+)?){16,}/i)).to be nil
    # words = rl_str_gen.split.reject{|el| el == "-"}
    # /\A[\"]?[а-яё]+(?:-[а-яё]+)\z/i
    # sub(/(\.\.\.|!\?|[.,:;\?\!])\z/, "")