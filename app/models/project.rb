class Project < Category

  scope :ordered_by_active, -> { order(active: :desc) }
  scope :active, -> { where(active: true) }

  def active?
    self.active
  end

  def inactive?
    active? ? false : true
  end
  
end
