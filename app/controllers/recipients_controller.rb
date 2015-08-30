class RecipientsController < ApplicationController
  def new
    @recipient = Recipient.new
  end
  
  def create
  	@recipient = current_user.recipients.build(recipient_params)
  	respond_to do |format|
      if @recipient.save
        format.html { redirect_to root_url, notice: 'Accountability buddy was successfully created.' }
        format.json { render action: 'show', status: :created, location: @recipient }
        format.js   { render action: 'show', status: :created, location: @recipient }
      else
        format.html { render action: 'new' }
        format.json { render json: @recipient.errors, status: :unprocessable_entity }
        format.js   { render json: @recipient.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    # Paginates and lists only all of USER's recipients
    @user = current_user
    @recipients = @user.recipients.paginate(page: params[:page])
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
  	@recipient = Recipient.find(params[:id])
    @owner_id = @recipient.user_id
    @recipient.destroy
  	flash[:success] = "Recipient deleted"
  	redirect_to recipients_user_path(@owner_id)
  end

  private

  	def recipient_params
  	  params.require(:recipient).permit(:name, :phone)
  	end 
end  