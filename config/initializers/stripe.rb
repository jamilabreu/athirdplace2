if Rails.env.production?
  Stripe.api_key = "sk_09ZfXvTPoQUGae19hKkxugGHR6Jik"
  STRIPE_PUBLIC_KEY = "pk_b4hWVN2gYtolH2aPGKVwxuO4Cd21Q"
else
  Stripe.api_key = "sk_09ZfztawwXPTsQRrKqZRrEoI9ViQu"
  STRIPE_PUBLIC_KEY = "pk_fZ8VW3jnok03xmlJpZMmSV5ueCwU7"
end