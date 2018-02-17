require 'pry'
require 'csv'
require 'awesome_print'
module Grocery
  class Customer
    attr_reader :customer_id, :email, :address
    def initialize(id, email, address)
      @customer_id = id
      @email = email
      @address = address
    end

    def self.all
      customer_list = []
      CSV.read('support/customers.csv', 'r', headers:true, header_converters: :symbol).each do |row|
        # csv_list = []
        id = row[:id].to_i
        email = row[:email]
        address = [ row[:street], row[:state], row[:zipcode] ]
        customer_list << Grocery::Customer.new(id, email, address)
        end #CSV.read('support/customers.rb')
      return customer_list
    end # Customer.all

    def self.find(id)
      #TODO: returns an instance of Customer where the value of the id field in the CSV matches the passed parameter
    end
  end
end

binding.pry
