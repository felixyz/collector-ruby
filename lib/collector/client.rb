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
      operation = operation_with_name :AddInvoice
      operation.body = Collector::InvoiceRequestRepresenter.new(invoice_request).to_hash
      response = operation.call.body
      # TODO: Exception class, and proper information extraction
      if !response[:fault].nil?
        raise response[:fault].to_s
      end
      add_invoice_resp = AddInvoiceResponse.new(response[AddInvoiceNamespace])
      add_invoice_resp
    end
  end
end