# Task Management System

## Problem Statement

This database system is designed to manage tasks for a small software development team. The system allows for:

1. Tracking tasks, including their descriptions, status, and deadlines.
2. Managing team members and their basic information.
3. Assigning tasks to team members.
4. Generating reports on task status and team member workloads.

## Conceptual Diagram

[ER diagram image](/tables%20relation.PNG)


## SQL Commands Executed

### Create Tasks Table
```sql
CREATE TABLE Tasks (
    task_id NUMBER PRIMARY KEY,
    description VARCHAR2(200) NOT NULL,
    status VARCHAR2(20) CHECK (status IN ('Not Started', 'In Progress', 'Completed')),
    deadline DATE
);
```
[Create Tasks table image](/img/create_tasks.PNG)

### Create Members Table
```sql
CREATE TABLE Members (
    member_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE
);
```
[Create Members table image](/img/create_members.PNG)

### Create TaskAssignments Table
```sql
CREATE TABLE TaskAssignments (
    task_id NUMBER,
    member_id NUMBER,
    assigned_date DATE DEFAULT SYSDATE,
    PRIMARY KEY (task_id, member_id),
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);
```
[Create TaskAssignments table image](/img/create_tasks_assignments.PNG)

### Insert Data into Tasks
```sql
INSERT INTO Tasks (task_id, description, status, deadline) 
VALUES (1, 'Implement login functionality', 'In Progress', TO_DATE('2024-10-15', 'YYYY-MM-DD'));
INSERT INTO Tasks (task_id, description, status, deadline) 
VALUES (2, 'Design user interface', 'Not Started', TO_DATE('2024-11-01', 'YYYY-MM-DD'));
INSERT INTO Tasks (task_id, description, status, deadline) 
VALUES (3, 'Write unit tests', 'Not Started', TO_DATE('2024-10-30', 'YYYY-MM-DD'));
```
[Insert Tasks table image](/img/insert_tasks.PNG)

### Insert Data into Members
```sql
INSERT INTO Members (member_id, name, email) 
VALUES (1, 'John Doe', 'john.doe@example.com');
INSERT INTO Members (member_id, name, email) 
VALUES (2, 'Jane Smith', 'jane.smith@example.com');
```
[Insert Members table image](/img/insert_members.PNG)

### Insert Data into TaskAssignments
```sql
INSERT INTO TaskAssignments (task_id, member_id) 
VALUES (1, 1);
INSERT INTO TaskAssignments (task_id, member_id) 
VALUES (2, 2);
```
[Insert TaskAssignments table image](/img/insert_tasks_assignments.PNG)


### Update Data
```sql
UPDATE Tasks 
SET status = 'Completed' 
WHERE task_id = 1;
```
[Update Tasks table image](/img/update_tasks.PNG)

### Delete Data
```sql
DELETE FROM TaskAssignments 
WHERE task_id = 2 AND member_id = 2;
```
[Delete TaskAssignments table image](/img/delete_tasks_assignments.PNG)

### Select Data with JOIN
```sql
SELECT t.description, t.status, m.name AS assigned_to
FROM Tasks t
JOIN TaskAssignments ta ON t.task_id = ta.task_id
JOIN Members m ON ta.member_id = m.member_id;
```
[Select join image](/img/select_join.PNG)

### Transaction Control Example
```sql
BEGIN
    -- Insert a new task
    INSERT INTO Tasks (task_id, description, status, deadline, priority)
    VALUES (4, 'Perform system testing', 'Not Started', TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'High');
    
    -- Create a savepoint
    SAVEPOINT new_task_added;
    
    -- Assign the task
    INSERT INTO TaskAssignments (task_id, member_id)
    VALUES (4, 2);
    
    ROLLBACK TO SAVEPOINT new_task_added;
    
    -- Assign to the correct person
    INSERT INTO TaskAssignments (task_id, member_id)
    VALUES (4, 1);
    
    COMMIT;
END;
```
[Transaction image](/img/tcl_example.PNG)

## Explanations of Results and Transactions

### Table Creation
The tables were successfully created with their respective constraints. The TaskAssignments table uses foreign keys to show relationships with the Tasks and Members tables.

### Data Insertion
Some data was inserted into all tables. This allows us to test and demonstrate the functionality of our system.

### Data Update and Deletion
The ability to update task status and delete task assignments

### Data Retrieval with JOIN
The JOIN operation successfully combined data from all three tables, showing which tasks are assigned to which team members.

### Transaction Example
In our transaction example, we demonstrated the use of SAVEPOINT and ROLLBACK. This allows for more control over which parts of a an operation are committed or rolled back. In this case, we were able to correct a mistaken task assignment without losing the newly added task.

## Conclusion

This Task Management System demonstrates the implementation of a relational database using Oracle SQL. It showcases various SQL operations including DDL for table creation, DML for data manipulation, and TCL for transaction control. The system provides a solid foundation for managing tasks in a small team environment, allowing for easy tracking of tasks, team members, and assignments.
