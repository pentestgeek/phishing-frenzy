class BlastsController < ApplicationController

  def show
    @blast = Blast.find(params[:id])
    @baits = @blast.baits
  end

end
