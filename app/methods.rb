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


VOWELS     = [1072, 1077, 1080, 1086, 1091, 1099, 1101, 1102, 1103, 1105]

CONSONANTS = [*1073..1076, 1078, 1079, *1081..1085, *1087..1090, *1092..1097]

def select_letters(arr)
  LETTERS_FREQ.select{ |k, v| arr.any? k }
end


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

VOWELS_PROBABILITY_ARRAY      = provide_distribution(select_letters(VOWELS))

CONSONANTS_PROBABILITY_ARRAY  = provide_distribution(select_letters(CONSONANTS))

############################################################################


def rl_str_gen

  words = words_gen(plane_words)
  digital_capitalize(words[0])
  words.map{ |a| a << 32 }.flatten[0..-2].push(46).pack("U*")

end  
  

    # "планирование" слов, для каждого слова создается хэш со свойствами
    #  например:
    # arr[0] =  {case:          :downcase,
    #           multi_syllable: true,
    #           dash:           true,
    #           one_letter:     false}

def plane_words
  
  # создаем массив в 2-15 слов, для каждого слова создается хэш со свойствами
  arr = Array.new(rand(2..15)) { {} } 

  arr.each do |el|

    case rand(20)             # для каждого слова определяем свойство case
      when 0 
        el[:case] = :acronim  # акроним (только большие буквы)
      when 1, 2
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


     # получаем массив с хэшами, где описаны свойства будущих слов
     #  согласно этим условиям создаем производный массив, где каждый элемент 
     # является массивом с int, который в будущем станет словом

def words_gen (arr)
  
  arr.map do |el|
    case el[:case]
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
    word  = [ONE_LETTER_WORDS_PROBABILITY_ARRAY.sample]
  else
    word  = generate_single_syllable_word
  end

  word    = add_dash(word) if hash[:dash]
  word

end


def generate_single_syllable_word

  vowel  = VOWELS_PROBABILITY_ARRAY.sample
  lenght = rand(20) < 15 ? rand(2..4) : rand(5..6)
  word   = Array.new(lenght)
  
  case lenght
    when 2
      word[rand(2)]    = vowel # и з / н а
    when 3, 4
      word[rand(1..2)] = vowel # т и р / д л я / т о р т / с т о л/ 
    when 5, 6
      word[-2]         = vowel # с т р и м / в з г л я д
  end

  short_y_position = word.find(1081)

  if short_y_position
    word.index(vowel)
  end

  word.map!{ |el| el ? el : CONSONANTS_PROBABILITY_ARRAY.sample }
  
  finalize_word(word)
end


def finalize_word(word)
  word = check_same_consonants(word)
  word = manage_y_short(word)
  occasionally_add_softening_sign(word)
end


def check_same_consonants(arr) # проверить на одинаковые согласные
  arr
end


def occasionally_add_softening_sign(arr) # случайно добавить ь
  arr
end


def manage_y_short(arr) # расставить й
  arr
end


def add_dash(arr) # добавить "-"
  
  return arr if arr.size < 5 || arr.size > 14
  vowel_indexes = []
  arr.each_with_index do |el, i|
      
    
    vowel_indexes << i if VOWELS.any?(el)
  
  end

    # создаем массив с индексами гласных границы, в пределах которых ставить -
    dash_zone_borders = [                 
                            # не допустить, чтобы - отделил одну гласную слева
      vowel_indexes[0]  == 0 ? 2 : vowel_indexes[0] + 1,
                            # не допустить, чтобы - отделил одну гласную справа
      vowel_indexes[-1] ==(arr.size-1) ? vowel_indexes[-1]-1 : vowel_indexes[-1]
    ]

    (dash_zone_borders[0]..dash_zone_borders[1]).map{ |i| 
      next if arr[i] == 1100 # пропускает индекс, если по индексу находится ь
    }

  arr

end


def get_no_insert_range(arr)
  no_insert = []
  consonants = 0
  arr.each_with_index do |el, i|
    consonants =  VOWELS.any?(el) ?  0 : consonants+1
    no_insert << ((i-3)..(i+1)) if consonants == 4
  end
  no_insert
end


def generate_multi_syllable_word
  generate_single_syllable_word + generate_single_syllable_word
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