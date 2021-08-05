# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

require 'rubygems'
require 'bundler'
require_relative 'lib/invoice.rb'

Bundler.require

get '/invoice' do
  content_type 'application/pdf'
  Invoice.new.generate
end

run Sinatra::Application

