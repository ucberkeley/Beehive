class Applic < ActiveRecord::Base
  belongs_to :job
  belongs_to :user
  belongs_to :resume,      :class_name => 'Document', :conditions => {:document_type => Document::Types::Resume}
  belongs_to :transcript,  :class_name => 'Document', :conditions => {:document_type => Document::Types::Transcript}
  
  validates_presence_of   :message
  validates_length_of     :message, :minimum => 1, :too_short => "Please enter a message to the faculty sponsor of this job." 

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

end
