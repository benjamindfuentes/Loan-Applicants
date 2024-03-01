--Borrower information
SELECT * 
FROM applications.borrower 
LIMIT 5

 id | age |   home   |  intent   | emp_length | cred_length | default
----+-----+----------+-----------+------------+-------------+---------
  0 |  22 | RENT     | PERSONAL  | 1          |           3 | Y
  1 |  21 | OWN      | EDUCATION | 5          |           2 | N
  2 |  25 | MORTGAGE | MEDICAL   | 1          |           3 | N
  3 |  23 | RENT     | MEDICAL   | 4          |           2 | N
  4 |  24 | RENT     | MEDICAL   | 8          |           4 | Y

--Income information per borrower
SELECT *
FROM applications.income
LIMIT 5

 income_id | income
-----------+--------
         0 |  59000
         1 |   9600
         2 |   9600
         3 |  65500
         4 |  54400

--Loan details per borrower   
SELECT *
FROM applications.loan
LIMIT 5

 loan_id | rate  | amount
---------+-------+--------
       0 | 16.02 |  35000
       1 | 11.14 |   1000
       2 | 12.87 |   5500
       3 | 15.23 |  35000
       4 | 14.27 |  35000

--Percent income based on loan amount requested per loan
SELECT loan.loan_id, 
       loan.amount, 
       income.income, 
       ROUND(((1.0*loan.amount)/income.income), 2) AS percent_income 
FROM applications.loan AS loan
INNER JOIN applications.income AS income
ON loan.loan_id = income.income_id
GROUP BY loan.loan_id, loan.amount, income.income
LIMIT 5
;

-- Note this only shows the first 5 loans but the query returns the entire loan table.
 loan_id | amount | income | percent_income
---------+--------+--------+----------------
       0 |  35000 |  59000 |           0.59
       1 |   1000 |   9600 |           0.10
       2 |   5500 |   9600 |           0.57
       3 |  35000 |  65500 |           0.53
       4 |  35000 |  54400 |           0.64

--Avergae loan amount per home ownership
SELECT borrower.home AS homeownership, 
       ROUND(AVG(loan.amount), 2) AS average_loan 
FROM applications.borrower AS borrower
RIGHT JOIN applications.loan AS loan
ON borrower.id = loan.loan_id
GROUP BY borrower.home
;

 homeownership | average_loan
---------------+--------------
 MORTGAGE      |      9021.95
 RENT          |     17710.69
 OTHER         |      5150.00
 OWN           |      6242.84

--Average age per homeownership   
SELECT borrower.home AS homeownership, 
       ROUND(AVG(borrower.age), 2) AS average_age 
FROM applications.borrower
GROUP BY borrower.home
;

 homeownership | average_age
---------------+-------------
 MORTGAGE      |       23.90
 RENT          |       24.03
 OTHER         |       23.17
 OWN           |       23.13

--Compare credit length, rate, loan amount and income for every borrower
SELECT borrower.id, 
       borrower.cred_length AS credit_length, 
       loan.rate, 
       loan.amount, 
       income.income 
FROM applications.borrower AS borrower
INNER JOIN applications.loan AS loan
ON borrower.id = loan.loan_id
INNER JOIN applications.income AS income
ON loan.loan_id = income.income_id
;

-- Note this only shows the first 5 borrowers but the query returns the entire borrower table.
 id | credit_length | rate  | amount | income
----+---------------+-------+--------+--------
  0 |             3 | 16.02 |  35000 |  59000
  1 |             2 | 11.14 |   1000 |   9600
  2 |             3 | 12.87 |   5500 |   9600
  3 |             2 | 15.23 |  35000 |  65500
  4 |             4 | 14.27 |  35000 |  54400

--Finding the MAX income for every loan purpose/intent
SELECT borrower.intent, 
	     MAX(income.income) AS max_income 
FROM applications.borrower AS borrower
INNER JOIN applications.income AS income
ON borrower.id = income.income_id
GROUP BY borrower.intent
ORDER BY borrower.intent
;

      intent       | max_income
-------------------+------------
 DEBTCONSOLIDATION |     500000
 EDUCATION         |     300000
 HOMEIMPROVEMENT   |     300000
 MEDICAL           |     300000
 PERSONAL          |     280000
 VENTURE           |     300000

--Finding the MIN income for every loan purpose/intent
SELECT borrower.intent, 
	   MIN(income.income) AS min_income 
FROM applications.borrower AS borrower
INNER JOIN applications.income AS income
ON borrower.id = income.income_id
GROUP BY borrower.intent
ORDER BY borrower.intent
;

      intent       | min_income
-------------------+------------
 DEBTCONSOLIDATION |      11820
 EDUCATION         |       9600
 HOMEIMPROVEMENT   |      10000
 MEDICAL           |       9600
 PERSONAL          |      10000
 VENTURE           |       9900
