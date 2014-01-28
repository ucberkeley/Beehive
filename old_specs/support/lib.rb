##
# Takes a range and yields pairs of [value, valid?]
#
# @param r [Range] range to test
#
# @example
#   test_range(10..20) do |value, valid|
#     MyModel.new(:value => value).valid?.should == valid
#   end
#
# Yields:
#   [9, false]
#   [10, true]
#   [19, true]
#   [20, false]
#
#
def test_range(r)
  yield [r.min-1, false]
  yield [r.min,   true]
  yield [r.max,   true]
  yield [r.max+1, false]
end
