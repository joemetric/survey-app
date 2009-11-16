class TransfersController < ApplicationController

  before_filter :require_user
  before_filter :find_user

  def index
    @transfers = @user.transfers
    render_json
  end

  def pending
    @transfers = @user.transfers.pending
    render_json
  end

  def paid
    @transfers = @user.transfers.paid
    render_json
  end

  protected

  def find_user
    @user = current_user
  end

  def render_json
    respond_to do |format|
      format.json { render :json => @transfers.to_json(:methods => [ :survey ] ), :status => 200 }
    end
  end

end
