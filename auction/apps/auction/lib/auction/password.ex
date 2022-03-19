defmodule Auction.Password do
  import Pbkdf2

  def hash(password) do
    hash_pwd_salt(password)
  end

  def verify(password, hash) do
    verify_pass(password, hash)
  end

  def dummy_verify() do
    no_user_verify()
  end
end
