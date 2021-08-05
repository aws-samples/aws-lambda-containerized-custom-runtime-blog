# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

require 'invoice_printer'
require_relative 'utils'

class Invoice
  def initialize
    @utils = Utils.new
  end

  def generate
    # Retrieve order and customer details using the helper module
    customer = @utils.customer_details
    provider = @utils.provider_details
    invoice_date = @utils.invoice_date
    order_item = @utils.order_item

    # Generate order items for the invoice
    item = InvoicePrinter::Document::Item.new(
      name: order_item[:name],
      quantity: order_item[:quantity],
      unit: order_item[:unit],
      price: order_item[:price],
      amount: order_item[:amount]
    )

    # Generate the invoice
    invoice = InvoicePrinter::Document.new(
      number: "NO. #{@utils.invoiceid}",
      provider_name: provider[:name],
      provider_lines: provider[:address],
      purchaser_lines: customer[:address],
      purchaser_name: customer[:name],
      issue_date: invoice_date[0],
      due_date: invoice_date[1],
      total: order_item[:amount],
      bank_account_number: customer[:bank_account_number],
      items: [item],
    )

    InvoicePrinter.render(
        document: invoice
    )
  end
end