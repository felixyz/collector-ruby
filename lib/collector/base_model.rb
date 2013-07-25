module Collector

  class BaseModel
    @swallow_unsupported_attributes = false

    class << self
      def attributes(*args)
        @attributes ||= []
        @attributes += args
        args.each{|attr| attr_accessor attr }
      end
      def attributes_opt(*args)
        @attributes_opt ||= []
        @attributes_opt += args
        args.each{|attr| attr_accessor attr }
      end

      alias_method :attribute, :attributes
      alias_method :attribute_opt, :attributes_opt

      def swallow_unsupported_attributes
        @swallow_unsupported_attributes = true
      end

      def swallow_unsupported_attributes?
        @swallow_unsupported_attributes
      end
    end

    def attributes
      self.class.instance_variable_get("@attributes") || []
    end

    def attributes_opt
      self.class.instance_variable_get("@attributes_opt") || []
    end

    def all_attributes
      attributes + attributes_opt
    end

    def validate_input(hash)
      unsupported_keys = hash.keys.map(&:to_sym) - all_attributes
      unless unsupported_keys.empty?
        raise ArgumentError.new("Unsupported attribute(s): #{unsupported_keys}")
      end
    end

    def initialize(hash = {})
      validate_input(hash) unless self.class.swallow_unsupported_attributes?
      all_attributes.each do |attr|
        val = hash[attr] || hash[attr.to_s]
        self.send("#{attr}=", val)
      end
    end

    def ==(other)
      self.class.attributes.each do |attr|
        return false if self.send(attr) != other.send(attr)
      end
      true
    end

    def has_required_attributes?
      missing_attributes.empty?
    end

    def missing_attributes
      own_missing + nested_missing
    end

    def own_missing
      attributes.select{|attr| send(attr).nil? }
    end

    def nested_missing
      missing = []
      all_attributes.each do |attr|
        val = send(attr)
        if !!val
          if val.kind_of? BaseModel
            nested_missing = val.missing_attributes
            missing << {attr => nested_missing} unless nested_missing.empty?
          elsif val.kind_of? Array
            val.each_with_index do |nested_val, index|
              if nested_val.kind_of? BaseModel
                nested_missing = nested_val.missing_attributes
                missing << {"#{attr}[#{index}]" => nested_missing} unless nested_missing.empty?
              end
            end
          end
        end
      end
      missing
    end

    def missing_attributes_human_readable(prefix = "", missing_attr = nil)
      missing_attr = missing_attributes if missing_attr.nil?
      missing_key_paths = missing_attr.map.each_with_index do |item|
        if item.kind_of? Hash
          key = item.keys.first
          missing_attributes_human_readable(prefix + "#{key}.", item[key])
        else
          "#{prefix}#{item}"
        end
      end
      if prefix.empty?
        "Missing attributes: " + missing_key_paths.flatten.join(", ")
      else
        missing_key_paths
      end
    end

  end

end