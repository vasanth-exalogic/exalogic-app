class PercentagesController < ApplicationController
  def edit
    @percentage = Percentage.find(1)
  end

  def update
  end
end
