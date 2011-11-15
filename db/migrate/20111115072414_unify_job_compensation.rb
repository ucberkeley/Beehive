class UnifyJobCompensation < ActiveRecord::Migration
  def self.up
    change_column :jobs, :compensation, :integer, :null => :false, :default => Job::Compensation::None

    Job.all.each do |job|
      c = case
      when (job.paid? and job.credit?)
        Job::Compensation::Both
      when job.paid?
        Job::Compensation::Pay
      when job.credit?
        Job::Compensation::Credit
      else
        Job::Compensation::None
      end
      job.update_attribute :compensation, c
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

    change_column :jobs, :compensation, :string
  end
end
