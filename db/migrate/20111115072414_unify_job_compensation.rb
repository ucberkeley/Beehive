class UnifyJobCompensation < ActiveRecord::Migration
  def self.up
    remove_column :jobs, :compensation
    add_column :jobs, :compensation, :integer, :null => :false, :default => Job::Compensation::None

    Job.all.each do |job|
      p = job.read_attribute :paid
      c = job.read_attribute :credit
      comp = case
      when (p and c)
        Job::Compensation::Both
      when p
        Job::Compensation::Pay
      when c
        Job::Compensation::Credit
      else
        Job::Compensation::None
      end
      job.update_attribute :compensation, comp
    end

    remove_column :jobs, :paid
    remove_column :jobs, :credit
  end

  def self.down
    add_column :jobs, :paid, :boolean
    add_column :jobs, :credit, :boolean

    Job.reset_column_information
    Job.all.each do |job|
      p = (job.compensation & Job::Compensation::Pay    != 0)
      c = (job.compensation & Job::Compensation::Credit != 0)
      job.update_attributes :paid => p, :credit => c
    end

    remove_column :jobs, :compensation
    add_column :jobs, :compensation, :string
  end
end
