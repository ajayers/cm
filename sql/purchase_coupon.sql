CREATE OR REPLACE FUNCTION purchase_coupon(requester_account_id bigint, coupon_id bigint)
RETURNS bigint AS $transaction_id$
DECLARE
    c coupons;
    poster_account accounts;
    requester_account accounts;
    transaction transactions;
    market_charge float;
BEGIN
    RAISE LOG 'Hello, %', requester_account_id;

    -- lock on coupon
    SELECT * INTO c FROM coupons WHERE id = coupon_id LIMIT 1 FOR UPDATE;
    if (c IS NULL) then
        RAISE EXCEPTION 'coupon % not found', coupon_id;
    end if;
    if (c.sold_at IS NOT NULL) then
        RAISE EXCEPTION 'coupon % already sold', coupon_id;
    end if;
    RAISE LOG 'coupon: %; value: %', c.id, c.value;

    -- lock requester account
    SELECT * INTO requester_account FROM accounts WHERE id = requester_account_id LIMIT 1 FOR UPDATE;
    if (requester_account IS NULL) then
        RAISE EXCEPTION 'requester account % not found', requester_account_id;
    end if;
    RAISE LOG 'requester: %; balance: %', requester_account.id, requester_account.balance;

    -- lock poster account
    SELECT * INTO poster_account FROM accounts WHERE id = c.account_id LIMIT 1 FOR UPDATE;
    RAISE LOG 'poster: %; balance: %', poster_account.id, poster_account.balance;

    -- calculater market charge: 5 percent of the coupon value
    market_charge = c.value * 0.05;
    RAISE LOG 'market_charge: %', market_charge;

    if (requester_account.balance - c.value < 0.0) THEN
        RAISE EXCEPTION 'insufficient funds';
    end if;

    -- do the accounting
    UPDATE accounts SET balance = balance - c.value WHERE id = requester_account.id;
    UPDATE accounts SET balance = balance + c.value - market_charge WHERE id = poster_account.id;

    -- add transaction
    INSERT INTO transactions (purchased_at, poster_account_id, requester_account_id, coupon_id, inserted_at, updated_at) VALUES (now(), poster_account.id, requester_account.id, c.id, now(), now())
    RETURNING * INTO transaction;

    -- test poster
    SELECT * INTO poster_account FROM accounts WHERE id = poster_account.id LIMIT 1;
    RAISE LOG 'poster: %; balance: %', poster_account.id, poster_account.balance;

    -- test request
    SELECT * INTO requester_account FROM accounts WHERE id = requester_account.id LIMIT 1;
    RAISE LOG 'requester: %; balance: %', requester_account.id, requester_account.balance;

    -- mark coupon as sold
    -- TODO AJA: calc now once for consistency of purchased_at and sold_at
    UPDATE coupons SET sold_at = now() WHERE id = c.id;

    RETURN transaction.id;
    --EXCEPTION
    --    WHEN NO_DATA_FOUND THEN
    --        RAISE INFO 'coupon % not found', coupon_id;
END;
$transaction_id$ LANGUAGE plpgsql;
