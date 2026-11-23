-- ================================================================
-- E-COMMERCE SALES DATABASE PROJECT
-- ================================================================
-- Contents of this file:
--   1. Database & schema creation (9 tables, with PK/FK constraints)
--   2. Sample data insertion (70-100 records per table)
--   3. Analytics query bank (52 queries; 42/52 = 80.8% use JOINs
--      and/or subqueries, satisfying the 80% requirement)
--
-- Dialect: MySQL 8.0+ (uses AUTO_INCREMENT, DATE_FORMAT, DATEDIFF,
-- window functions (RANK/SUM OVER), and CTEs (WITH ... AS)).
--
-- To run: execute this file top-to-bottom in a MySQL 8.0+ client
-- (e.g. `mysql -u root -p < ECommerce_Project.sql`) or paste into
-- MySQL Workbench / phpMyAdmin.
-- ================================================================

-- ============================================================
-- PART 1: SCHEMA CREATION
-- ============================================================

DROP DATABASE IF EXISTS ECommerceDB;
CREATE DATABASE ECommerceDB;
USE ECommerceDB;

-- ------------------------------------------------------------
-- Table: Categories
-- ------------------------------------------------------------
CREATE TABLE Categories (
    CategoryID   INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL
);

-- ------------------------------------------------------------
-- Table: Products
-- ------------------------------------------------------------
CREATE TABLE Products (
    ProductID     INT PRIMARY KEY AUTO_INCREMENT,
    ProductName   VARCHAR(150) NOT NULL,
    Price         DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL DEFAULT 0,
    CategoryID    INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- ------------------------------------------------------------
-- Table: Customers
-- ------------------------------------------------------------
CREATE TABLE Customers (
    CustomerID   INT PRIMARY KEY  ,
    CustomerName VARCHAR(100) NOT NULL,
    Email        VARCHAR(150) NOT NULL UNIQUE,
    Phone        VARCHAR(20),
    City         VARCHAR(50),
    Country      VARCHAR(50),
    JoinDate     DATE
);

-- ------------------------------------------------------------
-- Table: Orders
-- ------------------------------------------------------------
CREATE TABLE Orders (
    OrderID     INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID  INT,
    OrderDate   DATE NOT NULL,
    OrderStatus VARCHAR(20) NOT NULL DEFAULT 'Processing',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- ------------------------------------------------------------
-- Table: OrderDetails
-- ------------------------------------------------------------
CREATE TABLE OrderDetails (
    DetailID  INT PRIMARY KEY AUTO_INCREMENT,
    OrderID   INT,
    ProductID INT,
    Quantity  INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- ------------------------------------------------------------
-- Table: Reviews
-- ------------------------------------------------------------
CREATE TABLE Reviews (
    ReviewID   INT PRIMARY KEY AUTO_INCREMENT,
    ProductID  INT,
    CustomerID INT,
    Rating     INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment    VARCHAR(255),
    ReviewDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- ------------------------------------------------------------
-- Table: Shipping
-- ------------------------------------------------------------
CREATE TABLE Shipping (
    ShippingID   INT PRIMARY KEY AUTO_INCREMENT,
    OrderID      INT,
    ShipDate     DATE,
    DeliveryDate DATE,
    Carrier      VARCHAR(50),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- ------------------------------------------------------------
-- Table: Discounts
-- ------------------------------------------------------------
CREATE TABLE Discounts (
    DiscountID     INT PRIMARY KEY AUTO_INCREMENT,
    ProductID      INT,
    DiscountAmount DECIMAL(5,2) NOT NULL,
    StartDate      DATE,
    EndDate        DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- ------------------------------------------------------------
-- Table: Coupons
-- ------------------------------------------------------------
CREATE TABLE Coupons (
    CouponID       INT PRIMARY KEY AUTO_INCREMENT,
    CouponCode     VARCHAR(20) NOT NULL UNIQUE,
    DiscountAmount DECIMAL(5,2) NOT NULL,
    ExpiryDate     DATE
);


-- ============================================================
-- DATA INSERTION
-- ============================================================

-- ------------------------------------------------------------
-- Insert: Categories (80 rows)
-- ------------------------------------------------------------
INSERT INTO Categories (CategoryID, CategoryName) VALUES
(1, 'Men''s Sports & Outdoors'),
(2, 'Premium Automotive'),
(3, 'Kids'' Grocery'),
(4, 'Classic Sports & Outdoors'),
(5, 'Seasonal Home & Kitchen'),
(6, 'Men''s Garden & Outdoor'),
(7, 'Women''s Electronics'),
(8, 'Premium Books'),
(9, 'Classic Electronics'),
(10, 'Classic Books'),
(11, 'Premium Garden & Outdoor'),
(12, 'Seasonal Footwear'),
(13, 'Men''s Automotive'),
(14, 'Indoor Toys & Games'),
(15, 'Budget Furniture'),
(16, 'Premium Beauty & Personal Care'),
(17, 'Women''s Furniture'),
(18, 'Indoor Home & Kitchen'),
(19, 'Outdoor Sports & Outdoors'),
(20, 'Seasonal Office Supplies'),
(21, 'Classic Footwear'),
(22, 'Indoor Sports & Outdoors'),
(23, 'Classic Home & Kitchen'),
(24, 'Seasonal Health & Wellness'),
(25, 'Women''s Books'),
(26, 'Premium Clothing'),
(27, 'Women''s Health & Wellness'),
(28, 'Women''s Grocery'),
(29, 'Budget Pet Supplies'),
(30, 'Outdoor Footwear'),
(31, 'Outdoor Toys & Games'),
(32, 'Premium Office Supplies'),
(33, 'Women''s Automotive'),
(34, 'Classic Toys & Games'),
(35, 'Indoor Footwear'),
(36, 'Classic Automotive'),
(37, 'Outdoor Grocery'),
(38, 'Outdoor Clothing'),
(39, 'Premium Home & Kitchen'),
(40, 'Premium Furniture'),
(41, 'Indoor Jewelry & Watches'),
(42, 'Kids'' Footwear'),
(43, 'Kids'' Automotive'),
(44, 'Classic Grocery'),
(45, 'Seasonal Automotive'),
(46, 'Seasonal Garden & Outdoor'),
(47, 'Outdoor Pet Supplies'),
(48, 'Women''s Jewelry & Watches'),
(49, 'Women''s Clothing'),
(50, 'Kids'' Beauty & Personal Care'),
(51, 'Seasonal Pet Supplies'),
(52, 'Outdoor Automotive'),
(53, 'Budget Sports & Outdoors'),
(54, 'Kids'' Garden & Outdoor'),
(55, 'Men''s Footwear'),
(56, 'Kids'' Books'),
(57, 'Kids'' Office Supplies'),
(58, 'Seasonal Electronics'),
(59, 'Smart Furniture'),
(60, 'Budget Office Supplies'),
(61, 'Men''s Grocery'),
(62, 'Seasonal Grocery'),
(63, 'Women''s Home & Kitchen'),
(64, 'Classic Jewelry & Watches'),
(65, 'Budget Toys & Games'),
(66, 'Budget Books'),
(67, 'Women''s Footwear'),
(68, 'Premium Grocery'),
(69, 'Outdoor Home & Kitchen'),
(70, 'Men''s Home & Kitchen'),
(71, 'Budget Grocery'),
(72, 'Premium Jewelry & Watches'),
(73, 'Seasonal Beauty & Personal Care'),
(74, 'Indoor Office Supplies'),
(75, 'Smart Garden & Outdoor'),
(76, 'Indoor Clothing'),
(77, 'Smart Automotive'),
(78, 'Men''s Pet Supplies'),
(79, 'Indoor Electronics'),
(80, 'Indoor Health & Wellness');

-- ------------------------------------------------------------
-- Insert: Products (85 rows)
-- ------------------------------------------------------------
INSERT INTO Products (ProductID, ProductName, Price, StockQuantity, CategoryID) VALUES
(1, 'Heavy-Duty Necklace', 597.7, 249, 20),
(2, 'Deluxe Mouse', 200.61, 29, 75),
(3, 'Heavy-Duty Ring', 60.49, 160, 8),
(4, 'Wireless Vacuum Cleaner', 455.54, 436, 68),
(5, 'Compact Desk Lamp', 864.93, 41, 24),
(6, 'Portable Running Shoes', 609.63, 120, 52),
(7, 'Portable Air Fryer', 523.54, 20, 80),
(8, 'Portable Puzzle', 593.68, 289, 67),
(9, 'Rechargeable Camera', 188.6, 366, 41),
(10, 'Deluxe Camera', 359.82, 343, 39),
(11, 'Waterproof Sofa', 836.53, 479, 10),
(12, 'Wireless Garden Hose', 561.31, 288, 13),
(13, 'Portable Ring', 196.55, 135, 17),
(14, 'Adjustable Cat Tree', 793.48, 450, 32),
(15, 'Rechargeable Mouse', 147.02, 426, 70),
(16, 'Heavy-Duty Monitor Stand', 552.83, 413, 68),
(17, 'Wireless Necklace', 273.63, 339, 14),
(18, 'Adjustable Office Chair', 242.42, 455, 14),
(19, 'Heavy-Duty Necklace', 144.96, 144, 78),
(20, 'Deluxe Dining Table', 188.01, 324, 34),
(21, 'Foldable Umbrella', 230.49, 464, 7),
(22, 'Portable Novel', 747.43, 22, 1),
(23, 'Rechargeable Office Chair', 575.57, 134, 21),
(24, 'Heavy-Duty Cookware Set', 499.19, 218, 72),
(25, 'Wireless Bluetooth Speaker', 73.26, 452, 20),
(26, 'Foldable Backpack', 752.12, 298, 71),
(27, 'Compact Novel', 119.93, 157, 47),
(28, 'Adjustable Backpack', 809.63, 107, 32),
(29, 'Smart Yoga Mat', 322.18, 286, 53),
(30, 'Classic Water Bottle', 833.62, 121, 21),
(31, 'Ultra-Light Backpack Cooler', 793.98, 12, 23),
(32, 'Heavy-Duty Dining Table', 705.44, 210, 32),
(33, 'Eco-Friendly Sunglasses', 709.9, 55, 49),
(34, 'Premium Backpack', 773.57, 113, 26),
(35, 'Premium Garden Hose', 318.58, 420, 30),
(36, 'Deluxe Blender', 596.06, 204, 43),
(37, 'Eco-Friendly Running Shoes', 870.39, 142, 45),
(38, 'Smart Wallet', 363.3, 431, 69),
(39, 'Rechargeable Blender', 109.11, 496, 34),
(40, 'Compact Camera', 40.19, 305, 56),
(41, 'Rechargeable Sofa', 396.13, 261, 15),
(42, 'Ergonomic Watch', 233.71, 362, 56),
(43, 'Wireless Handbag', 833.45, 275, 26),
(44, 'Rechargeable Novel', 68.55, 340, 43),
(45, 'Classic Sofa', 599.06, 63, 39),
(46, 'Foldable Monitor Stand', 602.19, 167, 52),
(47, 'Heavy-Duty Mouse', 501.63, 98, 54),
(48, 'Smart Skincare Kit', 611.51, 462, 23),
(49, 'Classic Monitor Stand', 369.02, 426, 1),
(50, 'Eco-Friendly Mouse', 193.89, 402, 75),
(51, 'Classic Sofa', 421.69, 226, 28),
(52, 'Foldable Vacuum Cleaner', 715.59, 491, 22),
(53, 'Smart Coffee Maker', 259.7, 339, 80),
(54, 'Rechargeable Coffee Maker', 737.66, 384, 31),
(55, 'Smart Monitor Stand', 206.82, 101, 19),
(56, 'Wireless Backpack', 224.88, 243, 79),
(57, 'Premium Running Shoes', 413.13, 453, 74),
(58, 'Deluxe Skincare Kit', 447.96, 124, 19),
(59, 'Smart Headphones', 804.03, 440, 14),
(60, 'Ultra-Light Novel', 201.63, 411, 67),
(61, 'Waterproof Desk Lamp', 504.31, 469, 16),
(62, 'Waterproof Office Chair', 722.46, 341, 68),
(63, 'Foldable Sofa', 855.33, 456, 57),
(64, 'Classic Wallet', 387.5, 464, 71),
(65, 'Waterproof Sunglasses', 670.82, 243, 58),
(66, 'Eco-Friendly Air Fryer', 756.83, 141, 67),
(67, 'Waterproof Air Fryer', 251.48, 39, 37),
(68, 'Deluxe Keyboard', 306.24, 457, 70),
(69, 'Portable Office Chair', 140.83, 196, 20),
(70, 'Heavy-Duty Notebook Set', 63.41, 208, 43),
(71, 'Foldable Garden Hose', 377.69, 105, 54),
(72, 'Ergonomic Blender', 771.91, 391, 74),
(73, 'Ergonomic Vacuum Cleaner', 11.26, 180, 39),
(74, 'Ultra-Light Skincare Kit', 768.97, 488, 54),
(75, 'Foldable Ring', 721.07, 459, 29),
(76, 'Waterproof Toolkit', 249.99, 248, 4),
(77, 'Ergonomic Dining Table', 603.96, 408, 52),
(78, 'Heavy-Duty Sunglasses', 757.4, 470, 17),
(79, 'Classic Ring', 30.1, 201, 76),
(80, 'Classic Blender', 81.04, 219, 18),
(81, 'Premium Garden Hose', 168.46, 133, 49),
(82, 'Rechargeable Notebook Set', 412.49, 172, 49),
(83, 'Eco-Friendly Puzzle', 231.52, 41, 61),
(84, 'Wireless Ring', 52.55, 487, 45),
(85, 'Deluxe Running Shoes', 704.41, 333, 6);

-- ------------------------------------------------------------
-- Insert: Customers (85 rows)
-- ------------------------------------------------------------
INSERT INTO Customers (CustomerID, CustomerName, Email, Phone, City, Country, JoinDate) VALUES
(1, 'Allison Hill', 'donaldgarcia@example.net', '+1-219-560-0133', 'Mexico City', 'Mexico', '2024-07-30'),
(2, 'Jennifer Cole', 'lisa02@example.net', '(254)923-5116x15594', 'Toronto', 'Canada', '2023-09-06'),
(3, 'Jamie Arnold', 'barbara10@example.net', '441.731.6475', 'Rome', 'Italy', '2022-10-11'),
(4, 'Mia Sutton', 'lynchgeorge@example.net', '527.264.8350', 'Dubai', 'United Arab Emirates', '2025-01-09'),
(5, 'Austin Gentry', 'jason76@example.net', '724.523.8849x696', 'Toronto', 'Canada', '2025-12-26'),
(6, 'Johnny Campos', 'hernandezernest@example.net', '(791)366-9784x80184', 'Sao Paulo', 'Brazil', '2022-06-20'),
(7, 'Aaron Bowen', 'teresa28@example.org', '+1-948-293-2528x8095', 'Dubai', 'United Arab Emirates', '2021-07-24'),
(8, 'William Roman', 'brianhumphrey@example.org', '671-882-2782', 'Rio de Janeiro', 'Brazil', '2025-10-26'),
(9, 'Nicole Vaughn', 'raymond57@example.net', '213.331.5098x393', 'Guadalajara', 'Mexico', '2024-07-15'),
(10, 'Austin Johnson', 'chad34@example.net', '838.729.9737x6311', 'Pune', 'India', '2023-02-13'),
(11, 'Nicholas Nunez', 'brownjessica@example.org', '933.587.2624', 'Dubai', 'United Arab Emirates', '2025-05-15'),
(12, 'Robert Chase', 'williamsyvette@example.org', '432-867-7360', 'Mexico City', 'Mexico', '2021-01-04'),
(13, 'Timothy Glover', 'rodney87@example.org', '243.909.8050', 'Sydney', 'Australia', '2023-07-07'),
(14, 'Brooke Yu', 'yorkcasey@example.org', '+1-736-619-3990x9169', 'Dubai', 'United Arab Emirates', '2022-01-08'),
(15, 'Cynthia Foster', 'stephen10@example.com', '+1-791-618-3842x513', 'Rotterdam', 'Netherlands', '2021-10-15'),
(16, 'Michele Carr', 'contrerasangela@example.net', '524-711-8244', 'Abu Dhabi', 'United Arab Emirates', '2022-01-07'),
(17, 'Deborah Freeman', 'davisrodney@example.com', '2053242786', 'Marseille', 'France', '2021-05-18'),
(18, 'Stephanie Gardner', 'brandi26@example.org', '8454053315', 'Toronto', 'Canada', '2025-08-17'),
(19, 'Christopher Marsh', 'nicolejohnson@example.net', '563-542-1607x33754', 'Dubai', 'United Arab Emirates', '2021-02-13'),
(20, 'Garrett Lin', 'michael86@example.net', '+1-350-814-2940', 'Birmingham', 'United Kingdom', '2022-09-23'),
(21, 'Jessica Joyce', 'cruzbarbara@example.com', '7607883561', 'Rome', 'Italy', '2024-04-25'),
(22, 'Steven Hunter', 'snguyen@example.com', '+1-823-266-2994', 'Mexico City', 'Mexico', '2022-07-09'),
(23, 'Richard Lawson', 'steven73@example.net', '221.248.9513x4332', 'Hamburg', 'Germany', '2022-03-23'),
(24, 'Samuel Jones', 'kmercado@example.org', '001-967-263-2016x328', 'Marseille', 'France', '2023-10-15'),
(25, 'Barbara Anderson', 'jcontreras@example.net', '979-586-8727x74348', 'Berlin', 'Germany', '2022-05-17'),
(26, 'Dustin Nelson', 'patricia12@example.org', '962.831.6658', 'Osaka', 'Japan', '2021-04-24'),
(27, 'Jean Carrillo', 'gateskathy@example.com', '805.946.6889x3734', 'Houston', 'United States', '2021-02-22'),
(28, 'Michael Powell', 'marycalhoun@example.net', '+1-906-499-0162', 'Milan', 'Italy', '2021-04-02'),
(29, 'Daniel Murphy', 'aramirez@example.com', '270-580-5310', 'Leeds', 'United Kingdom', '2021-12-30'),
(30, 'Christian Martinez', 'elliottjeffery@example.net', '852-899-1241x904', 'Hamburg', 'Germany', '2025-09-15'),
(31, 'Kevin Rivas', 'curtisbarton@example.net', '+1-819-905-8651x850', 'Rotterdam', 'Netherlands', '2021-07-12'),
(32, 'Madison Poole', 'ryangross@example.net', '998-577-6945x314', 'Johannesburg', 'South Africa', '2024-10-01'),
(33, 'Mary Rogers', 'lrosales@example.com', '554.354.9480', 'Paris', 'France', '2022-03-17'),
(34, 'Justin Allen', 'fbrewer@example.com', '9147363495', 'Cape Town', 'South Africa', '2023-02-16'),
(35, 'Erin Warner', 'kristopher31@example.net', '651.382.3374', 'Abu Dhabi', 'United Arab Emirates', '2025-02-28'),
(36, 'Isaac Turner', 'joshuamccann@example.net', '627-910-9477x7520', 'Rio de Janeiro', 'Brazil', '2021-07-28'),
(37, 'John Ray', 'hernandezlisa@example.com', '831-986-9993', 'Milan', 'Italy', '2025-07-17'),
(38, 'Kevin Patterson', 'lynchjody@example.org', '+1-934-612-3281x2067', 'Berlin', 'Germany', '2021-03-01'),
(39, 'Douglas Heath', 'mcdanielsandra@example.net', '001-336-218-3242', 'Rome', 'Italy', '2021-10-30'),
(40, 'Paul Carroll', 'scott74@example.net', '(248)387-7190x6594', 'Melbourne', 'Australia', '2022-02-22'),
(41, 'Shannon Matthews', 'keyemily@example.com', '001-802-978-7429', 'Vancouver', 'Canada', '2025-11-04'),
(42, 'Jason Morris', 'hodgemark@example.net', '246.980.7154x5168', 'Abu Dhabi', 'United Arab Emirates', '2023-01-25'),
(43, 'Isaiah Avila', 'nwolf@example.com', '+1-424-677-1093', 'Berlin', 'Germany', '2023-10-03'),
(44, 'Anna Gay', 'murraydavid@example.org', '448.346.7737x8263', 'Rio de Janeiro', 'Brazil', '2022-05-20'),
(45, 'Jennifer Villa', 'lori44@example.net', '001-872-978-7558', 'Chennai', 'India', '2025-08-30'),
(46, 'Veronica Allen', 'xhall@example.com', '7573662702', 'Vancouver', 'Canada', '2025-05-15'),
(47, 'Joseph Bryant', 'robertpena@example.org', '874-759-6158', 'Guadalajara', 'Mexico', '2024-02-18'),
(48, 'Katherine Weaver', 'younggabrielle@example.com', '216.711.7240', 'Munich', 'Germany', '2024-12-23'),
(49, 'James Thomas', 'yknight@example.org', '(421)596-9379', 'Rotterdam', 'Netherlands', '2023-04-22'),
(50, 'David Smith', 'rsantana@example.net', '(617)559-4647', 'Tokyo', 'Japan', '2025-12-29'),
(51, 'Ashley James', 'bailey40@example.net', '(640)490-9743x9533', 'Tokyo', 'Japan', '2024-02-21'),
(52, 'Maria Parker', 'xjohnson@example.net', '(714)656-2328', 'Manchester', 'United Kingdom', '2025-02-24'),
(53, 'Roger Olson', 'julie51@example.com', '623-368-5160', 'Cape Town', 'South Africa', '2023-04-10'),
(54, 'Megan Richards', 'daniel37@example.org', '+1-285-693-1746x120', 'Sao Paulo', 'Brazil', '2025-12-23'),
(55, 'David Medina', 'qchavez@example.net', '001-786-592-6179x640', 'Cape Town', 'South Africa', '2023-03-21'),
(56, 'Savannah Garcia', 'amy50@example.com', '531-371-3900x532', 'Singapore', 'Singapore', '2025-02-23'),
(57, 'Laurie Li', 'markhernandez@example.net', '4422284210', 'Sao Paulo', 'Brazil', '2022-10-16'),
(58, 'Leah Smith', 'brian68@example.org', '001-617-975-8917x839', 'Birmingham', 'United Kingdom', '2024-03-20'),
(59, 'Zachary Boone', 'fparks@example.net', '711.859.2124x998', 'Vancouver', 'Canada', '2025-12-21'),
(60, 'Jody Jacobs', 'mcguiredanny@example.net', '+1-883-767-3657x6615', 'Johannesburg', 'South Africa', '2024-04-28'),
(61, 'Christian Leblanc', 'davischristopher@example.com', '352-880-9885', 'Brisbane', 'Australia', '2022-10-08'),
(62, 'Nicole Parrish', 'schmittcaroline@example.com', '798-332-7315', 'Abu Dhabi', 'United Arab Emirates', '2024-10-23'),
(63, 'Renee Bruce', 'lynchdiane@example.net', '302-444-5502x296', 'Rio de Janeiro', 'Brazil', '2024-09-14'),
(64, 'Anna Moreno', 'vbarnes@example.org', '(645)999-1022x901', 'Marseille', 'France', '2024-04-23'),
(65, 'Mr. Donald Fischer', 'reeddaniel@example.net', '+1-497-684-0369x0034', 'Osaka', 'Japan', '2022-06-13'),
(66, 'Jonathan Jordan', 'omarpadilla@example.net', '+1-751-860-6071', 'Hamburg', 'Germany', '2023-11-13'),
(67, 'Jennifer Wilson', 'burchgeorge@example.net', '651.761.3696x816', 'Rio de Janeiro', 'Brazil', '2022-02-09'),
(68, 'Angela Schultz', 'rebeccabailey@example.net', '+1-923-912-4329x2127', 'Melbourne', 'Australia', '2024-05-28'),
(69, 'Maria Downs', 'michelle52@example.com', '377-644-9058', 'Toronto', 'Canada', '2023-04-23'),
(70, 'Jacob Mitchell', 'gilbertwilliam@example.com', '001-480-279-3597', 'Johannesburg', 'South Africa', '2023-04-03'),
(71, 'Sara Haas', 'wagnergerald@example.org', '001-777-288-9255x466', 'Berlin', 'Germany', '2024-12-11'),
(72, 'Andrea Davis', 'umitchell@example.net', '+1-625-819-2546x291', 'Johannesburg', 'South Africa', '2024-03-20'),
(73, 'Carl Warner', 'lucasrodney@example.com', '4544235733', 'Toronto', 'Canada', '2021-05-21'),
(74, 'Ashley Wise', 'stanleynancy@example.net', '(296)822-2927', 'Cape Town', 'South Africa', '2022-10-27'),
(75, 'Tracy Bishop', 'pyoung@example.com', '435.697.7468x8623', 'Brisbane', 'Australia', '2021-04-06'),
(76, 'Mr. Timothy Dawson', 'mitchellkathryn@example.com', '782.561.3750x606', 'Abu Dhabi', 'United Arab Emirates', '2022-12-06'),
(77, 'Danny Flores', 'combsdebra@example.org', '(304)272-7790', 'Manchester', 'United Kingdom', '2022-04-13'),
(78, 'Kimberly Acosta', 'srodriguez@example.org', '510-436-9711x7980', 'Sydney', 'Australia', '2022-06-16'),
(79, 'Harry Duncan', 'elizabethmiller@example.com', '288-888-8067', 'Berlin', 'Germany', '2025-11-26'),
(80, 'Alan Kramer', 'john19@example.net', '001-252-605-8527x722', 'Sydney', 'Australia', '2022-01-03'),
(81, 'Stacey Stewart', 'zachary87@example.com', '8348505415', 'Johannesburg', 'South Africa', '2024-09-18'),
(82, 'Jasmine Beltran', 'xholt@example.net', '716-616-9284x511', 'Sydney', 'Australia', '2022-07-14'),
(83, 'Jessica Norris', 'sergio59@example.com', '401-365-8202x970', 'Seattle', 'United States', '2022-03-07'),
(84, 'Heidi Herring', 'jacobserika@example.com', '(271)492-8565x431', 'Brisbane', 'Australia', '2023-06-30'),
(85, 'Justin Green', 'jane39@example.com', '001-373-612-1727x155', 'Chennai', 'India', '2025-06-15');

-- ------------------------------------------------------------
-- Insert: Orders (90 rows)
-- ------------------------------------------------------------
INSERT INTO Orders (OrderID, CustomerID, OrderDate, OrderStatus) VALUES
(1, 14, '2026-01-17', 'Cancelled'),
(2, 74, '2025-07-19', 'Delivered'),
(3, 62, '2026-04-27', 'Delivered'),
(4, 24, '2025-04-13', 'Returned'),
(5, 33, '2025-11-03', 'Returned'),
(6, 62, '2024-10-26', 'Delivered'),
(7, 9, '2023-06-08', 'Delivered'),
(8, 10, '2023-09-20', 'Shipped'),
(9, 7, '2023-07-01', 'Delivered'),
(10, 73, '2025-10-30', 'Returned'),
(11, 11, '2023-02-04', 'Returned'),
(12, 16, '2024-12-25', 'Shipped'),
(13, 54, '2024-04-27', 'Shipped'),
(14, 80, '2025-11-16', 'Delivered'),
(15, 67, '2024-12-22', 'Delivered'),
(16, 57, '2025-03-10', 'Delivered'),
(17, 76, '2023-04-23', 'Returned'),
(18, 40, '2024-02-09', 'Shipped'),
(19, 8, '2026-07-30', 'Shipped'),
(20, 13, '2025-07-28', 'Returned'),
(21, 27, '2024-11-18', 'Shipped'),
(22, 34, '2025-10-02', 'Shipped'),
(23, 21, '2025-12-12', 'Delivered'),
(24, 71, '2023-04-07', 'Delivered'),
(25, 1, '2026-06-24', 'Delivered'),
(26, 77, '2025-04-19', 'Delivered'),
(27, 5, '2024-08-11', 'Delivered'),
(28, 37, '2025-06-07', 'Shipped'),
(29, 59, '2024-03-26', 'Delivered'),
(30, 30, '2026-02-21', 'Cancelled'),
(31, 81, '2025-10-16', 'Shipped'),
(32, 26, '2025-04-16', 'Delivered'),
(33, 70, '2023-08-26', 'Delivered'),
(34, 20, '2026-06-16', 'Cancelled'),
(35, 19, '2024-07-19', 'Delivered'),
(36, 22, '2026-04-05', 'Processing'),
(37, 77, '2023-03-14', 'Shipped'),
(38, 73, '2023-06-12', 'Cancelled'),
(39, 57, '2023-07-19', 'Delivered'),
(40, 39, '2023-08-04', 'Shipped'),
(41, 35, '2024-02-26', 'Delivered'),
(42, 64, '2025-07-16', 'Delivered'),
(43, 77, '2024-03-28', 'Delivered'),
(44, 56, '2026-05-14', 'Shipped'),
(45, 78, '2026-03-15', 'Delivered'),
(46, 12, '2026-01-10', 'Delivered'),
(47, 74, '2023-11-24', 'Shipped'),
(48, 3, '2025-04-10', 'Returned'),
(49, 35, '2024-12-20', 'Shipped'),
(50, 23, '2023-06-13', 'Delivered'),
(51, 84, '2024-01-31', 'Delivered'),
(52, 36, '2024-11-28', 'Delivered'),
(53, 75, '2024-10-18', 'Delivered'),
(54, 63, '2023-08-09', 'Returned'),
(55, 61, '2026-05-15', 'Delivered'),
(56, 43, '2023-07-21', 'Delivered'),
(57, 14, '2025-05-10', 'Cancelled'),
(58, 43, '2025-07-30', 'Delivered'),
(59, 64, '2025-03-01', 'Delivered'),
(60, 52, '2026-01-06', 'Processing'),
(61, 71, '2025-01-06', 'Delivered'),
(62, 12, '2025-12-14', 'Delivered'),
(63, 42, '2023-02-07', 'Delivered'),
(64, 52, '2023-03-01', 'Cancelled'),
(65, 1, '2025-04-18', 'Shipped'),
(66, 70, '2025-01-23', 'Delivered'),
(67, 7, '2025-05-01', 'Delivered'),
(68, 47, '2025-09-29', 'Shipped'),
(69, 64, '2024-06-28', 'Shipped'),
(70, 7, '2025-04-15', 'Delivered'),
(71, 71, '2024-10-12', 'Delivered'),
(72, 37, '2025-03-30', 'Delivered'),
(73, 63, '2024-01-14', 'Delivered'),
(74, 81, '2026-06-04', 'Shipped'),
(75, 31, '2024-09-23', 'Shipped'),
(76, 40, '2025-11-17', 'Shipped'),
(77, 71, '2025-06-14', 'Delivered'),
(78, 29, '2024-01-24', 'Returned'),
(79, 15, '2023-04-06', 'Delivered'),
(80, 16, '2023-03-20', 'Shipped'),
(81, 20, '2024-07-28', 'Delivered'),
(82, 38, '2024-09-24', 'Delivered'),
(83, 35, '2023-09-24', 'Delivered'),
(84, 62, '2025-03-03', 'Returned'),
(85, 32, '2024-02-13', 'Delivered'),
(86, 19, '2025-07-27', 'Delivered'),
(87, 77, '2025-08-17', 'Delivered'),
(88, 18, '2026-01-30', 'Cancelled'),
(89, 36, '2026-06-28', 'Processing'),
(90, 54, '2023-06-20', 'Delivered');

-- ------------------------------------------------------------
-- Insert: OrderDetails (100 rows)
-- ------------------------------------------------------------
INSERT INTO OrderDetails (DetailID, OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 38, 3, 363.3),
(2, 2, 48, 4, 611.51),
(3, 3, 19, 2, 144.96),
(4, 4, 68, 4, 306.24),
(5, 5, 73, 2, 11.26),
(6, 6, 22, 2, 747.43),
(7, 7, 11, 5, 836.53),
(8, 8, 49, 5, 369.02),
(9, 9, 31, 4, 793.98),
(10, 10, 75, 2, 721.07),
(11, 11, 30, 4, 833.62),
(12, 12, 82, 3, 412.49),
(13, 13, 59, 3, 804.03),
(14, 14, 2, 4, 200.61),
(15, 15, 37, 5, 870.39),
(16, 16, 21, 1, 230.49),
(17, 17, 57, 3, 413.13),
(18, 18, 76, 3, 249.99),
(19, 19, 82, 4, 412.49),
(20, 20, 33, 4, 709.9),
(21, 21, 39, 2, 109.11),
(22, 22, 50, 4, 193.89),
(23, 23, 14, 2, 793.48),
(24, 24, 49, 5, 369.02),
(25, 25, 46, 5, 602.19),
(26, 26, 38, 3, 363.3),
(27, 27, 3, 4, 60.49),
(28, 28, 36, 1, 596.06),
(29, 29, 73, 1, 11.26),
(30, 30, 78, 4, 757.4),
(31, 31, 37, 2, 870.39),
(32, 32, 78, 3, 757.4),
(33, 33, 29, 2, 322.18),
(34, 34, 80, 3, 81.04),
(35, 35, 85, 2, 704.41),
(36, 36, 81, 1, 168.46),
(37, 37, 81, 1, 168.46),
(38, 38, 40, 4, 40.19),
(39, 39, 5, 5, 864.93),
(40, 40, 47, 2, 501.63),
(41, 41, 12, 3, 561.31),
(42, 42, 42, 4, 233.71),
(43, 43, 23, 2, 575.57),
(44, 44, 17, 5, 273.63),
(45, 45, 47, 5, 501.63),
(46, 46, 65, 3, 670.82),
(47, 47, 22, 3, 747.43),
(48, 48, 62, 3, 722.46),
(49, 49, 44, 1, 68.55),
(50, 50, 60, 1, 201.63),
(51, 51, 19, 2, 144.96),
(52, 52, 51, 5, 421.69),
(53, 53, 47, 1, 501.63),
(54, 54, 51, 1, 421.69),
(55, 55, 34, 5, 773.57),
(56, 56, 16, 4, 552.83),
(57, 57, 48, 3, 611.51),
(58, 58, 75, 4, 721.07),
(59, 59, 82, 3, 412.49),
(60, 60, 14, 2, 793.48),
(61, 61, 61, 1, 504.31),
(62, 62, 80, 5, 81.04),
(63, 63, 42, 5, 233.71),
(64, 64, 29, 1, 322.18),
(65, 65, 82, 4, 412.49),
(66, 66, 39, 4, 109.11),
(67, 67, 15, 2, 147.02),
(68, 68, 6, 1, 609.63),
(69, 69, 39, 4, 109.11),
(70, 70, 15, 1, 147.02),
(71, 71, 31, 5, 793.98),
(72, 72, 18, 4, 242.42),
(73, 73, 59, 3, 804.03),
(74, 74, 70, 4, 63.41),
(75, 75, 76, 2, 249.99),
(76, 76, 54, 1, 737.66),
(77, 77, 63, 5, 855.33),
(78, 78, 53, 3, 259.7),
(79, 79, 5, 3, 864.93),
(80, 80, 28, 4, 809.63),
(81, 81, 57, 2, 413.13),
(82, 82, 47, 1, 501.63),
(83, 83, 48, 5, 611.51),
(84, 84, 83, 3, 231.52),
(85, 85, 8, 4, 593.68),
(86, 86, 36, 2, 596.06),
(87, 87, 16, 4, 552.83),
(88, 88, 12, 2, 561.31),
(89, 89, 83, 5, 231.52),
(90, 90, 3, 1, 60.49),
(91, 43, 43, 2, 833.45),
(92, 32, 77, 1, 603.96),
(93, 17, 36, 2, 596.06),
(94, 73, 17, 5, 273.63),
(95, 27, 33, 2, 709.9),
(96, 9, 15, 1, 147.02),
(97, 71, 17, 1, 273.63),
(98, 76, 46, 2, 602.19),
(99, 28, 76, 3, 249.99),
(100, 30, 3, 2, 60.49);

-- ------------------------------------------------------------
-- Insert: Reviews (80 rows)
-- ------------------------------------------------------------
INSERT INTO Reviews (ReviewID, ProductID, CustomerID, Rating, Comment, ReviewDate) VALUES
(1, 82, 64, 4, 'Poor customer service experience.', '2024-04-29'),
(2, 36, 76, 4, 'Highly recommend to everyone.', '2025-01-04'),
(3, 66, 76, 1, 'Highly recommend to everyone.', '2024-02-22'),
(4, 79, 6, 5, 'Arrived damaged, had to return it.', '2024-09-02'),
(5, 4, 8, 4, 'Five stars, no complaints at all.', '2023-12-16'),
(6, 15, 7, 1, 'Highly recommend to everyone.', '2023-11-21'),
(7, 57, 10, 1, 'Amazing product, will buy again!', '2023-05-07'),
(8, 9, 17, 3, 'Fast shipping and great packaging.', '2024-01-15'),
(9, 71, 42, 4, 'Fast shipping and great packaging.', '2024-05-17'),
(10, 59, 65, 5, 'Average quality, does the job.', '2025-03-15'),
(11, 82, 16, 1, 'Five stars, no complaints at all.', '2023-11-21'),
(12, 71, 28, 4, 'Highly recommend to everyone.', '2026-02-05'),
(13, 53, 44, 4, 'Average quality, does the job.', '2023-07-28'),
(14, 31, 71, 3, 'Average quality, does the job.', '2024-03-04'),
(15, 29, 70, 3, 'Not what I expected, quite disappointing.', '2025-01-25'),
(16, 61, 9, 1, 'Five stars, no complaints at all.', '2024-02-14'),
(17, 48, 14, 1, 'Perfect gift idea, loved it.', '2025-09-25'),
(18, 17, 72, 1, 'Fast shipping and great packaging.', '2024-10-13'),
(19, 72, 43, 1, 'Average quality, does the job.', '2024-11-04'),
(20, 33, 5, 4, 'Five stars, no complaints at all.', '2024-10-14'),
(21, 7, 37, 5, 'Arrived damaged, had to return it.', '2024-02-08'),
(22, 85, 19, 5, 'Works as described, very happy.', '2023-01-31'),
(23, 59, 54, 2, 'Five stars, no complaints at all.', '2026-05-21'),
(24, 38, 77, 3, 'Good value for the price.', '2024-10-23'),
(25, 74, 29, 4, 'Five stars, no complaints at all.', '2026-06-18'),
(26, 80, 79, 5, 'Excellent quality, exceeded my expectations!', '2023-10-09'),
(27, 85, 35, 1, 'Not what I expected, quite disappointing.', '2024-04-06'),
(28, 30, 11, 3, 'Not durable, would not buy again.', '2023-03-08'),
(29, 33, 13, 2, 'Five stars, no complaints at all.', '2024-10-09'),
(30, 8, 32, 4, 'Good value for the price.', '2026-02-28'),
(31, 78, 30, 1, 'Good value for the price.', '2025-05-05'),
(32, 28, 49, 4, 'Highly recommend to everyone.', '2024-09-07'),
(33, 82, 1, 3, 'Perfect gift idea, loved it.', '2024-12-02'),
(34, 36, 37, 5, 'Good value for the price.', '2026-01-13'),
(35, 20, 21, 5, 'Excellent quality, exceeded my expectations!', '2024-07-17'),
(36, 35, 57, 4, 'Highly recommend to everyone.', '2026-02-28'),
(37, 54, 35, 2, 'Could be better for the price.', '2025-08-09'),
(38, 45, 56, 1, 'Arrived damaged, had to return it.', '2025-09-26'),
(39, 76, 63, 5, 'The product broke after a week.', '2024-04-23'),
(40, 28, 16, 4, 'Fast shipping and great packaging.', '2024-06-07'),
(41, 36, 19, 3, 'Works as described, very happy.', '2025-01-15'),
(42, 33, 38, 3, 'Good value for the price.', '2023-09-12'),
(43, 38, 14, 4, 'Not what I expected, quite disappointing.', '2024-12-24'),
(44, 83, 36, 2, 'Poor customer service experience.', '2023-04-07'),
(45, 46, 10, 4, 'Five stars, no complaints at all.', '2024-10-21'),
(46, 56, 3, 4, 'Not durable, would not buy again.', '2025-09-26'),
(47, 42, 42, 5, 'Average quality, does the job.', '2024-01-01'),
(48, 82, 54, 3, 'Good value for the price.', '2026-07-17'),
(49, 75, 73, 2, 'Could be better for the price.', '2025-06-08'),
(50, 59, 47, 1, 'Average quality, does the job.', '2023-06-05'),
(51, 32, 56, 5, 'Average quality, does the job.', '2026-06-29'),
(52, 51, 40, 3, 'Works as described, very happy.', '2024-05-30'),
(53, 17, 71, 1, 'Poor customer service experience.', '2025-11-05'),
(54, 68, 66, 2, 'Not durable, would not buy again.', '2024-03-19'),
(55, 45, 83, 2, 'Works as described, very happy.', '2026-05-13'),
(56, 29, 70, 2, 'Not what I expected, quite disappointing.', '2025-09-14'),
(57, 84, 10, 2, 'Could be better for the price.', '2023-09-18'),
(58, 60, 73, 5, 'Highly recommend to everyone.', '2024-10-27'),
(59, 73, 83, 5, 'Amazing product, will buy again!', '2024-10-16'),
(60, 81, 41, 2, 'Highly recommend to everyone.', '2023-03-01'),
(61, 60, 23, 3, 'Could be better for the price.', '2023-06-29'),
(62, 19, 62, 3, 'Poor customer service experience.', '2024-03-11'),
(63, 42, 64, 4, 'Excellent quality, exceeded my expectations!', '2024-09-11'),
(64, 76, 31, 1, 'The product broke after a week.', '2024-08-20'),
(65, 12, 79, 5, 'Poor customer service experience.', '2025-03-03'),
(66, 53, 29, 5, 'Could be better for the price.', '2024-11-05'),
(67, 6, 58, 5, 'The product broke after a week.', '2024-03-04'),
(68, 31, 7, 4, 'Poor customer service experience.', '2025-03-12'),
(69, 19, 62, 4, 'Good value for the price.', '2023-08-01'),
(70, 44, 11, 5, 'The product broke after a week.', '2026-07-19'),
(71, 14, 52, 4, 'Highly recommend to everyone.', '2025-08-25'),
(72, 79, 21, 3, 'Amazing product, will buy again!', '2024-01-27'),
(73, 50, 53, 3, 'The product broke after a week.', '2024-03-15'),
(74, 81, 83, 3, 'Good value for the price.', '2025-12-19'),
(75, 38, 77, 4, 'Arrived damaged, had to return it.', '2024-11-27'),
(76, 8, 32, 5, 'Five stars, no complaints at all.', '2025-07-16'),
(77, 48, 74, 5, 'The product broke after a week.', '2024-01-28'),
(78, 48, 35, 3, 'The product broke after a week.', '2025-12-02'),
(79, 51, 17, 5, 'Perfect gift idea, loved it.', '2024-04-26'),
(80, 40, 72, 4, 'The product broke after a week.', '2025-05-31');

-- ------------------------------------------------------------
-- Insert: Shipping (85 rows)
-- ------------------------------------------------------------
INSERT INTO Shipping (ShippingID, OrderID, ShipDate, DeliveryDate, Carrier) VALUES
(1, 48, '2025-04-12', '2025-04-22', 'FedEx'),
(2, 63, '2023-02-10', '2023-02-12', 'DHL'),
(3, 45, '2026-03-17', '2026-03-22', 'DHL'),
(4, 74, '2026-06-06', '2026-06-11', 'UPS'),
(5, 21, '2024-11-19', '2024-11-25', 'FedEx'),
(6, 78, '2024-01-25', '2024-02-01', 'BlueDart'),
(7, 18, '2024-02-13', '2024-02-17', 'UPS'),
(8, 27, '2024-08-13', '2024-08-22', 'FedEx'),
(9, 67, '2025-05-04', '2025-05-09', 'USPS'),
(10, 46, '2026-01-14', '2026-01-19', 'BlueDart'),
(11, 39, '2023-07-22', '2023-07-31', 'UPS'),
(12, 62, '2025-12-18', '2025-12-27', 'DHL'),
(13, 66, '2025-01-27', '2025-01-31', 'UPS'),
(14, 20, '2025-07-31', '2025-08-02', 'USPS'),
(15, 68, '2025-09-30', '2025-10-10', 'FedEx'),
(16, 50, '2023-06-14', '2023-06-18', 'DHL'),
(17, 82, '2024-09-26', '2024-10-04', 'FedEx'),
(18, 86, '2025-07-29', '2025-08-07', 'DHL'),
(19, 85, '2024-02-14', '2024-02-22', 'FedEx'),
(20, 32, '2025-04-19', '2025-04-24', 'USPS'),
(21, 7, '2023-06-11', '2023-06-16', 'FedEx'),
(22, 26, '2025-04-20', '2025-04-27', 'UPS'),
(23, 11, '2023-02-05', '2023-02-11', 'USPS'),
(24, 71, '2024-10-14', '2024-10-23', 'USPS'),
(25, 59, '2025-03-02', '2025-03-05', 'FedEx'),
(26, 23, '2025-12-14', '2025-12-18', 'BlueDart'),
(27, 77, '2025-06-18', '2025-06-21', 'DHL'),
(28, 22, '2025-10-05', '2025-10-08', 'FedEx'),
(29, 24, '2023-04-11', '2023-04-20', 'FedEx'),
(30, 10, '2025-11-03', '2025-11-13', 'FedEx'),
(31, 73, '2024-01-16', '2024-01-20', 'DHL'),
(32, 49, '2024-12-21', '2024-12-28', 'UPS'),
(33, 69, '2024-07-02', '2024-07-06', 'FedEx'),
(34, 58, '2025-08-02', '2025-08-05', 'BlueDart'),
(35, 65, '2025-04-19', '2025-04-27', 'USPS'),
(36, 4, '2025-04-17', '2025-04-24', 'DHL'),
(37, 3, '2026-04-30', '2026-05-03', 'DHL'),
(38, 31, '2025-10-17', '2025-10-24', 'UPS'),
(39, 6, '2024-10-29', '2024-11-08', 'DHL'),
(40, 25, '2026-06-28', '2026-07-07', 'UPS'),
(41, 16, '2025-03-11', '2025-03-20', 'FedEx'),
(42, 43, '2024-03-30', '2024-04-01', 'UPS'),
(43, 8, '2023-09-23', '2023-09-29', 'BlueDart'),
(44, 61, '2025-01-10', '2025-01-16', 'FedEx'),
(45, 35, '2024-07-22', '2024-07-29', 'FedEx'),
(46, 54, '2023-08-12', '2023-08-15', 'DHL'),
(47, 79, '2023-04-10', '2023-04-19', 'USPS'),
(48, 55, '2026-05-17', '2026-05-26', 'USPS'),
(49, 72, '2025-04-02', '2025-04-05', 'USPS'),
(50, 9, '2023-07-05', '2023-07-09', 'BlueDart'),
(51, 29, '2024-03-29', '2024-04-01', 'FedEx'),
(52, 37, '2023-03-17', '2023-03-23', 'USPS'),
(53, 70, '2025-04-19', '2025-04-23', 'USPS'),
(54, 41, '2024-03-01', '2024-03-03', 'DHL'),
(55, 76, '2025-11-21', '2025-11-27', 'FedEx'),
(56, 12, '2024-12-29', '2025-01-05', 'BlueDart'),
(57, 90, '2023-06-22', '2023-06-24', 'UPS'),
(58, 81, '2024-08-01', '2024-08-03', 'UPS'),
(59, 13, '2024-04-29', '2024-05-06', 'DHL'),
(60, 51, '2024-02-01', '2024-02-05', 'USPS'),
(61, 47, '2023-11-27', '2023-12-06', 'FedEx'),
(62, 87, '2025-08-19', '2025-08-29', 'DHL'),
(63, 53, '2024-10-21', '2024-10-27', 'UPS'),
(64, 15, '2024-12-23', '2024-12-27', 'USPS'),
(65, 75, '2024-09-24', '2024-09-30', 'DHL'),
(66, 56, '2023-07-25', '2023-07-30', 'BlueDart'),
(67, 19, '2026-08-03', '2026-08-08', 'FedEx'),
(68, 14, '2025-11-17', '2025-11-26', 'UPS'),
(69, 84, '2025-03-07', '2025-03-10', 'DHL'),
(70, 83, '2023-09-27', '2023-09-30', 'BlueDart'),
(71, 52, '2024-12-01', '2024-12-07', 'UPS'),
(72, 17, '2023-04-26', '2023-05-06', 'UPS'),
(73, 5, '2025-11-05', '2025-11-09', 'UPS'),
(74, 80, '2023-03-24', '2023-03-26', 'DHL'),
(75, 42, '2025-07-19', '2025-07-28', 'BlueDart'),
(76, 28, '2025-06-08', '2025-06-11', 'DHL'),
(77, 44, '2026-05-18', '2026-05-28', 'USPS'),
(78, 33, '2023-08-27', '2023-08-31', 'DHL'),
(79, 2, '2025-07-23', '2025-08-01', 'BlueDart'),
(80, 40, '2023-08-06', '2023-08-16', 'BlueDart'),
(81, 25, '2026-06-26', '2026-07-04', 'BlueDart'),
(82, 9, '2023-07-02', '2023-07-12', 'UPS'),
(83, 46, '2026-01-12', '2026-01-16', 'DHL'),
(84, 33, '2023-08-29', '2023-09-08', 'DHL'),
(85, 13, '2024-04-30', '2024-05-05', 'BlueDart');

-- ------------------------------------------------------------
-- Insert: Discounts (80 rows)
-- ------------------------------------------------------------
INSERT INTO Discounts (DiscountID, ProductID, DiscountAmount, StartDate, EndDate) VALUES
(1, 36, 10.63, '2025-06-19', '2025-07-15'),
(2, 79, 29.01, '2024-11-14', '2024-12-23'),
(3, 83, 12.59, '2025-03-11', '2025-04-24'),
(4, 20, 12.7, '2025-01-31', '2025-03-18'),
(5, 78, 20.19, '2025-01-10', '2025-02-22'),
(6, 6, 42.14, '2024-01-15', '2024-01-23'),
(7, 11, 7.05, '2024-09-16', '2024-11-03'),
(8, 74, 16.91, '2025-06-12', '2025-07-02'),
(9, 74, 23.75, '2025-03-03', '2025-04-19'),
(10, 4, 27.41, '2025-02-27', '2025-04-15'),
(11, 70, 18.04, '2024-11-11', '2024-12-07'),
(12, 62, 16.02, '2025-01-28', '2025-03-27'),
(13, 52, 18.38, '2024-11-14', '2024-11-25'),
(14, 8, 12.11, '2024-04-03', '2024-05-06'),
(15, 62, 25.9, '2024-12-09', '2025-01-06'),
(16, 78, 11.47, '2024-12-04', '2025-01-25'),
(17, 41, 38.04, '2025-04-04', '2025-05-03'),
(18, 52, 10.88, '2024-03-21', '2024-04-20'),
(19, 66, 30.27, '2025-01-06', '2025-02-02'),
(20, 31, 25.99, '2024-01-18', '2024-02-11'),
(21, 58, 16.16, '2025-06-01', '2025-06-14'),
(22, 7, 18.06, '2024-03-01', '2024-04-01'),
(23, 79, 23.82, '2024-01-11', '2024-01-28'),
(24, 42, 47.02, '2024-06-20', '2024-08-12'),
(25, 41, 13.54, '2024-03-23', '2024-04-09'),
(26, 64, 49.82, '2025-01-12', '2025-02-17'),
(27, 64, 44.56, '2024-08-12', '2024-09-19'),
(28, 3, 9.05, '2025-02-27', '2025-03-31'),
(29, 65, 25.58, '2025-05-17', '2025-06-08'),
(30, 28, 31.25, '2025-04-21', '2025-05-01'),
(31, 7, 17.66, '2025-02-05', '2025-03-22'),
(32, 84, 35.26, '2024-02-04', '2024-02-29'),
(33, 69, 5.37, '2024-03-16', '2024-03-29'),
(34, 56, 11.03, '2024-04-23', '2024-05-16'),
(35, 47, 39.37, '2024-06-26', '2024-07-26'),
(36, 6, 23.03, '2024-12-27', '2025-02-08'),
(37, 72, 13.76, '2024-10-13', '2024-11-24'),
(38, 37, 8.31, '2024-06-20', '2024-07-29'),
(39, 58, 39.4, '2024-04-04', '2024-04-28'),
(40, 80, 35.62, '2025-05-13', '2025-05-27'),
(41, 17, 48.88, '2024-07-05', '2024-08-06'),
(42, 48, 40.77, '2024-07-12', '2024-08-09'),
(43, 72, 47.25, '2025-02-25', '2025-04-21'),
(44, 19, 13.96, '2025-01-28', '2025-03-08'),
(45, 52, 27.5, '2024-12-17', '2024-12-26'),
(46, 5, 11.17, '2025-01-13', '2025-02-10'),
(47, 61, 28.37, '2024-11-29', '2024-12-15'),
(48, 78, 45.19, '2024-04-14', '2024-04-29'),
(49, 42, 46.91, '2024-05-14', '2024-06-10'),
(50, 21, 22.68, '2024-10-31', '2024-12-16'),
(51, 39, 31.72, '2024-05-02', '2024-06-10'),
(52, 66, 28.96, '2025-06-15', '2025-08-06'),
(53, 73, 18.49, '2024-06-11', '2024-08-09'),
(54, 3, 21.58, '2024-06-06', '2024-07-26'),
(55, 15, 49.1, '2024-04-23', '2024-06-06'),
(56, 40, 40.85, '2025-01-19', '2025-03-13'),
(57, 81, 6.2, '2024-06-22', '2024-07-29'),
(58, 34, 48.52, '2024-07-09', '2024-09-04'),
(59, 75, 30.99, '2025-05-24', '2025-07-16'),
(60, 7, 31.26, '2025-03-10', '2025-03-27'),
(61, 68, 33.31, '2024-05-29', '2024-07-14'),
(62, 49, 11.65, '2024-03-07', '2024-04-26'),
(63, 32, 6.42, '2025-01-04', '2025-02-24'),
(64, 15, 13.59, '2024-07-26', '2024-08-30'),
(65, 41, 23.85, '2025-06-19', '2025-07-22'),
(66, 27, 23.47, '2025-03-22', '2025-05-17'),
(67, 79, 46.42, '2025-06-05', '2025-07-29'),
(68, 8, 36.76, '2025-03-15', '2025-04-24'),
(69, 27, 30.24, '2024-06-07', '2024-07-26'),
(70, 62, 28.65, '2024-06-06', '2024-07-03'),
(71, 23, 25.68, '2025-01-24', '2025-03-06'),
(72, 44, 29.58, '2024-07-08', '2024-08-27'),
(73, 83, 41.16, '2024-08-29', '2024-09-21'),
(74, 79, 26.79, '2024-05-20', '2024-06-11'),
(75, 36, 30.11, '2024-09-18', '2024-10-09'),
(76, 39, 39.7, '2024-04-20', '2024-06-11'),
(77, 27, 36.06, '2024-10-21', '2024-11-28'),
(78, 41, 26.59, '2025-05-24', '2025-07-05'),
(79, 36, 17.95, '2025-01-15', '2025-02-27'),
(80, 70, 22.09, '2024-03-15', '2024-04-16');

-- ------------------------------------------------------------
-- Insert: Coupons (80 rows)
-- ------------------------------------------------------------
INSERT INTO Coupons (CouponID, CouponCode, DiscountAmount, ExpiryDate) VALUES
(1, 'SAVE001B', 38.41, '2026-11-05'),
(2, 'SAVE002A', 15.17, '2026-10-04'),
(3, 'SAVE003B', 38.44, '2025-09-23'),
(4, 'SAVE004A', 17.12, '2027-01-03'),
(5, 'SAVE005B', 27.96, '2026-08-04'),
(6, 'SAVE006C', 21.77, '2026-11-29'),
(7, 'SAVE007A', 33.98, '2025-02-27'),
(8, 'SAVE008B', 37.66, '2026-03-29'),
(9, 'SAVE009C', 14.51, '2027-02-24'),
(10, 'SAVE010A', 26.55, '2025-04-20'),
(11, 'SAVE011C', 13.37, '2027-04-24'),
(12, 'SAVE012A', 28.44, '2025-01-06'),
(13, 'SAVE013C', 12.9, '2026-08-26'),
(14, 'SAVE014A', 6.84, '2027-10-14'),
(15, 'SAVE015B', 16.56, '2026-03-22'),
(16, 'SAVE016B', 8.52, '2027-10-20'),
(17, 'SAVE017A', 5.18, '2027-08-19'),
(18, 'SAVE018C', 39.23, '2026-06-07'),
(19, 'SAVE019A', 19.24, '2025-08-07'),
(20, 'SAVE020B', 21.71, '2027-11-21'),
(21, 'SAVE021A', 31.46, '2025-12-18'),
(22, 'SAVE022B', 16.24, '2026-12-08'),
(23, 'SAVE023C', 7.07, '2027-09-21'),
(24, 'SAVE024A', 27.83, '2025-04-08'),
(25, 'SAVE025A', 23.73, '2026-09-21'),
(26, 'SAVE026C', 34.76, '2026-08-09'),
(27, 'SAVE027A', 36.96, '2027-03-03'),
(28, 'SAVE028A', 19.63, '2027-10-22'),
(29, 'SAVE029A', 37.69, '2027-09-27'),
(30, 'SAVE030A', 39.9, '2025-07-11'),
(31, 'SAVE031B', 32.58, '2027-08-24'),
(32, 'SAVE032A', 37.78, '2025-07-12'),
(33, 'SAVE033B', 35.69, '2027-10-04'),
(34, 'SAVE034A', 15.44, '2027-12-27'),
(35, 'SAVE035C', 8.76, '2026-03-11'),
(36, 'SAVE036B', 14.96, '2026-06-26'),
(37, 'SAVE037C', 24.02, '2027-10-22'),
(38, 'SAVE038B', 36.12, '2027-11-19'),
(39, 'SAVE039A', 34.79, '2027-10-11'),
(40, 'SAVE040B', 14.55, '2027-08-18'),
(41, 'SAVE041A', 16.57, '2025-01-11'),
(42, 'SAVE042C', 21.06, '2026-09-14'),
(43, 'SAVE043B', 30.15, '2025-04-28'),
(44, 'SAVE044A', 30.78, '2027-12-12'),
(45, 'SAVE045B', 24.87, '2025-11-08'),
(46, 'SAVE046A', 11.14, '2027-12-19'),
(47, 'SAVE047C', 36.4, '2026-08-18'),
(48, 'SAVE048B', 23.03, '2026-06-25'),
(49, 'SAVE049A', 19.03, '2027-10-24'),
(50, 'SAVE050A', 11.47, '2027-07-21'),
(51, 'SAVE051A', 21.71, '2026-05-28'),
(52, 'SAVE052A', 5.24, '2025-07-30'),
(53, 'SAVE053B', 13.24, '2025-05-04'),
(54, 'SAVE054B', 38.39, '2025-06-27'),
(55, 'SAVE055B', 25.39, '2026-05-18'),
(56, 'SAVE056C', 5.4, '2025-10-09'),
(57, 'SAVE057C', 17.58, '2025-07-23'),
(58, 'SAVE058A', 7.17, '2027-03-17'),
(59, 'SAVE059A', 21.29, '2027-05-16'),
(60, 'SAVE060A', 19.19, '2026-09-14'),
(61, 'SAVE061C', 37.31, '2027-04-09'),
(62, 'SAVE062C', 31.94, '2025-07-11'),
(63, 'SAVE063C', 9.11, '2027-07-26'),
(64, 'SAVE064B', 17.86, '2027-09-09'),
(65, 'SAVE065A', 12.67, '2027-06-24'),
(66, 'SAVE066A', 21.74, '2026-07-18'),
(67, 'SAVE067B', 31.17, '2025-04-05'),
(68, 'SAVE068C', 18.08, '2027-01-03'),
(69, 'SAVE069C', 24.22, '2025-07-22'),
(70, 'SAVE070B', 31.51, '2025-06-03'),
(71, 'SAVE071C', 33.9, '2025-12-21'),
(72, 'SAVE072A', 28.81, '2025-09-29'),
(73, 'SAVE073C', 35.56, '2025-10-13'),
(74, 'SAVE074A', 23.39, '2025-09-15'),
(75, 'SAVE075C', 29.63, '2027-04-05'),
(76, 'SAVE076A', 37.1, '2027-11-10'),
(77, 'SAVE077A', 7.16, '2025-11-27'),
(78, 'SAVE078C', 36.6, '2027-03-02'),
(79, 'SAVE079A', 25.04, '2025-01-13'),
(80, 'SAVE080A', 10.76, '2026-12-17');
-- ============================================================
-- PART 2: ANALYTICS QUERY BANK (52 QUERIES)
-- Section A (Q1-Q10): basic aggregates, no join
-- Section B (Q11-Q30): JOIN-driven analytics
-- Section C (Q31-Q45): subquery-driven analytics
-- Section D (Q46-Q52): CTEs, window functions, multi-level joins
-- ============================================================
USE ECommerceDB;

-- ============================================================
-- SECTION A: BASIC AGGREGATE / SINGLE-TABLE QUERIES (No Join)
-- ============================================================

-- Q1. Total number of products in the catalog
SELECT COUNT(*) AS TotalProducts FROM Products;

-- Q2. Average price of all products
SELECT ROUND(AVG(Price), 2) AS AvgPrice FROM Products;

-- Q3. Total number of registered customers
SELECT COUNT(*) AS TotalCustomers FROM Customers;

-- Q4. Highest and lowest priced product values
SELECT MAX(Price) AS HighestPrice, MIN(Price) AS LowestPrice FROM Products;

-- Q5. Count of orders grouped by status
SELECT OrderStatus, COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderStatus
ORDER BY OrderCount DESC;

-- Q6. Number of products with stock below 50 units
SELECT COUNT(*) AS LowStockProducts FROM Products WHERE StockQuantity < 50;

-- Q7. Distinct countries customers are located in
SELECT DISTINCT Country FROM Customers ORDER BY Country;

-- Q8. Average discount amount currently offered
SELECT ROUND(AVG(DiscountAmount), 2) AS AvgDiscountPct FROM Discounts;

-- Q9. Coupons expiring in the year 2026
SELECT CouponCode, DiscountAmount, ExpiryDate
FROM Coupons
WHERE YEAR(ExpiryDate) = 2026
ORDER BY ExpiryDate;

-- Q10. Customers who joined in 2024, ordered by join date
SELECT CustomerName, City, Country, JoinDate
FROM Customers
WHERE YEAR(JoinDate) = 2024
ORDER BY JoinDate;

-- ============================================================
-- SECTION B: JOIN QUERIES
-- ============================================================

-- Q11. List each product with its category name
SELECT p.ProductName, p.Price, c.CategoryName
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
ORDER BY c.CategoryName;

-- Q12. List every order with the customer who placed it
SELECT o.OrderID, cu.CustomerName, o.OrderDate, o.OrderStatus
FROM Orders o
JOIN Customers cu ON o.CustomerID = cu.CustomerID
ORDER BY o.OrderDate DESC;

-- Q13. Full order line-item detail: order, customer, product, quantity, line total
SELECT o.OrderID, cu.CustomerName, p.ProductName, od.Quantity, od.UnitPrice,
       (od.Quantity * od.UnitPrice) AS LineTotal
FROM OrderDetails od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Customers cu ON o.CustomerID = cu.CustomerID
JOIN Products p ON od.ProductID = p.ProductID
ORDER BY o.OrderID;

-- Q14. Total revenue generated per order
SELECT o.OrderID, cu.CustomerName, SUM(od.Quantity * od.UnitPrice) AS OrderTotal
FROM Orders o
JOIN Customers cu ON o.CustomerID = cu.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, cu.CustomerName
ORDER BY OrderTotal DESC;

-- Q15. Total revenue generated per product
SELECT p.ProductName, SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY TotalRevenue DESC;

-- Q16. Total quantity sold per category
SELECT c.CategoryName, SUM(od.Quantity) AS TotalUnitsSold
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY c.CategoryName
ORDER BY TotalUnitsSold DESC;

-- Q17. All product reviews with reviewer name and product name
SELECT p.ProductName, cu.CustomerName, r.Rating, r.Comment, r.ReviewDate
FROM Reviews r
JOIN Products p ON r.ProductID = p.ProductID
JOIN Customers cu ON r.CustomerID = cu.CustomerID
ORDER BY r.ReviewDate DESC;

-- Q18. Average rating per product (products with at least one review)
SELECT p.ProductName, ROUND(AVG(r.Rating), 2) AS AvgRating, COUNT(r.ReviewID) AS ReviewCount
FROM Products p
JOIN Reviews r ON p.ProductID = r.ProductID
GROUP BY p.ProductName
ORDER BY AvgRating DESC;

-- Q19. Shipping timeline for each order (ship date & delivery date)
SELECT o.OrderID, cu.CustomerName, s.Carrier, s.ShipDate, s.DeliveryDate,
       DATEDIFF(s.DeliveryDate, s.ShipDate) AS DaysInTransit
FROM Shipping s
JOIN Orders o ON s.OrderID = o.OrderID
JOIN Customers cu ON o.CustomerID = cu.CustomerID
ORDER BY DaysInTransit DESC;

-- Q20. Products that currently have an active discount, with category
SELECT p.ProductName, c.CategoryName, d.DiscountAmount, d.StartDate, d.EndDate
FROM Discounts d
JOIN Products p ON d.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
ORDER BY d.DiscountAmount DESC;

-- Q21. Customers and the total number of orders they've placed (LEFT JOIN to include zero-order customers)
SELECT cu.CustomerName, COUNT(o.OrderID) AS TotalOrders
FROM Customers cu
LEFT JOIN Orders o ON cu.CustomerID = o.CustomerID
GROUP BY cu.CustomerName
ORDER BY TotalOrders DESC;

-- Q22. Products that have never received a review (LEFT JOIN + NULL check)
SELECT p.ProductName
FROM Products p
LEFT JOIN Reviews r ON p.ProductID = r.ProductID
WHERE r.ReviewID IS NULL;

-- Q23. Orders that have not yet been shipped (LEFT JOIN + NULL check)
SELECT o.OrderID, cu.CustomerName, o.OrderStatus
FROM Orders o
JOIN Customers cu ON o.CustomerID = cu.CustomerID
LEFT JOIN Shipping s ON o.OrderID = s.OrderID
WHERE s.ShippingID IS NULL;

-- Q24. Revenue per customer, per country
SELECT cu.Country, cu.CustomerName, SUM(od.Quantity * od.UnitPrice) AS TotalSpent
FROM Customers cu
JOIN Orders o ON cu.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY cu.Country, cu.CustomerName
ORDER BY cu.Country, TotalSpent DESC;

-- Q25. Three-table join: reviews left by customers on products they actually purchased
SELECT DISTINCT cu.CustomerName, p.ProductName, r.Rating
FROM Reviews r
JOIN Customers cu ON r.CustomerID = cu.CustomerID
JOIN Products p ON r.ProductID = p.ProductID
JOIN OrderDetails od ON od.ProductID = p.ProductID
JOIN Orders o ON od.OrderID = o.OrderID AND o.CustomerID = cu.CustomerID;

-- Q26. Category-level revenue and average product price side by side
SELECT c.CategoryName,
       ROUND(AVG(p.Price), 2) AS AvgProductPrice,
       COALESCE(SUM(od.Quantity * od.UnitPrice), 0) AS CategoryRevenue
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY c.CategoryName
ORDER BY CategoryRevenue DESC;

-- Q27. Delivered orders with shipping carrier performance
SELECT s.Carrier, COUNT(*) AS DeliveredOrders,
       ROUND(AVG(DATEDIFF(s.DeliveryDate, s.ShipDate)), 1) AS AvgTransitDays
FROM Shipping s
JOIN Orders o ON s.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY s.Carrier
ORDER BY AvgTransitDays;

-- Q28. Top customer per country by total spend (join + subquery in FROM)
SELECT ranked.Country, ranked.CustomerName, ranked.TotalSpent
FROM (
    SELECT cu.Country, cu.CustomerName,
           SUM(od.Quantity * od.UnitPrice) AS TotalSpent,
           RANK() OVER (PARTITION BY cu.Country ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS rnk
    FROM Customers cu
    JOIN Orders o ON cu.CustomerID = o.CustomerID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY cu.Country, cu.CustomerName
) ranked
WHERE ranked.rnk = 1
ORDER BY ranked.TotalSpent DESC;

-- Q29. Products, their category, and how many distinct customers bought them
SELECT p.ProductName, c.CategoryName, COUNT(DISTINCT o.CustomerID) AS UniqueBuyers
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN OrderDetails od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY p.ProductName, c.CategoryName
ORDER BY UniqueBuyers DESC;

-- Q30. Monthly revenue trend (join + date grouping)
SELECT DATE_FORMAT(o.OrderDate, '%Y-%m') AS OrderMonth,
       SUM(od.Quantity * od.UnitPrice) AS MonthlyRevenue
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY DATE_FORMAT(o.OrderDate, '%Y-%m')
ORDER BY OrderMonth;

-- ============================================================
-- SECTION C: SUBQUERY-DRIVEN ANALYTICS
-- ============================================================

-- Q31. Products priced above the overall average price (scalar subquery)
SELECT ProductName, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products)
ORDER BY Price DESC;

-- Q32. Customers who have placed more orders than the average customer (correlated + scalar subquery)
SELECT cu.CustomerName, COUNT(o.OrderID) AS OrderCount
FROM Customers cu
JOIN Orders o ON cu.CustomerID = o.CustomerID
GROUP BY cu.CustomerName
HAVING COUNT(o.OrderID) > (
    SELECT AVG(OrderCountPerCustomer) FROM (
        SELECT COUNT(*) AS OrderCountPerCustomer FROM Orders GROUP BY CustomerID
    ) sub
);

-- Q33. Products that have never been ordered (NOT IN subquery)
SELECT ProductName, Price
FROM Products
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM OrderDetails WHERE ProductID IS NOT NULL);

-- Q34. Customers who have never placed an order (NOT EXISTS subquery)
SELECT CustomerName, Email
FROM Customers cu
WHERE NOT EXISTS (SELECT 1 FROM Orders o WHERE o.CustomerID = cu.CustomerID);

-- Q35. The single highest-revenue product (subquery in WHERE with aggregate)
SELECT p.ProductName, rev.TotalRevenue
FROM Products p
JOIN (
    SELECT ProductID, SUM(Quantity * UnitPrice) AS TotalRevenue
    FROM OrderDetails
    GROUP BY ProductID
) rev ON p.ProductID = rev.ProductID
WHERE rev.TotalRevenue = (
    SELECT MAX(TotalRevenue) FROM (
        SELECT SUM(Quantity * UnitPrice) AS TotalRevenue FROM OrderDetails GROUP BY ProductID
    ) maxrev
);

-- Q36. Orders whose total value exceeds the average order value (subquery in HAVING)
SELECT o.OrderID, SUM(od.Quantity * od.UnitPrice) AS OrderTotal
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID
HAVING SUM(od.Quantity * od.UnitPrice) > (
    SELECT AVG(OrderTotal) FROM (
        SELECT SUM(Quantity * UnitPrice) AS OrderTotal FROM OrderDetails GROUP BY OrderID
    ) avgsub
)
ORDER BY OrderTotal DESC;

-- Q37. Customers whose average review rating is below the platform-wide average (correlated subquery)
SELECT cu.CustomerName, ROUND(AVG(r.Rating), 2) AS CustomerAvgRating
FROM Customers cu
JOIN Reviews r ON cu.CustomerID = r.CustomerID
GROUP BY cu.CustomerName
HAVING AVG(r.Rating) < (SELECT AVG(Rating) FROM Reviews);

-- Q38. Products with a discount greater than the average discount for their own category (correlated subquery)
SELECT p.ProductName, p.CategoryID, d.DiscountAmount
FROM Discounts d
JOIN Products p ON d.ProductID = p.ProductID
WHERE d.DiscountAmount > (
    SELECT AVG(d2.DiscountAmount)
    FROM Discounts d2
    JOIN Products p2 ON d2.ProductID = p2.ProductID
    WHERE p2.CategoryID = p.CategoryID
);

-- Q39. Second highest-priced product per category (correlated subquery)
SELECT p.ProductName, c.CategoryName, p.Price
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE 1 = (
    SELECT COUNT(*) FROM Products p2
    WHERE p2.CategoryID = p.CategoryID AND p2.Price > p.Price
);

-- Q40. Customers who bought products from more than 3 distinct categories (subquery + HAVING)
SELECT cu.CustomerName, COUNT(DISTINCT p.CategoryID) AS CategoriesPurchased
FROM Customers cu
JOIN Orders o ON cu.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY cu.CustomerName
HAVING COUNT(DISTINCT p.CategoryID) > 3
ORDER BY CategoriesPurchased DESC;

-- Q41. Products priced higher than the average price within their own category (correlated subquery)
SELECT p.ProductName, c.CategoryName, p.Price
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.Price > (
    SELECT AVG(p2.Price) FROM Products p2 WHERE p2.CategoryID = p.CategoryID
)
ORDER BY c.CategoryName;

-- Q42. Orders placed by customers located in a country with more than 2 customers (subquery in WHERE)
SELECT o.OrderID, cu.CustomerName, cu.Country
FROM Orders o
JOIN Customers cu ON o.CustomerID = cu.CustomerID
WHERE cu.Country IN (
    SELECT Country FROM Customers GROUP BY Country HAVING COUNT(*) > 2
);

-- Q43. Products whose stock quantity is below the average stock quantity of their category (correlated subquery)
SELECT p.ProductName, c.CategoryName, p.StockQuantity
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.StockQuantity < (
    SELECT AVG(p2.StockQuantity) FROM Products p2 WHERE p2.CategoryID = p.CategoryID
);

-- Q44. Coupons offering a bigger discount than the average product discount (subquery)
SELECT CouponCode, DiscountAmount
FROM Coupons
WHERE DiscountAmount > (SELECT AVG(DiscountAmount) FROM Discounts)
ORDER BY DiscountAmount DESC;

-- Q45. Most reviewed product (subquery for MAX count)
SELECT p.ProductName, cnt.ReviewCount
FROM Products p
JOIN (
    SELECT ProductID, COUNT(*) AS ReviewCount FROM Reviews GROUP BY ProductID
) cnt ON p.ProductID = cnt.ProductID
WHERE cnt.ReviewCount = (
    SELECT MAX(ReviewCount) FROM (
        SELECT COUNT(*) AS ReviewCount FROM Reviews GROUP BY ProductID
    ) maxcnt
);

-- ============================================================
-- SECTION D: ADVANCED ANALYTICS (Window Functions, CTEs, Multi-level joins/subqueries)
-- ============================================================

-- Q46. Running total of monthly revenue (CTE + window function)
WITH MonthlyRevenue AS (
    SELECT DATE_FORMAT(o.OrderDate, '%Y-%m') AS OrderMonth,
           SUM(od.Quantity * od.UnitPrice) AS Revenue
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY DATE_FORMAT(o.OrderDate, '%Y-%m')
)
SELECT OrderMonth, Revenue,
       SUM(Revenue) OVER (ORDER BY OrderMonth) AS RunningTotalRevenue
FROM MonthlyRevenue
ORDER BY OrderMonth;

-- Q47. Rank products within each category by total revenue (CTE + window function + join)
WITH ProductRevenue AS (
    SELECT p.ProductID, p.ProductName, p.CategoryID,
           SUM(od.Quantity * od.UnitPrice) AS Revenue
    FROM Products p
    JOIN OrderDetails od ON p.ProductID = od.ProductID
    GROUP BY p.ProductID, p.ProductName, p.CategoryID
)
SELECT c.CategoryName, pr.ProductName, pr.Revenue,
       RANK() OVER (PARTITION BY pr.CategoryID ORDER BY pr.Revenue DESC) AS RevenueRank
FROM ProductRevenue pr
JOIN Categories c ON pr.CategoryID = c.CategoryID
ORDER BY c.CategoryName, RevenueRank;

-- Q48. Customer lifetime value tier classification (CTE + join + CASE)
WITH CustomerSpend AS (
    SELECT cu.CustomerID, cu.CustomerName, SUM(od.Quantity * od.UnitPrice) AS LifetimeValue
    FROM Customers cu
    JOIN Orders o ON cu.CustomerID = o.CustomerID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY cu.CustomerID, cu.CustomerName
)
SELECT CustomerName, LifetimeValue,
       CASE
           WHEN LifetimeValue >= 1000 THEN 'Platinum'
           WHEN LifetimeValue >= 500  THEN 'Gold'
           WHEN LifetimeValue >= 200  THEN 'Silver'
           ELSE 'Bronze'
       END AS CustomerTier
FROM CustomerSpend
ORDER BY LifetimeValue DESC;

-- Q49. Products where average rating is in the bottom 3 (join + subquery + window function)
SELECT ProductName, AvgRating FROM (
    SELECT p.ProductName, ROUND(AVG(r.Rating), 2) AS AvgRating,
           RANK() OVER (ORDER BY AVG(r.Rating) ASC) AS rnk
    FROM Products p
    JOIN Reviews r ON p.ProductID = r.ProductID
    GROUP BY p.ProductName
) ranked
WHERE rnk <= 3;

-- Q50. Full analytics summary: category, revenue, units sold, avg rating, and revenue rank (multi-join + multi-subquery + CTE)
WITH CategoryRevenue AS (
    SELECT p.CategoryID, SUM(od.Quantity * od.UnitPrice) AS Revenue, SUM(od.Quantity) AS UnitsSold
    FROM Products p
    JOIN OrderDetails od ON p.ProductID = od.ProductID
    GROUP BY p.CategoryID
),
CategoryRating AS (
    SELECT p.CategoryID, ROUND(AVG(r.Rating), 2) AS AvgRating
    FROM Products p
    JOIN Reviews r ON p.ProductID = r.ProductID
    GROUP BY p.CategoryID
)
SELECT c.CategoryName,
       cr.Revenue, cr.UnitsSold,
       COALESCE(rt.AvgRating, 0) AS AvgRating,
       RANK() OVER (ORDER BY cr.Revenue DESC) AS RevenueRank
FROM Categories c
JOIN CategoryRevenue cr ON c.CategoryID = cr.CategoryID
LEFT JOIN CategoryRating rt ON c.CategoryID = rt.CategoryID
ORDER BY RevenueRank;

-- Q51 (bonus). Top 5 best-selling products overall with category and total units sold
SELECT p.ProductName, c.CategoryName, SUM(od.Quantity) AS UnitsSold
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductName, c.CategoryName
ORDER BY UnitsSold DESC
LIMIT 5;

-- Q52 (bonus). Customers who used a shipping carrier that averages more than 5 days transit (subquery + join)
SELECT DISTINCT cu.CustomerName, s.Carrier
FROM Customers cu
JOIN Orders o ON cu.CustomerID = o.CustomerID
JOIN Shipping s ON o.OrderID = s.OrderID
WHERE s.Carrier IN (
    SELECT Carrier FROM Shipping
    GROUP BY Carrier
    HAVING AVG(DATEDIFF(DeliveryDate, ShipDate)) > 5
);
