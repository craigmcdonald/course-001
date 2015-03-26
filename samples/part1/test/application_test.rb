require_relative 'test_helper'

class ApplicationTest < Minitest::Test

  def setup(*args)
    Dir.chdir("/home/craig/dev/challenges/course-001/samples/part1/data")
    ARGV.clear
    args.each {|arg| ARGV << arg }
    @application = RubyLS::Application.new
    @out, @err = capture_io do
      @application.run
    end
    Dir.chdir("/home/craig/dev/challenges/course-001/samples/part1/data")
    @ls_stdout, @ls_stderr, @ls_status = Open3.capture3("ls "+args.join(" ").to_s)
  end

  def test_with_empty_args
    setup
    assert_equal @ls_stdout, @out
  end

  def test_with_dir_foo
    setup("foo")
    assert_equal @ls_stdout, @out
  end

  def test_with_flag_l
    setup("-l")
    assert_equal @ls_stdout, @out
  end

  def test_with_flag_a
    setup("-a")
    assert_equal @ls_stdout, @out
  end

  def test_with_flags_a_and_l
    setup("-al")
    assert_equal @ls_stdout, @out
  end

  def test_with_flags_a_and_l_and_dir_star_dot_txt
    setup("-l","foo/bar.txt", "foo/baz.txt", "foo/quux.txt")
    assert_equal @ls_stdout, @out
  end

  def test_with_invalid_flag_Z
    setup("-Z")
    assert_equal @ls_stdout, @out
  end

end