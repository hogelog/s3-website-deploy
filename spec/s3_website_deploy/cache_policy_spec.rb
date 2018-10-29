RSpec.describe S3WebsiteDeploy::CachePolicy do
  describe S3WebsiteDeploy::CachePolicy::Policy do
    describe "#match?" do
      def policy(pattern)
        S3WebsiteDeploy::CachePolicy::Policy.new(pattern, { "cache_control" => "max-age=600" })
      end

      context "with exact pattern" do
        it "matches exact only pattern" do
          expect(policy("index.html")).to be_match("index.html")
          expect(policy("index.html")).not_to be_match("foobar/index.html")
        end
      end

      context "with wildcard patterns" do
        let(:pattern) { "*.html" }

        it "matches exact only pattern" do
          expect(policy("*.html")).to be_match("index.html")
          expect(policy("*.html")).to be_match("foobar/index.html")
          expect(policy("*.html")).to be_match("other.html")
          expect(policy("*.html")).to be_match("other.html")
          expect(policy("*.html")).not_to be_match("other.css")
          expect(policy("123*45*6789*")).to be_match("123456789")
          expect(policy("123*45*6789*")).to be_match("123xxx45x6789xxxx")
          expect(policy("123*45*6789")).not_to be_match("123xxx45x6789xxxx")
        end
      end
    end
  end

  describe "#value" do
    let(:config) { { "*.html" => { "cache_control" => "max-age=600" } } }
    let(:cache_policy) { S3WebsiteDeploy::CachePolicy.new(config) }

    it "returns cache-policy value" do
      expect(cache_policy.cache_control("index.html")).to eq("max-age=600")
      expect(cache_policy.cache_control("app.css")).to eq(nil)
    end
  end
end
