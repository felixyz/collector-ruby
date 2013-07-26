require 'savon'

module Collector

  CollectorUrl = 'https://eCommerceTest.collector.se/v3.0/InvoiceServiceV31.svc?wsdl'
  ServiceName =  :InvoiceServiceV31
  PortName =     :BasicHttpBinding_IInvoiceServiceV31

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

    AddInvoiceNamespace = :add_invoice_response_v31
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
      add_invoice_resp = InvoiceResponse.new(response[AddInvoiceNamespace])
      add_invoice_resp
    end

    GetAddressNamespace = :TODO_IMPLEMENT
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
      puts response
      User.new(response[GetAddressNamespace])
    end

    def activate_invoice(options)
      %w(invoice_no store_id country_code).each do |param|
        if options[param.to_sym].nil?
          raise ArgumentError.new("Required parameter #{param} missing.")
        end
      end
      request = ActivateInvoiceRequest.new(options)
      operation = operation_with_name :ActivateInvoice
      operation.body = ActivateInvoiceRequestRepresenter.new(request).to_hash
      response = operation.call.body
      if !response[:fault].nil?
        raise response[:fault].to_s
      end
      namespace = response.keys.first
      InvoiceResponse.new(response[namespace])
    end
  end
end