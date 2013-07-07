require 'yatvdb/version'

# Yet Another TheTVDB.com API client.
module YATVDB
  require 'yatvdb/config'
  include Config

  require 'yatvdb/fetch'
  include Fetch

  require 'yatvdb/find'
  include Find

  extend self
end
