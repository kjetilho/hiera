class Hiera
  module Backend
    class Json_backend
      def initialize(cache=nil)
        require 'json'
        Hiera.debug("Hiera JSON backend starting")

        @cache = cache || Filecache.new
      end

      def lookup_source(source, key, scope)
        answer = nil

        jsonfile = Backend.datafile(:json, scope, source, "json") || return

        Hiera.debug("Looking for #{key} in JSON data source #{source}")

        data = @cache.read_file(jsonfile, Hash) do |data|
          JSON.parse(data)
        end

        if not data.empty? and data.include?(key)
          # Extra logging that we found the key. This can be outputted
          # multiple times if the resolution type is array or hash but that
          # should be expected as the logging will then tell the user ALL the
          # places where the key is found.
          Hiera.debug("Found #{key} in #{source}")
          answer = Backend.parse_answer(data[key], scope)
        end

        return answer

      end
    end
  end
end
