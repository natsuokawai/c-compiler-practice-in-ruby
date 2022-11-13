require 'strscan'

if ARGV.size != 1
  STDERR.puts "#{ARGV.size}: invalid number of arguments\n"
  return
end

s = StringScanner.new ARGV[0]

puts "  .global main"
puts "main:"
puts "  mov $#{s.scan(/\d+/)}, %rax"

until s.eos?
  if s.check('+')
    s.getch
    puts "  add $#{s.scan(/\d+/)}, %rax"
    next
  end

  if s.check('-')
    s.getch
    puts "  sub $#{s.scan(/\d+/)}, %rax"
    next
  end

  STDERR.puts "unexpected character: '#{s.getch}'"
  return
end

puts "  ret"
