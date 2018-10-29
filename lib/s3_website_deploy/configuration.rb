module S3WebsiteDeploy
  class Configuration
    attr_reader :source, :region, :bucket, :prefix, :cache_policy, :dryrun

    def initialize(source:, region:, bucket:, prefix:, cache_policy:, dryrun:)
      @source = source
      @region = region
      @bucket = bucket
      @prefix = prefix
      @cache_policy = S3WebsiteDeploy::CachePolicy.new(cache_policy)
      @dryrun = dryrun
    end
  end
end
