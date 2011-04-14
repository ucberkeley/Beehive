# This simulates loading the what_column plugin, but without relying on
# vendor/plugins (unashamedly stolen from how shoulda does this)

what_column_path = File.join(File.dirname(__FILE__), *%w(.. .. .. ..))
what_column_lib_path = File.join(what_column_path, "lib")

$LOAD_PATH.unshift(what_column_lib_path)
load File.join(what_column_path, "init.rb")
