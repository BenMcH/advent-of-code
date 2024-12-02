class Day02
  
  def self.parse(input)
    lines = input.strip.split("\n")
    lines = lines.map{|line| line.split.map(&:to_i)}

    lines
  end
  
  def self.is_safe?(report, correction = false)
      report.reverse! if report[0] > report[1]
      
      safe = true
      
      i = 0

      for i in 0..(report.length - 2)
        a = report[i]
        b = report[i + 1]
        if a >= b || b - a > 3
          safe = false
          break
        end
      end
      
      safe
  end

  def self.part_1(input)
    reports = parse(input)
    
    count = 0
    
    reports.each do |report|
      count += 1 if is_safe?(report)
    end

    count
  end
  
  def self.part_2(input)
    reports = parse(input)
    
    count = 0
    
    reports.each do |report|
      cases = [report]
      
      for i in 0..(report.length - 1)
        r = report.dup
        r.delete_at(i)
        cases << r
      end

      if cases.any?{ |report| is_safe?(report)}
        count += 1
      end
    end

    count
  end
end
