require "stringio"

RSpec.describe S3WebsiteDeploy::Client do
  def local_file(*args)
    S3WebsiteDeploy::Client::LocalFile.new(*args)
  end

  def s3_file(*args)
    S3WebsiteDeploy::Client::S3File.new(*args)
  end

  describe "#run" do
    let(:log) { StringIO.new }
    let(:config) { S3WebsiteDeploy::Configuration.new(source: "build/", region: "ap-northeast-1", bucket: "some-bucket", prefix: "", dryrun: false) }
    let(:client) { S3WebsiteDeploy::Client.new(config, logger: Logger.new(log)) }
    let(:file_stats) do
      {
        "create.html": { local: local_file("create.html", "build/create.html", "xxxx") },
        "skip.html": { local: local_file("skip.html", "build/skip.html", "xxxx"), remote: s3_file("skip.html", "xxxx") },
        "update.html": { local: local_file("update.html", "build/update.html", "xxxx"), remote: s3_file("update.html", "yyyy") },
        "delete.html": { remote: s3_file("delete.html", "xxxx") },
      }
    end
    before do
      allow(client).to receive(:fetch_file_stats).and_return(file_stats)
      allow(client).to receive(:deploy_local_file)
      allow(client).to receive(:delete_remote_file)
    end

    it "deploy files" do
      client.run
      expect(log.string).to match(/Creating: create.html/)
      expect(log.string).to match(/Skip: skip.html/)
      expect(log.string).to match(/Updating: update.html/)
      expect(log.string).to match(/Deleting: delete.html/)
    end
  end

  describe "#source_files" do
    let(:log) { StringIO.new }
    let(:config) { S3WebsiteDeploy::Configuration.new(source: "spec/dummy", region: "ap-northeast-1", bucket: "some-bucket", prefix: "", dryrun: false) }
    let(:client) { S3WebsiteDeploy::Client.new(config, logger: Logger.new(log)) }
    it "list files" do
      expect(client.source_files.map(&:path)).to match_array(%w(deploy.yml favicon.ico index.html dir/dir/hello.txt))
    end
  end
end
