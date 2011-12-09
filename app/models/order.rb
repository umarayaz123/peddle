class Order < ActiveRecord::Base
  belongs_to :user
  has_many :order_details, :dependent => :destroy

  attr_accessor :card_number, :card_verification, :ip_address, :first_name, :last_name, :card_type, :card_expires_on, :billing_name, :billing_address, :billing_city, :billing_state, :billing_country, :billing_zip
  #attr_accessible :cart_id, :ip_address, :first_name, :last_name, :card_type, :card_expires_on
  #validate :validate_card

  default_scope order('created_at')
  paginates_per 15

  #-------------------------
  def total_price
    order_details.to_a.sum { |item| item.total_price }
  end

  def total_items
    i = 0
    order_details.each do
      i+=1
    end
    i
  end

  #-------------------------
  def purchase(uid)
    #response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
    response = STANDARD_GATEWAY.purchase(price_in_cents, credit_card(), purchase_options)
    #transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
    self.update_attributes(:purchased_at => Time.now, :message => response.message, :success => response.success?, :amount => price_in_cents, :user_id => uid) if response.success?
    response.success?
  end

  def authorise_store_package(price)
    #response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
    response = STANDARD_GATEWAY.authorize(price, credit_card(), purchase_options)
    #transactions.create!(:action => "purchase_store_package", :amount => price, :response => response)
    #cart.update_attribute(:purchased_at, Time.now) if response.success?
    response
  end

  def capture_store_package(price,uid,authorize)
    #response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
    response = STANDARD_GATEWAY.capture(price, authorize)
    #transactions.create!(:action => "capture_store_package", :amount => price, :response => response)
    #cart.update_attribute(:purchased_at, Time.now) if response.success?
    #cart.update_attribute(:purchased_at, Time.now) if response.success?
    self.update_attributes(:purchased_at => Time.now, :message => response.message, :success => response.success?, :amount => price, :user_id => uid) if response.success?
    response
  end

  def price_in_cents
    #(cart.total_price*100).round
    (total_price).round
  end

  private

  def purchase_options
    {
        :ip => ip_address,
        :billing_address => {
            :name => billing_name,
            :address1 => billing_address,
            :city => billing_city,
            :state => "NY",
            :country => "US",
            :zip => "10001"
        }
    }
  end

  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        #errors.add_to_base message
        errors[:base] << message #new rails functionality
        #errors.add :base, message      #old rails functionality
      end
    end
  end

  def credit_card()
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
        :type => card_type,
        :number => card_number,
        :verification_value => card_verification,
        :month => card_expires_on.month,
        :year => card_expires_on.year,
        :first_name => first_name,
        :last_name => last_name
    )
  end
end
