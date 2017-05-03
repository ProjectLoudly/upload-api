require 'spec_helper'
require 'transcoder'

describe Transcoder do
  before do
    @transcoder = Transcoder.new()
  end

  context 'when to_flac()' do
    module SuccessTrue
      def self.success?
        true
      end
    end
    module StubStatus
      def self.value
        SuccessTrue
      end
    end
    input_file = '/tmp/input.flac'
    output_file = '/tmp/output.flac'
    title = 'title'
    contributor = 'contributor'

    it 'raises an error when there is no binary path' do
      expect{@transcoder.to_flac(
          file: input_file,
          output_file: output_file,
          title: title,
          contributor: contributor)}.to raise_error StandardError
    end

    it 'raises an error when no title is supplied' do
      expect{@transcoder.to_flac(
          file: input_file,
          output_file: output_file,
          contributor: contributor)}.to raise_error ArgumentError
    end

    it 'returns a path to output file' do
      allow(File).to receive(:exists?).and_return(true)
      response = ['stdin', 'stdout', 'stderr', StubStatus]
      allow(Open3).to receive(:popen3).and_yield(*response)
      expect(@transcoder.to_flac(file: input_file,
                                 output_file: output_file,
                                 title: title,
                                 contributor: contributor)).to be output_file
    end
  end
end