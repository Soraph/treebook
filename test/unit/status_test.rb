require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  test "that a status requires content" do
    status = Status.new
    assert !status.save
    assert !status.errors[:content].empty?
  end

  test "that a status's content is at least 2 letters" do
    status = Status.new
    status.content = "A"
    assert !status.save
    assert !status.errors[:content].empty?
  end

  test "that a status had a user id" do
    status = Status.new
    status.content = "ABCDEF"
    assert !status.save
    assert !status.errors[:user_id].empty?
  end
end
