require 'set'

class WordChainer

  def read_file
    File.open("Word Chains/dictionary.txt").reduce(Set.new) {|set, line| set.add(line.chomp)}
  end

  def initialize
    @dictionary = read_file
  end

  def adjacent_words(word)
    words = []
    word.each_char.with_index do |c, i|
      word_copy = String.new(word) #we need the copy to point to another block in memory due to string mutability
      ("a".."z").each do |l|
        word_copy[i] = l if c != l
        words << String.new(word_copy) if @dictionary.include?(word_copy)
      end
    end
    words
  end

  def longest_word #=>outputs 23, we wont accept words longer than 23
    @dictionary.reduce(0) {|acc, word| word.length > acc ? acc = word.length : acc}
  end

  #explore all adjacents to each word in current words array
  def explore_current_words(target)
    new_current_words = []
      @current_words.each do |word|
        adjacent_words(word).each do |adjacent_word|
          return new_current_words if @all_seen_words.include?(target) #we can stop early if we already included the target word (we will be able to construct a full path)
          next if @all_seen_words.include?(adjacent_word) #no need to go over the words we've already seen
          if @all_seen_words[word] != adjacent_word #make sure we dont get endless loops
            @all_seen_words[adjacent_word] = word
            new_current_words << adjacent_word
          end
        end
      end
    new_current_words
  end

  #used for debugging
  def print_all_words
    @all_seen_words.sort {|k, v| k}
    @all_seen_words.each {|k, v| puts "#{k} => #{v}"}
  end

  #runs the core logic, current words contains adjacent words to the source, all seen words is a hash which will be filled with all possible words and the adjacent that led to them
  def run(source, target)
    @current_words = adjacent_words(source)
    @all_seen_words = {source => nil}
    until @current_words.empty? #loop until we have no more relevant adjacent words
      @current_words = explore_current_words(target)
    end
    build_path(source, target)
  end

  #builds and prints path from source word to target word
  def build_path(source, target)
    path = [] << target
    until @all_seen_words[path.last] == nil
      path << @all_seen_words[path.last]
    end
    path << source
    p path
  end

end


chainer = WordChainer.new
chainer.run("duck", "ruby")






