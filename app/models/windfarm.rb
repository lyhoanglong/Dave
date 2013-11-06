class Windfarm
  include Mongoid::Document

  ## REFERENCES
  belongs_to :user

  field :name, type: String

  field :geo_loc, type: Hash # Hash[:lng => "", :lat => ""]

  ## ??
  field :date_commissioned, type: String ## year??
  field :location, type: String
  field :power, type: String
  field :total_turbines, type: Integer, :default => 0

  field :iec, type: String

  field :roughness, type: String
  field :location_type, type: String

  field :dave_active, type: String, :default => 'no' ## yes, no
  field :dave_approved, type: String, :default => 'no' ## yes, no
  field :auto_activate, type: String, :default => 'no' ## yes, no

  attr_accessible :name, :power, :total_turbines, :geo_loc, :date_commissioned, :location, :iec, :roughness,
                  :location_type, :dave_active, :dave_approved, :auto_activate

  ## INDEX
  index({ name: 1 }, { name: "windfarm_name", background: true})
  index({ dave_active: 1 }, {name: "windfarm_dave_active", background: true })
  index({ dave_approved: 1 }, {name: "windfarm_dave_approve", background: true })
  index({ auto_activate: 1 }, {name: "windfarm_auto_activate", background: true })

  ##Validate
  validates :name, :presence => true, :length => {:minimum => 1, :maximum => 100}
  validates :location, :length => {:minimum => 1, :maximum => 100}, :if => Proc.new { |wf| not wf.location.nil? }
  validates :total_turbines, :presence => true, :numericality => {:only_integer => true}

  validates :iec, :presence => true, :inclusion => {:in => ['1A','2A','3A','1B','2B','3B','1C','2C','3C','S']}
  #validates :roughness, :presence => true, :inclusion => {:in => []}
  #validates :location_type, :presence => true, :inclusion => {:in => []}

  validates :dave_active, :presence => true, :inclusion => {:in => ['yes', 'no']}
  validates :dave_approved, :presence => true, :inclusion => {:in => ['yes', 'no']}
  validates :auto_activate, :presence => true, :inclusion => {:in => ['yes', 'no']}

end
