require 'citrus'
require 'time'

Citrus.load(File.expand_path('../apachelog', __FILE__))

if $0 == __FILE__
  require 'test/unit'

  class ApacheCommonLogTest < Test::Unit::TestCase
    SAMPLE_DATA = <<LOG_ENTRIES
127.0.0.1 - - [10/Apr/2007:10:39:11 +0300] "GET / HTTP/1.1" 500 606
127.0.0.1 - - [10/Apr/2007:10:39:11 +0300] "GET /favicon.ico HTTP/1.1" 200 766
139.12.0.2 - - [10/Apr/2007:10:40:54 +0300] "GET / HTTP/1.1" 500 612
139.12.0.2 - - [10/Apr/2007:10:40:54 +0300] "GET /favicon.ico HTTP/1.1" 200 766
127.0.0.1 - - [10/Apr/2007:10:53:10 +0300] "GET / HTTP/1.1" 500 612
127.0.0.1 - - [10/Apr/2007:10:54:08 +0300] "GET / HTTP/1.0" 200 3700
127.0.0.1 - - [10/Apr/2007:10:54:08 +0300] "GET /style.css HTTP/1.1" 200 614
127.0.0.1 - - [10/Apr/2007:10:54:08 +0300] "GET /img/pti-round.jpg HTTP/1.1" 200 17524
127.0.0.1 - - [10/Apr/2007:10:54:21 +0300] "GET /unix_sysadmin.html HTTP/1.1" 200 3880
217.0.22.3 - - [10/Apr/2007:10:54:51 +0300] "GET / HTTP/1.1" 200 34
217.0.22.3 - - [10/Apr/2007:10:54:51 +0300] "GET /favicon.ico HTTP/1.1" 200 11514
217.0.22.3 - - [10/Apr/2007:10:54:53 +0300] "GET /cgi/pti.pl HTTP/1.1" 500 617
127.0.0.1 - - [10/Apr/2007:10:54:08 +0300] "GET / HTTP/0.9" 200 3700
217.0.22.3 - - [10/Apr/2007:10:58:27 +0300] "GET / HTTP/1.1" 200 3700
217.0.22.3 - - [10/Apr/2007:10:58:34 +0300] "GET /unix_sysadmin.html HTTP/1.1" 200 3880
217.0.22.3 - - [10/Apr/2007:10:58:45 +0300] "GET /talks/excel-file.html HTTP/1.1" 404 311
LOG_ENTRIES

    def test_entry_timestamp
      match = ApacheCommonLogEntry.parse('[18/Sep/2004:11:07:48 +1000]', :root => :timestamp)
      assert(match)
      assert_equal('18/Sep/2004:11:07:48 +1000', match.ts_string)

      time = Time.parse('18/Sep/2004 11:07:48 +1000')
      assert_equal(time, match.value)

      match = ApacheCommonLogEntry.parse('[03/Nov/2010:09:59:26 -0500]', :root => :timestamp)
      assert(match)
      assert_equal('03/Nov/2010:09:59:26 -0500', match.ts_string)

      time = Time.parse('03/Nov/2010 09:59:26 -0500')
      assert_equal(time, match.value)
    end

    def test_file
      match = ApacheCommonLogFile.parse(SAMPLE_DATA)
      assert(match)
      assert_equal(16, match.entries.length)

      first_entry = match.entries.first
      assert(first_entry)

      # Test to make sure the entry's attributes are set correctly.
      assert_equal(Time.parse('10/Apr/2007 10:39:11 +0300'), first_entry.time)
      assert_equal(500, first_entry.status)
      assert_equal(606, first_entry.size)
    end
  end
end
