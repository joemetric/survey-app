class TransfersController < ApplicationController

  before_filter :require_user
  before_filter :find_user
  
  def index
    @transfers = @user.transfers
    respond_to do |format|
      format.json { render :json => @transfers.to_json(:methods => [ :survey ] ) }
    end
  end
  
  protected
  
  def find_user
    @user = current_user
  end
  
end
