# frozen_string_literal: true

require 'tempfile'

class SafeRuby
  EvalError = Class.new(StandardError)

  DEFAULTS = {
    timeout: 5,
    raise_errors: true
  }.freeze

  def self.eval(code, options = {})
    new(code, options).eval
  end

  def self.check(code, expected)
    eval(code) == eval(expected)
  end

  def initialize(code, options = {})
    raise ArgumentError, 'No code to evaluate.' unless code

    options = DEFAULTS.merge(options)

    @code         = code
    @raise_errors = options[:raise_errors]
    @timeout      = options[:timeout]
  end

  def eval
    temp = build_tempfile
    read, write = IO.pipe

    ChildProcess.build('ruby', temp.path).tap do |process|
      process.io.stdout = write
      process.io.stderr = write
      process.start
      begin
        process.poll_for_exit(@timeout)
      rescue ChildProcess::TimeoutError => e
        process.stop # tries increasingly harsher methods to kill the process.
        raise e
      ensure
        write.close
        temp.unlink
      end
    end

    data = read.read

    begin
      Marshal.load(data)
    rescue
      raise data if raise_errors?
    ensure
      read.close
    end

    data
  end

  private

  def build_tempfile
    file = Tempfile.new('saferuby')
    file.write(MAKE_SAFE_CODE)

    file.write <<-STRING
      result = eval(%q(#{@code}))
      print Marshal.dump(result)
    STRING

    file.rewind
    file
  end

  def raise_errors?
    @raise_errors
  end
end
