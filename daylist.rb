#!/opt/local/bin/ruby -w


class Days
    @@day_array = %w{ sun mon tues wed thurs fri sat }
    @@day_hash  = { 
        'sun'   => 0,
        'mon'   => 1,
        'tues'  => 2,
        'wed'   => 3,
        'thurs' => 4,
        'fri'   => 5,
        'sat'   => 6,
    }

    def initialize(first,last)
        @first = first
        @last  = last
    end

    def list
        result  = []
        current = @@day_hash[@first]

        while current != @@day_hash[@last]
            result << @@day_array[current]

            if current == 6
                current = 0
            else
                current += 1
            end

            if current == @@day_hash[@last]
                result << @@day_array[current]
            end
         end

         return result.join(', ')
    end
end

days = Days.new('tues','mon');
puts days.list

