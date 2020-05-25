require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test 'create' do 
    user = users(:jack_sparrow)
    assert Tag.create!(name: 'Something', user: user)
    assert Tag.create!(name: 'Something123', user: user)
    assert Tag.create!(name: 'Something-else_nothing', user: user)
    assert_raises ActiveRecord::RecordInvalid do 
      Tag.create!(name: 'S0meth!ng', user: user)
    end
  end 

  test 'update' do 
    user = users(:jack_sparrow)
    Tag.create!(name: 'Something', user: user)
    tag = Tag.last
    assert tag.update(name: 'Something-else_nothing')
    refute tag.update(name: 'S0meth!$#ng')
  end 
end
