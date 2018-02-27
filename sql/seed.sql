set client_min_messages = LOG;

DELETE FROM transactions;
DELETE FROM coupons;
DELETE FROM accounts;
DELETE FROM brands;

INSERT INTO brands (id, name, inserted_at, updated_at) VALUES (1, 'Starbucks', now(), now());
INSERT INTO brands (id, name, inserted_at, updated_at) VALUES (2, 'Peets', now(), now());
INSERT INTO brands (id, name, inserted_at, updated_at) VALUES (3, 'Dunkin Donuts', now(), now());
INSERT INTO brands (id, name, inserted_at, updated_at) VALUES (4, 'Intelligensia', now(), now());
INSERT INTO brands (id, name, inserted_at, updated_at) VALUES (5, 'Godiva', now(), now());

INSERT INTO accounts (id, balance, owner_id, inserted_at, updated_at) VALUES (1, 10.0, 1, now(), now());
INSERT INTO accounts (id, balance, owner_id, inserted_at, updated_at) VALUES (2, 20.0, 1, now(), now());
INSERT INTO accounts (id, balance, owner_id, inserted_at, updated_at) VALUES (3, 30.0, 1, now(), now());

INSERT INTO coupons (id, value, account_id, brand_id, inserted_at, updated_at) VALUES (1, 2.0, 1, 1, now(), now());
INSERT INTO coupons (id, value, account_id, brand_id, inserted_at, updated_at) VALUES (2, 3.0, 1, 1, now(), now());
INSERT INTO coupons (id, value, account_id, brand_id, inserted_at, updated_at) VALUES (3, 6.0, 1, 1, now(), now());

