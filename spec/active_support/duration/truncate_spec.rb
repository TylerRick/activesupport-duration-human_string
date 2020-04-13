# TODO:
# rename?
# extract to -change gem

def durations(value)
  [
    ActiveSupport::Duration.build(value),
    #ActiveSupport::Duration.seconds(value)
  ]
end

RSpec.describe ActiveSupport::Duration, '.parse_parts' do
  it do
    parts = {minutes: 30.5, seconds: 30.5}
    duration = ActiveSupport::Duration.parse_parts(parts, normalize: true)
    expect(duration.parts).to eq({minutes: 31, seconds: 0.5})
    # TODO: don't use if standalone gem
    expect(duration.to_human_s).to eq('31m 0.5s')
  end

  it do
    parts = {minutes: 30.5, seconds: 30.5}
    duration = ActiveSupport::Duration.parse_parts(parts)
    expect(duration.parts).to eq(parts)
    # TODO: don't use if standalone gem
    expect(duration.to_human_s).to eq('31m 0.5s')
  end

  it 'is inverse of .parts'
end

RSpec.describe ActiveSupport::Duration, '#change/#change_cascade' do
  describe '1830.50' do
    let(:value) { 1830.50 }
    let(:duration) { ActiveSupport::Duration.build(value) }
    it { expect(duration.parts).to eq({minutes: 30, seconds: 30.5}) }

    describe do
      it do
        new = duration.change(minutes: 1)
        expect(new.parts).to eq({minutes: 1, seconds: 30.5})
      end
      it do
        new = duration.change_cascade(minutes: 1)
        expect(new.parts).to eq({minutes: 1})
      end

      # TODO
    end
  end
end

RSpec.describe ActiveSupport::Duration, '#change_cascade' do
  describe '1830.50' do
    let(:value) { 1830.50 }
    let(:duration) { ActiveSupport::Duration.build(value) }
    it { expect(duration.parts).to eq({minutes: 30, seconds: 30.5}) }

    it do
      durations(value).each do |duration|
      end
    end
  end
end

RSpec.describe ActiveSupport::Duration, '#truncate/#round' do
  describe '1830.50' do
    let(:value) { 1830.50 }
    let(:duration) { ActiveSupport::Duration.build(value) }
    it { expect(duration.parts).to eq({minutes: 30, seconds: 30.5}) }

    it do
      durations(value).each do |duration|
        expect(duration.truncate(:seconds).parts).to eq({minutes: 30, seconds: 30})
        expect(duration.   round(:seconds).parts).to eq({minutes: 30, seconds: 31})
      end
    end

    it do
      durations(value).each do |duration|
        expect(duration.truncate(:minutes).parts).to eq({minutes: 30})
        expect(duration.   round(:minutes).parts).to eq({minutes: 31})
      end
    end

#    it do
#      durations(value).each do |duration|
#        expect(duration.truncate(:hours).parts).to eq({hours: 1})
#        expect(duration.   round(:hours).parts).to eq({})
#        expect(duration.   round(:hours).value).to eq(0)
#      end
#    end
  end

#  it do
#    durations(3510.50).each do |duration|
#      expect(duration.truncate(:hours).parts).to eq({})
#      expect(duration.   round(:hours).parts).to eq({hours: 59})
#    end
#  end

if false
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

end

RSpec.describe ActiveSupport::Duration, '#truncate_part/#round_part' do
  xit 'can be chained' do
    parts = {minutes: 30.5, seconds: 30.5}
    it { expect(duration.round_part(:minutes).round_part(:seconds).parts).to eq({minutes: 31, seconds: 31}) }
  end
end
