# == Schema Information
#
# Table name: applics
#
#  id            :integer          not null, primary key
#  job_id        :integer
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#  message       :text
#  resume_id     :integer
#  transcript_id :integer
#  status        :string(255)      default("undecided")
#  applied       :boolean
#

class Applic < ActiveRecord::Base


  belongs_to :job
  belongs_to :user
  validates_presence_of   :message
  validates_length_of     :message, :minimum => 1, :too_short => 'Please enter a message to the faculty sponsor of this listing.'
  validates_length_of     :message, :maximum => 65536, :too_long => 'Please enter a message to the faculty sponsor of this listing that is shorter than 65536 characters.'

  # Uniq'd list of emails of all [sponsors, poster] who want to receive notifications for this applic
  def subscriber_emails
    # TODO: for now, just email the poster
    job.user.email

    # TODO: add preferences to these people
    # TODO: condense faculty -> users
##    emales = job.faculties.collect(&:email)
##    emales << user.email
##    emales
  end

  def unread?
    return false
  end

end
