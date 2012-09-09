require 'rspec'

class DayList
  include Enumerable

  def initialize(args)
    @start = args[:start]
    @end   = args[:end]

    @days_map = {
      sun:   0,
      mon:   1,
      tues:  2,
      wed:   3,
      thurs: 4,
      fri:   5,
      sat:   6,
    }

    @days = @days_map.keys
    @last_day = @days.size - 1
  end

  def each
    start_day = @days_map[@start]
    stop_day = @days_map[@end]

    is_overlap = (stop_day < start_day)

    last_day = if is_overlap
             @last_day
           else
             stop_day
           end

    (start_day..last_day).each do |day|
      yield @days[day]
    end

    if is_overlap
      (0..(start_day - 1)).each do |day|
        yield @days[day]
      end
    end
  end
end


describe DayList do
  it 'should exist' do
    @daylist = DayList.new(start: :sun, end: :sat)
    @daylist.should be_true
  end

  it 'should have a map function' do
    @daylist = DayList.new(start: :sun, end: :sat)
    list = @daylist.map {|d| d}
    list.length.should == 7
    list.should == [:sun, :mon, :tues, :wed, :thurs, :fri, :sat]
  end

  it 'should work starting in the middle of the week' do
    list = DayList.new(start: :wed, end: :tues).map {|d| d}
    list.length.should == 7
    list.should == [:wed, :thurs, :fri, :sat, :sun, :mon, :tues]
  end

  it 'should find beginning of list' do
    @daylist = DayList.new(start: :sun, end: :sat)
    start = @daylist.first
    start.should == :sun

  end

end
