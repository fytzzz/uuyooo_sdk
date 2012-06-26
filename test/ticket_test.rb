require File.dirname(__FILE__) + '/unit_test_helper'
require 'crack'
require 'restclient'

require File.dirname(__FILE__) + "/../init"

class TicketTest < Test::Unit::TestCase
  def test_query_ticket
      result = UuyoooTicket.get_with('queryTicket',{:goodsId=>"xxxxxx"})
      p result.inspect,'----queryTicket---'
  end

  #第三方接口有问题
  def test_query_film
     result = UuyoooTicket.get_with('queryFilm',{:goodsId=>"xxxxxx"})
     p result.inspect,'----queryFilm---'
  end

  def test_buy_film
    result = UuyoooTicket.get_with('buyFilm',{:goodsId=>"xxxxxx",:goodsNum=>"1",:tranSeq=>"xxxxxx",:time=>"20120531154000",:userPhone=>"xxxxxx"})
    p result.inspect,'----buyFilm---'
  end
end
