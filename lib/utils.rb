# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

class Utils
  # Static values for customer and order details to be used on the invoice.
  # In a real-world scenario, we would receive this as POST body or
  # GET query string parameters.
  def initialize
    provider_address = <<ADDRESS
    5th Avenue
    Anytown, USA
ADDRESS
    
    address1 = <<ADDRESS
    123 Any Street
    Any Town, USA
ADDRESS
    
    address2 = <<ADDRESS
    100 Main Street
    Anytown, USA
ADDRESS
    
    @customers = [
      { name: 'John Doe', address: address1, bank_account_number: '000999999991' },
      { name: 'Shirley Rodriguez', address: address2, bank_account_number: '12345678901234' }
    ]
    
    @provider = {
      name: 'Example Corp.', address: provider_address
    }

    @items = [
      { name: 'Lightweight Breathable Running Shoes', quantity: '1', unit: 'nos', price: '$ 55', amount: '$ 55' },
      { name: 'Espresso and Cappuccino Maker with Grinder - Red', quantity: '1', unit: 'nos', price: '$ 1,999', amount: '$ 1,999' }
    ]
  end

  # Calculate invoice date
  def invoice_date
    current_time = Time.now.utc
    invoice_date = current_time.strftime('%d-%m-%Y')
    [invoice_date, due_date(current_time)]
  end

  def due_date(current_time)
    due_time = current_time + (2 * 7 * 24 * 60 * 60) # 2 weeks from now
    due_date = due_time.strftime('%d-%m-%Y')
    due_date
  end

  def invoiceid
    Time.now.to_i
  end

  # Randomly sample from the array of static customer details
  def customer_details
    @customers.sample
  end

  def provider_details
    @provider
  end

  # Randomly sample from the array of static order details
  def order_item
    @items.sample
  end
end
