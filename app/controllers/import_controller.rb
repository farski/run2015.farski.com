class ImportController < ApplicationController
  def update
    @activities = Import.import
  end
end
