require "stringio"

RSpec.describe S3WebsiteDeploy::CLI do
  describe ".parse_argv" do
    let(:argv) do
      [
        "--source", "build/",
        "--region", "ap-northeast-1",
        "--bucket", "bucket1",
        "--prefix", "dummy/",
        "--cache-policy", %({ "*.html": { "cache_control": "max-age=600" } })
      ]
    end

    it "parses cmdline" do
      config = S3WebsiteDeploy::CLI.parse_argv(argv)
      expect(config.source).to eq("build/")
      expect(config.region).to eq("ap-northeast-1")
      expect(config.bucket).to eq("bucket1")
      expect(config.prefix).to eq("dummy/")
      expect(config.cache_policy.cache_control("index.html")).to eq("max-age=600")
    end

    describe "with config file" do
      let(:argv) { %w(--config spec/dummy/deploy.yml) }

      it "parses config file" do
        config = S3WebsiteDeploy::CLI.parse_argv(argv)
        expect(config.source).to eq(".")
        expect(config.region).to eq("us-east-1")
        expect(config.bucket).to eq("some-bucket")
        expect(config.prefix).to eq("production/")
        expect(config.cache_policy.cache_control("index.html")).to eq("max-age=600")
      end
    end
  end
end
