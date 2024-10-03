-- Task Management System SQL Script

-- DDL: Create Tables
CREATE TABLE Tasks (
    task_id NUMBER PRIMARY KEY,
    description VARCHAR2(200) NOT NULL,
    status VARCHAR2(20) CHECK (status IN ('Not Started', 'In Progress', 'Completed')),
    deadline DATE
);

CREATE TABLE Members (
    member_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE
);

CREATE TABLE TaskAssignments (
    task_id NUMBER,
    member_id NUMBER,
    assigned_date DATE DEFAULT SYSDATE,
    PRIMARY KEY (task_id, member_id),
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- DML: Insert Data

-- Tasks
INSERT INTO Tasks (task_id, description, status, deadline) 
VALUES (1, 'Implement login functionality', 'In Progress', TO_DATE('2024-10-15', 'YYYY-MM-DD'));

INSERT INTO Tasks (task_id, description, status, deadline) 
VALUES (2, 'Design user interface', 'Not Started', TO_DATE('2024-11-01', 'YYYY-MM-DD'));

INSERT INTO Tasks (task_id, description, status, deadline) 
VALUES (3, 'Write unit tests', 'Not Started', TO_DATE('2024-10-30', 'YYYY-MM-DD'));

-- Members
INSERT INTO Members (member_id, name, email) 
VALUES (1, 'John Doe', 'john.doe@example.com');

INSERT INTO Members (member_id, name, email) 
VALUES (2, 'Jane Smith', 'jane.smith@example.com');

-- Assignments
INSERT INTO TaskAssignments (task_id, member_id) 
VALUES (1, 1);

INSERT INTO TaskAssignments (task_id, member_id) 
VALUES (2, 2);

-- DML: Update Data
UPDATE Tasks 
SET status = 'Completed' 
WHERE task_id = 1;

-- DML: Delete Data
DELETE FROM TaskAssignments 
WHERE task_id = 2 AND member_id = 2;

-- DML: Select Data with JOIN
SELECT t.description, t.status, m.name AS assigned_to
FROM Tasks t
JOIN TaskAssignments ta ON t.task_id = ta.task_id
JOIN Members m ON ta.member_id = m.member_id;


-- TCL: Transaction Control
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
/