# Unicode字符转换成Unicode 转义序列
str = '  '

arr = str.split(' ')
# 循环输出每个元素及其 Unicode 转义序列
arr.each do |str|
  unicode_point = str.codepoints.map { |c| "\\u#{c.to_s(16).rjust(4, '0')}" }.join
  puts "#{str} #{unicode_point}"
end


