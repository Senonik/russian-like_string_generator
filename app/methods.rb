def rl_str_gen
  base_string
  # "Свеко-льный, Свеколёёный, взгляд ВЗГЛД порт ОПРТ абырвалг - это ППЦ, гоол!"
end  
  

def base_string
  x   = [*1040..1103, 1105, 1025]
  arr = Array.new(rand(3..250)) {x.sample}
  i   = rand(1..15)
  num_words = 0

  while i < arr.size
    arr[i] = 32
    i += rand(2..16)
  end
  arr.pack("U*")
end


def plane_words
    # arr[0] =  {case:          :downcase,
    #           multi_syllable: true,
    #           dash:           true,
    #           one_letter:     false}

    # создаем массив в 2-15 слов, для каждого слова создается хэш со свойствами
  arr = Array.new(rand(2..15)) { {} } 

  arr.each do |el|

    case rand(10)             # для каждого слова определяем свойство case
      when 0 
        el[:case] = :acronim
      when 1
        el[:case] = :capital
      else
        el[:case] = :downcase
    end

    if el[:case] != :acronim
      el[:multi_syllable] = rand(5) == 0 ? false : true
    end

    if el[:multi_syllable] == true
      el[:dash] = rand(20) == 0 ? true : false
    elsif el[:multi_syllable] == false # односложное
      if rand(2) == 0 
        el[:one_letter] = true       # если слово однобуквенное, то оно 
        el[:case]       = :downcase  # должно быть с маленькой буквы
        else 
        el[:one_letter] = false
      end
    end

  end

end


def words_gen (arr)
  arr.map do |el|
    case el.case
      when :acronim
        make_acronim
      when :downcase
        make_common_word(el)
      when :capital
        digital_capitalize(make_common_word(el))
    end
  end
end


def make_acronim
  letters = [*1040..1048, *1050..1065, *1069..1071, 1025]
  Array.new(rand(2..5)) {letters.sample}
end


def digital_capitalize (arr)
  if arr[0] == 1105
    arr[0] = 1025
  elsif arr[0] > 1071
    arr[0] -= 32
  end
  arr
end

  # arr[0] =  {case:          :downcase,
    #           multi_syllable: true,
    #           dash:           true,
    #           one_letter:     false}

def make_common_word (hash)
  letters = [*1072..1103, 1105]
  if hash[:multi_syllable]              # многосложное слово
    word = generate_multi_syllable_word
  elsif hash[:one_letter]               # однобуквенное слово
    word = [1072, 1103, 1074, 1086, 1091, 1080, 1082, 1089].sample
  else
    word = generate_single_syllable_word
  end

  word = add_dash(word) if hash[:dash]
  word
end
  # it "should not contain word over 15 letters"
  # it "should not allow unwanted symbols inside words" 
  # it "should not allow words starting from: ь,ы,ъ" 
  # it "should always have a vowel after й at the beginning of the world" 
  # it "should allow only particular letters after й inside words" 
  # it "should always be vowel in 2- and 3- letter words"
  # it "should allow only particular one-letter words"
  # it "should not allow more than 4 consonant letters in a row"
  # it "should not allow more than 2 vowel letters in a row"
  # it "should not allow more than 2 same consonant letters in a row" 
  # it "should contain at least 40% vowels in multisyllable words" 
  # it "should contain 5 or less consonant letters in single-syllable words" 
  # it "should allow я,е,ё,ю after ъ" 
  # it "should not allow a vowel at the beginning of the word"\
  #    "in single-syllable words if they have 3 or more letters" 


