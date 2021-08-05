# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

require 'base64'
require 'json'
require 'logger'
require_relative 'lib/invoice.rb'

LOGLEVELS = %w[DEBUG INFO WARN ERROR FATAL UNKNOWN].freeze

module Billing
  class InvoiceGenerator
    # Configure logging
    @logger = Logger.new(STDOUT)
    level ||= LOGLEVELS.index ENV.fetch("LOG_LEVEL","WARN") # default to WARN if not specified
    level ||= Logger::WARN  # FIX default in case of environment LOG_LEVEL value is present but not correct
    @logger.level = level

    def self.logger
        @logger
    end

    def self.process(event:, context:)
      self.logger.debug(JSON.generate(event))

      # Base 64 encoding is a requirement for rturning binary data from API Gateway
      # https://docs.aws.amazon.com/apigateway/latest/developerguide/lambda-proxy-binary-media.html
      invoice_pdf = Base64.encode64(Invoice.new.generate)

      { 'headers' => { 'Content-Type': 'application/pdf' },
        'statusCode' => 200, 
        'body' => invoice_pdf,
        'isBase64Encoded' => true
      }
    end
  end
end