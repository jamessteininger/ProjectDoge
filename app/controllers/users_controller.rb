class UsersController < ApplicationController
  #before_filter :authenticate_user!
  
  def remove_battle_logs
    @user = User.find(params[:user_id])
    @user.remove_battle_logs
    respond_to do |format|
      format.html { redirect_to @user, notice: ':) You removed all Ghost Logs!' }
    end
  end
  
  def give_doge
    @user = User.find(params[:user_id])
    @user.give_doge(params[:doge])
    respond_to do |format|
      format.html { redirect_to @user, notice: ':) You gave Doge!' }
    end
  end
  
  def mod
    @user = User.find(params[:user_id])
  end
  
  def join_guild
    current_user.update_attribute(:guild_id, params[:guild_id])
    redirect_to Guild.find(params[:guild_id])
  end
  
  def get_booster
    @user = User.find(params[:user_id])
    @item1 = Item.order("RANDOM()").first
    @sale1 = @user.sales.new(user_id: @user.id, item_id: @item1.id)
    @sale1.save
     @item1 = Item.order("RANDOM()").first
    @sale1 = @user.sales.new(user_id: @user.id, item_id: @item1.id)
    @sale1.save
     @item1 = Item.order("RANDOM()").first
    @sale1 = @user.sales.new(user_id: @user.id, item_id: @item1.id)
    @sale1.save
    @item1 = Item.order("RANDOM()").first
    @sale1 = @user.sales.new(user_id: @user.id, item_id: @item1.id)
    @sale1.save
    @item1 = Item.order("RANDOM()").first
    @sale1 = @user.sales.new(user_id: @user.id, item_id: @item1.id)
    @sale1.save
    redirect_to @user
  end
  
  def add_coin
    amount = params[:amount]
    @user = User.find(params[:user_id])
    @user.add_coin(Float(amount))
    redirect_to @user, notice: 'Got coin.'
  end
  
  def send_doge
    amount = params[:amount]
    address = params[:address]
   # @user = User.find(params[:user_id])
   # my_address = BlockIo.get_user_address user_id: @user.block_io_wallet_id
    BlockIo.withdraw_from_user user_id: current_user.block_io_wallet_id, payment_address: address.to_s, amount: amount.to_i
    redirect_to wallet_path
  end
  
  def make_wallet
    @user = User.find(params[:user_id])
    wallet_id = BlockIo.get_new_address :label => 'LABEL'
    current_user.update_attribute(:block_io_wallet_id, wallet_id["data"]["user_id"].to_i)
    redirect_to wallet_path
  end
  
  def withdrawl
    amount = params[:amount]
    address = params[:address]
    BlockIo.withdraw :amounts => amount, :to_addresses => address
  end
  
 # def sell_all
   # @user = User.find(params[:user_id])
  ##  @user.sales.destroy_all
  #  redirect_to @user
 # end
  
  def set_town
   # town = params[:town_id]
    @user = User.find(params[:user_id])
    @user.set_town(params[:town_id])
    @town = Town.find(params[:town_id])
    redirect_to @town
  end
  
  def destroy
		@user = User.find(params[:id])
		@user.destroy
	end

	def index
    if params[:search]
      @users = User.where(['dogetag LIKE ?', "%#{params[:search]}%"]).paginate(:page => params[:page], :per_page => 30).order('dogetag ASC')
    else
      @users = User.paginate(:page => params[:page], :per_page => 30).order('dogetag ASC')
    end
		#@user = current_user
	end
  
  def show
    @user = User.find(params[:id])
    if (@user.block_io_wallet_id.presence)
      @blockio = BlockIo.get_user_balance user_id: @user.block_io_wallet_id
    #@blockio_address = BlockIo.get_address_by_label label: @user.email
    end
    @sales = @user.sales

	#	if current_user.id == @user.id
			render action: :show
		#elsif current_user.following?(@user)
		#	render action: :show 
		#else
		#	render file: 'public/denied', formats: [:html]
		#end
	end
  
  private 
  def user_params
    params.require(:user).permit(:email, :coin, :health, :total_health, :magic, :attack, :css_theme)
   end
end
