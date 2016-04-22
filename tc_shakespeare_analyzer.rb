require_relative "shakespeare_analyzer"
require "test/unit"
 
 #unit tests for Shakespeare_analyzer class
class TestShakespeareParser < Test::Unit::TestCase
 

	#test empty xml
	def test_empty
	  	base_hash = Hash.new
	  	assert_raise( RuntimeError ) { 
	  		result_hash = Shakespeare_analyzer.parse("") 
	  	}
	end

	#tests malformed string
	def test_malformed_string
	  	base_hash = Hash.new
	  	assert_raise( RuntimeError ) { 
	  		result_hash = Shakespeare_analyzer.parse("<one><two></one></two>") 
	  	}
	end

	#tests speech with one speaker only
	def test_one_speaker
	  	base_hash = {"Second Witch" => 2}
	  	result_hash = Shakespeare_analyzer.parse("<SPEECH>
			<SPEAKER>Second Witch</SPEAKER>
			<LINE>When the hurlyburly's done,</LINE>
			<LINE>When the battle's lost and won.</LINE>
			</SPEECH>
	")
	  	assert_equal(base_hash,result_hash)
	end

	#tests more than one speech#
	def test_more_than_one_occurrence
	  	base_hash = {"Second Witch" => 3}
	  	result_hash = Shakespeare_analyzer.parse(
	  		"
			<r1>
	  		<SPEECH>
				<SPEAKER>Second Witch</SPEAKER>
					<LINE>When the hurlyburly's done,</LINE>
					<LINE>When the battle's lost and won.</LINE>
			</SPEECH>
			<SPEECH>
				<SPEAKER>Second Witch</SPEAKER>
					<LINE>When the hurlyburly's done,</LINE>
			</SPEECH>
			</r1>
	")
	  	assert_equal(base_hash,result_hash)
	  end

	  #tests two speakers in same speech
	  def test_two_speakers
	  	base_hash = {"Second Witch" => 3,"Third Witch" => 3}
	  	result_hash = Shakespeare_analyzer.parse("<SPEECH>
			<SPEAKER>Second Witch</SPEAKER>
			<SPEAKER>Third Witch</SPEAKER>
			<LINE>When the hurlyburly's done,</LINE>
			<LINE>When the battle's lost and won.</LINE>
			<LINE>another line</LINE>
			</SPEECH>
	")
	  	assert_equal(base_hash,result_hash)
	  end

	#tests xml with speaker not in the beginning of speech
	def test_speaker_end
	  	base_hash = {"John Doe" => 1}
	  	result_hash = Shakespeare_analyzer.parse(
	  		"<SPEECH>
			<LINE>When the hurlyburly's done,</LINE>
			<SPEAKER>John Doe</SPEAKER>
			</SPEECH>"
		)
	  	assert_equal(base_hash,result_hash)
	end

	#tests speech with no speaker
	def test_no_speaker
	  	base_hash = Hash.new
	  	result_hash = Shakespeare_analyzer.parse(
	  		"<SPEECH>
			<LINE>When the hurlyburly's done,</LINE>
			</SPEECH>"
		)
	  	assert_equal(base_hash,result_hash)
	end

	#tests speaker all
	def test_speaker_ALL
	  	base_hash = Hash.new
	  	result_hash = Shakespeare_analyzer.parse(
	  		"<SPEECH>
	  		<SPEAKER>ALL</SPEAKER>
			<LINE>When the hurlyburly's done,</LINE>
			</SPEECH>"
		)
	  	assert_equal(base_hash,result_hash)
	end

	#tests xml enclosed in other tags
	def test_enclosed_other_tags
	  	base_hash = {"John Doe" => 1}
	  	result_hash = Shakespeare_analyzer.parse(
	  		"<play>
	  		<SPEECH>
			<LINE>When the hurlyburly's done,</LINE>
			<SPEAKER>John Doe</SPEAKER>
			</SPEECH>
			</play>"
		)
	  	assert_equal(base_hash,result_hash)
	end
 
end
