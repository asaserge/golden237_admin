<script src="https://checkout.flutterwave.com/v3.js"></script>
<script>
  function makePayment(amount, email, phone, name, code) {
    FlutterwaveCheckout({
      public_key: "FLWPUBK-80dbc8752ce16374dfb957a3750c0749-X",
      tx_ref: code,
      amount: amount,
      currency: "XAF",
      payment_options: "mobilemoneyfranco",
      redirect_url: "https://glaciers.titanic.com/handle-flutterwave-payment",
      meta: {
        consumer_id: 23,
        consumer_mac: "92a3-912ba-1192a",
      },
      customer: {
        email: email,
        phone_number: phone,
        name: name,
      },
      customizations: {
        title: "Golden 237 Ecommerce Store",
        description: "Payment for product",
        logo: "https://www.logolynx.com/images/logolynx/22/2239ca38f5505fbfce7e55bbc0604386.jpeg",
      },
      callback: function(payment) {
             // Send AJAX verification request to backend
             verifyTransactionOnBackend(payment.id);
             modal.close();
           },
    });
  }
</script>