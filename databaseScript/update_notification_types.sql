-- Script to update NotificationType constraint to use only 5 types
-- This script will find the existing constraint name and update it

-- First, let's see what constraints exist on the Notifications table
SELECT 
    CONSTRAINT_NAME,
    CHECK_CLAUSE
FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS cc
JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc ON cc.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
WHERE tc.TABLE_NAME = 'Notifications' AND tc.CONSTRAINT_TYPE = 'CHECK';

-- Now let's create a dynamic SQL script to update the constraint
DECLARE @ConstraintName NVARCHAR(128)
DECLARE @SQL NVARCHAR(MAX)

-- Find the constraint name for NotificationType
SELECT @ConstraintName = CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS cc
JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc ON cc.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
WHERE tc.TABLE_NAME = 'Notifications' 
  AND tc.CONSTRAINT_TYPE = 'CHECK'
  AND cc.CHECK_CLAUSE LIKE '%NotificationType%'

-- If constraint exists, drop it and create new one
IF @ConstraintName IS NOT NULL
BEGIN
    PRINT 'Found constraint: ' + @ConstraintName
    
    -- Drop the existing constraint
    SET @SQL = 'ALTER TABLE Notifications DROP CONSTRAINT [' + @ConstraintName + ']'
    EXEC sp_executesql @SQL
    PRINT 'Dropped constraint: ' + @ConstraintName
END
ELSE
BEGIN
    PRINT 'No existing NotificationType constraint found'
END

-- Add the new constraint with only 5 notification types
ALTER TABLE Notifications ADD CONSTRAINT CK_Notifications_NotificationType 
CHECK (NotificationType IN ('order', 'event', 'promotion', 'system', 'message'))

PRINT 'Added new constraint with 5 notification types only'

-- Insert some test notifications for admin (UserID = 1)
INSERT INTO Notifications (UserID, Title, Content, NotificationType, RelatedID, IsRead, Priority, CreatedAt, ExpiresAt)
VALUES 
(1, 'Chào mừng Admin', 'Chào mừng bạn đến với hệ thống quản lý MasterTicket!', 'system', NULL, 0, 'normal', GETDATE(), DATEADD(day, 30, GETDATE())),
(1, 'Test Notification 1', 'Đây là thông báo test đầu tiên', 'system', NULL, 0, 'normal', GETDATE(), DATEADD(day, 7, GETDATE())),
(1, 'Test Notification 2', 'Đây là thông báo test thứ hai', 'system', NULL, 0, 'high', GETDATE(), DATEADD(day, 7, GETDATE())),
(1, 'Yêu cầu hoàn tiền mới', 'Có yêu cầu hoàn tiền mới từ khách hàng - Yêu cầu hoàn tiền cần xử lý.', 'order', 1, 0, 'high', GETDATE(), DATEADD(day, 7, GETDATE()))

PRINT 'Inserted test notifications for admin'

-- Verify the changes
SELECT 
    CONSTRAINT_NAME,
    CHECK_CLAUSE
FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS cc
JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc ON cc.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
WHERE tc.TABLE_NAME = 'Notifications' AND tc.CONSTRAINT_TYPE = 'CHECK';

-- Show the test notifications
SELECT 
    NotificationID,
    UserID,
    Title,
    Content,
    NotificationType,
    IsRead,
    Priority,
    CreatedAt
FROM Notifications 
WHERE UserID = 1 
ORDER BY CreatedAt DESC; 