# Added to your config\initializers file
Infusionsoft.configure do |config|
  config.api_url = ENV['INFUSIONSOFT_URL']  # 'xxx.infusionsoft.com'
  config.api_key = ENV['INFUSIONSOFT_API']
  config.api_logger = Logger.new("#{Rails.root}/log/infusionsoft_api.log") # optional logger file
end
