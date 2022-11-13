require 'strscan'

def error(message)
  STDERR.puts message
  exit(1)
end

if ARGV.size != 1
  error "#{ARGV.size}: invalid number of arguments\n"
end

class Tokenizer
  Token = Struct.new('Token', :kind, :value, :next, :loc, :len)

  module TokenKind
    %i(
      NUM
      PUNKT
      EOF
    ).each_with_index { |kind, i| const_set(kind, i) }
  end

  def initialize
    @tokens = []
    @pos = 0
  end
  attr_reader :tokens, :pos

  def tokenize!(str)
    s = StringScanner.new str

    until s.eos?
      next if s.scan(/\s/)

      if d = s.scan(/\d+/)
        tokens << Token.new(kind: TokenKind::NUM, value: d, loc: s.pos - d.length, len: d.length)
        next
      end

      if op = s.scan(/[\+|\-]/)
        tokens << Token.new(kind: TokenKind::PUNKT, value: op, loc: s.pos - op.length, len: op.length)
        next
      end

      error 'invalid token'
    end

    tokens << Token.new(kind: TokenKind::EOF, value: "EOF", loc: s.pos)
  end

  def next_pos
    return if tokens[pos] == TokenKind::EOF

    @pos += 1
  end

  def eq?(str)
    tokens[pos].value == str
  end

  def skip(str)
    unless eq? str
      error "expected #{str}"
    end
    next_pos
  end

  def get_number
    if tokens[pos].kind != TokenKind::NUM
      error "expected a number"
    end
    tokens[pos].value
  end

  def eof?
    tokens[pos].kind == TokenKind::EOF
  end
end

tok = Tokenizer.new
tok.tokenize! ARGV[0]

puts "  .global main"
puts "main:"
puts "  mov $#{tok.get_number}, %rax"
tok.next_pos

until tok.eof?
  if tok.eq? '+'
    tok.next_pos
    puts "  add $#{tok.get_number}, %rax"
    tok.next_pos
    next
  end

  tok.skip('-')
  puts "  sub $#{tok.get_number}, %rax"
  tok.next_pos
end

puts "  ret"
