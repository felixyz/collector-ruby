require 'savon'
require 'active_support/core_ext'

module Collector

  CollectorUrl = 'https://eCommerceTest.collector.se/v3.0/InvoiceServiceV31.svc?wsdl'
  ServiceName =  :InvoiceServiceV31
  PortName =     :BasicHttpBinding_IInvoiceServiceV31
  class InvoiceNotFoundError < RuntimeError ; end
  class InvalidInvoiceStatusError < RuntimeError ; end

  class Client
    def initialize(user_name, password)
      @header = {"ClientIpAddress" => "?",
                      "Username" => user_name,
                      "Password" => password }
      @savon = Savon.new(CollectorUrl)
    end

    def operation_with_name(operation_name)
      @savon.operation(ServiceName, PortName, operation_name).tap do |operation|
        operation.header = @header
      end
    end

    def raise_error(response_hash)
      fault = response_hash[:fault]
      err_class = RuntimeError
      case fault[:faultcode]
      when "s:INVOICE_NOT_FOUND"
        err_class = InvoiceNotFoundError
      when "s:INVALID_INVOICE_STATUS"
        err_class = InvalidInvoiceStatusError
      end
      raise err_class.send(:new, fault[:faultstring])
    end

    def add_invoice(invoice_request)
      unless invoice_request.has_required_attributes?
        raise ArgumentError.new(invoice_request.missing_attributes_human_readable)
      end
      operation = operation_with_name :AddInvoice
      operation.body = InvoiceRequestRepresenter.new(invoice_request).to_hash
      response = operation.call.body
      # TODO: Exception class, and proper information extraction
      if !response[:fault].nil?
        raise response[:fault].to_s
      end
      namespace = response.keys.first
      add_invoice_resp = InvoiceResponse.new(response[namespace])
      add_invoice_resp
    end

    def get_address(options)
      raise ArgumentError.new("Required parameter 'reg_no' missing.") unless !!options[:reg_no]
      raise ArgumentError.new("Required parameter 'store_id' missing.") unless !!options[:store_id]
      request = GetAddressRequest.new(options.merge({country_code: "SE"}))
      req = GetAddressRequestRepresenter.new(request).to_hash
      operation = operation_with_name :GetAddress
      operation.body = req
      response = operation.call.body
      if !response[:fault].nil?
        raise response[:fault].to_s
      end
      namespace = response.keys.first
      user_hash = response[namespace].with_indifferent_access
      user = User.new
      UserRepresenter.new(user).from_hash(user_hash)
      user
    end

    def cancel_invoice(options)
      %w(invoice_no store_id country_code).each do |param|
        if options[param.to_sym].nil?
          raise ArgumentError.new("Required parameter #{param} missing.")
        end
      end
      request = CancelInvoiceRequest.new(options)
      req = CancelInvoiceRequestRepresenter.new(request).to_hash
      operation = operation_with_name :CancelInvoice
      operation.body = req
      response = operation.call.body
      if !response[:fault].nil?
        raise_error(response)
      end
      namespace = response.keys.first
      response_hash = response[namespace]
      response_hash[:correlation_id]
    end

    def activate_invoice(options)
      %w(invoice_no store_id country_code).each do |param|
        if options[param.to_sym].nil?
          raise ArgumentError.new("Required parameter #{param} missing.")
        end
      end
      request = ActivateInvoiceRequest.new(options)
      operation = nil
      if request.article_list.nil?
        operation = operation_with_name :ActivateInvoice
        operation.body = ActivateInvoiceRequestRepresenter.new(request).to_hash
      else
        operation = operation_with_name :PartActivateInvoice
        operation.body = PartActivateInvoiceRequestRepresenter.new(request).to_hash
      end
      response = operation.call.body
      if !response[:fault].nil?
        raise_error(response)
      end
      namespace = response.keys.first
      InvoiceResponse.new(response[namespace])
    end

    def part_activate_invoice(options)
      if options[:article_list].nil?
        raise ArgumentError.new("Required parameter article_list missing.")
      end
      activate_invoice(options)
    end
  end
end