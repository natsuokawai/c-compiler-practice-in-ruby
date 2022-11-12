if ARGV.size != 1
  STDERR.puts "#{ARGV.size}: invalid number of arguments\n"
  return
end

if ARGV[0].is_a? Integer
  STDERR.puts "#{ARGV[0]}: invalid number og arguments\n"
  return
end

puts "  .global main"
puts "main:"
puts "  mov $#{ARGV[0]}, %rax"
puts "  ret"
