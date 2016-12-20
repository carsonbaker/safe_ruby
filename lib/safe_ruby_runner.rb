# frozen_string_literal: true

require 'tempfile'

class SafeRuby
  EvalError = Class.new(StandardError)

  DEFAULTS = {
    timeout: 5,
    raise_errors: true
  }.freeze

  def self.eval(code, **options)
    new(code, options).eval
  end

  def self.check(code, expected)
    eval(code) == eval(expected)
  end

  def initialize(code, **options)
    raise ArgumentError, 'No code to evaluate.' if code.nil?

    options = DEFAULTS.merge(options)

    @code         = code
    @raise_errors = options[:raise_errors]
    @timeout      = options[:timeout]
  end

  def eval
    tmpfile = build_tempfile
    data = eval_file(tmpfile)
    Marshal.load(data)
  rescue ChildProcess::TimeoutError => e
    raise EvalError, e.message if raise_errors?
    e.message
  rescue
    raise EvalError, data if raise_errors?
    data
  ensure
    tmpfile.unlink
  end

  private

  def eval_file(tempfile)
    IO.pipe do |r_pipe, w_pipe|
      ChildProcess.build('ruby', tempfile.path).tap do |process|
        process.io.stdout = w_pipe
        process.io.stderr = w_pipe
        process.start

        begin
          process.poll_for_exit(@timeout)
        rescue ChildProcess::TimeoutError => e
          process.stop # tries increasingly harsher methods to kill the process.
          raise e
        ensure
          w_pipe.close
        end
      end

      r_pipe.read
    end
  end

  def build_tempfile
    file = Tempfile.new(%w(saferuby .rb))
    file.write(MAKE_SAFE_CODE)

    file.write <<~RUBY
      result = eval(%q(#{@code}))
      print Marshal.dump(result)
    RUBY

    file.rewind
    file
  end

  def raise_errors?
    @raise_errors
  end
end
