require 'commander/import'

program :version, '0.0.1'
program :name, 'Collector browser'
program :description, 'Simple tool to browse the Collector API.'

require 'savon'
require 'terminal-table'

CollectorUrl = 'https://eCommerceTest.collector.se/v3.0/InvoiceServiceV31.svc?wsdl'
ServiceName =  :InvoiceServiceV31
PortName =     :BasicHttpBinding_IInvoiceServiceV31

default_command :menu

def client
  return @savon if @savon
  http = Savon::HTTPClient.new
  http.client.ssl_config.ssl_version = 'TLSv1'
  @savon = Savon.new(CollectorUrl, http)
end

def operations
  @operations ||= client.operations(ServiceName, PortName)
end

def build_operation_info(parts)
  memo = {}

  parts.each do |element|
    name = element.name.to_sym

    case
    when element.simple_type?
      base_type_local = element.base_type.split(':').last
      memo[name] = { type: base_type_local, simple: true, singular: element.singular? }

    when element.complex_type?
      value = build_operation_info(element.children)
      memo[name] = { type: :complex, sub_part: value, simple: false, singular: element.singular? }
    end
  end

  memo
end

def clear_screen
  system ('clear')
end

def print_example(operation_name, path = [0])
  clear_screen
  operation = client.wsdl.operation(ServiceName.to_s, PortName.to_s, operation_name.to_s)
  info = build_operation_info operation.input.body_parts
  request_name = info.keys.first
  hash = info
  path.each { |index| key = hash.keys[index]; hash = hash[key][:sub_part] }
  rows = hash.keys.map.each_with_index do |key, idx|
    value = hash[key]
    [value[:simple] ? '-' : idx + 1,
     key,
     value[:type],
     value[:singular]]
  end
  puts Terminal::Table.new title: request_name, headings: ['#', 'Param', 'Type', 'Singular?'], rows: rows
  choice = ask('Choose nested structure, (b)ack, or e(x)it')
  case choice
  when 'x'
    abort
  when 'b'
    if path.count == 1
      print_menu
    else
      path.pop
      print_example(operation_name, path)
    end
  else
    print_example(operation_name, path << (choice.to_i - 1))
  end
end

def print_menu
  clear_screen
  rows = operations.map.each_with_index { |name, idx| [idx + 1, name] }
  table = Terminal::Table.new title: 'Operations', headings: ['#', 'Operation'], rows: rows
  puts table
  choice = ask('Operation?')
  print_example(operations[choice.to_i - 1])
end

command :menu do
  print_menu
end
