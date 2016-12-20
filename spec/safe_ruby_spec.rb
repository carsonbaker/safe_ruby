# frozen_string_literal: true

require 'spec_helper'

describe SafeRuby do
  describe '#eval' do
    it 'allows basic operations' do
      SafeRuby.eval('4 + 5').should eq 9
      SafeRuby.eval('[4, 5].map{|n| n+1}').should eq [5, 6]
    end

    it 'returns correct object' do
      SafeRuby.eval('[1,2,3]').should eq [1, 2, 3]
    end

    it 'does not allow malicious operations' do
      expect { SafeRuby.eval("system('rm *')") }.to raise_error
      expect { SafeRuby.eval('`rm *`') }.to raise_error
      expect { SafeRuby.eval('Kernel.abort') }.to raise_error
    end

    describe 'options' do
      describe 'timeout' do
        it 'defaults to a 5 second timeout' do
          time = Benchmark.realtime do
            SafeRuby.eval('(1..100000).map {|n| n**100}')
          end
          time.should be_within(0.5).of(5)
        end

        it 'allows custom timeout' do
          time = Benchmark.realtime do
            SafeRuby.eval('(1..100000).map {|n| n**100}', timeout: 1)
          end
          time.should be_within(0.5).of(1)
        end
      end

      describe 'raising errors' do
        it 'defaults to raising errors' do
          expect { SafeRuby.eval('asdasdasd') }.to raise_error
        end

        it 'allows not raising errors' do
          expect { SafeRuby.eval('asdasd', raise_errors: false) }.to_not raise_error
        end
      end
    end
  end
end
