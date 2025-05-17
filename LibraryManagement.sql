
USE librarymanagement;

CREATE TABLE authors(
					author_id INT Primary Key,
                    first_name VARCHAR(50),
                    last_name VARCHAR(50),
                    birth_date DATE,
                    nationality VARCHAR(50)
                    );

INSERT INTO authors (author_id, first_name, last_name, birth_date, nationality)
VALUES(1, 'Harper', 'Lee', '1926-04-28', 'American'),
(2, 'George', 'Orwell', '1903-06-25', 'British'),
(3, 'Jane', 'Austen', '1775-12-16', 'British'),
(4, 'F.Scott', 'Fitzgerald', '1896-09-24', 'American'),
(5, 'Herman', 'Melville', '1819-08-01',	'American'),
(6, 'J.D.', 'Salinger', '1919-01-01', 'American'),
(7, 'Leo', 'Tolstoy', '1828-09-09', 'Russian'),
(8, 'Homer'	'UK', 'UK', NULL,'Greek'),
(9, 'Fyodor', 'Dostoevsky', '1821-11-11', 'Russian'),
(10, 'J.R.R.', 'Tolkien', '1892-01-03', 'British'),
(11, 'C.S.', 'Lewis', '1898-11-29', 'British'),
(12, 'J.K.', 'Rowling', '1965-07-31', 'British'),
(13, 'Dan', 'Brown', '1964-06-22', 'American'),
(14, 'Paulo', 'Coelho', '1947-08-24', 'Brazilian'),
(15, 'Stephen', 'King', '1947-09-21', 'American'),
(16, 'Cormac', 'McCarthy', '1933-07-20', 'American'),
(17, 'Paula', 'Hawkins', '1972-08-26', 'British'),
(18, 'Suzanne', 'Collins', '1962-08-10', 'American'),
(19, 'Joseph', 'Heller', '1923-05-01', 'American'),
(20, 'Aldous', 'Huxley', '1894-07-26', 'British'),
(21, 'Oscar', 'Wilde', '1854-10-16', 'Irish'),
(22, 'Sylvia', 'Plath', '1932-10-27', 'American'),
(23, 'Frances', 'Hodgson Burnett', '1849-11-24', 'British'),
(24, 'Louisa May', 'Alcott', '1832-11-29', 'American'),
(25, 'S.E.', 'Hinton', '1950-07-22', 'American'),
(26, 'Lois', 'Lowry', '1937-03-20', 'American'),
(27, 'Stephen', 'Chbosky', '1970-01-25', 'American'),
(28, 'Khaled', 'Hosseini', '1965-03-04', 'Afghan');

SELECT * FROM authors;

select CONCAT(first_name, space(1), last_name) AS full_name FROM authors;


CREATE TABLE members(
					member_id INT Primary Key, 
                    first_name VARCHAR(50), 
                    last_name VARCHAR(50), 
                    email VARCHAR(50), 
                    address VARCHAR(100), 
                    phone VARCHAR(50), 
                    membership_date DATE
					);
SELECT * FROM members;

INSERT INTO members(member_id, first_name , last_name, email, address, phone, membership_date)
VALUES (1, "Nikoletta", "Mouser", "nmouser8f@storify.com", "Chinook", "237-836-4154", "2024-03-15"),
(2, "Clair", "Boynton", "cboynton8g@epa.gov", "Rutledge", "697-569-6076", "2023-08-22"),
(3, "Morten",	"Lain", "mlain8h@goo.ne.jp", "Jackson", "682-146-4338", "2022-11-05"),
(4, "Constantina", "Fant", "cfant8i@si.edu", "Hoard", "700-309-8405", "2021-06-30"),
(5, "Mildred", "Duthie", "mduthie8j@eepurl.com", "Gateway", "474-706-1426", "2020-09-12"),
(6, "Nikita", "Cummins", "ncummins8k@lycos.com", "Stephen", "414-357-7239", "2023-02-18"),
(7, "Matteo", "O'Cridigan", "mocridigan8l@webnode.com", "Delladonna", "922-483-8711", "2024-01-25"),
(8, "Cy", "Garner", "cgarner8m@studiopress.com", "Novick", "573-543-4064", "2022-04-10"),
(9, "Ricky", "Wein", "rwein8n@jigsy.com", "Messerschmidt", "311-422-3994", "2021-07-19"),
(10, "Jay", "Bonnin", "jbonnin8o@samsung.com", "International", "953-589-7871", "2023-09-05"),
(11, "Nobie", "Sheivels", "nsheivels8p@blogtalkradio.com", "Service", "183-106-9959", "2020-12-13"),
(12, "Adrienne", "Hurndall", "ahurndall8q@rakuten.co.jp", "4th", "149-647-6340", "2022-02-28"),
(13, "Sarena", "Wyburn", "swyburn9r@shareasale.com", "Fremont", "626-441-6221", "2021-11-16"),
(14, "Devi", "Gratton", "dgratton9s@sohu.com", "Raven", "659-614-4422", "2023-05-09"),
(15, "Shela", "Bartrum", "sbartrum9t@nps.gov", "Forest Dale", "690-702-5471", "2022-08-23"),
(16, "Letisha", "Nelthorp", "lnelthorp9u@uiuc.edu", "Dixon", "862-598-9959", "2021-04-17"),
(17, "Lois", "Kelso", "lkelso9v@google.it", "Golf Course", "397-797-5214", "2023-11-30"),
(18, "Jennette", "Tipton", "jtipton9w@linkedin.com", "Tomscot", "202-902-9674", "2022-07-14"),
(19, "Hilary", "Lovejoy", "hlovejoy9x@icq.com", "Ruskin", "273-613-9630", "2021-05-06"),
(20, "Berget", "Eplate", "beplate9y@51.la", "Bultman", "522-292-9916", "2023-03-22"),
(21, "Neel", "Rigolle", "nrigolle9z@woothemes.com", "Maple Wood", "969-451-3562", "2022-01-11"),
(22, "Jessee", "Simeon", "jsimeona0@dailymail.co.uk", "Michigan", "743-766-9434", "2021-09-18"),
(23, "Jeanette", "Rollason", "jrollasona1@php.net", "Sutherland", "797-884-9586", "2023-06-04"),
(24, "Lydie", "McHale", "lmchalea2@google.nl", "Autumn Leaf", "113-255-5824", "2022-10-29"),
(25, "Cher", "Miall", "cmiallh5@usa.gov", "2nd", "956-512-1415", "2021-02-02"),
(26, "Sibelle", "Trethewey", "stretheweyh6@twitpic.com", "Eagle Crest", "442-143-0165", "2023-04-13"),
(27, "Hatti", "Southers", "hsouthersh7@unc.edu", "Calypso", "789-167-0552", "2022-05-20"),
(28, "Glori", "Kubicki", "gkubickih8@meetup.com", "Mitchell", "212-537-6062", "2021-08-30"),
(29, "Kelsi", "Maciaszek", "kmaciaszekh9@vimeo.com", "Starling", "647-907-3533", "2023-07-17"),
(30, "Glory", "Filov", "gfilovha@lulu.com", "Forest Dale", "873-383-7030", "2022-11-09");

SELECT * FROM members;


CREATE TABLE staff(
					staff_id INT Primary Key,
                    first_name	VARCHAR(50), 
                    last_name VARCHAR(50),
                    email VARCHAR(100),
                    phone VARCHAR(50), 
                    hire_date DATE,
                    position VARCHAR(50)
					);
 
 INSERT INTO staff(staff_id, first_name, last_name, email, phone, hire_date, position)
 VALUES (900, "John", "Doe", "john.doe@library.com", "9876543210", "2022-01-15", "Library Director"),
(901, "Jane", "Smith", "jane.smith@library.com", "9876543211", "2021-03-22", "Circulation Supervisor"),
(902, "Michael", "Johnson", "michael.johnson@library.com", "9876543212", "2020-07-10", "Cataloging Manager"),
(903, "Emily", "Davis", "emily.davis@library.com", "9876543213", "2019-11-05", "Reference Librarian"),
(904, "David", "Wilson", "david.wilson@library.com", "9876543214", "2018-09-18", "Technical Services Manager"),
(905, "Sarah", "Brown", "sarah.brown@library.com", "9876543215", "2021-02-28", "Digital Resources Coordinator"),
(906, "James", "Taylor", "james.taylor@library.com", "9876543216", "2020-05-14", "Interlibrary Loan Specialist"),
(907, "Linda", "Anderson", "linda.anderson@library.com", "9876543217", "2019-08-20", "Library Assistant"),
(908, "Robert", "Thomas", "robert.thomas@library.com", "9876543218", "2022-04-02", "Systems Librarian"),
(909, "Patricia", "Jackson", "patricia.jackson@library.com", "9876543219", "2021-06-25", "Programming Librarian");
 
 SELECT * FROM staff;
 
 
 CREATE TABLE publishers(
						publisher_id INT Primary Key,
						name VARCHAR(50),
						address	VARCHAR(100),
						phone VARCHAR(50),
						email VARCHAR(100)
						);
                        
INSERT INTO publishers (publisher_id, name, address, phone, email)
VALUES (111, "Aayu Publications", "D-134, Agar Nagar, Prem Nagar-III, New Delhi-110086", "9910728725", "aayupublication@gmail.com"),
(112, "Abhay Publication", "1/11083, Street No 8- Subhash Park, Delhi-32", "9871137296", "abhaypublication@gmail.com"),
(113, "ABS Books", "B-21, Ved and Shiv Colony, Buddha Vihar, Phase-2, Delhi-110086", "9999868875", "absbooksindia@gmail.com"),
(114, "Academic and Agrovet Books", "23/4760-61, Ansari Road, Daryaganj, New Delhi-110002", "9811676048", "academicagrovetpub17@gmail.com"),
(115, "Adam Publishers & Distributors", "1542, Pataudi House, Darya Ganj, New Delhi-110002", '9810296541', "apd1542@gmail.com"),
(116, "Arvind Book Distributors", "89, G.F., SFS Flats, Rajouri Apartments, Mayapuri, New Delhi-110064", '25144089', "arvindm1959@gmail.com"),
(117, "Arya Prakashan Mandal", "Room No. 210-11, 24, Ansari Road, Daryaganj, Delhi-110002", "9811175085", "aryanprakashanmandal@gmail.com"),
(118, "Ashu Book House", "Opp. Science College, Canal Road, Jammu", "9858052341", "guptajay33@yahoo.in"),
(119, "Asian Books International", "Sathu Balla Barbar Shah, Srinagar-190001", "00000000", "acc.sgr@rediffmail.com"),
(120, "ASR Publications", "JP-535, Jairaj Puri, Hydril Colony, Sarojini Nagar, Lucknow-226008", "9651090738", "ayushmangroupofpublications@gmail.com");

SELECT * FROM publishers;


CREATE TABLE books(
					book_id INT Primary Key,
					title VARCHAR(100),
					author_id INT, 
					publisher_id INT, 
					genre VARCHAR(50),
					year_published YEAR,
					isbn VARCHAR(100),
					copies_available INT,
					Foreign Key(author_id) REFERENCES authors(author_id), 
					Foreign Key(publisher_id) REFERENCES publishers(publisher_id)
					);

INSERT INTO books (book_id, title, author_id, publisher_id, genre, year_published, isbn, copies_available)
VALUES(101, 'To Kill a Mockingbird', 1, 111, 'Fiction', 1960, '9780061120084', 13),
(102, '1984', 2, 112, 'Dystopian Fiction', 1949, '978-0451524935', 66),
(103, 'Pride and Prejudice', 3, 113, 'Romance, Satire', 1913, '978-1503290563', 28),
(104, 'The Great Gatsby', 4, 114, 'Tragedy, Social Commentary', 1925, '978-0743273565', 111),
(105, 'Moby-Dick', 5, 115, 'Adventure, Epic', 1951, '978-1503280786', 99),
(106, 'The Catcher in the Rye', 6, 116, 'Realistic Fiction', 1951, '978-0316769488', 110),
(107, 'War and Peace', 7, 117, 'Historical Fiction', 1969, '978-0140447934', 2),
(108, 'Crime and Punishment', 8, 118, 'Psychological Fiction', 1966, '978-0486415871', 7),
(109, 'Catch-22', 9, 119, 'Satirical War Novel', 1961, '978-1451626650', 76),
(110, 'Brave New World', 10, 120, 'Science Fiction, Dystopian', 1932, '978-0060850524', 19),
(111, 'The Picture of Dorian Gray', 11, 111, 'Gothic Fiction', 1990, '978-1505296002', 33), 
(112, 'The Bell Jar', 12, 112, 'Semi-autobiographical Fiction', 1963, '978-0060837020', 46),
(113, 'The Secret Garden', 13, 113, "Children's Fiction", 1911, '978-0141321063', 55),
(114, 'Little Women', 14, 114, 'Coming-of-Age Fiction', 1968, '978-1503280298', 64),
(115, 'The Outsiders', 15, 115, 'Young Adult Fiction', 1967, '978-0142407332', 73),
(116, 'The Giver', 16, 116, 'Dystopian Fiction', 1993, '978-0440237686', 87),
(117, 'The Perks of Being a Wallflower', 17, 117, 'Young Adult Fiction', 1999, '978-0671027346', 97),
(118, 'The Girl on the Train', 18, 118, 'Psychological Thriller', 2015, '978-1594633669', 113),
(119, 'The Hunger Games', 19, 119, 'Dystopian, Science Fiction', 2008, '978-0439023528', 23),
(120, 'The Kite Runner', 20, 120, 'Historical Fiction', 2003, '978-1594631931', 26),
(121, 'The Odyssey', 21, 111, 'Epic Poetry', 1901, '978-0140268867', 14),
(122, 'The Hobbit', 22, 112, 'High Fantasy', 1937, '978-0547928227', 110),
(123, 'The Lion, the Witch and the Wardrobe', 23, 113, "Children's Fantasy", 1950, '978-0064409421', 9),
(124, "Harry Potter and the Philosopher's Stone", 24, 114, 'Fantasy', 1997, '978-0747532699', 21),
(125, 'The Da Vinci Code', 25, 115, 'Mystery, Thriller', 2003, '978-0307474278', 72),
(126, 'The Alchemist', 26, 116, 'Quest, Adventure, Fantasy', 1988, 978-0061122415, 12);

SELECT * FROM books;

-- The below was to check what are foreign key constraint names
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.table_constraints
WHERE table_schema = 'librarymanagement'
AND table_name = 'books';


CREATE TABLE loans(
					loan_id	INT Primary Key,
					book_id	INT,
					member_id INT,
					loan_date DATE,
					return_date DATE NULL,
					due_date DATE,
                    Foreign Key(book_id) REFERENCES books(book_id),
                    Foreign Key(member_id) REFERENCES members(member_id)   
					);

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.table_constraints
WHERE table_schema = 'librarymanagement'
AND table_name = 'loans';

INSERT INTO Loans (loan_id, book_id, member_id, loan_date, return_date, due_date) 
VALUES
(1, 101, 1, '2025-05-01', '2025-05-10', '2025-05-08'),
(2, 102, 2, '2025-05-02', '2025-05-12', '2025-05-09'),
(3, 103, 3, '2025-05-03', '2025-05-13', '2025-05-10'),
(4, 104, 4, '2025-05-04', '2025-05-14', '2025-05-11'),
(5, 105, 5, '2025-05-05', '2025-05-15', '2025-05-12'),
(6, 106, 6, '2025-05-06', '2025-05-16', '2025-05-13'),
(7, 107, 7, '2025-05-07', '2025-05-17', '2025-05-14'),
(8, 108, 8, '2025-05-08', '2025-05-18', '2025-05-15'),
(9, 109, 9, '2025-05-09', '2025-05-19', '2025-05-16'),
(10, 110, 10, '2025-05-10', '2025-05-20', '2025-05-17'),
(11, 111, 11, '2025-05-11', '2025-05-21', '2025-05-18'),
(12, 112, 12, '2025-05-12', '2025-05-22', '2025-05-19'),
(13, 113, 13, '2025-05-13', '2025-05-23', '2025-05-20'),
(14, 114, 14, '2025-05-14', '2025-05-24', '2025-05-21'),
(15, 115, 15, '2025-05-15', '2025-05-25', '2025-05-22'),
(16, 116, 16, '2025-05-16', '2025-05-26', '2025-05-23'),
(17, 117, 17, '2025-05-17', '2025-05-27', '2025-05-24'),
(18, 118, 18, '2025-05-18', '2025-05-28', '2025-05-25'),
(19, 119, 19, '2025-05-19', '2025-05-29', '2025-05-26'),
(20, 120, 20, '2025-05-20', '2025-05-30', '2025-05-27'),
(21, 121, 21, '2025-05-21', '2025-05-31', '2025-05-28'),
(22, 122, 22, '2025-05-22', '2025-06-01', '2025-05-29'),
(23, 123, 23, '2025-05-23', '2025-06-02', '2025-05-30'),
(24, 124, 24, '2025-05-24', '2025-06-03', '2025-06-01'),
(25, 125, 25, '2025-05-25', '2025-06-04', '2025-06-02'),
(26, 126, 26, '2025-05-26', '2025-06-05', '2025-06-03');

SELECT * FROM loans;
