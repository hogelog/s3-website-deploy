require "logger"

module S3WebsiteDeploy
  class Client
    def initialize(source:, bucket:, prefix:, logger: Logger.new(STDOUT))
      @source = source
      @bucket = bucket
      @prefix = prefix
      @logger = logger
    end

    def run
      @logger.info("Start deploying #{@source} -> s3://#{@bucket}/#{@prefix}")
      @logger.info("Finish deploying #{@source} -> s3://#{@bucket}/#{@prefix}")
    end
  end
end
