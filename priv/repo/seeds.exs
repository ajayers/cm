# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CouponMarket.Repo.insert!(%CouponMarket.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
CouponMarket.Repo.delete_all CouponMarket.Coherence.User

CouponMarket.Coherence.User.changeset(%CouponMarket.Coherence.User{}, %{name: "Test User", email: "testuser@example.com", password: "secret", password_confirmation: "secret"})
|> CouponMarket.Repo.insert!



