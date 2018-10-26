require "optparse"
require "yaml"

module S3WebsiteDeploy
  class CLI
    def self.run(argv)
      config = parse_argv(argv)
      S3WebsiteDeploy::Client.new(config).run
    end

    def self.parse_argv(argv)
      opts = {}
      parser = OptionParser.new
      parser.on("-c [CONFIG]", "--config", "config YAML") {|v| opts["config"] = v }
      parser.on("-s [SOURCE]", "--source", "source directory") {|v| opts["source"] = v }
      parser.on("-r [REGION]", "--region", "target region") {|v| opts["region"] = v }
      parser.on("-b [BUCKET]", "--bucket", "target bucket") {|v| opts["bucket"] = v }
      parser.on("-p [PREFIX]", "--prefix", "target prefix") {|v| opts["prefix"] = v }
      parser.on("-n", "--dry-run", "dry run") {|v| opts["dryrun"] = v }
      parser.parse(argv)

      file_opts = opts["config"] ? YAML.load_file(opts["config"]) : {}
      source = (opts["source"] || file_opts["source"]) or raise ArgumentError, "--source is required"
      region = (opts["region"] || file_opts["region"] || ENV["AWS_DEFAULT_REGION"]) or raise ArgumentError, "--region is required"
      bucket = (opts["bucket"] || file_opts["bucket"]) or raise ArgumentError, "--bucket is required"
      prefix = opts["prefix"] || file_opts["prefix"] || ""
      dryrun = opts["dryrun"]

      S3WebsiteDeploy::Configuration.new(source: source, region: region, bucket: bucket, prefix: prefix, dryrun: dryrun)
    end
  end
end
