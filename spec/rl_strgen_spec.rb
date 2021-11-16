require "rspec"
require_relative "../app/methods"

describe "rl_string_generator" do

  it "should contain from 2 to 15 words" do 
    1000.times do
      str = rl_str_gen 
      expect(str.scan(/[а-яё]+/i).size).to be >= 2
      expect(str.scan(/[а-яё]+/i).size).to be <= 15
    end
  end

  it "should not contain word over 15 letters"
    1000.times do
      str = rl_str_gen 
      expect(str.scan(/[а-яё]+/i).count{ |el|
        el.size <= 15 }).to eq (0)
    end
  end
end
