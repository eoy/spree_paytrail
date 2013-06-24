module Spree
  CheckoutController.class_eval do
    before_filter :confirm_paytrail, :only => [:update]

    def success?(params)
      params['PAID'] != "0000000000"
    end

    def acknowledge(authcode)
      return_authcode = [params["ORDER_NUMBER"], params["TIMESTAMP"], params["PAID"], params["METHOD"], authcode].join("|")
      Digest::MD5.hexdigest(return_authcode).upcase == params["RETURN_AUTHCODE"]
    end

    def secret
      # Defined in admin interface
      Spree::BillingIntegration::Paytrail::PaytrailCheckout.first.preferences[:merchant_secret]
    end

    def paytrail_return
      # Create new payment if no payment already exists
      unless @order.payments.where(:source_type => 'Spree::PaytrailTransaction').present?
        payment_method = PaymentMethod.find(params[:payment_method_id])
        paytrail_transaction = PaytrailTransaction.new

        payment = @order.payments.create({:amount => @order.total,
                                         :source => paytrail_transaction,
                                         :payment_method => payment_method},
                                         :without_protection => true)
        payment.started_processing!
        payment.pend!
      end

      payment_method = PaymentMethod.find(params[:payment_method_id])
      payment = @order.payments.where(:state => "pending",
                                      :payment_method_id => payment_method).first

      unless payment
        paytrail_transaction = PaytrailTransaction.new
        payment = @order.payments.create({:amount => @order.total,
                                         :source => paytrail_transaction,
                                         :payment_method => payment_method},
                                         :without_protection => true)
      end

      # Check if the auth-code returned from Paytrail is valid
      unless success?(params) && acknowledge(secret)
        payment.failure!
        redirect_to checkout_state_path(@order.state)
      else
        payment.complete!
        @order.update!
        @order.finalize!
        @order.state = "complete"
        @order.save!
      end

      if @order.state == "complete" or @order.completed?
        flash[:notice] = I18n.t(:order_processed_successfully)
        flash[:commerce_tracking] = "nothing special"
        redirect_to completion_route
      else
        redirect_to checkout_state_path(@order.state)
      end
    end

    def paytrail_cancel
      flash[:error] = t(:payment_has_been_cancelled)
      redirect_to edit_order_path(@order)
    end

    private

    def confirm_paytrail
      return unless (params[:state] == "payment") && params[:order][:payments_attributes]

      payment_method = PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
      if payment_method.kind_of?(BillingIntegration::Paytrail::PaytrailCheckout)
        #TODO confirming payment method
        redirect_to edit_order_checkout_url(@order, :state => 'payment'),
                    :notice => t(:complete_skrill_checkout)
      end
    end
  end
end