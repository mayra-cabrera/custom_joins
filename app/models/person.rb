class Person < ActiveRecord::Base
  belongs_to :location
  belongs_to :role
  belongs_to :manager, class_name: "Person", foreign_key: :manager_id
  has_many :employees, class_name: "Person", foreign_key: :manager_id

  def self.without_remote_manager
    joins(<<-SQL).
      LEFT JOIN people managers
      ON managers.id = people.manager_id
    SQL
    where("managers.location_id = ? OR managers.id IS NULL",
         Location.first)
  end

  def self.order_by_location_name
    joins(:location).order("locations.name")
  end

  def self.with_employees
    joins(:employees).distinct
  end

  def self.with_local_coworkers
    includes(location: :people).references(:location).where("people_locations.id <> people.id").distinct
  end
end
