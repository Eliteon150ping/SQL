-- Create the zip_code table with a CHECK constraint on zip_code to allow only 4 digits
CREATE TABLE zip_code (
    zip_code CHAR(4) PRIMARY KEY,
    city VARCHAR(50),
    province VARCHAR(50),
    CHECK (length(zip_code) = 4)
);

-- Insert records for 9 provinces and 2 cities per province
INSERT INTO zip_code (zip_code, city, province) VALUES
('1001', 'Johannesburg', 'Gauteng'),
('1002', 'Pretoria', 'Gauteng'),
('2001', 'Durban', 'KZN'),
('2002', 'Pietermaritzburg', 'KZN'),
('3001', 'Polokwane', 'Limpopo'),
('3002', 'Giyani', 'Limpopo'),
('4001', 'Rustenburg', 'North West'),
('4002', 'Mahikeng', 'North West'),
('5001', 'Kimberley', 'Northern Cape'),
('5002', 'Upington', 'Northern Cape'),
('6001', 'Cape Town', 'Western Cape'),
('6002', 'Bellville', 'Western Cape'),
('7001', 'Gqeberha', 'Eastern Cape'),
('7002', 'East London', 'Eastern Cape'),
('8001', 'Bloemfontein', 'Free State'),
('8002', 'Welkom', 'Free State'),
('9001', 'Emalahleni', 'Mpumalanga'),
('9002', 'Nelspruit', 'Mpumalanga');

-- Create the profession table with a UNIQUE constraint
CREATE TABLE profession (
    profession_id SERIAL PRIMARY KEY,
    profession VARCHAR(100) UNIQUE
);

-- Create the status table with predefined values
CREATE TABLE status (
    status_id SERIAL PRIMARY KEY,
    status VARCHAR(100)
);

-- Insert status values
INSERT INTO status (status) VALUES
('Single'),
('Married'),
('Divorced'),
('Widowed');

-- Create the my_contacts table with more than 15 contacts
CREATE TABLE my_contacts (
    contact_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
	last_name VARCHAR(100),
    profession_id INT REFERENCES profession(profession_id),
    zip_code CHAR(4) REFERENCES zip_code(zip_code),
    status_id INT REFERENCES status(status_id),
    seeking VARCHAR(100)
);

-- Insert professions
INSERT INTO profession (profession) VALUES
('Engineer'),
('Doctor'),
('Teacher'),
('Artist'),
('Lawyer'),
('Nurse'),
('Scientist'),
('Musician');

-- Insert contacts (ensure each contact has a profession, zip_code, and status)
INSERT INTO my_contacts (first_name, last_name, profession_id, zip_code, status_id, seeking) VALUES
('John','Doe', 1, '1001', 1, 'Friendship'),
('Jane','Smith', 2, '1002', 1, 'Relationship'),
('Alice','Johnson', 3, '2001', 2, 'Networking'),
('Bob','Brown', 4, '2002', 1, 'Friendship'),
('Charlie','Davis', 5, '3001', 3, 'Relationship'),
('Diana','Miller', 6, '3002', 4, 'Friendship'),
('Ethan','Wilson', 7, '4001', 1, 'Networking'),
('Fiona','Moore', 8, '4002', 1, 'Friendship'),
('George','Taylor', 1, '5001', 2, 'Networking'),
('Hannah','Anderson', 2, '5002', 3, 'Friendship'),
('Ivy','Thomas', 3, '6001', 1, 'Relationship'),
('Jack','Lee', 4, '6002', 1, 'Networking'),
('Kate','Harris', 5, '7001', 2, 'Friendship'),
('Liam','Walker', 6, '7002', 3, 'Networking'),
('Mia','Young', 7, '8001', 4, 'Relationship'),
('Noah','King', 8, '8002', 1, 'Friendship');

-- Create the interests table
CREATE TABLE interests (
    interest_id SERIAL PRIMARY KEY,
    contact_id INT REFERENCES my_contacts(contact_id),
    interests VARCHAR(100)
);

-- Insert interests (more than 2 interests per contact)
INSERT INTO interests (contact_id, interests) VALUES
(1, 'Reading''Hiking'),
(2, 'Swimming''Traveling'),
(3, 'Gaming''Dancing'),
(4, 'Traveling''Music'),
(5, 'Reading''Writing'),
(6, 'Gaming''Cooking'),
(7, 'Photography''Music'),
(8, 'Reading''Hiking'),
(9, 'Cooking''Dancing'),
(10, 'Swimming''Photography'),
(11, 'Gaming''Writing'),
(12, 'Yoga''Biking'),
(13, 'Art''Reading'),
(14, 'Cooking''Traveling'),
(15, 'Photography''Dancing'),
(16, 'Reading''Hiking');

-- Example LEFT JOIN query to display the required information
SELECT
    c.first_name,
    c.last_name,
    p.profession AS profession,
    z.zip_code,
    z.city,
    z.province,
    s.status AS status,
    STRING_AGG(i.interests, ', ') AS interests,
    c.seeking
FROM
    my_contacts c
LEFT JOIN
    zip_code z ON c.zip_code = z.zip_code
LEFT JOIN
    profession p ON c.profession_id = p.profession_id
LEFT JOIN
    status s ON c.status_id = s.status_id
LEFT JOIN
    interests i ON c.contact_id = i.contact_id
GROUP BY
    c.contact_id, c.first_name, c.last_name, p.profession, z.zip_code, z.city, z.province, s.status, c.seeking;
