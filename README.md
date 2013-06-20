# Spree Paytrail

A [Spree](http://spreecommerce.com) extension to allow payments using Paytrail, heavily inspried by spree-pp-website-standard and spree_gateway

## Before you read further

This README is in the process of thorough rework to describe the current codebase, design decisions and how to use it. But at the moment some parts are out-of-date. Please read the code of the extension, it's pretty well commented and structured. 

## Old Introduction (outdated!)

Overrides the default Spree checkout process and uses offsite payment processing via PayPal's Website Payment Standard (WPS).  

You'll want to test this using a paypal sandbox account first.  Once you have a business account, you'll want to turn on Instant Payment Notification (IPN).  This is how your application will be notified when a transaction is complete.  Certain transactions aren't completed immediately.  Because of this we use IPN for your application to get notified when the transaction is complete.  IPN means that our application gets an incoming request from Paypal when the transaction goes through.  

You may want to implement your own custom logic by adding 'state_machine' hooks.  Just add these hooks in your site extension (don't change the 'pp_website_standard' extension.) Here's an example of how to add the hooks to your site extension.


    fsm = Order.state_machines['state']  
    fsm.after_transition :to => 'paid', :do => :after_payment
    fsm.after_transition :to => 'pending_payment', :do => :after_pending  
    
    Order.class_eval do  
      def after_payment
        # email user and tell them we received their payment
      end
      
      def after_pending
        # email user and thell them that we are processing their order, etc.
      end
    end


## Installation 

Add to your Spree application Gemfile.

    gem "spree_paytrail", :git => "git://github.com/eoy/spree_paytrail.git"

Run the install rake task to copy migrations (create payment_notifications table)

    rails generate spree_paytrail:install

Configure, run, test.


## Configuration

Be sure to set the Merchant ID and Merchant Secret in the admin panel.

## TODO

* Make it less aggressive towards other payment solutions
