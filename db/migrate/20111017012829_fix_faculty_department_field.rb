class FixFacultyDepartmentField < ActiveRecord::Migration

  # Faculty.department was a string.
  # Make it a foreign key to Department.

  def self.up
    depts = Faculty.all.collect {|f| [f.id, f.department]}
    remove_column :faculties, :department
    add_column :faculties, :department_id, :integer

    Faculty.reset_column_information
    depts.each do |f_id, dept_name|
      Faculty.find(f_id).update_attribute(:department, Department.find_or_create_by(name: dept_name)) || raise("Unable to reset department for faculty ##{f_id}")
    end
  end

  def self.down
    depts = Faculty.all.collect {|f| [f.id, f.department.name]}
    remove_column :faculties, :department_id
    add_column :faculties, :department, :string

    Faculty.reset_column_information
    depts.each do |f_id, dept_name|
      Faculty.find(f_id).update_attribute(:department, dept_name) || raise("Unable to reset department for faculty ##{f_id}")
    end
  end
end
