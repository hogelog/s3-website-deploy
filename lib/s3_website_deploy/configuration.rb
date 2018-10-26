module S3WebsiteDeploy
  class Configuration
    attr_reader :source, :region, :bucket, :prefix, :dryrun

    def initialize(source:, region:, bucket:, prefix:, dryrun:)
      @source = source
      @region = region
      @bucket = bucket
      @prefix = prefix
      @dryrun = dryrun
    end
  end
end
