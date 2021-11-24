LETTERS_FREQ = {1072 => 801,  # а
                1073 => 159,  # б
                1074 => 454,  # в
                1075 => 170,  # г
                1076 => 298,  # д
                1077 => 745,  # е
                1105 => 104,  # ё
                1078 => 94,   # ж
                1079 => 165,  # з 
                1080 => 735,  # и
                1081 => 121,  # й
                1082 => 349,  # к
                1083 => 440,  # л
                1084 => 321,  # м
                1085 => 670,  # н
                1086 => 1097, # о
                1087 => 281,  # п
                1088 => 473,  # р 
                1089 => 547,  # с
                1090 =>  626, # т
                1091 =>  262, # у
                1092 =>  26,  # ф
                1093 =>  97,  # х
                1094 =>  48,  # ц
                1095 =>  144, # ч
                1096 =>  73,  # ш
                1097 =>  36,  # щ
                1098 =>  4,   # ъ
                1099 =>  190, # ы
                1100 =>  174, # ь
                1001 =>  32,  # э
                1002 =>  64,  # ю
                1003 =>  201  # я
                }.freeze


ONE_LETTER_WORDS_FREQ = {1080 => 358,
                         1074 => 314,
                         1103 => 127,
                         1089 => 113,
                         1072 => 82, 
                         1082 => 54, 
                         1091 => 43, 
                         1086 => 34}.freeze


def provide_distribution(hash)
  sample_array = []
  hash.each_key do |k|
    hash[k].times do
      sample_array << k
    end
  end
  sample_array.freeze
  sample_array
end


ONE_LETTER_WORDS_PROBABILITY_ARRAY = provide_distribution(ONE_LETTER_WORDS_FREQ)

LETTERS_PROBABILITY_ARRAY          = provide_distribution(LETTERS_FREQ)


############################################################################


def rl_str_gen
  base_string
end  
  

def base_string
        # числа, соответствующие буквам А-Яа-я,ё,Ё, в кодировке UTF-8
  x   = [*1040..1103, 1105, 1025]         
  arr = Array.new(rand(3..250)) {x.sample}
  i   = rand(1..15)             # количество слов в предложении
  num_words = 0

  while i < arr.size     # случайным образом расставляем запятые == 32 в UTF-8
    arr[i] = 32
    i += rand(2..16)
  end
  arr.pack("U*")         # преобразуем массив с int в строку по код-ке UTF-8
end


def plane_words
  
  # "планирование" слов, для каждого слова создается хэш со свойствами
    # например:
    # arr[0] =  {case:          :downcase,
    #           multi_syllable: true,
    #           dash:           true,
    #           one_letter:     false}
  
  # создаем массив в 2-15 слов, для каждого слова создается хэш со свойствами
  arr = Array.new(rand(2..15)) { {} } 

  arr.each do |el|

    case rand(10)             # для каждого слова определяем свойство case
      when 0 
        el[:case] = :acronim  # акроним (только большие буквы)
      when 1
        el[:case] = :capital  # заглавная только первая буква
      else
        el[:case] = :downcase # только строчные буквы
    end

    if el[:case] != :acronim
      el[:multi_syllable] = rand(5) == 0 ? false : true
    end

    if el[:multi_syllable]    == true             # если многосложное слово
      el[:dash] = rand(20) == 0 ? true : false    # то 5% вероятность дефиса
    elsif el[:multi_syllable] == false            # если слово односложное,
      
      if rand(2) == 0                # то с вероятностью 50% оно либо:
        el[:one_letter] = true       # однобуквенное, и тогда оно 
        el[:case]       = :downcase  # должно быть из строчных букв
        else 
        el[:one_letter] = false      # либо односложное
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
  
  letters = [*1040..1048, *1050..1065, *1069..1071, 1025] # кроме Й Ъ Ы Ь
  Array.new(rand(2..5)) {letters.sample}

end


def digital_capitalize (arr)
  
  if arr[0] == 1105             # ё
    arr[0]  = 1025              # Ё
  elsif arr[0] > 1071           # значит входят в диапазон а-я, 1072 => a
    arr[0] -= 32                #                               1040 => А
  end

  arr

end


def make_common_word (hash)

  letters = [*1072..1103, 1105]   # а-я, ё
  if    hash[:multi_syllable]     # многосложное слово
    word  = generate_multi_syllable_word
  elsif hash[:one_letter]         # однобуквенное только из букв аявуоикс
    word  = ONE_LETTER_WORDS_PROBABILITY_ARRAY.sample
  else
    word  = generate_single_syllable_word
  end

  word    = add_dash(word) if hash[:dash]
  
  word

end


def generate_sigle_syllable_word

  vowel = [1072, 1077, 1105, 1080, 1086, 1091, 1099, 1101, 1102, 1103].sample
  lenght = rand(20) < 15 ? rand(2..4) : rand(5..6)
  consonant = [*1073..1076, 1078, 1079, *1082..1085, *1087..1090, *1092..1097]

end

                # arr[0] =  {case:          :downcase,
                  #           multi_syllable: true,
                  #           dash:           true,
                  #           one_letter:     false}

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