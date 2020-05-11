(function() {
  var StripeMeta;

  StripeMeta = {
    card: {
      createToken: function(params, handler) {
        return Stripe.card.createToken(params, handler);
      },
      fieldMappings: {
        number: 'card_number',
        exp_month: 'expiration_month',
        exp_year: 'expiration_year',
        cvc: 'security_code'
      },
      convertResponse: function(response, data) {
        var k, result, v;
        if (data == null) {
          data = {};
        }
        result = {
          stripe_tok: response.id,
          bank_name: response.card.brand,
          last_four: response.card.last4,
          expiration_month: response.card.exp_month,
          expiration_year: response.card.exp_year
        };
        for (k in data) {
          v = data[k];
          result[k] = v;
        }
        return result;
      }
    },
    _bankAccount: {
      createToken: function(params, handler) {
        return Stripe.bankAccount.createToken(params, handler);
      },
      fieldMappings: {
        country: 'country',
        currency: 'currency',
        account_number: 'account_number',
        routing_number: 'routing_number',
        account_holder_type: 'account_holder_type',
        account_holder_name: 'account_holder_name'
      },
      convertResponse: function(response, data) {
        var k, result, v;
        if (data == null) {
          data = {};
        }
        result = {
          stripe_tok: response.id,
          bank_name: response.bank_account.bank_name,
          last_four: response.bank_account.last4
        };
        for (k in data) {
          v = data[k];
          result[k] = v;
        }
        return result;
      }
    }
  };

  StripeMeta['checking'] = StripeMeta['_bankAccount'];

  StripeMeta['savings'] = StripeMeta['_bankAccount'];

  this.PaymentProvider = (function() {
    function PaymentProvider() {}

    PaymentProvider.tokenize = function(fields, type, $container) {
      var appName, convertResponse, createToken, deferred, fieldMappings, name, notes, params, stripeName;
      deferred = $.Deferred();
      Stripe.setPublishableKey($container.data("stripe-publishable-key"));
      name = fields.name;
      notes = fields.notes;
      fieldMappings = StripeMeta[type].fieldMappings;
      createToken = StripeMeta[type].createToken;
      convertResponse = StripeMeta[type].convertResponse;
      params = {};
      for (stripeName in fieldMappings) {
        appName = fieldMappings[stripeName];
        params[stripeName] = fields[appName];
      }
      createToken(params, function(status, response) {
        var error, errors, result;
        error = response.error;
        if (error) {
          errors = [
            {
              param: fieldMappings[error.param] || error.param,
              message: error.message
            }
          ];
          return deferred.reject(errors);
        } else {
          result = convertResponse(response, {
            account_type: type,
            name: name,
            notes: notes
          });
          return deferred.resolve(result);
        }
      });
      return deferred.promise();
    };

    return PaymentProvider;

  })();

}).call(this);
