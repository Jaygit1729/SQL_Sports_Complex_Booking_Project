#---------------------CREATING A DATABSE AND USING IT FOR FURTHER OPERATION--------------------

CREATE DATABASE sports_booking;
USE sports_booking;
#---------------------CREATING A TABLE AND JOINING THEM--------------------

CREATE TABLE members(id VARCHAR(255) PRIMARY KEY,
password VARCHAR(255) NOT NULL,
email VARCHAR(255) NOT NULL,
member_since DATETIME NOT NULL ,
payment_due DECIMAL(6,2) NOT NULL DEFAULT 0
);

CREATE TABLE pending_termination(id VARCHAR(255) PRIMARY KEY,
email VARCHAR(255) NOT NULL,
request_date DATETIME NOT NULL,
payment_due DECIMAL(6,2) NOT NULL DEFAULT 0
);

CREATE TABLE room(id VARCHAR(255) NOT NULL PRIMARY KEY,
room_type VARCHAR(255) NOT NULL,
price DECIMAL(6,2) NOT NULL
);

CREATE TABLE bookings (id INT AUTO_INCREMENT PRIMARY KEY,
room_id VARCHAR(255) NOT NULL,
booked_date DATE NOT NULL ,
booked_time TIME NOT NULL ,
member_id VARCHAR(255) NOT NULL,
datetime_of_booking DATETIME NOT NULL,
payment_status VARCHAR(255) NOT NULL DEFAULT "UNPAID",
CONSTRAINT ct UNIQUE(room_id,booked_date,booked_time)
);

ALTER TABLE bookings
ADD CONSTRAINT fk1 FOREIGN KEY(member_id) REFERENCES members(id) ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT fk2 FOREIGN KEY(room_id) REFERENCES room(id) ON UPDATE CASCADE ON DELETE CASCADE;

#---------------------INSERTING DATA INTO TABLE--------------------



INSERT INTO members (id, password, email, member_since,
payment_due) VALUES
('afeil', 'feil1988<3', 'Abdul.Feil@hotmail.com', '2017-04-15 12:10:13', 0),
('amely_18', 'loseweightin18', 'Amely.Bauch91@yahoo.com','2018-02-06 16:48:43', 0),
('bbahringer', 'iambeau17', 'Beaulah_Bahringer@yahoo.com', '2017-12-28 05:36:50', 0),
('little31', 'whocares31', 'Anthony_Little31@gmail.com', '2017-06-01 21:12:11', 10),
('macejkovic73', 'jadajeda12', 'Jada.Macejkovic73@gmail.com','2017-05-30 17:30:22', 0),
('marvin1', 'if0909mar', 'Marvin_Schulist@gmail.com', '2017-09-09 02:30:49', 10),
('nitzsche77', 'bret77@#', 'Bret_Nitzsche77@gmail.com', '2018-01-09 17:36:49', 0),
('noah51', '18Oct1976#51', 'Noah51@gmail.com', '2017-12-16 22:59:46', 0),
('oreillys', 'reallycool#1', 'Martine_OReilly@yahoo.com', '2017-10-12 05:39:20', 0),
('wyattgreat', 'wyatt111', 'Wyatt_Wisozk2@gmail.com', '2017-07-18 16:28:35', 0);

INSERT INTO room(id, room_type, price) VALUES
('AR', 'Archery Range', 120),
('B1', 'Badminton Court', 8),
('B2', 'Badminton Court', 8),
('MPF1', 'Multi Purpose Field', 50),
('MPF2', 'Multi Purpose Field', 60),
('T1', 'Tennis Court', 10),
('T2', 'Tennis Court', 10);

INSERT INTO bookings (id, room_id, booked_date, booked_time,
member_id, datetime_of_booking, payment_status) VALUES
(1, 'AR', '2017-12-26', '13:00:00', 'oreillys', '2017-12-20
20:31:27', 'Paid'),
(2, 'MPF1', '2017-12-30', '17:00:00', 'noah51', '2017-12-22
05:22:10', 'Paid'),
(3, 'T2', '2017-12-31', '16:00:00', 'macejkovic73', '2017-12-28
18:14:23', 'Paid'),
(4, 'T1', '2018-03-05', '08:00:00', 'little31', '2018-02-22
20:19:17', 'Unpaid'),
(5, 'MPF2', '2018-03-02', '11:00:00', 'marvin1', '2018-03-01
16:13:45', 'Paid'),
(6, 'B1', '2018-03-28', '16:00:00', 'marvin1', '2018-03-23
22:46:36', 'Paid'),
(7, 'B1', '2018-04-15', '14:00:00', 'macejkovic73', '2018-04-12
22:23:20', 'Cancelled'),
(8, 'T2', '2018-04-23', '13:00:00', 'macejkovic73', '2018-04-19
10:49:00', 'Cancelled'),
(9, 'T1', '2018-05-25', '10:00:00', 'marvin1', '2018-05-21
11:20:46', 'Unpaid'),
(10, 'B2', '2018-06-12', '15:00:00', 'bbahringer', '2018-05-30
14:40:23', 'Paid');

#---------------------JOINING THE TABLE AND CREATING A VIEW--------------------


CREATE VIEW member_booking AS
SELECT bookings.id,bookings.room_id,booked_date,booked_time,member_id,datetime_of_booking,payment_status,room_type,price
FROM bookings
JOIN room
ON room.id=bookings.room_id
ORDER BY bookings.id;

select * from member_booking;

#---------------------CREATING A STORE PROCEDURE--------------------

DELIMITER $$
CREATE PROCEDURE insert_new_member (IN p_id VARCHAR(255) ,p_email VARCHAR(255),p_password VARCHAR(255) ,p_member_since DATETIME )
BEGIN
INSERT INTO member(id,email,password,member_since) Values(p_id,p_email,p_password,p_memmber_since);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE delete_member (IN p_id VARCHAR(255))
BEGIN
DELETE FROM member where id=p_id;
END $$

DELIMITER $$
CREATE PROCEDURE update_member_password(IN p_id VARCHAR(255) , IN p_password VARCHAR(255))
BEGIN
UPDATE member
SET password=p.password
WHERE id=p_id;
END $$

DELIMITER $$
CREATE PROCEDURE update_member_email(IN p_id VARCHAR(255), IN p_email VARCHAR(255))
BEGIN
UPDATE member 
SET email=p.email
WHERE id=p.id;
END $$

DELIMITER $$
CREATE PROCEDURE update_member_since(IN p_id VARCHAR(255),IN p_member_since DATETIME(255))
BEGIN
UPDATE member
SET member_since=p.member_since
where id=p.id;
END $$

DELIMITER $$
CREATE PROCEDURE make_booking(IN p_room_id VARCHAR(255), 
IN p_booked_date DATE,IN p_booked_time TIME, IN p_member_id VARCHAR(255))
BEGIN
DECLARE v_price DECIMAL(6,2);
DECLARE v_payment_due DECIMAL(6,2);
SELECT price INTO v_price FROM rooms WHERE id=p_room_id;
INSERT INTO bookings (room_id, booked_date, booked_time,
member_id) VALUES (p_room_id, p_booked_date, p_booked_time,
p_member_id);
SELECT payment_due INTO v_payment_due FROM members WHERE id
= p_member_id;
UPDATE members SET payment_due = v_payment_due + v_price
WHERE id = p_member_id;
END $$

DELIMITER $$
CREATE PROCEDURE update_payment(IN p_id INT)
BEGIN
DECLARE v_member_id VARCHAR(255); 
DECLARE v_payment_due DECIMAL(6,2);
DECLARE v_price DECIMAL(6,2);
UPDATE booking SET payment_status="paid" where id=p_id;
SELECT member_id, price INTO v_member_id, v_price FROM
member_bookings WHERE id = p_id;
SELECT payment_due INTO v_payment_due FROM members WHERE id
= v_member_id;
UPDATE members SET payment_due = v_payment_due - v_price
WHERE id = v_member_id;
END $$

DELIMITER $$
CREATE PROCEDURE search_room (IN p_room_type VARCHAR(255), IN
p_booked_date DATE, IN p_booked_time TIME)
BEGIN
SELECT * FROM room WHERE id NOT IN (SELECT room_id FROM
bookings WHERE booked_date = p_booked_date AND booked_time =
p_booked_time AND payment_status != 'Cancelled') AND room_type =
p_room_type;
END $$

DELIMITER $$
CREATE PROCEDURE cancel_booking (IN p_booking_id INT, OUT
p_message VARCHAR(255))
BEGIN
DECLARE v_cancellation INT;
DECLARE v_member_id VARCHAR(255);
DECLARE v_payment_status VARCHAR(255);
DECLARE v_booked_date DATE;
DECLARE v_price DECIMAL(6, 2);
DECLARE v_payment_due VARCHAR(255);
SET v_cancellation = 0;
SELECT member_id, booked_date, price, payment_status INTO
v_member_id, v_booked_date, v_price, v_payment_status FROM
member_bookings WHERE id = p_booking_id;
SELECT payment_due INTO v_payment_due FROM members WHERE id
= v_member_id;
IF curdate() >= v_booked_date THEN
SELECT 'Cancellation cannot be done on/after the
booked date' INTO p_message;
ELSEIF v_payment_status = 'Cancelled' OR
v_payment_status = 'Paid' THEN
SELECT 'Booking has already been cancelled or
paid' INTO p_message;
ELSE
UPDATE bookings SET payment_status = 'Cancelled'
WHERE id = p_booking_id;
SET v_payment_due = v_payment_due -
v_price;
SET v_cancellation = check_cancellation
(p_booking_id);
IF v_cancellation >= 2 THEN SET v_payment_due =
v_payment_due + 10;
END IF;
UPDATE members SET payment_due = v_payment_due
WHERE id = v_member_id;
SELECT 'Booking Cancelled' INTO p_message;
END IF;
END $$