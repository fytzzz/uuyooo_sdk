# Include hook code here
Dir["#{File.dirname(__FILE__)+'/lib/*.rb'}"].sort.each do |file|
  require file
  ticket_config_file = File.dirname(__FILE__) + "/template/config/#{File.basename(file,'.rb')}.yml"
  UuyoooTicket.load_configuration(ticket_config_file)
end
