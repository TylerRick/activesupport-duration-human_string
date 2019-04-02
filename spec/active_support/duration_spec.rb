RSpec.describe ActiveSupport::Duration do
  describe '#human_str' do
    it do
      duration = ActiveSupport::Duration.build(3500)
      expect(duration.human_str                ).to eq '58m 20s'
      expect(duration.human_str(delimiter: '') ).to eq '58m20s'
      expect(duration.human_str(separator: ' ')).to eq '58 m 20 s'
      expect(duration.human_str(delimiter: ', ', separator: ' ')).to eq '58 m, 20 s'
    end

    it 'precision' do
      duration = ActiveSupport::Duration.build(65.12345)
      expect(duration.human_str              ).to eq '1m 5.12345s'
      expect(duration.human_str(precision: 3)).to eq '1m 5.123s'
      expect(duration.human_str(precision: 0)).to eq '1m 5s'
    end

    it do
      duration = ActiveSupport::Duration.build(35)
      expect(duration.human_str).to eq '35s'
    end

    it 'use_2_digit_numbers: false' do
      duration = ActiveSupport::Duration.build(65)
      expect(duration.human_str).to eq '1m 5s'
    end

    it 'use_2_digit_numbers: true' do
      duration = ActiveSupport::Duration.build(65)
      expect(duration.human_str(use_2_digit_numbers: true)).to eq '1m 05s'
    end
  end

  describe '#human_string, #to_human_s aliases' do
    it do
      duration = ActiveSupport::Duration.build(3500)
      expect(duration.human_string).to eq duration.human_str
      expect(duration.to_human_s  ).to eq duration.human_str
    end
  end
end
