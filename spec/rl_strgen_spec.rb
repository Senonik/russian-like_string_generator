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
      expect(rl_str_gen.match?(/[^а-яё ,\.:;!\?\'\"-]/i)).to be false
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
      expect(str.gsub("- ","").match?(/\A(?:[^ ]+ ){1,14}[^ ]+\z/)).to be true
    end
  end

  it "should not contain word over 15 letters" do
    1001.times do
      words = rl_str_gen.scan(/[а-яё]+(?:-[а-яё]+)?/i)

      expect(words.count{ |el| el.size > 15}).to eq(0)
      # expect(str.match(/(/[а-яё]+(?:-[а-яё]+)?){16,}/i)).to be nil
    end
  end
  
  it "should allow only particular signs after words withing sentence" do
    1001.times do
     withing = rl_str_gen.split.reject{|el| el == "-"}[0..-2]
     expect(withing.select{|el| el[-1].match? /[^,:\"\'а-яё]/i}.size)
                                      .to eq(0)
    end
  end

  it "should allow particular sings at the end of the sentence" do
    1001.times do
    expect(rl_str_gen.match? /.*[а-яё]+[\"\']?(\.|\?|!|!\?|\.\.\.)\z/)
                      .to be true
    end
  end

  it "should be allow multiply punctuation" do
  end

  it "should not allow unwanted symbols inside words" do
    1001.times do
      expect(rl_str_gen.match?(/[а-яё\-][^а-яё \-]+[а-яё\-]/i)).to be false
     # words = rl_str_gen.split.reject{|el| el == "-"}
     # /\A[\"\']?[а-яё]+(?:-[а-яё]+)\z/i
      # sub(/(\.\.\.|!\?|[.,:;\?\!])\z/, "")
    end
  end

  it "should be allow multiply dashes" do
  end
end