module S3WebsiteDeploy
  class CachePolicy
    attr_reader :config, :policies

    class Policy
      attr_reader :pattern, :regexp, :value

      def initialize(pattern, value)
        @pattern = pattern
        @regexp = Regexp.compile("\\A#{ Regexp.escape(pattern).gsub("\\*", ".*") }\\z")
        @value = value
      end

      def match?(path)
        regexp.match?(path)
      end
    end

    def initialize(config)
      @policies = config.map {|pattern, value| Policy.new(pattern, value) }
    end

    def cache_control(path)
      policy = @policies.find{|policy| policy.match?(path) }
      return unless policy
      policy.value["cache_control"]
    end
  end
end
