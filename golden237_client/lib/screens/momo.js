// Install with: npm i flutterwave-node-v3

const FlutterWave = require('flutterwave-node-v3');
const flw = new FlutterWave('FLWPUBK-80dbc8752ce16374dfb957a3750c0749-X',
'FLWSECK-b909bd811c0ca444725bbe252e28581d-X');
const payload = {
    phone_number: '651565843',
    amount: 100,
    currency: 'XAF',
    email: 'JoeBloggs@acme.co',
    tx_ref: this.generateTransactionReference(),
}
flw.MobileMoney.franco_phone(payload)
    .then(console.log)
    .catch(console.log);