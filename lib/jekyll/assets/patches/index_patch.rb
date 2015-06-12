# 3rd-party
require "sprockets"

module Jekyll
  module Assets
    module Patches
      module IndexPatch
        def self.included(base)
          base.class_eval do
            alias_method :__orig_find_asset, :find_asset
            alias_method :find_asset, :__wrap_find_asset
          end
        end

        def __wrap_find_asset(path, options = {})
          __orig_find_asset(path, options).tap do |asset|
            if asset
              asset.instance_variable_set :@site, @environment.site
              # Avoid removing assets by Jekyll:Cleaner
              @environment.site.keep_files << asset.destination(@environment.site.dest)
            end
          end
        end
      end
    end
  end
end

Sprockets::Index.send :include, Jekyll::Assets::Patches::IndexPatch
