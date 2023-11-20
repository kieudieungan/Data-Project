SELECT * FROM Employees

SELECT SSN, LastName --Select last name of all employees
FROM dbo.Employees

SELECT distinct LastName --Select last name with out duplicates
FROM dbo.Employees

SELECT * --Select data of employees with last name is Smith
FROM dbo.Employees
WHERE LastName = 'Smith'

SELECT * --Select data of employees with last name is Smith or Doe
FROM dbo.Employees
WHERE LastName = 'Smith' OR LastName = 'Doe'

SELECT * --Select data of employees work in department 14
FROM dbo.Employees
WHERE Department = 14

SELECT * --Select data of employees work in de 37 or 77
FROM dbo.Employees
WHERE Department = 37 or Department = 77

SELECT * --Select data of employees whose last name begin with 'S'
FROM dbo.Employees
WHERE LastName like 'S%'

SELECT * FROM dbo.Departments

SELECT SUM(Budget) as TotalBudget -- Select sum of total budgets
FROM dbo.Departments

SELECT a.Code, COUNT(b.SSN) CountEmployess --Select number of employees in each department
FROM dbo.Departments a
LEFT JOIN dbo.Employees b 
ON a.Code = b.Department
GROUP BY Code

SELECT * --Select data of employees and their departments 
FROM dbo.Employees b
LEFT JOIN dbo.Departments a
ON b.Department = a.Code 

SELECT b.Name, b.LastName, a.Name DepartmentName, a.Budget --Select name, last name of employees, name and budget of their department
FROM dbo.Employees b
INNER JOIN dbo.Departments a
ON b.Department = a.Code 

SELECT b.Name, b.LastName, a.Name DepartmentName, a.Budget --Select name, last name of employees, name of de having budget > 60000
FROM dbo.Employees b
LEFT JOIN dbo.Departments a
ON b.Department = a.Code 
WHERE a.Budget > 60000

SELECT * --Select departments having budget > average budget
FROM dbo.Departments 
WHERE Budget > (SELECT AVG(Budget) FROM dbo.Departments)

WITH A AS (
    SELECT a.Name, COUNT(SSN) AS NumberEmployees --Select name of departments with more than 2 employees
    FROM dbo.Departments a 
    INNER JOIN dbo.Employees b
    ON a.Code = b.Department
    GROUP BY a.Name 
)
SELECT *
FROM A
WHERE NumberEmployees > 2

WITH B AS (--Select name of employees working for department having second lowest budget
    SELECT b.Name, b.LastName, a.Name DepartmentName, a.Budget,
    DENSE_RANK() OVER (ORDER BY a.Budget ASC) AS BudgetRank 
    FROM dbo.Employees b
    INNER JOIN dbo.Departments a
    ON b.Department = a.Code 
)
SELECT *
FROM B 
WHERE BudgetRank = 2

INSERT INTO dbo.Departments(Code, Name, Budget) --Add a new deparment, its budget
VALUES(11, 'Quality Assurance', 40000)

SELECT * from dbo.Departments

INSERT INTO dbo.Employees(SSN, Name, LastName, Department)--Add a new employee
VALUES(847219811, 'Mary', 'Moore', 11)

UPDATE dbo.Employees
SET SSN = 847219811

DELETE dbo.Employees
WHERE SSN = -8985

SELECT * FROM dbo.Employees

SELECT *, CAST(Budget - Budget/10 AS INT) AS NewBudget-- Reduce Budget of each Department by 10%
FROM dbo.Departments

UPDATE dbo.Employees--Reassign employees from department 77 to 14
SET Department = 14
WHERE Department = 77

DELETE dbo.Employees--Delete employees in IT department code 14
WHERE Department = 14

DELETE FROM dbo.Employees--Delete employees in departments having budget >= 60000
WHERE Department IN (
    SELECT a.Code
    FROM dbo.Departments a
    WHERE a.Budget >= 60000
)

DROP TABLE dbo.Employees --Delete all employees
