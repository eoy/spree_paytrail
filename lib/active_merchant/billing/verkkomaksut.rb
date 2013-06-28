module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class Verkkomaksut < Gateway

      def fields(opts)
        hash = {
          TYPE: "S1",
          MERCHANT_ID: opts[:merchant_id],
          ORDER_NUMBER: opts[:order_id],
          REFERENCE_NUMBER: "",
          ORDER_DESCRIPTION: opts[:description],
          RETURN_ADDRESS: opts[:return_url],
          CANCEL_ADDRESS: opts[:cancel_url],
          PENDING_ADDRESS: "",
          NOTIFY_ADDRESS: "",
          CULTURE: "en_US",
          PRESELECTED_METHOD: "",
          MODE: 1,
          VISIBLE_METHODS: "",
          GROUP: "",
          CURRENCY: opts[:currency],
          AMOUNT: opts[:amount]
          # CONTACT_EMAIL: "user@example.com",
          # CONTACT_FIRSTNAME: opts[:firstname],
          # CONTACT_LASTNAME: opts[:lastname],
          # CONTACT_ADDR_STREET: opts[:address],
          # CONTACT_ADDR_ZIP: opts[:zipcode],
          # CONTACT_ADDR_CITY: opts[:city],
          # CONTACT_ADDR_COUNTRY: "FI",
          # INCLUDE_VAT: 1,
        }
        return hash
      end

      def service_url
        "https://payment.verkkomaksut.fi/"
      end

      def payment_url(opts)
        post = PostData.new
        post.merge! fields(opts)
        post.merge!(AUTHCODE: generate_md5string(fields(opts), opts[:merchant_secret]))

        "#{service_url}?#{post.to_s}"
      end

      # Calculates the AUTHCODE
      def generate_md5string(data, secret)
        fields = [secret,
                  data[:MERCHANT_ID],
                  data[:AMOUNT],
                  data[:ORDER_NUMBER],
                  data[:REFERENCE_NUMBER],
                  data[:ORDER_DESCRIPTION],
                  data[:CURRENCY],
                  data[:RETURN_ADDRESS],
                  data[:CANCEL_ADDRESS],
                  data[:PENDING_ADDRESS],
                  data[:NOTIFY_ADDRESS],
                  data[:TYPE],
                  data[:CULTURE],
                  data[:PRESELECTED_METHOD],
                  data[:MODE],
                  data[:VISIBLE_METHODS],
                  data[:GROUP]]
                  ### For use with form type E1
                  # data[:CONTACT_EMAIL],
                  # data[:CONTACT_FIRSTNAME],
                  # data[:CONTACT_LASTNAME],
                  # data[:CONTACT_ADDR_STREET],
                  # data[:CONTACT_ADDR_ZIP],
                  # data[:CONTACT_ADDR_CITY],
                  # data[:CONTACT_ADDR_COUNTRY],
                  # data[:INCLUDE_VAT],
        
        fields = fields.join("|")
        return Digest::MD5.hexdigest(fields).upcase.to_s
      end

    end
  end
end
