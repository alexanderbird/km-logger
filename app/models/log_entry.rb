class LogEntry < ActiveRecord::Base
  validates_presence_of :kms, :for
  validates :kms, numericality: {less_than: 999999}
  validate :kms_are_not_less_than_the_greatest_so_far
  def kms_are_not_less_than_the_greatest_so_far
    self.infer_extra_digits_of_kms
    if self.previous && self.kms < self.previous.kms
      errors[:kms] << "must be greater than #{self.previous.kms}."
    end
  end
  def previous
    if self.new_record?
      LogEntry.order(:kms).last
    else
      LogEntry.where("kms < ?", self.kms).order(:kms).last
    end
  end
  before_save :infer_extra_digits_of_kms
  def infer_extra_digits_of_kms
    if self.kms.to_s.size < 6 && self.previous && self.previous.kms
      previous_kms = self.previous.kms
      number_of_digits_provided = self.kms.to_s.size
      inferred_kms = previous_kms.to_s[0..(5-number_of_digits_provided)] + self.kms.to_s
      self.kms = inferred_kms.to_i
    end
  end 
end
