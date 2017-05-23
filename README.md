# GreedyGameSession

Language Used: T-SQL
How to run:
  1. Connect to SQL Server
  2. Open any database and run the script.
 
How it works:
  1. First it will Users, Game and Session table
  2. It will insert randomly 500 Users in Users table.
  3. It will insert randomly 500 Game in Game table.
  4. It will insert randomly 600+ session (using random functionality) in session table. 
  5. Creating a CTE to identify the valid Session (Stoptime-StartTime should be greated than eqaul to 60).
  6. Assinging all the valid session count to one variable.
  7. Assinging total session count to one variable.
  8. Printing out all valid and total session value.
  9. Droping all the created table.
