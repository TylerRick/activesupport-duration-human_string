def durations(value)
  [ActiveSupport::Duration.build(value), ActiveSupport::Duration.seconds(value)]
end

RSpec.describe ActiveSupport::Duration do
  describe '#human_str' do
    it do
      durations(3500).each do |duration|
        expect(duration.human_str                ).to eq '58m 20s'
        expect(duration.human_str(delimiter: '') ).to eq '58m20s'
        expect(duration.human_str(separator: ' ')).to eq '58 m 20 s'
        expect(duration.human_str(delimiter: ', ', separator: ' ')).to eq '58 m, 20 s'
      end
    end

    it 'precision' do
      durations(65.12345).each do |duration|
        expect(duration.human_str              ).to eq '1m 5.12345s'
        expect(duration.human_str(precision: 3)).to eq '1m 5.123s'
        expect(duration.human_str(precision: 0)).to eq '1m 5s'
      end
    end

    it do
      durations(35).each do |duration|
        expect(duration.human_str).to eq '35s'
      end
    end

    it 'use_2_digit_numbers: false' do
      durations(65).each do |duration|
        expect(duration.human_str).to eq '1m 5s'
      end
    end

    it 'use_2_digit_numbers: true' do
      durations(65).each do |duration|
        expect(duration.human_str(use_2_digit_numbers: true)).to eq '1m 05s'
      end
    end
  end

  describe '#human_string, #to_human_s aliases' do
    it do
      durations(3500).each do |duration|
        expect(duration.human_string).to eq duration.human_str
        expect(duration.to_human_s  ).to eq duration.human_str
      end
    end
  end
end
