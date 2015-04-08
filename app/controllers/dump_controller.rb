# controller to create promotional licenses
class DumpController < ApplicationController

  def index
    @password = params[:password]
    if @password == ENV['IQE_REPORT_PASSWORD']
      IqeMailer.dump_qtest.deliver
      @password = true
    else
      @password = false
    end
  end

end
