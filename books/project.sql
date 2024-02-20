drop database if exists project;
create database if not exists project;
use project;

create table if not exists publisher(
PublisherName varchar(100) NOT NULL,
PublisherAddress varchar(100),
PublisherPhone varchar(100),
PRIMARY KEY (PublisherName));

create table if not exists book(
BookID INT NOT NULL AUTO_INCREMENT,
Title varchar(100),
PublisherName varchar(100),
PRIMARY KEY (BookID),
FOREIGN KEY (PublisherName)
references publisher(PublisherName)
ON DELETE CASCADE
ON UPDATE CASCADE);

create table if not exists authors(
AuthorID int  NOT NULL AUTO_INCREMENT,
BookID INT,
AuthorName varchar(100),
PRIMARY KEY (AuthorID),
FOREIGN KEY (BookID)
references book(BookID)
ON DELETE CASCADE
ON UPDATE CASCADE);

create table if not exists library_branch(
BranchID INT  NOT NULL AUTO_INCREMENT,
BranchName varchar(100),
BranchAddress varchar(100),
PRIMARY KEY (BranchID));

create table if not exists book_copies(
copiesID INT NOT NULL AUTO_INCREMENT,
BookID INT,
BranchID INT,
No_Of_Copies INT,
PRIMARY KEY (copiesID),
FOREIGN KEY (BookID)
references book(BookID)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (BranchID)
references library_branch (BranchID)
ON DELETE CASCADE
ON UPDATE  CASCADE);

create table if not exists borrower(
CardNo INT  NOT NULL AUTO_INCREMENT,
BorrowerName varchar(100),
BorrowerAddress varchar(100),
BorrowerPhone varchar(20),
PRIMARY KEY (CardNo));


create table if not exists book_loans(
loanID INT AUTO_INCREMENT NOT NULL,
BookID INT,
BranchID INT,
CardNo INT,
DateOut Date,
DueDate Date,
PRIMARY KEY (loanID),
FOREIGN KEY (BookID)
references book(BookID)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (BranchID)
references library_branch (BranchID)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (CardNo)
references borrower (CardNo)
ON DELETE CASCADE
ON UPDATE CASCADE);


 -- Drop table  book_loans;
-- drop table borrower;

select * from publisher;
select * from book;
select * from authors;
select * from library_branch;
select * from book_copies;
select * from book_loans;
select * from borrower;


-- 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
SELECT b.Title,bc.No_Of_Copies,l.BranchName
FROM book b
INNER JOIN book_copies bc
ON b.BookID=bc.BookID
INNER JOIN library_branch l
ON bc.BranchID=l.BranchID
WHERE Title ="The Lost Tribe" and BranchName = "Sharpstown";


-- 2.How many copies of the book titled "The Lost Tribe" are owned by each library branch?
SELECT b.Title,bc.No_Of_Copies,l.*
FROM book b
INNER JOIN book_copies bc
ON b.BookID=bc.BookID
INNER JOIN library_branch l
ON bc.BranchID=l.BranchID
WHERE Title ="The Lost Tribe";


-- 3. Retrieve the names of all borrowers who do not have any books checked out.
SELECT  br.BorrowerName
FROM borrower br
LEFT JOIN book_loans bl
ON bl.CardNo=br.CardNo
WHERE bl.BookID IS NULL;


/* 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, 
etrieve the book title, the borrower's name, and the borrower's address. */
SELECT b.BookID,br.BorrowerName,br.BorrowerAddress,b.Title,bl.DueDate,lb.BranchName
FROM book b
INNER JOIN book_loans bl
ON b.BookID=bl.BookID
INNER JOIN library_branch lb
ON bl.BranchID=lb.BranchID
INNER JOIN borrower br
ON bl.CardNo=br.CardNo
WHERE BranchName = "Sharpstown" and  DueDate =  '2018/02/03';


-- 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
SELECT lb.BranchName,count(bl.BookID) AS Books
FROM library_branch lb
INNER JOIN book_loans bl
ON bl.BranchID = lb.BranchID
GROUP BY lb.BranchName;


-- 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
SELECT br.BorrowerName,br.BorrowerAddress,count(bl.BookID) AS Books_Checkedout
FROM  borrower br
INNER JOIN book_loans bl
ON br.CardNo=bl.CardNo
GROUP BY br.BorrowerName,br.BorrowerAddress
HAVING Books_Checkedout>5;


-- 7.For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
SELECT a.BookID,a.AuthorName,lb.BranchName,lb.BranchID,bc.No_Of_Copies,a.AuthorID,b.Title
FROM authors a
INNER JOIN book b
ON a.BookID=b.BookID
INNER JOIN book_copies bc
ON b.BookID=bc.BookID
INNER JOIN library_branch lb
ON bc.BranchID=lb.BranchID
WHERE  AuthorName = "Stephen King" AND BranchName = "Central";
