require "optparse"

module S3WebsiteDeploy
  class CLI
    def self.run(argv)
      opts = ARGV.getopts("", "source:.", "region:", "bucket:", "prefix:")
      source = opts["source"] or raise ArgumentError, "--source is required"
      region = opts["region"] or raise ArgumentError, "--region is required"
      bucket = opts["bucket"] or raise ArgumentError, "--bucket is required"
      prefix = opts["prefix"] || ""
      config = S3WebsiteDeploy::Configuration.new(source: source, region: region, bucket: bucket, prefix: prefix)
      S3WebsiteDeploy::Client.new(config).run
    end
  end
end
