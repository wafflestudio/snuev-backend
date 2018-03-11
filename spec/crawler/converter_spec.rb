RSpec.describe Crawler::Converter do
  describe 'Crawler::Converter' do
    let(:xls_path) { Rails.root.join("crawl/2018_spring_ex.xls").to_s }

    context 'try to convert invalid xls' do
      it { expect { Crawler::Converter.convert("not_an_entry") }.to raise_error(Errno::ENOENT) }
    end

    context 'convert valid xls to csv' do
      it { expect(Crawler::Converter.convert(xls_path)).to match(".csv") }
    end
  end
end
