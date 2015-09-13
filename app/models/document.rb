# == Schema Information
#
# Table name: documents
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  document_type :integer
#  size          :integer
#  content_type  :string(255)
#  filename      :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Document < ActiveRecord::Base

  belongs_to :user
  class Types
    Generic    = 0
    Resume     = 1
    Transcript = 2
  end
  has_attachment(:content_type => ['application/pdf', 'application/msword', 'text/plain'],
                 :max_size     => 1.megabyte,
                 :storage      => :file_system,
                 :path_prefix  => 'files')
  validates_as_attachment
  validates_inclusion_of :document_type, :in => [Types::Generic, Types::Resume, Types::Transcript]
  before_validation :set_document_type

  def self.type_string(type)
    case
    when type.is_a?(Integer)
      ["Document", "Resume", "Transcript"][type]
    when type.is_a?(Symbol)
      self.type_string({:document=>Document::Types::Generic, :resume=>Document::Types::Resume, :transcript=>Document::Types::Transcript}[type])
    else
      nil
    end
  end

  def type_string
    Document.type_string(document_type)
  end

  def set_document_type(t=self.document_type)
    values   = [Types::Generic, Types::Resume, Types::Transcript,
                "generic",      "resume",      "transcript"
               ]
    doctypes = [Types::Generic, Types::Resume, Types::Transcript,
                Types::Generic, Types::Resume, Types::Transcript
               ]
    self.document_type = find_and_choose(values, doctypes, t, Types::Generic)
  end
end

