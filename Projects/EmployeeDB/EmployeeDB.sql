-- Create department Table
CREATE TABLE department (
    depart_id SERIAL PRIMARY KEY,
    depart_name VARCHAR(100),
	depart_city VARCHAR(100)
);

-- Create roles Table
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_title VARCHAR(100)
);

-- Create salaries Table
CREATE TABLE salaries (
    salary_id SERIAL PRIMARY KEY,
    salary_pa NUMERIC(10, 2)	
);

-- Create overtime_hours Table
CREATE TABLE overtime_hours (
    overtime_id SERIAL PRIMARY KEY,
    overtime_hours INTEGER	
);

-- Create employees Table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    surname VARCHAR(100),
	gender VARCHAR(10),
	address TEXT,
	email VARCHAR(100) UNIQUE,
    depart_id INTEGER REFERENCES department(depart_id),
    role_id INTEGER REFERENCES roles(role_id),
	salary_id INTEGER REFERENCES salaries(salary_id),
	overtime_id INTEGER REFERENCES overtime_hours(overtime_id)
);

-- Insert values into department Table
INSERT INTO department (depart_name, depart_city) 
VALUES ('IT','Johannesburg'),
       ('HR','Paris');

-- Insert values into roles Table
INSERT INTO roles (role_title) 
VALUES ('Software Engineer'),
       ('Manager');

-- Insert values into salary Table
INSERT INTO salaries (salary_pa)
VALUES (69000.00),
       (40000.00);

-- Insert values into overtime_hours Table
INSERT INTO overtime_hours (overtime_hours)
VALUES (2),
       (1);
	   
-- Insert values into employees Table
INSERT INTO employees (first_name, surname, gender, address, email, depart_id, role_id, salary_id, overtime_id)
VALUES ('Rishen', 'Surjoobhalee', 'Male', '69th street', 'rish@gmail.com', 1, 1, 1, 1),
       ('Anna', 'Smith', 'Female', '7th street', 'Anna@gmail.com', 2, 2, 2, 2);
	   
-- Join all the tables to show the person's info
SELECT 
     e.first_name, 
     e.surname, 
	 d.depart_name, 
	 r.role_title, 
	 s.salary_pa, 
	 o.overtime_hours
	 
FROM Employees e
LEFT JOIN 
    Department d ON e.depart_id = d.depart_id
LEFT JOIN 
    roles r ON e.role_id = r.role_id
LEFT JOIN 
    salaries s ON e.employee_id = s.salary_id
LEFT JOIN 
    overtime_hours o ON e.employee_id = o.overtime_id;
