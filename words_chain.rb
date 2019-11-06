require 'byebug'

class WordChain
  @@dictionary = Array.new
  attr_reader :start, :finish, :chain

  def initialize( start, finish )
    @start_word  = self.class.normalize_word(start)
    @finish_word = self.class.normalize_word(finish)

    @chain = nil
  end

  def self.distance( from_word, to_word )
    same = 0
    from_word.length.times { |index| same += 1 if from_word[index] == to_word [index] }
    from_word.length - same
  end

  def self.load_words( file, limit )
    limit = normalize_word(limit).length
    File.foreach(file) do |word|
      word = normalize_word(word)

      next unless word.length == limit

      @@dictionary << word
    end

    @@dictionary.uniq!
  end

  def self.normalize_word( word )
    normal_word = word.dup.strip.downcase.delete("^a-z")
  end

  def link
    chains = Array[Array[@start_word]]

    unless chains.empty? || self.class.distance(chains.first.last, @finish_word) == 1
      chain = chains.shift
      links = @@dictionary.select do |word|
        self.class.distance(chain.last, word) == 1
      end
      links.each { |link| chains << (chain.dup << link) }

      chains = chains.sort_by do |c|
        c.length + self.class.distance(c.last, @finish_word)
      end
    end
    if chains.empty?
      @chain = Array.new 
    else
      @chain = (chains.shift << @finish_word)
    end 
  end

  def to_s
    link if @chain.nil?

    if @chain.empty?
        "No words #{@start_word} and #{@finish_word}."
    else
        @chain.join("\n")
    end
  end
end


if __FILE__ == $0
  dictionary_file = "wordlist.txt"
  if ARGV.size >= 2 && ARGV.first == "-d"
      ARGV.shift
      dictionary_file = ARGV.shift
  end

  unless (ARGV.size == 2) && (ARGV.first != ARGV.last) && (ARGV.first.length == ARGV.last.length)
    puts "no sale morra"
    exit
  end
  start, finish = ARGV

  puts "Cargando diccionario..." 
  WordChain.load_words(dictionary_file, start)
  puts "Construyendo diccionario..."
  puts WordChain.new(start, finish)
end
