module YATVDB
  module Configuration
    def config
      @config ||= load_config
    end

    # Loads a config, if it can find one, from the config_paths
    def load_config
      config = { 'yatvdb' => { 'cache' => '~/.yatvdb' } }
      config_paths.each do |f|
        path = Pathname.new(f).expand_path
        config.update(YAML.load(path.read) || {}) if path.exist?
      end
      config
    end

    def config_paths
      @config_paths ||= %w[
        /etc/yatvdb.conf
        /usr/local/etc/yatvdb.conf
        ~/.yatvdb/config
      ]
    end
  end
end
