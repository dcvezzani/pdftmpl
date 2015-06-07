class Invoice < ActiveRecord::Base
  has_many :work_weeks

  def calculate_totals(pay_rate)
    self.subtotal = self.work_weeks.inject(0.0){|a,b| a += ((b.hours or 0.0) * pay_rate)}
    self.total = self.subtotal #no tax applicable
  end
end
