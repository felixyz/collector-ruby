module Collector

  class BaseModel

    class << self
      def attributes(*args)
        @attributes ||= []
        @attributes += args
        args.each{|attr| attr_accessor attr }
      end

      alias_method :attribute, :attributes
    end

    def attributes
      self.class.instance_variable_get("@attributes")
    end

    def initialize(hash = {})
      attributes.each do |attr|
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

  end

end