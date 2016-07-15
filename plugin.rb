# name: discourse-aws-cn
# about: Support aws cn in discourse
# version: 0.1
# authors: Ming
# url: https://github.com/ming-relax/discourse-aws-cn

after_initialize do
  class ::S3RegionSiteSetting
    def self.valid_values
      [ 'us-east-1',
        'us-west-1',
        'us-west-2',
        'us-gov-west-1',
        'eu-west-1',
        'eu-central-1',
        'ap-southeast-1',
        'ap-southeast-2',
        'ap-northeast-1',
        'ap-northeast-2',
        'sa-east-1',
        'cn-north-1'
      ]
    end
  end

  module ::FileStore
    class S3Store
      def absolute_base_url
        # cf. http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region
        @absolute_base_url ||= if SiteSetting.s3_region == "us-east-1"
          "//#{s3_bucket}.s3.amazonaws.com"
        elsif SiteSetting.s3_region == 'cn-north-1'
          "//#{s3_bucket}.s3.cn-north-1.amazonaws.com.cn"
        else
          "//#{s3_bucket}.s3-#{SiteSetting.s3_region}.amazonaws.com"
        end
      end
    end
  end
end
