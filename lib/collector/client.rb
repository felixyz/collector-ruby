require 'savon'
require 'active_support/core_ext'

module Collector
  COLLECTOR_URL       =  'https://ecommerce.collector.se/v3.0/InvoiceServiceV31.svc?wsdl'
  COLLECTOR_URL_TEST  =  'https://eCommerceTest.collector.se/v3.0/InvoiceServiceV31.svc?wsdl'
  SERVICE_NAME        =   :InvoiceServiceV31
  PORT_NAME           =   :BasicHttpBinding_IInvoiceServiceV31

  class CollectorError < RuntimeError
    attr_reader :faultcode
    def initialize(faultcode, message)
      super(message)
      @faultcode = faultcode
    end
  end

  class InvoiceNotFoundError < CollectorError; end
  class InvalidInvoiceStatusError < CollectorError; end
  class InvalidTransactionAmountError < CollectorError; end
  class AuthorizationFailedError < CollectorError; end

  class Client
    def initialize(user_name, password, sandbox = false)
      @header = { 'ClientIpAddress' => '?',
                  'Username' => user_name,
                  'Password' => password }
      url = sandbox ? COLLECTOR_URL_TEST : COLLECTOR_URL
      http = Savon::HTTPClient.new
      http.client.ssl_config.ssl_version = 'TLSv1'
      @savon = Savon.new(url, http)
    end

    def operation_with_name(operation_name)
      @savon.operation(SERVICE_NAME, PORT_NAME, operation_name).tap do |operation|
        operation.header = @header
      end
    end

    def raise_error(response_hash)
      fault = response_hash[:fault]
      err_class = CollectorError
      case fault[:faultcode]
      when 's:INVOICE_NOT_FOUND'
        err_class = InvoiceNotFoundError
      when 's:INVALID_INVOICE_STATUS'
        err_class = InvalidInvoiceStatusError
      when 's:INVALID_TRANSACTION_AMOUNT'
        err_class = InvalidTransactionAmountError
      when 's:AUTHORIZATION_FAILED'
        err_class = AuthorizationFailedError
      end
      faultcode = fault[:faultcode].split(':').last
      fail err_class.send(:new, faultcode, fault[:faultstring])
    end

    def validate_attributes(request_object)
      unless request_object.has_required_attributes?
        fail ArgumentError.new(request_object.missing_attributes_human_readable)
      end
    end

    # operation_name is a symbol named as in the Collector API, eg :AddInvoice
    # request is a hash or an object responding to to_hash
    def perform_operation(operation_name, request)
      operation = operation_with_name operation_name
      operation.body = request.to_hash.with_indifferent_access
      response = operation.call.body
      raise_error(response) unless response[:fault].nil?
      namespace = response.keys.first
      response[namespace].with_indifferent_access
    end

    def add_invoice(invoice_request)
      validate_attributes(invoice_request)
      resp = perform_operation(:AddInvoice, InvoiceRequestRepresenter.new(invoice_request))
      InvoiceResponse.new(resp)
    end

    def get_address(options)
      request = GetAddressRequest.new(options.merge(country_code: 'SE'))
      validate_attributes(request)
      resp = perform_operation(:GetAddress, GetAddressRequestRepresenter.new(request))
      user = User.new
      UserRepresenter.new(user).from_hash(resp)
      user
    end

    def cancel_invoice(options)
      request = CancelInvoiceRequest.new(options)
      validate_attributes(request)
      resp = perform_operation(:CancelInvoice, CancelInvoiceRequestRepresenter.new(request))
      resp[:correlation_id]
    end

    def adjust_invoice(options)
      request = AdjustInvoiceRequest.new(options)
      validate_attributes(request)
      resp = perform_operation(:AdjustInvoice, AdjustInvoiceRequestRepresenter.new(request))
      resp[:correlation_id]
    end

    def replace_invoice(options)
      request = ReplaceInvoiceRequest.new(options)
      validate_attributes(request)
      resp = perform_operation(:ReplaceInvoice, ReplaceInvoiceRequestRepresenter.new(request))
      InvoiceResponse.new(resp)
    end

    def activate_invoice(options)
      request = ActivateInvoiceRequest.new(options)
      validate_attributes(request)
      operation = nil
      if request.article_list.nil?
        operation = :ActivateInvoice
        request = ActivateInvoiceRequestRepresenter.new(request)
      else
        operation = :PartActivateInvoice
        request = PartActivateInvoiceRequestRepresenter.new(request)
      end
      resp = perform_operation(operation, request)
      InvoiceResponse.new(resp)
    end

    def part_activate_invoice(options)
      if options[:article_list].nil?
        fail ArgumentError.new('Required parameter article_list missing.')
      end
      activate_invoice(options)
    end
  end
end
