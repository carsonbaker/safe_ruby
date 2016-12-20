# frozen_string_literal: true

CORE_CLASSES = %i(
  Array
  BasicObject
  Bignum
  Binding
  Class
  Comparable
  Complex
  ConditionVariable
  Data
  Encoding
  Enumerable
  Enumerator
  FalseClass
  Fiber
  Fixnum
  Float
  Hash
  IO
  Integer
  Kernel
  Marshal
  MatchData
  Math
  Method
  Module
  NilClass
  Numeric
  Object
  Proc
  Queue
  Random
  Range
  Rational
  Regexp
  RubyVM
  Signal
  SizedQueue
  StopIteration
  String
  Struct
  Symbol
  Thread Mutex
  ThreadGroup
  Time
  TracePoint
  TrueClass
  UnboundMethod
).freeze

OTHER_CLASSES = %i(
  Config
  Date
  Exception2MessageMapper
  Gem
  IRB
  Monitor
  MonitorMixin
  RbConfig
  Readline
  RubyLex
  RubyToken
).freeze

EXCEPTION_CLASSES = %i(
  ArgumentError
  EOFError
  EncodingError
  Errno
  Exception
  FiberError
  FloatDomainError
  IOError
  IndexError
  Interrupt
  KeyError
  LoadError
  LocalJumpError
  NameError
  NoMemoryError
  NoMethodError
  NotImplementedError
  RangeError
  RegexpError
  RuntimeError
  ScriptError
  SecurityError
  SignalException
  StandardError
  SyntaxError
  SystemCallError
  SystemExit
  SystemStackError
  ThreadError
  TypeError
  ZeroDivisionError
).freeze

OTHER_CONSTANTS = %i(
  ARGV
  CROSS_COMPILING
  FALSE
  NIL
  RUBY_COPYRIGHT
  RUBY_DESCRIPTION
  RUBY_ENGINE
  RUBY_PATCHLEVEL
  RUBY_PLATFORM
  RUBY_RELEASE_DATE
  RUBY_REVISION
  RUBY_VERSION
  RUBYGEMS_ACTIVATION_MONITOR
  STDIN
  STDOUT
  STDERR
  TOPLEVEL_BINDING
  TRUE
).freeze

ALLOWED_CONSTANTS = [
  CORE_CLASSES,
  OTHER_CLASSES,
  EXCEPTION_CLASSES,
  OTHER_CONSTANTS
].flatten.freeze
