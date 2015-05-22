# The Money element has three possible attributes: currency, alternateAmount,
# alternateCurrency. The attributes currency and alternateCurrecy must be a three-letter ISO
# 4217 currency code. The content of the Money element and of the aternateAmount
# attribute should be a numeric value. For example:
# <Money currency="USD">12.34</Money>
# The optional alternateCurrency and alternateAmount attributes are used together to specify
# an amount in an alternate currency. These can be used to support dual-currency
# requirements such as the euro. For example:
# <Money currency="USD" alternateCurrency=”EUR” alternateAmount=”14.28”>12.34
# </Money>
# Note:  You can optionally use commas as thousands separators. Do not use
# commas as decimal separators.
#
# Page: 59
# <Money currency="GBP">5.35</Money>

module CXML
  class Money
    attr_accessor :currency
    attr_accessor :amount
    attr_accessor :alternate_currency
    attr_accessor :alternate_amount
  end

  def initialize(data={})
    @currency = data['current']
  end

  def build_attributes
    attributes = {}
    attributes << {'currency' => currency} if currency
    attributes << {'alternateCurrency' => alternate_currency} if alternate_currency
    attributes << {'alternateAmount' => alternate_amount} if alternate_amount
  end

  def render(node)
    node.Money(build_attributes){amount}
  end


end
