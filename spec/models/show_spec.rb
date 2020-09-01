require 'rails_helper'

RSpec.describe Show, type: :model do
  let(:title) { 'Uncle Vanya' }
  
  def date(arg)
    arg.is_a?(Fixnum) ? Date.new(2020, 9, arg) : arg
  end

  def create_show(date_from, date_to)
    Show.create(title: title, period: date(date_from) .. date(date_to))
  end

  it "should allow to create new show with valid attributes" do
    expect(Show.count).to be(0)
    show = create_show(10, 20)

    expect(show).to be_valid
    expect(show.title).to eq(title)
    expect(Show.count).to be(1)

    expect(show.period).to eq(Date.new(2020, 9, 10) .. Date.new(2020, 9, 20))    
  end

  it "should not allow to create a show with empty title" do
    show = Show.create(title: '', period: (date(1) .. date(5)))
    expect(show).not_to be_valid
    expect(show.errors[:title]).to be_present
  end
  
  invalid_periods = [
    nil,
    (Date.new(2020, 9, 12) .. Date.new(2020, 9, 10)),
    34,
    (10 .. 12)
  ]

  invalid_periods.each do |period|
    it "should not allow to create a show with invalid period (#{period})" do
      show = Show.create(title: 'correct', period: period)      
      expect(show).not_to be_valid
      expect(show.errors[:period]).to be_present
    end
  end
  
  conflicting_intervals = [ # with (10 .. 20)
    [1, 10],
    [1, 15],
    [10, 15],
    [12, 15],

    [18, 20],
    [18, 25],
    [20, 25],

    [5, 25]
  ]

  conflicting_intervals.each do |interval|
    it "should not allow to create show on dates (#{interval[0]} .. #{interval[1]}) when there is a show on dates (10 .. 20)" do 
      show = create_show(10, 20)
      show2 = create_show(*interval)

      expect(show2).not_to be_valid
      expect(Show.count).to be(1)
    end
  end

  valid_intervals = [
    [1, 9],
    [1, 5],

    [21, 25],
    [23, 30]
  ]

  valid_intervals.each do |interval|
    it "should allow to create show on dates (#{interval[0]} .. #{interval[1]}) when there is a show on dates (10 .. 20)" do 
      show = create_show(10, 20)
      show2 = create_show(*interval)

      expect(show2).to be_valid
      expect(Show.count).to be(2)
    end
  end
end
