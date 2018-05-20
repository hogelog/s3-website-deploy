require "logger"
require "pathname"

require "aws-sdk-s3"

module S3WebsiteDeploy
  class Client
    LocalFile = Struct.new(:path, :local_path)
    S3File = Struct.new(:path, :s3_uri)

    def initialize(source:, region:, bucket:, prefix:, logger: Logger.new(STDOUT))
      @source = Pathname.new(source)
      @region = region
      @bucket = bucket
      @prefix = prefix
      @logger = logger
    end

    def run
      @logger.info("Start deploying #{@source} -> s3://#{@bucket}/#{@prefix}")
      file_stats = fetch_file_stats
      deploy(file_stats)
      @logger.info("Finish deploying #{@source} -> s3://#{@bucket}/#{@prefix}")
    end

    def fetch_file_stats
      stats = {}
      source_files.each do |file|
        stats[file.path] = { local: file }
      end
      remote_files.each do |file|
        stats[file.path] ||= { }
        stats[file.path][:remote] = file
      end
      stats
    end

    def deploy(file_stats)
      file_stats.each do |path, stat|
        if stat[:local]
          deploy_local_file(stat[:local])
        end
      end
    end

    def deploy_local_file(local_file)
      key = "#{@prefix}#{local_file.path}"
      @logger.info("Create: #{local_file.local_path} -> s3://#{@bucket}/#{key}")
      File.open(local_file.local_path, "rb") do |file|
        s3.put_object(
          body: file,
          bucket: @bucket,
          key: key,
        )
      end
    end

    def source_files
      Pathname.glob(@source.join("**")).map do |pathname|
        LocalFile.new(pathname.relative_path_from(@source).to_s, pathname.to_s)
      end
    end

    def remote_files
      files = []
      prefix_pathname = Pathname.new(@prefix)
      next_token = nil
      loop do
        res = s3.list_objects_v2(
          bucket: @bucket,
          prefix: @prefix,
          continuation_token: next_token,
        )
        res.contents.each do |content|
          pathname = Pathname.new(content.key)
          uri = "s3://#{@bucket}/#{content.key}"
          files << S3File.new(pathname.relative_path_from(prefix_pathname).to_s, uri)
        end
        next_token = res.next_continuation_token
        break unless next_token
      end
      files
    end

    private

    def s3
      @s3 ||= Aws::S3::Client.new(region: @region)
    end
  end
end
