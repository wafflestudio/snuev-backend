require 'rails_helper'
require 'crawler/migrator'

RSpec.describe Crawler::Migrator do
  describe 'Crawler::Migrator' do
    let(:csv_path) { file_fixture('2018_spring_ex.csv').to_s }

    context 'try to migrate from invalid csv' do
      it { expect { Crawler::Migrator.migrate('not_an_entry', 2018, 'spring') }.to raise_error(Errno::ENOENT) }
    end

    context 'try to migrate with invalid year' do
      it { expect { Crawler::Migrator.migrate(csv_path, 1900, 'spring') }.to raise_error(ArgumentError) }
    end

    context 'try to download with invalid semester' do
      it { expect { Crawler::Migrator.migrate(csv_path, 2018, 'not_semester') }.to raise_error(ArgumentError) }
    end

    context 'convert valid xls to csv' do
      it {
        prev_lectures = Lecture.all.count
        Crawler::Migrator.migrate(csv_path, 2018, 'spring')
        expect(prev_lectures).not_to eq(Lecture.all.count)
      }
    end
  end
end
