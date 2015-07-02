class RecipientsController < ApplicationController
  def index
  	@user = current_user
  	@recipients = @user.recipients.paginate(page: params[:page])
  end

  def new
  	@recipient = Recipient.new
  end

  def create
  	@recipient = current_user.recipients.build(recipient_params)
  	if @recipient.save
  	  flash[:success] = "Recipient successfully created"
  	  redirect_to root_url
  	else
  	  flash.now[:danger] = "Invalid Recipient"
  	  render 'static_pages/home'
  	 end
  end

  def edit
  end

  def update
  	@user = current_user
  	@recipient = @user.recipient
  	if @recipient.update_attributes(recipient_params)
  	  flash[:success] = "Recipient details updated"
  	  redirect_to root_url
  	else
  	  render 'edit'
  	end
  end

  def destroy
  	Recipient.find(params[:id]).destroy
  	flash[:success] = "Recipient deleted"
  	redirect_to recipients_url
  end

  private

  	def recipient_params
  	  params.require(:recipient).permit(:name, :phone)
  	end 
end  