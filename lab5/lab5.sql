
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name text,
    last_name text,
    age integer CHECK (age BETWEEN 18 AND 65),
    salary numeric CHECK (salary > 0)
);

CREATE TABLE products_catalog (
    product_id SERIAL PRIMARY KEY,
    product_name text,
    regular_price numeric,
    discount_price numeric,
    CONSTRAINT valid_discount CHECK (
        regular_price > 0
        AND discount_price > 0
        AND discount_price < regular_price
    )
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    check_in_date date,
    check_out_date date,
    num_guests integer CHECK (num_guests BETWEEN 1 AND 10),
    CHECK (check_out_date > check_in_date)
);



INSERT INTO employees (first_name, last_name, age, salary) 
    VALUES ('Alice', 'Smith', 30, 45000.00),
        ('Bob', 'Johnson', 45, 60000.50);




INSERT INTO products_catalog (product_name, regular_price, discount_price) 
    VALUES ('Widget A', 100.00, 80.00),
        ('Gadget B', 50.00, 45.00);





INSERT INTO bookings (check_in_date, check_out_date, num_guests) 
    VALUES ('2025-06-01', '2025-06-05', 2),
    ('2025-07-10', '2025-07-12', 1);






CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    email text NOT NULL,
    phone text,
    registration_date date NOT NULL
);

CREATE TABLE inventory (
    item_id SERIAL PRIMARY KEY,
    item_name text NOT NULL,
    quantity integer NOT NULL CHECK (quantity >= 0),
    unit_price numeric NOT NULL CHECK (unit_price > 0),
    last_updated timestamp NOT NULL
);

INSERT INTO customers (email, phone, registration_date) 
    VALUES ('cust1@example.com', '555-0100', '2024-01-15'),
        ('cust2@example.com', NULL, '2024-02-20'),
        ('cust3@example.com', NULL, '2024-03-05');




INSERT INTO inventory (item_name, quantity, unit_price, last_updated) 
    VALUES ('Screwdriver', 50, 5.99, NOW()),
        ('Hammer', 20, 12.50, NOW());






CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username text,
    email text,
    created_at timestamp,
    CONSTRAINT unique_username UNIQUE (username),
    CONSTRAINT unique_email UNIQUE (email)
);

CREATE TABLE course_enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id integer,
    course_code text,
    semester text,
    CONSTRAINT uniq_student_course_semester UNIQUE (student_id, course_code, semester)
);

INSERT INTO users (username, email, created_at) 
    VALUES ('alice', 'alice@example.com', NOW()), 
        ('bob', 'bob@example.com', NOW());



INSERT INTO course_enrollments (student_id, course_code, semester) 
    VALUES (200, 'CS101', '2025-S1'),
        (201, 'CS101', '2025-S1');





CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name text NOT NULL,
    location text
);

INSERT INTO departments (dept_name, location) 
    VALUES ('Human Resources', 'Building A'),
        ('Engineering', 'Building B'),
        ('Sales', 'Building C');





CREATE TABLE student_courses (
    student_id integer,
    course_id integer,
    enrollment_date date,
    grade text,
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO student_courses (student_id, course_id, enrollment_date, grade) 
    VALUES (1000, 501, '2024-09-01', 'A'),
        (1001, 502, '2024-09-02', 'B');





CREATE TABLE employees_dept (
    emp_id SERIAL PRIMARY KEY,
    emp_name text NOT NULL,
    dept_id integer REFERENCES departments(dept_id),
    hire_date date
);

INSERT INTO employees_dept (emp_name, dept_id, hire_date) 
    VALUES ('Mary Major', 1, '2022-05-01'),
        ('John Doe', 2, '2023-01-15');



CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    author_name text NOT NULL,
    country text
);

CREATE TABLE publishers (
    publisher_id SERIAL PRIMARY KEY,
    publisher_name text NOT NULL,
    city text
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title text NOT NULL,
    author_id integer REFERENCES authors(author_id),
    publisher_id integer REFERENCES publishers(publisher_id),
    publication_year integer,
    isbn text UNIQUE
);

INSERT INTO authors (author_name, country) 
    VALUES ('Jane Austen', 'United Kingdom'), 
        ('Gabriel Garcia Marquez', 'Colombia'), 
        ('Haruki Murakami', 'Japan');

INSERT INTO publishers (publisher_name, city) 
    VALUES ('Penguin Books', 'London'), 
        ('HarperCollins', 'New York'), 
        ('Vintage', 'London');

INSERT INTO books (title, author_id, publisher_id, publication_year, isbn) 
    VALUES ('Pride and Prejudice', 1, 1, 1813, 'ISBN-0001'), 
        ('One Hundred Years of Solitude', 2, 2, 1967, 'ISBN-0002'), 
        ('Norwegian Wood', 3, 3, 1987, 'ISBN-0003');

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name text NOT NULL
);

CREATE TABLE products_fk (
    product_id SERIAL PRIMARY KEY,
    product_name text NOT NULL,
    category_id integer REFERENCES categories(category_id) ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_date date NOT NULL
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id integer REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id integer REFERENCES products_fk(product_id),
    quantity integer CHECK (quantity > 0)
);

INSERT INTO categories (category_name) VALUES ('Electronics'), ('Books');
INSERT INTO products_fk (product_name, category_id) VALUES ('Smartphone', 1), ('Novel', 2);
INSERT INTO orders (order_date) VALUES ('2025-01-10');
INSERT INTO order_items (order_id, product_id, quantity) VALUES (1, 1, 2), (1, 2, 1);

CREATE TABLE ecommerce_customers (
    customer_id SERIAL PRIMARY KEY,
    name text NOT NULL,
    email text NOT NULL UNIQUE,
    phone text,
    registration_date date NOT NULL
);

CREATE TABLE ecommerce_products (
    product_id SERIAL PRIMARY KEY,
    name text NOT NULL,
    description text,
    price numeric NOT NULL CHECK (price >= 0),
    stock_quantity integer NOT NULL CHECK (stock_quantity >= 0)
);

CREATE TABLE ecommerce_orders (
    order_id SERIAL PRIMARY KEY,
    customer_id integer REFERENCES ecommerce_customers(customer_id) ON DELETE SET NULL,
    order_date date NOT NULL,
    total_amount numeric NOT NULL CHECK (total_amount >= 0),
    status text NOT NULL CHECK (status IN ('pending','processing','shipped','delivered','cancelled'))
);

CREATE TABLE ecommerce_order_details (
    order_detail_id SERIAL PRIMARY KEY,
    order_id integer REFERENCES ecommerce_orders(order_id) ON DELETE CASCADE,
    product_id integer REFERENCES ecommerce_products(product_id),
    quantity integer NOT NULL CHECK (quantity > 0),
    unit_price numeric NOT NULL CHECK (unit_price >= 0)
);

INSERT INTO ecommerce_customers (name, email, phone, registration_date) 
	VALUES ('Alice Shopper', 'alice.shop@example.com', '555-1000', '2024-04-01'),
		('Bob Buyer', 'bob.buyer@example.com', '555-1001', '2024-04-02'),
		('Carol Consumer', 'carol.cons@example.com', NULL, '2024-04-03'),
		('David Deal', 'david.deal@example.com', '555-1003', '2024-04-04'),
		('Eve Ecom', 'eve.ecom@example.com', '555-1004', '2024-04-05');

INSERT INTO ecommerce_products (name, description, price, stock_quantity) 
	VALUES ('Wireless Mouse', 'Ergonomic wireless mouse', 25.50, 100),
			('Mechanical Keyboard', 'Blue switches keyboard', 75.00, 50),
			('USB-C Cable', '1m cable', 5.00, 500),
			('Monitor 24\"', '24-inch 1080p monitor', 150.00, 30),
			('Webcam HD', '720p webcam', 40.00, 20);

INSERT INTO ecommerce_orders (customer_id, order_date, total_amount, status) 
	VALUES (1, '2025-02-01', 56.50, 'pending'), 
			(2, '2025-02-02', 75.00, 'processing'), 
			(3, '2025-02-03', 150.00, 'shipped'), 
			(4, '2025-02-04', 5.00, 'delivered'), 
			(5, '2025-02-05', 40.00, 'cancelled');

INSERT INTO ecommerce_order_details (order_id, product_id, quantity, unit_price) 
	VALUES (1, 1, 2, 25.50),
			(2, 2, 1, 75.00),
			(3, 4, 1, 150.00),
			(4, 3, 1, 5.00),
			(5, 5, 1, 40.00);



