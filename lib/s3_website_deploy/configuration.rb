module S3WebsiteDeploy
  class Configuration
    attr_reader :source, :region, :bucket, :prefix

    def initialize(source:, region:, bucket:, prefix:)
      @source = source
      @region = region
      @bucket = bucket
      @prefix = prefix
    end
  end
end
