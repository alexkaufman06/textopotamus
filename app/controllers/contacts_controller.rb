class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @user = User.find(current_user.id)
    @contact = @user.contacts.new(contact_params)
    if @contact.save
      flash[:notice] = "Your contact was successfully saved!"
      redirect_to contact_path(current_user)
    else
      render 'new'
    end
  end

  def show
    user = User.find(current_user.id)
    @contacts = user.contacts
  end

private
  def contact_params
    params.require(:contact).permit(:name, :phone_number)
  end
end
