module Rails

  class << self
    # Test environments like Rails.test?
    [:development, :production, :test].each do |e|
      define_method "#{e.to_s}?" do
        Rails.env == e.to_s
      end
    end

  end

end
RAILS_ENV='development'
