require 'nokogiri'
require 'open-uri'

class Shakespeare_analyzer

  def self.parse(xml)
    pair_array = Hash.new(0)		
    doc = Nokogiri::XML(xml)
	# doc = Nokogiri::XML(open("http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml"))
    speeches = get_speeches(doc)
    speeches.each do |speech|
      children = speech.children
      speakers = get_speakers(children)
      line_count = get_line_count(children)
      sum_children(pair_array,speakers,line_count)
    end
    return pair_array
  end

  def self.get_speeches(doc)
    return doc.xpath("//SPEECH")
  end

  def self.get_speakers(children)
    speakers = Array.new
    children.each do |child|
      if child.name == "SPEAKER"
	if child.content != "ALL"
	  speakers.push(child.content)
	end
      end
    end
    return speakers
  end


  def self.get_line_count(children)
    count = 0
    children.each do |child|
      if child.name == "LINE"
	count = count+1
      end
    end
    return count
  end

  def self.sum_children(hash_table,speakers,count)
    speakers.each do |speaker|
      hash_table[speaker] = hash_table[speaker] + count
    end
  end			

end


class Pretty_printer

	def self.pretty(hash_table)
    	hash_table.each do |key,value|
      		puts "#{key} #{value}"
      	end
    end
end


table = Shakespeare_analyzer.parse(open("http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml"))
Pretty_printer.pretty(table)

