module Ewmami
  module Protocol

    class ClientDownloadRequest < ::Protobuf::Message
      class ApkInfo < ::Protobuf::Message
        optional :string, :packageName, 1
        optional :int32, :versionCode, 2
      end

      class CertificateChain < ::Protobuf::Message
        class Element < ::Protobuf::Message
          optional :bytes, :certificate, 1
          optional :bool, :parsedSuccessfully, 2
          optional :bytes, :subject, 3
          optional :bytes, :issuer, 4
          optional :bytes, :fingerprint, 5
          optional :int64, :expiryTime, 6
          optional :int64, :startTime, 7
        end
        repeated :Element, :element, 1
      end

      class Digests < ::Protobuf::Message
        optional :bytes, :sha256, 1
        optional :bytes, :sha1, 2
        optional :bytes, :md5, 3
      end

      class Resource < ::Protobuf::Message
        optional :string, :url, 1
        optional :int32, :type, 2
        optional :bytes, :remoteIp, 3
        optional :string, :referrer, 4
      end

      class SignatureInfo < ::Protobuf::Message
        repeated :CertificateChain, :certificateChain, 1
        optional :bool, :trusted, 2
      end

      optional :string, :url, 1
      optional :Digests, :digests, 2
      optional :int64, :length, 3
      repeated :Resource, :resources, 4
      optional :SignatureInfo, :signature, 5
      optional :bool, :userInitiated, 6

      repeated :string, :clientAsn, 8
      optional :string, :fileBasename, 9
      optional :int32, :downloadType, 10
      optional :string, :locale, 11
      optional :ApkInfo, :apkInfo, 12
      optional :int64, :androidId, 13
    end

    class ClientDownloadResponse < ::Protobuf::Message
      class MoreInfo < ::Protobuf::Message
        optional :string, :description, 1
        optional :string, :url, 2
      end

      # Probably an enum I missed
      class Verdict < ::Protobuf::Enum
        define :OK, 0
        define :MORE_INFO_1, 1
        define :MORE_INFO_2, 2
      end
      optional Verdict, :verdict, 1
      optional :MoreInfo, :moreInfo, 2
      optional :bytes, :token, 3
    end

    class ClientDownloadStatsRequest < ::Protobuf::Message
      optional :int32, :userDecision, 1
      optional :bytes, :token, 2
    end
  end
end
