require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'
require_relative '../lib/order'
require 'csv'

describe "Order Wave 1" do
  before do
    @all = Grocery::Order.populate
  end
  describe "#initialize" do
    it "Takes an ID and collection of products" do
      id = 1337
      order = Grocery::Order.new(id, {})

      order.must_respond_to :id
      order.id.must_equal id
      order.id.must_be_kind_of Integer

      order.must_respond_to :products
      order.products.length.must_equal 0
    end
  end

  describe "#total" do
    it "Returns the total from the collection of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      sum = products.values.inject(0, :+)
      expected_total = sum + (sum * 0.075).round(2)

      order.total.must_equal expected_total
    end

    it "Returns a total of zero if there are no products" do
      order = Grocery::Order.new(1337, {})

      order.total.must_equal 0
    end
  end

  describe "#add_product" do
    it "Increases the number of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      before_count = products.count
      order = Grocery::Order.new(1337, products)

      order.add_product("salad", 4.25)
      expected_count = before_count + 1
      order.products.count.must_equal expected_count
    end

    it "Is added to the collection of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      order.add_product("sandwich", 4.25)
      order.products.include?("sandwich").must_equal true
    end

    it "Returns false if the product is already present" do
      products = { "banana" => 1.99, "cracker" => 3.00 }

      order = Grocery::Order.new(1337, products)
      before_total = order.total

      result = order.add_product("banana", 4.25)
      after_total = order.total

      result.must_equal false
      before_total.must_equal after_total
    end

    it "Returns true if the product is new" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      result = order.add_product("salad", 4.25)
      result.must_equal true
    end
  end
end

describe "Order Wave 2" do
  describe "Order.all" do
    it "Returns an array of all orders" do
      # # Arrange
      # products = { "banana" => 1.99, "cracker" => 3.00 }
      # products2 = {"Slivered Almonds" => 22.88, "Wholewheat flour" => 1.93, "Grape Seed Oil" => 74.9}
      # order = Grocery::Order.new(1337, products)
      # order2 = Grocery::Order.new(23, products2)
      # order_list = [order, order2]

      # Act
      result = Grocery::Order.all

      # Assert
      result.must_be_kind_of Array
      result[0].must_be_kind_of Grocery::Order

    end

    it "Returns accurate information about the first order" do
      #Arrange
      # id = 1
      # products = {"Slivered Almonds" => 22.88, "Wholewheat flour" => 1.93, "Grape Seed Oil" => 74.9}
      # id2 = 2
      # products2 = {"Albacore Tuna" => 36.92, "Capers" => 97.99, "Sultanas" => 2.82, "Koshihikari rice" => 7.55}
      # order = Grocery::Order.new(id, products)
      # order2 = Grocery::Order.new(id2, products2)
      # order_list = [order, order2]

      # Act

      result = Grocery::Order.all[0]


      # Assert

      result.id.must_equal 1
      result.total.must_equal 107.19

    end

    it "Returns accurate information about the last order" do
      #Arrange
      # # id = 1
      # # products = {"Slivered Almonds" => 22.88, "Wholewheat flour" => 1.93, "Grape Seed Oil" => 74.9}
      # # id2 = 2
      # # products2 = {"Albacore Tuna" => 36.92, "Capers" => 97.99, "Sultanas" => 2.82, "Koshihikari rice" => 7.55}
      #
      # # Act
      # order = Grocery::Order.new(id, products)
      # order2 = Grocery::Order.new(id2, products2)
      result = Grocery::Order.all[-1]
      # Assert
      result.id.must_equal Grocery::Order.all.length
      result.total.must_equal 172.05
    end
  end

  describe "Order.find" do
    it "Can find the first order from the CSV" do
      # #Arrange
      # FILE_NAME = 'support/orders.csv'
      # csv_file = CSV.read(FILE_NAME, 'r', headers: true, header_converters: :symbol)
      #
      # # Act
      # order = Grocery::Order.new(csv_file.first[:id], csv_file.first[:products])
      result = Grocery::Order.find(1)

      # Assert
      result.id.must_equal 1
      result.must_be_kind_of Grocery::Order

    end
    it "Can find the last order from the CSV" do
      # # Arrange
      # FILE_NAME = 'support/orders.csv'
      # csv_file = CSV.read(FILE_NAME, 'r', headers: true, header_converters: :symbol)
      #
      # # Act
      # order = Grocery::Order.new(csv_file[-1][:id], csv_file[-1][:products])
      result = Grocery::Order.find(100)

      # Assert
      result.id.must_equal 100
      result.must_be_kind_of Grocery::Order
    end

    it "Raises an error for an order that doesn't exist" do
      # Arrange
      # Act
      # Assert
      proc {Grocery::Order.find(1337)}.must_raise Grocery::FindError
    end
  end
end
