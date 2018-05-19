require "optparse"

module S3WebsiteDeploy
  class CLI
    def self.run(argv)
      opts = ARGV.getopts("", "source:.", "bucket:", "prefix:")
      source = opts["source"] or raise ArgumentError, "--source is required"
      bucket = opts["bucket"] or raise ArgumentError, "--bucket is required"
      prefix = opts["prefix"] || ""
      S3WebsiteDeploy::Client.new(source: source, bucket: bucket, prefix: prefix).run
    end
  end
end
