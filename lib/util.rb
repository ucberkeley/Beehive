class String

  # @param n [Integer] number to pluralize for
  # @return [String] +self+, pluralized for +n+
  # @example
  #   'user'.pluralize_for(1)
  #    => user
  #   'user'.pluralize_for(2)
  #    => users
  #
  def pluralize_for(n=2)
    n == 1 ? self : self.pluralize
  end

end
