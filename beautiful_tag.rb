
$andr_special_tags = ["android", "app", "xmlns", "xml", "style"]

$andr_ignore_tags = ["<!--"]

def write_this(fw, indent, word)
  fw.write "    "*indent + word
end

def put_new_line_after(fw, indent, word)
  write_this(fw, indent, word)
  fw.puts ""
end

def put_bw_new_line(fw, indent, word)
  fw.puts ""
  write_this(fw,indent,word)
  fw.puts ""
end


File.open("out.xml", "w") do |fw|
  File.open("fragment_task_detail.xml", "r") do |fr|
    tags = []
    tags_pos = []
    indent = 0
    while line = fr.gets
      puts tags.join ' '
      words = line.split(" ")
      if !words.empty? and $andr_ignore_tags.any? {|ign| words.first.start_with? ign }
        write_this(fw, indent, line)
        next
      end
      words.each { |word|
        if word.start_with? '<' and !word.start_with? '</'
          fw.puts ""
          put_bw_new_line(fw, indent, word)
          tags.push( word[1..-1] )
          tags_pos.push indent
          indent+=1

        elsif word.end_with? '/>'
          # finito tag #1
          put_bw_new_line(fw, indent, word)
          tags.pop
          tags_pos.pop
          indent-=1

        elsif word.start_with? '</' and word[2..-2].eql? tags.last and word.end_with? '>'
          # finito tag #2
          indent = tags_pos.pop
          puts "back to indent #{indent}"
          tags.pop
          put_bw_new_line(fw, indent, word)

        elsif $andr_special_tags.any?{|w| word.start_with? w }
          fw.puts ""
          write_this(fw,indent, word)
        else
          write_this(fw, indent, word)
        end
      }
    end
  end
end




###  todo
#
# - recursive file searching
# - getting file name or path from terminal
# - first line is always <?xml so after that do not indent
#
