create database EventTicketDB2

CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(MAX) NOT NULL,
    Role NVARCHAR(50) CHECK (Role IN ('guest', 'customer', 'event_owner', 'admin')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    Gender NVARCHAR(10) CHECK (Gender IN ('Male', 'Female', 'Other')),
    Birthday DATE,
    PhoneNumber NVARCHAR(20),
    Address NVARCHAR(255),
    Avatar NVARCHAR(MAX),
    IsLocked BIT DEFAULT 0,
    LastLoginAt DATETIME,
	GoogleId NVARCHAR(MAX) ,
    CONSTRAINT CK_Users_Email CHECK (Email LIKE '%@%.%' AND LEN(Email) >= 5),
    CONSTRAINT CK_Users_PhoneNumber CHECK (PhoneNumber IS NULL OR PhoneNumber LIKE '[0-9]%'),
    CONSTRAINT CK_Users_Birthday CHECK (Birthday IS NULL OR Birthday <= GETDATE())
);

-- Bảng Genre
CREATE TABLE Genres (
    GenreID INT IDENTITY(1,1) PRIMARY KEY,
    GenreName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Bảng Events(cải thiện đáng kể)
CREATE TABLE Events(
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    PhysicalLocation NVARCHAR(255),
    StartTime DATETIME NOT NULL,
    EndTime DATETIME NOT NULL,
    TotalTicketCount INT NOT NULL,
    IsApproved BIT DEFAULT 0,
    Status NVARCHAR(20) DEFAULT 'pending' CHECK (Status IN ('pending', 'active', 'cancelled', 'completed')),
    GenreID INT,
    OwnerID INT NOT NULL,
    ImageURL NVARCHAR(255),
    HasSeatingChart BIT DEFAULT 0,
    IsDeleted BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Events_Genre FOREIGN KEY (GenreID) REFERENCES Genres(GenreID),
    CONSTRAINT FK_Events_Owner FOREIGN KEY (OwnerID) REFERENCES Users(Id),
    CONSTRAINT CK_Event_Time CHECK (EndTime > StartTime)
	);

-- Bảng Seat (cải thiện)
CREATE TABLE Seat (
    SeatID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    SeatNumber NVARCHAR(10) NOT NULL,
    SeatRow NVARCHAR(10),
    SeatSection NVARCHAR(20), --vd: khu vuc A, B
    SeatStatus NVARCHAR(20) DEFAULT 'available' CHECK (SeatStatus IN ('available', 'reserved', 'sold')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Seat_Event FOREIGN KEY (EventID) REFERENCES Events(EventID),
    CONSTRAINT UK_Seat_Event_Number UNIQUE (EventID, SeatNumber)
); 

-- Bảng TicketInfo (đổi tên và cải thiện)
CREATE TABLE TicketInfo (
    TicketInfoID INT IDENTITY(1,1) PRIMARY KEY,
    TicketName NVARCHAR(100) NOT NULL,
    TicketDescription NVARCHAR(255),
    Category NVARCHAR(100),
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    SalesStartTime DATETIME NOT NULL,
    SalesEndTime DATETIME NOT NULL,
    EventID INT NOT NULL,
    MaxQuantityPerOrder INT DEFAULT 10,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_TicketInfo_Event FOREIGN KEY (EventID) REFERENCES Events(EventID),
    CONSTRAINT CK_TicketInfo_SalesTime CHECK (SalesEndTime > SalesStartTime),
    CONSTRAINT CK_TicketInfo_MaxQuantity CHECK (MaxQuantityPerOrder > 0)
);

-- Bảng TicketInventory (mới - quản lý số lượng ticket)
CREATE TABLE TicketInventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    TicketInfoID INT NOT NULL,
    TotalQuantity INT NOT NULL CHECK (TotalQuantity >= 0),
    SoldQuantity INT DEFAULT 0 CHECK (SoldQuantity >= 0),
    ReservedQuantity INT DEFAULT 0 CHECK (ReservedQuantity >= 0),
    AvailableQuantity AS (TotalQuantity - SoldQuantity - ReservedQuantity),
    LastUpdated DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Inventory_TicketInfo FOREIGN KEY (TicketInfoID) REFERENCES TicketInfo(TicketInfoID),
    CONSTRAINT CK_Inventory_Quantities CHECK (SoldQuantity + ReservedQuantity <= TotalQuantity)
);

-- Bảng Ticket (cải thiện)
CREATE TABLE Ticket (
    TicketID INT IDENTITY(1,1) PRIMARY KEY,
    TicketInfoID INT NOT NULL,
    TicketCode NVARCHAR(50) UNIQUE NOT NULL, -- Mã ticket duy nhất
    Status NVARCHAR(20) DEFAULT 'available' CHECK (Status IN ('available', 'reserved', 'sold', 'used', 'cancelled')), -- khi event end thi ve se chuyen trang thai thanh used
    SeatID INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Ticket_TicketInfo FOREIGN KEY (TicketInfoID) REFERENCES TicketInfo(TicketInfoID),
    CONSTRAINT FK_Ticket_Seat FOREIGN KEY (SeatID) REFERENCES Seat(SeatID)
);

-- Bảng PaymentMethod
CREATE TABLE PaymentMethod (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
    MethodName NVARCHAR(100) NOT NULL UNIQUE,
    PromotionCode NVARCHAR(50), 
    Description NVARCHAR(255),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
   
);

-- Bảng Orders (Gộp thông tin từ Orders cũ và một số thông tin từ OrderTickets)
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    OrderNumber NVARCHAR(50) UNIQUE NOT NULL, -- Mã đơn hàng duy nhất
    UserID INT NOT NULL,
    TotalQuantity INT NOT NULL CHECK (TotalQuantity > 0), --Tổng số lượng vé/sản phẩm trong đơn. Phải > 0.
    SubtotalAmount DECIMAL(10,2) NOT NULL CHECK (SubtotalAmount >= 0),
    DiscountAmount DECIMAL(10,2) DEFAULT 0 CHECK (DiscountAmount >= 0),
    TotalAmount DECIMAL(10,2) NOT NULL CHECK (TotalAmount >= 0),
    PaymentStatus NVARCHAR(50) DEFAULT 'pending' CHECK (PaymentStatus IN ('pending', 'paid', 'failed', 'refunded', 'cancelled')),
    OrderStatus NVARCHAR(50) DEFAULT 'created' CHECK (OrderStatus IN ('created', 'delivered', 'cancelled')),
    PaymentMethodID INT,
    DeliveryMethod NVARCHAR(50) DEFAULT 'Mail' CHECK (DeliveryMethod IN ('Mail')),
    ContactPhone NVARCHAR(20),
    ContactEmail NVARCHAR(255),
    Notes NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Orders_User FOREIGN KEY (UserID) REFERENCES Users(Id),
    CONSTRAINT FK_Orders_PaymentMethod FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethod(PaymentMethodID)
);

-- Bảng OrderItems (Gộp thông tin từ OrderItems cũ và OrderTickets)
CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    TicketInfoID INT NOT NULL,
    EventID INT NOT NULL,
    TicketID INT NOT NULL, -- Ticket cụ thể được mua (từ bảng OrderTickets cũ)
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
	Quantity INT NOT NULL DEFAULT 1,
    TotalPrice DECIMAL(10,2) NOT NULL DEFAULT 0,
    AssignedAt DATETIME DEFAULT GETDATE(), -- Thời gian assign ticket (từ bảng OrderTickets cũ)
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_OrderItems_Order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderItems_TicketInfo FOREIGN KEY (TicketInfoID) REFERENCES TicketInfo(TicketInfoID),
    CONSTRAINT FK_OrderItems_Event FOREIGN KEY (EventID) REFERENCES Events(EventID),
    CONSTRAINT FK_OrderItems_Ticket FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID),
    CONSTRAINT UK_OrderItems_Ticket UNIQUE (TicketID) -- Mỗi ticket chỉ thuộc về 1 order item
);

-- Bảng Feedback (cải thiện)
CREATE TABLE Feedback (
    FeedbackID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    EventID INT NOT NULL,
    OrderID INT, -- Liên kết với order để verify user đã mua ticket
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Content NVARCHAR(MAX),
    IsApproved BIT DEFAULT 0,
    AdminResponse NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Feedback_User FOREIGN KEY (UserID) REFERENCES Users(Id),
    CONSTRAINT FK_Feedback_Event FOREIGN KEY (EventID) REFERENCES Events(EventID),
    CONSTRAINT FK_Feedback_Order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Bảng Report (cải thiện)
CREATE TABLE Report (
    ReportID INT IDENTITY(1,1) PRIMARY KEY,
    ReporterID INT NOT NULL,
    EventID INT,
    Description NVARCHAR(MAX) NOT NULL,
    AdminID INT, -- Admin xử lý
    IsResolved BIT DEFAULT 0,
    ResolvedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Report_Reporter FOREIGN KEY (ReporterID) REFERENCES Users(Id),
    CONSTRAINT FK_Report_Event FOREIGN KEY (EventID) REFERENCES Events(EventID),
    CONSTRAINT FK_Report_Admin FOREIGN KEY (AdminID) REFERENCES Users(Id)
);

-- Bảng ConversationTable (đổi tên và cải thiện)
CREATE TABLE Conversations (
    ConversationID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    EventOwnerID INT NOT NULL,
    EventID INT, -- Cuộc trò chuyện về event nào
    Subject NVARCHAR(255),
    Status NVARCHAR(20) DEFAULT 'active' CHECK (Status IN ('active', 'closed', 'archived')),
    LastMessageAt DATETIME,
    CreatedBy INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Conversations_Customer FOREIGN KEY (CustomerID) REFERENCES Users(Id),
    CONSTRAINT FK_Conversations_EventOwner FOREIGN KEY (EventOwnerID) REFERENCES Users(Id),
    CONSTRAINT FK_Conversations_Event FOREIGN KEY (EventID) REFERENCES Events(EventID),
    CONSTRAINT FK_Conversations_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    CONSTRAINT UK_Conversations UNIQUE (CustomerID, EventOwnerID, EventID)
);

-- Bảng Message (cải thiện)
CREATE TABLE Messages (
    MessageID INT IDENTITY(1,1) PRIMARY KEY,
    ConversationID INT NOT NULL,
    SenderID INT NOT NULL,
    MessageContent NVARCHAR(MAX) NOT NULL,
    MessageType NVARCHAR(20) DEFAULT 'text' CHECK (MessageType IN ('text', 'image', 'file', 'system')),
    AttachmentURL NVARCHAR(255),
    IsRead BIT DEFAULT 0,
    ReadAt DATETIME,
    IsEdited BIT DEFAULT 0,
    EditedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Messages_Conversation FOREIGN KEY (ConversationID) REFERENCES Conversations(ConversationID),
    CONSTRAINT FK_Messages_Sender FOREIGN KEY (SenderID) REFERENCES Users(Id)
);

-- Bảng Promotions (cải thiện)
CREATE TABLE Promotions(
    PromotionID INT IDENTITY(1,1) PRIMARY KEY,
    PromotionName NVARCHAR(300) NOT NULL,
    PromotionCode NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(500),
    PromotionType NVARCHAR(20) DEFAULT 'percentage' CHECK (PromotionType IN ('percentage', 'fixed_amount', 'buy_x_get_y')),
    StartTime DATETIME NOT NULL,
    EndTime DATETIME NOT NULL,
    EventID INT,
    DiscountPercentage DECIMAL(5,2) CHECK (DiscountPercentage BETWEEN 0 AND 100),
    DiscountAmount DECIMAL(10,2) CHECK (DiscountAmount >= 0),
    MinOrderAmount DECIMAL(10,2) DEFAULT 0 CHECK (MinOrderAmount >= 0),
    MaxDiscountAmount DECIMAL(10,2) CHECK (MaxDiscountAmount >= 0),
    MaxUsageCount INT,
    CurrentUsageCount INT DEFAULT 0,
    IsActive BIT DEFAULT 1,
    CreatedBy INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Promotions_Event FOREIGN KEY (EventID) REFERENCES Events(EventID),
    CONSTRAINT FK_Promotions_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    CONSTRAINT CK_Promotions_Time CHECK (EndTime > StartTime),
    CONSTRAINT CK_Promotions_Usage CHECK (CurrentUsageCount <= MaxUsageCount OR MaxUsageCount IS NULL),
    CONSTRAINT CK_Promotions_Discount CHECK (
        (PromotionType = 'percentage' AND DiscountPercentage IS NOT NULL AND DiscountAmount IS NULL) OR
        (PromotionType = 'fixed_amount' AND DiscountAmount IS NOT NULL AND DiscountPercentage IS NULL) OR
        (PromotionType = 'buy_x_get_y')
    )
);

-- Bảng Notifications (mới)
CREATE TABLE Notifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Title NVARCHAR(255) NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    NotificationType NVARCHAR(50) NOT NULL CHECK (NotificationType IN ('order', 'event', 'promotion', 'system', 'message')),
    RelatedID INT, -- ID của object liên quan (OrderID, EventID, etc.)
    IsRead BIT DEFAULT 0,
    ReadAt DATETIME,
    Priority NVARCHAR(20) DEFAULT 'normal' CHECK (Priority IN ('low', 'normal', 'high')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    ExpiresAt DATETIME,
    CONSTRAINT FK_Notifications_User FOREIGN KEY (UserID) REFERENCES Users(Id)
);

-- Bảng AuditLog (mới - theo dõi thay đổi)
CREATE TABLE AuditLog (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(100) NOT NULL,
    RecordID INT NOT NULL,
    Action NVARCHAR(10) NOT NULL CHECK (Action IN ('INSERT', 'UPDATE', 'DELETE')),
    OldValues NVARCHAR(MAX),
    NewValues NVARCHAR(MAX),
    ChangedColumns NVARCHAR(500),
    UserID INT,
    UserAgent NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_AuditLog_User FOREIGN KEY (UserID) REFERENCES Users(Id)
);



-- Bảng Refunds (Quản lý yêu cầu hoàn tiền)
CREATE TABLE Refunds (
    RefundID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL, -- Liên kết với đơn hàng
    OrderItemID INT, -- Liên kết với mục đơn hàng cụ thể (nếu chỉ hoàn tiền cho một số vé)
    UserID INT NOT NULL, -- Người yêu cầu hoàn tiền
    AdminID INT, -- Admin xử lý yêu cầu hoàn tiền
    RefundAmount DECIMAL(10,2) NOT NULL CHECK (RefundAmount >= 0), -- Số tiền hoàn
    RefundReason NVARCHAR(500), -- Lý do yêu cầu hoàn tiền
    RefundStatus NVARCHAR(50) DEFAULT 'pending' CHECK (RefundStatus IN ('pending', 'approved', 'rejected', 'completed', 'cancelled')),
    PaymentMethodID INT, -- Phương thức hoàn tiền (có thể khác với phương thức thanh toán ban đầu)
    RefundRequestDate DATETIME DEFAULT GETDATE(), -- Thời gian yêu cầu hoàn tiền
    RefundProcessedDate DATETIME, -- Thời gian xử lý hoàn tiền
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    IsDeleted BIT DEFAULT 0,
    CONSTRAINT FK_Refunds_Order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_Refunds_OrderItem FOREIGN KEY (OrderItemID) REFERENCES OrderItems(OrderItemID),
    CONSTRAINT FK_Refunds_User FOREIGN KEY (UserID) REFERENCES Users(Id),
    CONSTRAINT FK_Refunds_Admin FOREIGN KEY (AdminID) REFERENCES Users(Id),
    CONSTRAINT FK_Refunds_PaymentMethod FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethod(PaymentMethodID),
 
);
Go


-- =============================================
-- INDEXES để tối ưu hiệu suất
-- =============================================

-- Indexes cho bảng Users
CREATE INDEX IX_Users_name ON USers(Username);
CREATE INDEX IX_Users_Email ON Users(Email);
CREATE INDEX IX_Users_Role ON Users(Role);
CREATE INDEX IX_Users_IsLcoked ON Users(IsLocked);

-- Indexes cho bảng Events
CREATE INDEX IX_Events_StartTime ON Events(StartTime);
CREATE INDEX IX_Events_Status ON Events(Status);
CREATE INDEX IX_Events_Owner ON Events(OwnerID);
CREATE INDEX IX_Events_Genre ON Events(GenreID);
CREATE INDEX IX_Events_IsDeleted ON Events(IsDeleted);

-- Indexes cho bảng Orders
CREATE INDEX IX_Orders_UserID ON Orders(UserID);
CREATE INDEX IX_Orders_Status ON Orders(OrderStatus);
CREATE INDEX IX_Orders_PaymentStatus ON Orders(PaymentStatus);
CREATE INDEX IX_Orders_CreatedAt ON Orders(CreatedAt);
CREATE INDEX IX_Orders_OrderNumber ON Orders(OrderNumber);

-- Indexes cho bảng OrderItems
CREATE INDEX IX_OrderItems_OrderID ON OrderItems(OrderID);
CREATE INDEX IX_OrderItems_EventID ON OrderItems(EventID);
CREATE INDEX IX_OrderItems_TicketInfoID ON OrderItems(TicketInfoID);
CREATE INDEX IX_OrderItems_TicketID ON OrderItems(TicketID);

-- Indexes cho bảng Tickets
CREATE INDEX IX_Tickets_TicketInfoID ON Ticket(TicketInfoID);
CREATE INDEX IX_Tickets_Status ON Ticket(Status);
CREATE INDEX IX_Tickets_Code ON Ticket(TicketCode);

-- Indexes cho bảng Messages
CREATE INDEX IX_Messages_ConversationID ON Messages(ConversationID);
CREATE INDEX IX_Messages_SenderID ON Messages(SenderID);
CREATE INDEX IX_Messages_CreatedAt ON Messages(CreatedAt);
CREATE INDEX IX_Messages_IsRead ON Messages(IsRead);

-- Indexes cho bảng Notifications
CREATE INDEX IX_Notifications_UserID ON Notifications(UserID);
CREATE INDEX IX_Notifications_IsRead ON Notifications(IsRead);
CREATE INDEX IX_Notifications_CreatedAt ON Notifications(CreatedAt);
CREATE INDEX IX_Notifications_Type ON Notifications(NotificationType);

-- Indexes cho bảng Refunds
CREATE INDEX IX_Refunds_OrderID ON Refunds(OrderID);
CREATE INDEX IX_Refunds_OrderItemID ON Refunds(OrderItemID);
CREATE INDEX IX_Refunds_UserID ON Refunds(UserID);
CREATE INDEX IX_Refunds_AdminID ON Refunds(AdminID);
CREATE INDEX IX_Refunds_RefundStatus ON Refunds(RefundStatus);
CREATE INDEX IX_Refunds_CreatedAt ON Refunds(CreatedAt);
CREATE INDEX IX_Refunds_IsDeleted ON Refunds(IsDeleted);
GO

-- =============================================
-- Procedure
-- =============================================
-- Execute each procedure separately, one at a time

-- 1. Get count of events created this month
CREATE PROCEDURE GetEventsCountThisMonth
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT COUNT(*) AS EventCount
    FROM Events 
    WHERE YEAR(CreatedAt) = YEAR(GETDATE()) 
      AND MONTH(CreatedAt) = MONTH(GETDATE())
      AND IsDeleted = 0;
END;
GO
--exec GetEventsCountThisMonth;
--GO
-- 2. Get all events created this month (for listing)
CREATE PROCEDURE GetEventsCreatedThisMonth
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        EventID,
        Name,
        Description,
        PhysicalLocation,
        StartTime,
        EndTime,
        TotalTicketCount,
        IsApproved,
        Status,
        GenreID,
        OwnerID,
        ImageURL,
        HasSeatingChart,
        CreatedAt,
        UpdatedAt
    FROM Events 
    WHERE YEAR(CreatedAt) = YEAR(GETDATE()) 
      AND MONTH(CreatedAt) = MONTH(GETDATE())
      AND IsDeleted = 0
    ORDER BY CreatedAt DESC;
END;
GO
--exec GetEventsCreatedThisMonth

-- 3. Get top 5 hot events (most popular by ticket count)
CREATE PROCEDURE GetTopHotEvents
    @TopCount INT = 5
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@TopCount)
        EventID,
        Name,
        StartTime,
        EndTime,
        TotalTicketCount,
        Status,
        ROW_NUMBER() OVER (ORDER BY TotalTicketCount DESC, CreatedAt DESC) as Ranking
    FROM Events 
    WHERE IsDeleted = 0
      AND IsApproved = 1
      AND Status IN ('active', 'pending')
      AND EndTime > GETDATE()
    ORDER BY TotalTicketCount DESC, CreatedAt DESC;
END;
GO

--4. get top event owner base on their ticket selling through platform
CREATE PROCEDURE GetTopEventOrganizers
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP 5
        u.Id,
        u.Email AS [Tên tổ chức],
        COUNT(e.EventID) AS [Số sự kiện],
        COALESCE(SUM(ti.SoldQuantity), 0) AS [Tổng vé đã bán],
        u.IsLocked AS [Trạng thái tài khoản],
        u.Avatar
    FROM Users u
    LEFT JOIN Events e ON u.Id = e.OwnerID AND e.IsDeleted = 0
    LEFT JOIN TicketInventory ti ON e.EventID = ti.TicketInfoID
    WHERE u.Role = 'event_owner'
    GROUP BY u.Id, u.Email, u.IsLocked, u.Avatar
    ORDER BY [Tổng vé đã bán] DESC;
END;


exec GetTopEventOrganizers
-- =============================================
-- TRIGGERS
-- =============================================




-- Trigger để cập nhật UpdatedAt
GO
CREATE TRIGGER TR_Users_UpdatedAt ON Users
AFTER UPDATE AS
BEGIN
    UPDATE Users SET UpdatedAt = GETDATE() 
    WHERE Id IN (SELECT DISTINCT Id FROM Inserted)
END;

GO
CREATE TRIGGER TR_Events_UpdatedAt ON Events
AFTER UPDATE AS
BEGIN
    UPDATE Events SET UpdatedAt = GETDATE() 
    WHERE EventID IN (SELECT DISTINCT EventID FROM Inserted)
END;

GO
CREATE TRIGGER TR_Orders_UpdatedAt ON Orders
AFTER UPDATE AS
BEGIN
    UPDATE Orders SET UpdatedAt = GETDATE() 
    WHERE OrderID IN (SELECT DISTINCT OrderID FROM Inserted)
END;

-- Trigger để validate promotion end time
GO
CREATE TRIGGER TR_Promotions_ValidateEndTime ON Promotions
AFTER INSERT, UPDATE AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN Events e ON i.EventID = e.EventID
        WHERE i.EventID IS NOT NULL AND i.EndTime > e.StartTime
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50001, 'Promotion end time cannot exceed event start time.', 1;
    END
END;

-- Trigger để cập nhật inventory khi ticket được bán
GO
CREATE TRIGGER TR_UpdateInventory_OnTicketSold ON Ticket
AFTER UPDATE AS
BEGIN
    IF UPDATE(Status)
    BEGIN
        -- Cập nhật khi ticket chuyển từ available/reserved sang sold
        UPDATE ti SET 
            SoldQuantity = (
                SELECT COUNT(*) 
                FROM Ticket t 
                WHERE t.TicketInfoID = ti.TicketInfoID 
                AND t.Status = 'sold'
            ),
            ReservedQuantity = (
                SELECT COUNT(*) 
                FROM Ticket t 
                WHERE t.TicketInfoID = ti.TicketInfoID 
                AND t.Status = 'reserved'
            ),
            LastUpdated = GETDATE()
        FROM TicketInventory ti
        WHERE ti.TicketInfoID IN (
            SELECT DISTINCT TicketInfoID 
            FROM inserted 
            UNION 
            SELECT DISTINCT TicketInfoID 
            FROM deleted
        );
    END
END;

-- Trigger để tự động tạo OrderNumber
GO
CREATE TRIGGER TR_Orders_GenerateOrderNumber ON Orders
AFTER INSERT AS
BEGIN
    UPDATE Orders 
    SET OrderNumber = 'ORD' + FORMAT(OrderID, '00000000')
    WHERE OrderID IN (SELECT OrderID FROM inserted) 
    AND OrderNumber IS NULL;
END;

-- Trigger để tự động tạo TicketCode
GO
CREATE TRIGGER TR_Tickets_GenerateTicketCode ON Ticket
AFTER INSERT AS
BEGIN
    UPDATE Ticket 
    SET TicketCode = 'TKT' + FORMAT(TicketID, '00000000') + FORMAT(DATEPART(year, GETDATE()), '0000')
    WHERE TicketID IN (SELECT TicketID FROM inserted) 
    AND TicketCode IS NULL;
END;

-- Trigger để cập nhật TotalQuantity trong Orders khi có thay đổi OrderItems
GO
CREATE TRIGGER TR_Orders_UpdateTotalQuantity ON OrderItems
AFTER INSERT, UPDATE, DELETE AS
BEGIN
    -- Cập nhật TotalQuantity trong bảng Orders
    UPDATE o SET 
        TotalQuantity = (
            SELECT COUNT(*) 
            FROM OrderItems oi 
            WHERE oi.OrderID = o.OrderID
        )
    FROM Orders o
    WHERE o.OrderID IN (
        SELECT DISTINCT OrderID FROM inserted
        UNION
        SELECT DISTINCT OrderID FROM deleted
    );
END;


-- Trigger để cập nhật UpdatedAt cho Refunds
GO
CREATE TRIGGER TR_Refunds_UpdatedAt ON Refunds
AFTER UPDATE AS
BEGIN
    UPDATE Refunds SET UpdatedAt = GETDATE()
    WHERE RefundID IN (SELECT DISTINCT RefundID FROM Inserted)
END;

-- Trigger để kiểm tra trạng thái đơn hàng trước khi tạo yêu cầu hoàn tiền
GO
CREATE TRIGGER TR_Refunds_ValidateOrderStatus ON Refunds
AFTER INSERT AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM Inserted i
        JOIN Orders o ON i.OrderID = o.OrderID
        WHERE o.PaymentStatus != 'paid' OR o.OrderStatus = 'cancelled'
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50004, 'Refunds can only be requested for paid and non-cancelled orders.', 1;
    END
END;

-- Trigger để cập nhật trạng thái vé khi hoàn tiền được phê duyệt
GO
CREATE TRIGGER TR_Refunds_UpdateTicketStatus ON Refunds
AFTER UPDATE AS
BEGIN
    IF UPDATE(RefundStatus)
    BEGIN
        UPDATE t SET 
            Status = 'cancelled',
            UpdatedAt = GETDATE()
        FROM Ticket t
        JOIN OrderItems oi ON t.TicketID = oi.TicketID
        JOIN Inserted i ON oi.OrderID = i.OrderID
        JOIN Deleted d ON i.RefundID = d.RefundID
        WHERE i.RefundStatus = 'approved' AND d.RefundStatus != 'approved'
        AND (i.OrderItemID IS NULL OR oi.OrderItemID = i.OrderItemID);
    END
END;

-- Trigger để cập nhật TicketInventory khi hoàn tiền được phê duyệt
GO
CREATE TRIGGER TR_Refunds_UpdateInventory ON Refunds
AFTER UPDATE AS
BEGIN
    IF UPDATE(RefundStatus)
    BEGIN
        UPDATE ti SET 
            SoldQuantity = (
                SELECT COUNT(*) 
                FROM Ticket t 
                WHERE t.TicketInfoID = ti.TicketInfoID 
                AND t.Status = 'sold'
            ),
            ReservedQuantity = (
                SELECT COUNT(*) 
                FROM Ticket t 
                WHERE t.TicketInfoID = ti.TicketInfoID 
                AND t.Status = 'reserved'
            ),
            LastUpdated = GETDATE()
        FROM TicketInventory ti
        WHERE ti.TicketInfoID IN (
            SELECT DISTINCT t.TicketInfoID
            FROM Ticket t
            JOIN OrderItems oi ON t.TicketID = oi.TicketID
            JOIN Inserted i ON oi.OrderID = i.OrderID
            JOIN Deleted d ON i.RefundID = d.RefundID
            WHERE i.RefundStatus = 'approved' AND d.RefundStatus != 'approved'
            AND (i.OrderItemID IS NULL OR oi.OrderItemID = i.OrderItemID)
        );
    END
END;


-- Insert into Users (Administrator with Id=1)
INSERT INTO Users (Username, Email, PasswordHash, Role, Gender, Birthday, PhoneNumber, Address, Avatar, isLocked, LastLoginAt)
VALUES
( N'Admin','adminEventWeb@support.com', 'ddfa08f04ffbedd937ce079026ead9826c0f4572feee5e45ff2a66d058c0c9d5', 'admin', 'Male', '1980-01-01', '0901234567', '123 Admin St, HCMC', 'https://upload.wikimedia.org/wikipedia/en/c/c2/Peter_Griffin.png', 0, GETDATE()),
( N'TayNguyen Sound','organizer@ticketbox.vn', '058caa5e5eec0aa2911b924607646627dbf0815d513576ada793072e78810691', 'event_owner', 'Female', '1985-05-15', '0912345678', '456 Event St, HCMC', 'https://i1.sndcdn.com/avatars-2RgyZdB5k8fW6HXl-lENkFQ-t500x500.jpg', 0, GETDATE()),
( N'Mây Lang Thang','music_events@hcmc.com','e51a4dbbf6c5021893e89253da30c135286bb8cdfb8019d87d666e5483e21c21', 'event_owner', 'Male', '1990-03-20', '0923456789', '789 Music Ave, HCMC', 'https://yt3.googleusercontent.com/ytc/AIdro_l4eBctyyqzD3BxJ7-cWiEjr0y35flQ8TCI1KUFjgIV6g=w544-c-h544-k-c0x00ffffff-no-l90-rj', 0, GETDATE()),
( N'VFF','sports_events@hcmc.com','42148a0e9fdc241f7d762b460c4ee97442621455745864c23adb3e4abbcdf17c', 'event_owner', 'Other', '1988-07-10', '0934567890', '101 Sports Rd, HCMC', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDO9aNJzXLps11YKgoXkwEqHNvvet0RKlwV7Ps2LNSUIUXS_iJ65s4SKf8iJVgigVdW-c&usqp=CAU', 0, GETDATE()),
( N'Lê Văn A','customer1@ticketbox.vn','1f28a586d5c3af781e15c49fc8cc1b8721a8508f32f8dc4264197e4908fef2b8', 'customer', 'Female', '1995-11-25', '0945678901', '202 Customer Ln, HCMC', 'https://whatisxwearing.com/wp-content/uploads/2024/07/glenn-quagmire-feature-image-768x549.png', 0, GETDATE());


select * from Users;

--select * from users;
--adminEventWeb@support.com: admin123@
--organizer@ticketbox.vn: eventowner123
--music_events@hcmc.com: eventowner321
--sports_events@hcmc.com: testpasswords
--customer1@ticketbox.vn: customer123##

-- Insert into Genres
INSERT INTO Genres (GenreName, Description)
VALUES
('Theater and Art', 'Theater performances and art shows'),
('Music', 'Music concerts and performances'),
('Sport', 'Sporting events'),
('Others', 'Miscellaneous events');

--select * from Genres;

-- Insert into Events
INSERT INTO Events (Name, Description, PhysicalLocation, StartTime, EndTime, TotalTicketCount, IsApproved, Status, GenreID, OwnerID, ImageURL, HasSeatingChart, IsDeleted)
VALUES
(N'Nhà Hát Kịch IDECAF: 12 Bà Mụ', 'A captivating theater performance', 'Ho Chi Minh City', '2025-06-05 12:30:00', '2025-06-05 14:30:00', 200, 1, 'active', 1, 2, 'https://images.tkbcdn.com/2/608/332/ts/ds/7c/18/6f/b32013793b1dbda15606e1cca4ab40ac.jpg', 0, 0),
(N'The Island And The Bay', 'A scenic cultural event', 'Ho Chi Minh City', '2025-06-07 07:00:00', '2025-06-07 09:00:00', 200, 1, 'active', 1, 2, 'https://images.tkbcdn.com/2/608/332/ts/ds/7d/cd/82/bea62d09033db74784ee82e8f811ff60.png', 0, 0),
(N'Địa Đạo Củ Chi : Trăng Chiến Khu', 'Historical reenactment', 'Ho Chi Minh City', '2025-06-07 11:00:00', '2025-06-07 13:00:00', 200, 1, 'active', 4, 2, 'https://images.tkbcdn.com/2/608/332/ts/ds/a6/0a/4a/60e9e35f58d00a4df2f987fe5f02803c.jpg', 0, 0),
(N'SÂN KHẤU THIÊN ĐĂNG: XÓM VỊT TRỜI', 'A vibrant theater show', 'Ho Chi Minh City', '2025-06-07 12:30:00', '2025-06-07 14:30:00', 200, 1, 'active', 1, 2, 'https://images.tkbcdn.com/2/608/332/ts/ds/1a/2c/a1/8d41e6a6d325f907b7e14b4582428461.jpg', 0, 0),
(N'NGÀY AN LÀNH - khoá tu 1 ngày cuối tuần', 'A peaceful retreat', 'Ho Chi Minh City', '2025-06-08 01:30:00', '2025-06-08 03:30:00', 200, 1, 'active', 4, 2, 'https://images.tkbcdn.com/2/608/332/ts/ds/d5/f7/31/b8dc405591074e95b041acf1f3d4d57e.jpg', 0, 0),
(N'[Dốc Mộng Mơ] Hãy Để Anh Đi - Quốc Thiên & Bùi Công Nam', 'Music concert with popular artists', 'Ho Chi Minh City', '2025-06-08 12:30:00', '2025-06-08 14:30:00', 200, 1, 'active', 2, 3, 'https://images.tkbcdn.com/2/608/332/ts/ds/a2/70/f0/a39e4fd823cd2f7b4186138c2c983012.jpg', 0, 0),
(N'ISAAC WITH LOVE - FANMEETING IN HO CHI MINH', 'Fan meeting with Isaac', 'Ho Chi Minh City', '2025-06-13 10:00:00', '2025-06-13 12:00:00', 200, 1, 'active', 4, 2, 'https://images.tkbcdn.com/2/608/332/ts/ds/9a/10/52/9efce559d9ab037ff649429ea74a2a4a.jpg', 0, 0),
(N'LULULOLA SHOW HƯƠNG TRÀM | MỘT NỬA SỰ THẬT', 'Hương Tràm live performance', 'Ho Chi Minh City', '2025-06-14 10:30:00', '2025-06-14 12:30:00', 200, 1, 'active', 2, 3, 'https://images.tkbcdn.com/2/608/332/ts/ds/77/67/54/d1ee978159818ef0d07bbefa3e3cd6cb.png', 0, 0),
(N'LỄ HỘI ẨM THỰC ẤN ĐỘ - INDIAN FOOD FESTIVAL AT BENARAS', 'Indian cultural food festival', 'Ho Chi Minh City', '2025-06-14 11:00:00', '2025-06-14 13:00:00', 200, 1, 'active', 4, 2, 'https://images.tkbcdn.com/2/608/332/ts/ds/3a/b7/00/2eb78869acb58fc6980137a595b89b53.jpg', 0, 0),
(N'[CONCERT] ANH TRAI VƯỢT NGÀN CHÔNG GAI DAY5, DAY6', 'Popular music concert', 'Ho Chi Minh City', '2025-06-14 11:00:00', '2025-06-14 13:00:00', 200, 1, 'active', 2, 3, 'https://images.tkbcdn.com/2/608/332/ts/ds/23/f2/8c/da6aee269301e6142fafc511a801be51.jpg', 0, 0),
(N'SAXOPHONE FESTIVAL - SMOKE & SILK', 'Jazz saxophone event', 'Ho Chi Minh City', '2025-06-14 12:00:00', '2025-06-14 14:00:00', 200, 1, 'active', 1, 2, 'https://images.tkbcdn.com/2/608/332/ts/ds/5f/1f/06/163a5bb4ca28688762920970ff950111.png', 0, 0),
(N'Lion Championship 23 - 2025', 'MMA championship', 'Ho Chi Minh City', '2025-06-14 12:00:00', '2025-06-14 14:00:00', 200, 1, 'active', 3, 4, 'https://images.tkbcdn.com/2/608/332/ts/ds/51/5f/ca/fac991cc2a4bba8b33e563950a6aaa7a.jpg', 0, 0),
(N'VBA 2025 - Saigon Heat vs CT Catfish', 'Basketball league match', 'Ho Chi Minh City', '2025-06-14 12:30:00', '2025-06-14 14:30:00', 200, 1, 'active', 3, 4, 'https://images.tkbcdn.com/2/608/332/ts/ds/93/0e/29/7f646019dd57ad00287f633b1f452087.jpg', 0, 0),
(N'Vở cải lương "CÂU THƠ YÊN NGỰA"', 'Traditional Vietnamese opera', 'Ho Chi Minh City', '2025-06-14 13:00:00', '2025-06-14 15:00:00', 200, 1, 'active', 1, 2, 'https://images.tkbcdn.com/2/608/332/ts/ds/5a/e0/78/9193c340c70ea454ed1ebaddedcf8dfc.jpg', 0, 0),
(N'[Viện pháp HCM] CONCERT LUIZA', 'Classical music concert', 'Ho Chi Minh City', '2025-06-14 13:00:00', '2025-06-14 15:00:00', 200, 1, 'active', 1, 2, 'https://images.tkbcdn.com/2/608/332/ts/ds/03/07/93/56c6b9b83197539cca52c3bb13397de5.png', 0, 0),
(N'HBAshow: Lê Hiếu - Bạch Công Khanh "Bài Tình Ca Cho Em"', 'Romantic music show', 'Ho Chi Minh City', '2025-06-14 13:00:00', '2025-06-14 15:00:00', 200, 1, 'active', 2, 3, 'https://images.tkbcdn.com/2/608/332/ts/ds/ce/ca/81/ee52041ca219455e6c63d567b432a1d9.png', 0, 0),
(N'Vở cải lương "Sấm vang dòng Như Nguyệt"', 'Historical Vietnamese opera', 'Ho Chi Minh City', '2025-06-14 13:00:00', '2025-06-14 15:00:00', 200, 1, 'active', 1, 2, 'https://images.tkbcdn.com/2/608/332/ts/ds/3e/83/b9/4cbc8280f4561730dc2111e7da0153a0.jpg', 0, 0),
(N'THE BEST OF POP - ROCK - MOVIE MUSIC & FASHION RHYTHM', 'Pop and rock music event', 'Ho Chi Minh City', '2025-06-17 13:00:00', '2025-06-17 15:00:00', 200, 1, 'active', 1, 2, 'https://images.tkbcdn.com/2/608/332/ts/ds/de/1d/3a/0e31e92b668d06ed9fa520aa76f23292.png', 0, 0),
(N'autoFEST@HCMC [Music Party & Merchandise]', 'Music and automotive merchandise event', 'Ho Chi Minh City', '2025-06-19 02:00:00', '2025-06-19 04:00:00', 200, 1, 'active', 2, 3, 'https://images.tkbcdn.com/2/608/332/ts/ds/87/43/e3/7e239ba463207db6e0e12cee4e433536.jpg', 0, 0),
(N'Automotive Mobility Solutions Conference', 'Industry conference and workshop', 'Ho Chi Minh City', '2025-06-19 03:00:00', '2025-06-19 05:00:00', 200, 1, 'active', 4, 2, 'https://images.tkbcdn.com/2/608/332/ts/ds/4d/8c/8a/4b0586d8a8733d9ed6cc9f5115960529.png', 0, 0),
(N'D''FESTA HANOI - KPOP VIRTUAL STAGE', N'others', N'Hanoi', '2023-11-27 03:00:00', '2023-11-27 05:00:00', 350000, 1, 'pending', 4, 2, 'https://images.tkbcdn.com/2/608/332/Upload/eventcover/2023/10/11/CEEE87.jpg', 0, 0),
(N'[THE GREENERY ART] ART WORKSHOP "TRANH ĐẤT SÉT"', N'others', N'Hanoi', '2023-11-26 10:30:00', '2023-11-26 12:30:00', 385000, 1, 'pending', 4, 2, 'https://images.tkbcdn.com/2/608/332/Upload/eventcover/2023/11/01/26BCA9.jpg', 0, 0),
(N'VIETNAM CEO: NGHĨ KHÁC LÀM KHÁC - GẶP GỠ ÔNG HOÀNG NAM TIẾN PCT HỘI ĐỒNG TRƯỜNG ĐẠI HỌC FPT', N'others', N'Hanoi', '2023-11-26 01:00:00', '2023-11-26 03:00:00', 298000, 1, 'pending', 4, 2, 'https://images.tkbcdn.com/2/608/332/Upload/eventcover/2023/10/25/5B3256.jpg', 0, 0);



--select * from Events;
-- Insert into Seat (for events with seating charts, assuming some events have seats)
INSERT INTO Seat (EventID, SeatNumber, SeatRow, SeatSection, SeatStatus)
VALUES
(1, 'A1', 'A', 'VIP', 'available'),
(1, 'A2', 'A', 'VIP', 'available'),
(6, 'B1', 'B', 'Standard', 'available'),
(6, 'B2', 'B', 'Standard', 'available'),
(8, 'C1', 'C', 'Premium', 'available'),
(8, 'C2', 'C', 'Premium', 'available');

--select * from Seat
-- Insert into TicketInfo
INSERT INTO TicketInfo (TicketName, TicketDescription, Category, Price, SalesStartTime, SalesEndTime, EventID, MaxQuantityPerOrder, IsActive)
VALUES
(N'Standard Ticket - 12 Bà Mụ', 'Regular seating', 'Standard', 150000, '2025-05-01 00:00:00', '2025-06-05 12:00:00', 1, 10, 1),
(N'VIP Ticket - The Island', 'Premium seating', 'VIP', 200000, '2025-05-01 00:00:00', '2025-06-07 06:30:00', 2, 10, 1),
(N'Standard Ticket - Địa Đạo', 'General admission', 'Standard', 120000, '2025-05-01 00:00:00', '2025-06-07 10:30:00', 3, 10, 1),
(N'Premium Ticket - Xóm Vịt Trời', 'Enhanced experience', 'Premium', 180000, '2025-05-01 00:00:00', '2025-06-07 12:00:00', 4, 10, 1),
(N'General Admission - Ngày An Lành', 'Open seating', 'General Admission', 100000, '2025-05-01 00:00:00', '2025-06-08 01:00:00', 5, 10, 1),
(N'VIP Ticket - Hãy Để Anh Đi', 'Premium concert ticket', 'VIP', 250000, '2025-05-01 00:00:00', '2025-06-08 12:00:00', 6, 10, 1),
(N'Meet & Greet - Isaac', 'Includes meet and greet', 'Meet & Greet', 300000, '2025-05-01 00:00:00', '2025-06-13 09:30:00', 7, 5, 1),
(N'Premium Ticket - Hương Tràm', 'Premium concert ticket', 'Premium', 280000, '2025-05-01 00:00:00', '2025-06-14 10:00:00', 8, 10, 1),
(N'Food Festival Pass', 'Entry to food festival', 'General Admission', 80000, '2025-05-01 00:00:00', '2025-06-14 10:30:00', 9, 10, 1),
(N'VIP Concert - Anh Trai', 'VIP concert experience', 'VIP', 350000, '2025-05-01 00:00:00', '2025-06-14 10:30:00', 10, 10, 1),
(N'Standard Ticket - Saxophone Festival', 'General admission', 'Standard', 160000, '2025-05-01 00:00:00', '2025-06-14 11:30:00', 11, 10, 1),
(N'Ringside Ticket - Lion Championship', 'Premium ringside seats', 'Premium', 400000, '2025-05-01 00:00:00', '2025-06-14 11:30:00', 12, 8, 1),
(N'Courtside Ticket - VBA Match', 'Courtside basketball seats', 'VIP', 300000, '2025-05-01 00:00:00', '2025-06-14 12:00:00', 13, 6, 1),
(N'Standard Ticket - Cải Lương Câu Thơ', 'Traditional opera seating', 'Standard', 130000, '2025-05-01 00:00:00', '2025-06-14 12:30:00', 14, 10, 1),
(N'Concert Ticket - Luiza', 'Classical music concert', 'Premium', 220000, '2025-05-01 00:00:00', '2025-06-14 12:30:00', 15, 10, 1),
(N'Premium Ticket - Lê Hiếu Show', 'Premium romantic show', 'Premium', 260000, '2025-05-01 00:00:00', '2025-06-14 12:30:00', 16, 10, 1),
(N'Standard Ticket - Sấm Vang', 'Traditional opera', 'Standard', 140000, '2025-05-01 00:00:00', '2025-06-14 12:30:00', 17, 10, 1),
(N'VIP Ticket - Pop Rock Fashion', 'VIP experience', 'VIP', 320000, '2025-05-01 00:00:00', '2025-06-17 12:30:00', 18, 8, 1),
(N'Party Pass - autoFEST', 'Music party admission', 'General Admission', 180000, '2025-05-01 00:00:00', '2025-06-19 01:30:00', 19, 10, 1),
(N'Conference Pass - Automotive', 'Industry conference access', 'Professional', 250000, '2025-05-01 00:00:00', '2025-06-19 02:30:00', 20, 5, 1);

--select * from TicketInfo
-- Insert into TicketInventory
INSERT INTO TicketInventory (TicketInfoID, TotalQuantity, SoldQuantity, ReservedQuantity)
VALUES
(1, 200, 2, 0), -- Nhà Hát Kịch IDECAF: 12 Bà Mụ
(2, 200, 1, 0), -- The Island And The Bay
(3, 200, 1, 0), -- Địa Đạo Củ Chi : Trăng Chiến Khu
(4, 200, 0, 0), -- SÂN KHẤU THIÊN ĐĂNG: XÓM VỊT TRỜI
(5, 200, 1, 0), -- NGÀY AN LÀNH
(6, 200, 1, 0), -- Hãy Để Anh Đi Concert
(7, 200, 2, 0), -- ISAAC FANMEETING
(8, 200, 2, 0), -- LULULOLA SHOW HƯƠNG TRÀM
(9, 200, 2, 0), -- LỄ HỘI ẨM THỰC ẤN ĐỘ
(10, 200, 1, 0), -- ANH TRAI VƯỢT NGÀN CHÔNG GAI
(11, 200, 0, 0), -- Saxophone Festival
(12, 200, 0, 0), -- Lion Championship
(13, 200, 0, 0), -- VBA Match
(14, 200, 0, 0), -- Cải Lương Câu Thơ
(15, 200, 0, 0), -- Concert Luiza
(16, 200, 0, 0), -- Lê Hiếu Show
(17, 200, 0, 0), -- Sấm Vang
(18, 200, 0, 0), -- Pop Rock Fashion
(19, 200, 0, 0), -- autoFEST
(20, 200, 0, 0); -- Automotive Conference

--select * from TicketInventory
-- Insert into Ticket
INSERT INTO Ticket (TicketInfoID, TicketCode, Status, SeatID)
VALUES
(1, 'TKT000000012025', 'sold', 1), -- Nhà Hát Kịch IDECAF: 12 Bà Mụ
(1, 'TKT000000022025', 'sold', 2), -- Nhà Hát Kịch IDECAF: 12 Bà Mụ
(2, 'TKT000000032025', 'sold', NULL), -- The Island And The Bay
(3, 'TKT000000042025', 'sold', NULL), -- Địa Đạo Củ Chi : Trăng Chiến Khu
 (4, 'TKT000000142025', 'available', NULL), --SÂN KHẤU THIÊN ĐĂNG: XÓM VỊT TRỜI
(4, 'TKT000000152025', 'available', NULL),--SÂN KHẤU THIÊN ĐĂNG: XÓM VỊT TRỜI
(5, 'TKT000000052025', 'sold', NULL), -- NGÀY AN LÀNH
(6, 'TKT000000062025', 'sold', 3), -- Hãy Để Anh Đi Concert
(7, 'TKT000000072025', 'sold', NULL), -- ISAAC FANMEETING
(7, 'TKT000000082025', 'sold', NULL), -- ISAAC FANMEETING
(8, 'TKT000000092025', 'sold', 5), -- LULULOLA SHOW HƯƠNG TRÀM
(8, 'TKT000000102025', 'sold', 6), -- LULULOLA SHOW HƯƠNG TRÀM
(9, 'TKT000000112025', 'sold', NULL), -- LỄ HỘI ẨM THỰC ẤN ĐỘ
(9, 'TKT000000122025', 'sold', NULL), -- LỄ HỘI ẨM THỰC ẤN ĐỘ
(10, 'TKT000000132025', 'sold', NULL); -- ANH TRAI VƯỢT NGÀN CHÔNG GAI

--select * from Ticket
-- Insert into PaymentMethod
INSERT INTO PaymentMethod (MethodName, PromotionCode, Description, IsActive)
VALUES
('Credit Card', 'CREDIT5', '5% off for first-time users - Pay with Visa, MasterCard, or Amex', 1),
('Bank Transfer', NULL, 'Direct bank transfer', 1),
('VNPay', 'VNPAY0', 'Free transaction fee - Pay with VNPay mobile app', 1),
('E-Wallet', 'EWALLET0', 'Free transaction fee - Pay with mobile apps like Momo', 1);

--select * from PaymentMethod
-- Insert into Orders
INSERT INTO Orders (OrderNumber, UserID, TotalQuantity, SubtotalAmount, DiscountAmount, TotalAmount, PaymentStatus, OrderStatus, PaymentMethodID, ContactPhone, ContactEmail, Notes)
VALUES
('ORD00000001', 5, 2, 300000, 0, 300000, 'paid', 'delivered', 1, '0945678901', 'customer1@ticketbox.vn', 'Deliver via email'),
('ORD00000002', 5, 2, 450000, 0, 450000, 'paid', 'delivered', 2, '0945678901', 'customer1@ticketbox.vn', NULL),
('ORD00000003', 5, 2, 200000, 0, 200000, 'pending', 'created', 3, '0945678901', 'customer1@ticketbox.vn', NULL),
('ORD00000004', 5, 2, 600000, 0, 600000, 'paid', 'delivered', 1, '0945678901', 'customer1@ticketbox.vn', NULL),
('ORD00000005', 5, 1, 150000, 0, 150000, 'failed', 'cancelled', 2, '0945678901', 'customer1@ticketbox.vn', NULL),
('ORD00000006', 5, 1, 280000, 0, 280000, 'paid', 'delivered', 3, '0945678901', 'customer1@ticketbox.vn', NULL),
('ORD00000007', 5, 1, 350000, 0, 350000, 'pending', 'created', 1, '0945678901', 'customer1@ticketbox.vn', NULL);

--select * from Orders
-- Insert into OrderItems
INSERT INTO OrderItems (OrderID, TicketInfoID, EventID, TicketID, UnitPrice, Quantity, TotalPrice)
VALUES
(1, 1, 1, 1, 150000, 1, 150000),
(1, 1, 1, 2, 150000, 1, 150000),
(2, 6, 6, 6, 250000, 1, 250000),
(2, 8, 8, 9, 280000, 1, 280000),
(3, 3, 3, 4, 120000, 1, 120000),
(3, 5, 5, 5, 100000, 1, 100000),
(4, 7, 7, 7, 300000, 1, 300000),
(4, 7, 7, 8, 300000, 1, 300000),
(5, 2, 2, 3, 200000, 1, 200000),
(6, 8, 8, 10, 280000, 1, 280000),
(7, 10, 10, 13, 350000, 1, 350000);

--select * from OrderItems
-- Insert into Feedback
INSERT INTO Feedback (UserID, EventID, OrderID, Rating, Content, IsApproved)
VALUES
(5, 1, 1, 5, 'Absolutely fantastic theater performance! The actors were brilliant and the story was captivating.', 1),
(5, 6, 2, 4, 'Great concert with amazing vocals. The venue was perfect and the atmosphere was incredible.', 1),
(5, 3, 3, 4, 'Very educational and moving experience. Well worth the visit to learn about history.', 1),
(5, 7, 4, 5, 'Isaac was amazing! The fanmeeting was well organized and he was so kind to all fans.', 1),
(5, 8, 6, 3, 'Good show but the sound system had some issues. Hương Tràm sang beautifully though.', 0);

-- Insert into Report
INSERT INTO Report (ReporterID, EventID, Description, AdminID, IsResolved, ResolvedAt)
VALUES
(5, 8, 'Sound system issues during the concert', 1, 0, NULL),
(5, 6, 'Late start time reported', 1, 1, '2025-06-09 16:00:00');

-- Insert into Conversations
INSERT INTO Conversations (CustomerID, EventOwnerID, EventID, Subject, Status, LastMessageAt, CreatedBy)
VALUES
(5, 3, 6, 'Inquiry about concert details', 'active', '2025-05-25 10:00:00', 5),
(5, 2, 1, 'Question about theater seating', 'closed', '2025-05-20 15:00:00', 5);

-- Insert into Messages
INSERT INTO Messages (ConversationID, SenderID, MessageContent, MessageType, IsRead, ReadAt)
VALUES
(1, 5, 'Can you provide more details about the concert schedule?', 'text', 1, '2025-05-25 10:05:00'),
(1, 3, 'The concert starts at 12:30 PM and ends at 2:30 PM.', 'text', 1, '2025-05-25 10:10:00'),
(2, 5, 'Is there a seating chart for the theater?', 'text', 1, '2025-05-20 15:05:00'),
(2, 2, 'No seating chart for this event, it’s general admission.', 'text', 1, '2025-05-20 15:10:00');

-- Insert into Promotions
INSERT INTO Promotions (PromotionName, PromotionCode, Description, PromotionType, StartTime, EndTime, EventID, DiscountPercentage, DiscountAmount, MinOrderAmount, MaxDiscountAmount, MaxUsageCount, CurrentUsageCount, IsActive, CreatedBy)
VALUES
('Summer Sale', 'SUMMER25', '25% off all concert tickets', 'percentage', '2025-06-01 00:00:00', '2025-06-08 12:00:00', 6, 25.00, NULL, 200000, 100000, 100, 10, 1, 1),
('Food Festival Deal', 'FOODFEST', 'Fixed discount for food festival', 'fixed_amount', '2025-06-01 00:00:00', '2025-06-14 10:00:00', 9, NULL, 20000, 50000, 20000, 50, 5, 1, 1);

-- Insert into Notifications
INSERT INTO Notifications (UserID, Title, Content, NotificationType, RelatedID, IsRead, Priority)
VALUES
(5, 'Order Confirmation', 'Your order ORD00000001 has been confirmed!', 'order', 1, 1, 'normal'),
(5, 'Event Reminder', 'Don’t miss the concert on June 8th!', 'event', 6, 0, 'high'),
(5, 'New Promotion', 'Use code SUMMER25 for 25% off!', 'promotion', 1, 0, 'normal');

-- Insert into AuditLog
INSERT INTO AuditLog (TableName, RecordID, Action, OldValues, NewValues, ChangedColumns, UserID, UserAgent)
VALUES
('Users', 5, 'INSERT', NULL, 'Email: customer1@ticketbox.vn, Role: customer', 'Email, Role', 1, 'Mozilla/5.0'),
('Orders', 1, 'INSERT', NULL, 'OrderNumber: ORD00000001, TotalAmount: 300000', 'OrderNumber, TotalAmount', 1, 'Mozilla/5.0'),
('Ticket', 1, 'UPDATE', 'Status: available', 'Status: sold', 'Status', 1, 'Mozilla/5.0');

-- Insert into Refunds
INSERT INTO Refunds (OrderID, OrderItemID, UserID, RefundAmount, RefundReason, RefundStatus, PaymentMethodID)
VALUES
(1, 1, 5, 150000, 'Change of plans', 'pending', 2),
(2, NULL, 5, 530000, 'Double booking', 'pending', 1);


