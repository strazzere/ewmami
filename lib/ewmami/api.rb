module Ewmami
  class API

    include Ewmami::Protocol

    # Active as of 11/5/12
    SERVICE_URL        = 'https://safebrowsing.google.com/safebrowsing/clientreport/download'
    # Not active as of 11/5/12
    STATS_URL          = 'https://safebrowsing.google.com/safebrowsing/clientreport/download-stat'

    DEFAULT_LOCALE     = "en_US"

    CONTENT_TYPE_KEY   = "Content-Type"
    CONTENT_TYPE_VALUE = "application/x-protobuffer"
    USER_AGENT_KEY     = "User-Agent"
    USER_AGENT_VALUE   = "Android-Finsky/3.9.17 (versionCode=8015017,sdk=17,device=maguro,hardware=tuna,product=takju)"

    class ArgumentError < RuntimeError; end
    class ResponseError < RuntimeError; end

    def initialize(options={})
      @options = options
      if(@options[:proxy].nil?)
        @options[:proxy] = {}
      end
    end

    def verify_file(file=nil)
      return verify_sha256(Digest::SHA256.file(file).hexdigest)
    end

    def verify_sha256(sha256=nil)
      return verify_app("", 1, "", 0, hex_to_string(sha256))
    end

    # Method to verify applications when the locale and AndroidId have been
    # passed in via the options object through init. Also sets the downloadType
    # to '2'
    def verify_app(packageName=nil, versionCode=nil, url="", length=nil, sha256=nil)
      return full_verify_app(packageName, versionCode, url, length, sha256, @options[:locale], @options[:androidId].to_i, 2)
    end

    # All of these should be filled in to look like a legit request
    #
    # packageName
    # verisonCode
    # url (required)
    # downloadType = 2
    # length (long)
    # digests sha256
    # locale
    # androidId (long, required)
    def full_verify_app(packageName=nil, versionCode=nil, url="", length=nil, sha256=nil, locale=nil, androidId=nil, downloadType=2)
      request = Ewmami::Protocol::ClientDownloadRequest.new
      request.apkInfo = Ewmami::Protocol::ClientDownloadRequest::ApkInfo.new
      if(packageName.nil?)
        packageName = ""
      end
      request.apkInfo.packageName = packageName

      if(versionCode.nil?)
        versionCode = 1
      end
      request.apkInfo.versionCode = versionCode

      request.digests = Ewmami::Protocol::ClientDownloadRequest::Digests.new
      if(sha256.nil?)
        raise ArgumentError.new 'Unable to perform a request without a sha256!'
      end
      request.digests.sha256 = sha256

      if(url.nil?)
        url = ""
      end
      request.url = url

      if(length.nil?)
        length = 0
      end
      request.length = length

      if(locale.nil?)
        locale = DEFAULT_LOCALE
      end
      request.locale = locale

      if(downloadType.nil?)
        downloadType = 2
      end
      request.downloadType = downloadType

      if(downloadType.nil?)
        downloadType = 2
      end
      request.androidId = androidId

      result = parse(send(request.serialize_to_string))

      return result
    end

    private

    def hex_to_string(data=nil)
      if(data.nil?)
        raise ArgumentError.new 'Unable to convert a nil object!'
      end

      array = []
      array << data

      return array.pack("H*")
    end

    def parse(data=nil)
      if(data.nil?)
        raise ArgumentError.new 'Unable to parse a nil object!'
      end

      return Ewmami::Protocol::ClientDownloadResponse.new.parse_from_string data
    end

    def send(data=nil)
      if(data.nil?)
        raise ArgumentError.new 'Unable to send an empty request!'
      end

      url = URI.parse(SERVICE_URL)
      http = Net::HTTP.new(url.host,
                           url.port,
                           @options[:proxy][:proxy_address],
                           @options[:proxy][:proxy_port],
                           @options[:proxy][:proxy_login],
                           @options[:proxy][:proxy_password])

      # Avoid weird proxy issues
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      post_body = []
      post_body << data

      request = Net::HTTP::Post.new(url.request_uri)
      request.body = post_body.join
      request[CONTENT_TYPE_KEY] = CONTENT_TYPE_VALUE
      request[USER_AGENT_KEY] = USER_AGENT_VALUE

      response = http.request(request)

      return response.body if response.is_a?(Net::HTTPSuccess)
      raise ResponseError.new 'Something went wrong, expected a Net::HTTPSuccess object but got ' + response.class.to_s
    end
  end
end

