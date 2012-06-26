require 'digest/md5'
module UuyoooTicket
  @raw_ticket_configuration = {}
  @ticket_configuration = {}
  class << self
    def load_configuration(ticket_config_file)
      if File.exist?(ticket_config_file)
        @raw_ticket_configuration = YAML.load(File.read(ticket_config_file))
        if defined? RAILS_ENV
          @raw_ticket_configuration = @raw_ticket_configuration[RAILS_ENV]
        end

        apply_configuration(@raw_ticket_configuration)
      end
    end

    def apply_configuration(config)
      @ticket_configuration = config
    end

    def generate_url(method,pasted)
      @ticket_configuration['apis'][method.to_s] +  url_params(pasted)
    end

    def get_with(method,joined_params = {})
       @method = method
       pra = pasted_params.reverse_merge!(joined_params).stringify_keys
       generate_url(method,pra)
       parse_result(RestClient.get(generate_url(method,pra),:content_type => 'text/html; charset=UTF-8'))
    end

    def post_with(method,joined_params = {})
       pra = pasted_params.reverse_merge!(joined_params).stringify_keys
       parse_result RestClient.post(generate_url(method,pra),:content_type => 'text/html; charset=UTF-8' )
    end

    #支持中文
    def url_encode(str)
      return str.to_s.gsub(/[^a-zA-Z0-9_\-.]/n){ sprintf("%%%02X", $&.unpack("C")[0]) }
    end

    #按ASC正排序生成sign才能在prod上显示
    def url_params(pasted)
      #pasted_sort = pasted.sort{|a,b|a.to_s <=> b.to_s}
      total_params = pasted.to_a.collect{|key,value| key.to_s+"="+url_encode(value.to_s)} + ["md5Info=#{generate_md5info(pasted)}"]
      total_params.join("&")
    end

    def pasted_params
      { :businessId => @ticket_configuration['businessId'] }
    end

    def generate_md5info(pasted)
      pasted_str = String.new
      @ticket_configuration["md5infokeys"][@method].each do |item|
        pasted_str << pasted["#{item}"] if pasted.has_key?(item)
      end
       pasted_str << @ticket_configuration['key']
       Digest::MD5.hexdigest(pasted_str).upcase
    end

    def timestamp
      Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end

    def parse_result(result)
      case @ticket_configuration['format']
      when 'xml'
        Crack::XML.parse(result) || Crack::XML.parse(result)['error_rsp']
      when 'json'
        Crack::JSON.parse(result)
      end
    end
  end
end
