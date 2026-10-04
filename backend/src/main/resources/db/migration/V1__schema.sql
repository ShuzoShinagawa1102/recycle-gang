CREATE TABLE customer (
    id varchar(40) PRIMARY KEY,
    display_name varchar(80) NOT NULL,
    email varchar(200) NOT NULL,
    phone varchar(30) NOT NULL
);
CREATE TABLE customer_address (
    id varchar(40) PRIMARY KEY,
    customer_id varchar(40) NOT NULL REFERENCES customer(id),
    label varchar(40) NOT NULL,
    postal_code varchar(10) NOT NULL,
    prefecture varchar(10) NOT NULL,
    address_line varchar(200) NOT NULL
);
CREATE TABLE facility (
    id varchar(40) PRIMARY KEY,
    name varchar(120) NOT NULL,
    address varchar(200) NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    instructions varchar(1000) NOT NULL
);
CREATE TABLE item_type (
    id varchar(40) PRIMARY KEY,
    name varchar(80) NOT NULL,
    unit varchar(20) NOT NULL,
    price_yen integer NOT NULL CHECK (price_yen >= 0)
);
CREATE TABLE reservation (
    id varchar(40) PRIMARY KEY,
    customer_id varchar(40) NOT NULL REFERENCES customer(id),
    client_request_id varchar(40) NOT NULL,
    request_hash varchar(64) NOT NULL,
    mode varchar(16) NOT NULL CHECK (mode IN ('PICKUP','DROPOFF')),
    status varchar(16) NOT NULL CHECK (status IN ('RESERVED','ENTERED','COMPLETED','CANCELLED')),
    facility_id varchar(40) REFERENCES facility(id),
    location_name varchar(120) NOT NULL,
    address varchar(240) NOT NULL,
    slot_start timestamp with time zone NOT NULL,
    slot_end timestamp with time zone NOT NULL,
    amount_yen integer NOT NULL CHECK (amount_yen >= 0),
    payment_status varchar(30) NOT NULL,
    note varchar(500) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    admitted_at timestamp with time zone,
    completed_at timestamp with time zone,
    UNIQUE (customer_id, client_request_id),
    CHECK (slot_end > slot_start),
    CHECK ((mode = 'DROPOFF' AND facility_id IS NOT NULL) OR (mode = 'PICKUP' AND facility_id IS NULL))
);
CREATE INDEX reservation_customer_date ON reservation(customer_id, created_at DESC);
CREATE TABLE reservation_item (
    reservation_id varchar(40) NOT NULL REFERENCES reservation(id),
    item_type_id varchar(40) NOT NULL REFERENCES item_type(id),
    name varchar(80) NOT NULL,
    quantity integer NOT NULL CHECK (quantity BETWEEN 1 AND 20),
    unit_price_yen integer NOT NULL CHECK (unit_price_yen >= 0),
    PRIMARY KEY (reservation_id, item_type_id)
);
CREATE TABLE entry_ticket (
    reservation_id varchar(40) PRIMARY KEY REFERENCES reservation(id),
    token_hash varchar(64) NOT NULL UNIQUE,
    encrypted_token varchar(300) NOT NULL,
    expires_at timestamp with time zone NOT NULL
);
CREATE TABLE admission (
    reservation_id varchar(40) PRIMARY KEY REFERENCES reservation(id),
    facility_id varchar(40) NOT NULL REFERENCES facility(id),
    manager_id varchar(40) NOT NULL,
    admitted_at timestamp with time zone NOT NULL
);
CREATE TABLE completion_photo (
    id varchar(40) PRIMARY KEY,
    reservation_id varchar(40) NOT NULL REFERENCES reservation(id),
    file_name varchar(80) NOT NULL,
    content_type varchar(40) NOT NULL,
    size bigint NOT NULL CHECK (size > 0),
    content bytea NOT NULL,
    created_at timestamp with time zone NOT NULL
);
CREATE INDEX completion_photo_reservation ON completion_photo(reservation_id);
