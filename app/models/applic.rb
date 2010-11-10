class Applic < ActiveRecord::Base
  belongs_to :job
  belongs_to :user
  has_one  :resume,      :class_name => 'Document', :conditions => {:document_type => Document::Types::Resume}
  has_one  :transcript,  :class_name => 'Document', :conditions => {:document_type => Document::Types::Transcript}
end
