require "logger"
require "pathname"

require "aws-sdk-s3"

module S3WebsiteDeploy
  class Client
    CONTENT_MD5_KEY = "content-md5"

    LocalFile = Struct.new(:path, :local_path, :content_md5)
    S3File = Struct.new(:path, :etag)

    def initialize(config, logger: Logger.new(STDOUT))
      @config = config
      @logger = logger
    end

    def run
      @logger.info("---- DRY RUN ----") if @config.dryrun
      @logger.info("Start deploying #{@config.source} -> s3://#{@config.bucket}/#{@config.prefix}")
      file_stats = fetch_file_stats
      deploy(file_stats)
      @logger.info("Finish deploying #{@config.source} -> s3://#{@config.bucket}/#{@config.prefix}")
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
        local_file = stat[:local]
        remote_file = stat[:remote]
        if local_file
          if !remote_file
            @logger.info("Creating: #{local_file.path}")
            deploy_local_file(local_file)
          elsif local_file.content_md5 != remote_file.etag
            @logger.info("Updating: #{local_file.path}")
            deploy_local_file(local_file)
          else
            @logger.info("Skip: #{local_file.path}")
          end
        elsif remote_file
          @logger.info("Deleting: #{remote_file.path}")
          delete_remote_file(remote_file)
        end
      end
    end

    def deploy_local_file(local_file)
      return if @config.dryrun
      key = "#{@config.prefix}#{local_file.path}"
      File.open(local_file.local_path, "rb") do |file|
        s3.put_object(
          body: file,
          bucket: @config.bucket,
          key: key,
        )
      end
    end

    def delete_remote_file(remote_file)
      return if @config.dryrun
      key = "#{@config.prefix}#{remote_file.path}"
      s3.delete_object(
        bucket: @config.bucket,
        key: key,
      )
    end

    def source_files
      source_directory = Pathname.new(@config.source)
      files = []
      Pathname.glob(source_directory.join("**", "*").to_s).map do |pathname|
        next if pathname.directory?
        path = pathname.to_s
        content_md5 = Digest::MD5.hexdigest(File.binread(path))
        files << LocalFile.new(pathname.relative_path_from(source_directory).to_s, path, content_md5)
      end
      files
    end

    def remote_files
      files = []
      prefix_pathname = Pathname.new(@config.prefix)
      next_token = nil
      loop do
        res = s3.list_objects_v2(
          bucket: @config.bucket,
          prefix: @config.prefix,
          continuation_token: next_token,
        )
        res.contents.each do |content|
          pathname = Pathname.new(content.key)
          files << S3File.new(pathname.relative_path_from(prefix_pathname).to_s, JSON.parse(content.etag))
        end
        next_token = res.next_continuation_token
        break unless next_token
      end
      files
    end

    private

    def s3
      @s3 ||= Aws::S3::Client.new(region: @config.region)
    end
  end
end
