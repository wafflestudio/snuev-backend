require 'rails_helper'
require 'crawler/downloader'

RSpec.describe Crawler::Downloader do
  describe 'Crawler::Downloader' do
    let(:file) { File.new(file_fixture('2018_spring_ex.xls')) }

    before { stub_request(:any, %r{#{Crawler::Downloader::CRS_HOST}/*}).to_return(body: file) }

    context 'try to download with invalid year' do
      it { expect { Crawler::Downloader.download(1900, 'spring') }.to raise_error(ArgumentError) }
    end

    context 'try to download with invalid semester' do
      it { expect { Crawler::Downloader.download(2017, 'not_semester') }.to raise_error(ArgumentError) }
    end

    context 'download with valid year and semester' do
      it { expect(Crawler::Downloader.download(2017, 'spring')).to match('.xls') }
      it { expect(Crawler::Downloader.download(2017, 'autumn')).to match('.xls') }
      it { expect(Crawler::Downloader.download(2017, 'summer')).to match('.xls') }
      it { expect(Crawler::Downloader.download(2017, 'winter')).to match('.xls') }
    end
  end
end
