# controller for taking the test
class LicenseController < ApplicationController
  include QtestHelper

  def no_license
    @qtest = Qtest.new
  end

  def license
    @license_key = params[:qtest][:license_key]
    @qtest = Qtest.find_by_license_key(@license_key)
    if @qtest
      redirect_to qtest_path(@qtest.license_key)
    else
      redirect_to invalid_license_path
    end
  end
end
