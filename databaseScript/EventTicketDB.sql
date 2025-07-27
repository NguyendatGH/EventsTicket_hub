create database EventTicketDB

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

CREATE TABLE Zones (
    id INT IDENTITY(1,1) PRIMARY KEY,
    event_id INT,
    name VARCHAR(50),
    shape VARCHAR(20),
    color VARCHAR(7),
    rows INT,
    seats_per_row INT,
    total_seats INT,
    x INT,
    y INT,
    rotation INT,
    ticket_price FLOAT,
    vertices NVARCHAR(MAX), -- store JSON as text
    FOREIGN KEY (event_id) REFERENCES Events(EventID)
);

-- Bảng Seat (cải thiện)
CREATE TABLE Seat (
    SeatID INT IDENTITY(1,1) PRIMARY KEY,
    ZoneID INT,
    Label VARCHAR(10),
    color VARCHAR(7),
    price FLOAT,
    x INT,
    y INT,
    relative_x FLOAT,
    relative_y FLOAT,
    SeatStatus NVARCHAR(20) DEFAULT 'available' CHECK (SeatStatus IN ('available', 'reserved', 'sold')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Seat FOREIGN KEY (ZoneId) REFERENCES Zones(id),
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
    TransactionID NVARCHAR(MAX),
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

-- Bảng ConversationTable 
CREATE TABLE Conversations (
    ConversationID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    EventOwnerID INT NOT NULL,
    EventID INT, -- Cuộc trò chuyện về event nào
    Subject NVARCHAR(255) DEFAULT 'Event Discussion',
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

-- Bảng Message 
CREATE TABLE Messages (
    MessageID INT IDENTITY(1,1) PRIMARY KEY,
    ConversationID INT NOT NULL,
    SenderID INT NOT NULL,
    MessageContent NVARCHAR(MAX), -- Optional for non-text messages (e.g., file-only messages)
    MessageType NVARCHAR(20) NOT NULL DEFAULT 'text' CHECK (MessageType IN ('text', 'image', 'file', 'system')),
    IsRead BIT DEFAULT 0,
    ReadAt DATETIME,
    IsEdited BIT DEFAULT 0,
    EditedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Messages_Conversation FOREIGN KEY (ConversationID) REFERENCES Conversations(ConversationID),
    CONSTRAINT FK_Messages_Sender FOREIGN KEY (SenderID) REFERENCES Users(Id),
    CONSTRAINT CK_Messages_Content CHECK (
        (MessageType = 'text' AND MessageContent IS NOT NULL) OR
        (MessageType IN ('image', 'file', 'system') AND MessageContent IS NULL OR MessageContent IS NOT NULL)
    )
);

CREATE TABLE FileAttachments (
    AttachmentID INT IDENTITY(1,1) PRIMARY KEY,
    MessageID INT NOT NULL,
    OriginalFilename NVARCHAR(255) NOT NULL,
    StoredFilename NVARCHAR(255) NOT NULL,
    FilePath NVARCHAR(500) NOT NULL,
    FileSize BIGINT NOT NULL CHECK (FileSize >= 0),
    MimeType NVARCHAR(100) NOT NULL,
    UploadedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_FileAttachments_Message FOREIGN KEY (MessageID) REFERENCES Messages(MessageID)
);


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
-- Bảng supportItems
CREATE TABLE SupportItems (
    SupportID INT IDENTITY(1,1) PRIMARY KEY,
    FromEmail NVARCHAR(255) NOT NULL,
    ToEmail NVARCHAR(255) NOT NULL,
    Subject NVARCHAR(255) NOT NULL,
    SendDate DATE NOT NULL,
    SendTimestamp DATETIME NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    Priority NVARCHAR(50) NOT NULL,
    Category NVARCHAR(100) NOT NULL,
    CreatedDate DATE NOT NULL,
    LastModified DATE NOT NULL,
    AdminResponse NVARCHAR(MAX) NULL,
    AssignedAdmin NVARCHAR(255) NULL
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
CREATE INDEX IX_FileAttachments_MessageID ON FileAttachments(MessageID);

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

go
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
      AND Status IN ('active')
      AND EndTime > GETDATE()
    ORDER BY TotalTicketCount DESC, CreatedAt DESC;
END;
GO
--exec GetTopHotEvents
go

--4. get top event organizers
CREATE OR ALTER PROCEDURE GetTopEventOrganizers
    @TopCount INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@TopCount)
        u.Id,
        u.Email AS [Tên tổ chức],
        COUNT(DISTINCT e.EventID) AS [Số sự kiện],
        COALESCE(SUM(ti.SoldQuantity), 0) AS [Tổng vé đã bán],
        COALESCE(SUM(ti.SoldQuantity * tif.Price), 0) AS [Tổng doanh thu],
        u.IsLocked AS [Trạng thái tài khoản],
        u.Avatar
    FROM Users u
    LEFT JOIN Events e ON u.Id = e.OwnerID AND e.IsDeleted = 0
    LEFT JOIN TicketInfo tif ON e.EventID = tif.EventID
    LEFT JOIN TicketInventory ti ON tif.TicketInfoID = ti.TicketInfoID
    WHERE u.Role = 'event_owner'
    GROUP BY u.Id, u.Email, u.IsLocked, u.Avatar
    ORDER BY [Tổng doanh thu] DESC, [Số sự kiện] DESC;
END;

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

Go
-- New Trigger for Messages to update LastMessageAt in Conversations
CREATE TRIGGER TR_Messages_UpdateConversation ON Messages
AFTER INSERT, UPDATE AS
BEGIN
    UPDATE Conversations
    SET LastMessageAt = GETDATE(),
        UpdatedAt = GETDATE()
    WHERE ConversationID IN (SELECT DISTINCT ConversationID FROM Inserted)
END;
GO

-- New Trigger for FileAttachments to validate file size
CREATE TRIGGER TR_FileAttachments_ValidateFileSize ON FileAttachments
AFTER INSERT, UPDATE AS
BEGIN
    IF EXISTS (SELECT 1 FROM Inserted WHERE FileSize > 104857600) -- 100MB limit
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50005, 'File size cannot exceed 100MB.', 1;
    END
END;
GO
-- DELETE from Users
-- DBCC CHECKIDENT ('Users', RESEED, 0);
-- Insert into Users (Administrator with Id=1)
INSERT INTO Users (Username, Email, PasswordHash, Role, Gender, Birthday, PhoneNumber, Address, Avatar, isLocked, LastLoginAt)
VALUES
(N'Admin', 'adminEventWeb@support.com', 'ddfa08f04ffbedd937ce079026ead9826c0f4572feee5e45ff2a66d058c0c9d5', 'admin', 'Male', '1980-01-01', '0901234567', '123 Admin St, HCMC', '', 0, GETDATE()),
(N'TayNguyen Sound', 'organizer@ticketbox.vn', '058caa5e5eec0aa2911b924607646627dbf0815d513576ada793072e78810691', 'event_owner', 'Female', '1985-05-15', '0912345678', '456 Event St, HCMC', 'taynguyensound-avt.jpg', 0, GETDATE()),
(N'Mây Lang Thang', 'music_events@hcmc.com', 'e51a4dbbf6c5021893e89253da30c135286bb8cdfb8019d87d666e5483e21c21', 'event_owner', 'Male', '1990-03-20', '0923456789', '789 Music Ave, HCMC', 'maylangthang.jpg', 0, GETDATE()),
(N'VFF', 'sports_events@hcmc.com', '42148a0e9fdc241f7d762b460c4ee97442621455745864c23adb3e4abbcdf17c', 'event_owner', 'Other', '1988-07-10', '0934567890', '101 Sports Rd, HCMC', 'vff.png', 0, GETDATE()),
(N'Lê Văn A', 'customer1@ticketbox.vn', '1f28a586d5c3af781e15c49fc8cc1b8721a8508f32f8dc4264197e4908fef2b8', 'customer', 'Female', '1995-11-25', '0945678901', '202 Customer Ln, HCMC', 'LeVanA.png', 0, GETDATE()),
(N'Trần Văn B', 'tranvanb@ticketbox.vn', 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6', 'customer', 'Male', '1992-04-15', '0956789012', '303 Customer St, HCMC', '', 0, GETDATE()),
(N'Nguyễn Thị C', 'nguyenthic@ticketbox.vn', 'b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a1', 'customer', 'Female', '1994-06-22', '0967890123', '404 Customer Rd, HCMC', '', 0, GETDATE()),
(N'Hà Nội Events', 'hanevents@hcmc.com', 'c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a1b2', 'event_owner', 'Other', '1987-09-10', '0978901234', '505 Event Ave, Hanoi', '', 0, GETDATE()),
(N'Sài Gòn Sports', 'saigonsports@hcmc.com', 'd4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a1b2c3', 'event_owner', 'Male', '1983-12-05', '0989012345', '606 Sports Ln, HCMC', '', 0, GETDATE()),
(N'Phạm Thị D', 'phamthid@ticketbox.vn', 'e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a1b2c3d4', 'customer', 'Female', '1998-08-30', '0990123456', '707 Customer Pl, HCMC', '', 0, GETDATE()),
(N'Nguyễn Văn An', N'nguyen.van.an@gmail.com', N'hashedpassword1', N'customer', N'Male', '1990-05-15', N'0123456789', N'123 Nguyễn Trãi, Hà Nội', '', 0, NULL),
(N'Trần Thị Bình', N'tran.thi.binh@gmail.com', N'hashedpassword2', N'customer', N'Female', '1992-08-22', N'0987654321', N'456 Lê Lợi, Hồ Chí Minh', '', 0, NULL),
(N'Lê Minh Châu', N'le.minh.chau@gmail.com', N'hashedpassword3', N'event_owner', N'Male', '1988-12-03', N'0345678901', N'789 Trần Phú, Đà Nẵng', '', 0, NULL),
(N'Phạm Thùy Dung', N'pham.thuy.dung@gmail.com', N'hashedpassword4', N'customer', N'Female', '1995-03-18', N'0456789012', N'321 Bạch Đằng, Hải Phòng', '', 0, NULL),
(N'Hoàng Quốc Duy', N'hoang.quoc.duy@gmail.com', N'hashedpassword5', N'customer', N'Other', '1991-07-09', N'0567890123', N'654 Đồng Khởi, Cần Thơ', '', 0, NULL),
(N'Vũ Đình Hưng', N'vu.dinh.hung@gmail.com', N'hashedpassword6', N'customer', N'Male', '1993-11-25', N'0678901234', N'987 Lý Thường Kiệt, Huế', '', 0, NULL),
(N'Đặng Thị Lan', N'dang.thi.lan@gmail.com', N'hashedpassword7', N'customer', N'Female', '1989-04-12', N'0789012345', N'159 Nguyễn Huệ, Vũng Tàu', '', 0, NULL),
(N'Bùi Văn Minh', N'bui.van.minh@gmail.com', N'hashedpassword8', N'event_owner', N'Male', '1994-09-30', N'0890123456', N'753 Lê Thánh Tôn, Nha Trang', '', 0, NULL),
(N'Ngô Thị Nga', N'ngo.thi.nga@gmail.com', N'hashedpassword9', N'customer', N'Female', '1987-01-14', N'0901234567', N'852 Hai Bà Trưng, Quy Nhơn', '', 0, NULL),
(N'Đinh Công Phúc', N'dinh.cong.phuc@gmail.com', N'hashedpassword10', N'customer', N'Male', '1996-06-07', N'0912345678', N'741 Phan Chu Trinh, Đà Lạt', '', 0, NULL),
(N'Mai Thị Quỳnh', N'mai.thi.quynh@gmail.com', N'hashedpassword11', N'customer', N'Other', '1990-10-28', N'0923456789', N'963 Nguyễn Thị Minh Khai, Phan Thiết', '', 0, NULL),
(N'Chu Thị Sương', N'chu.thi.suong@gmail.com', N'hashedpassword12', N'customer', N'Female', '1992-02-19', N'0934567890', N'147 Võ Văn Tần, Long An', '', 0, NULL),
(N'Lý Văn Tùng', N'ly.van.tung@gmail.com', N'hashedpassword13', N'event_owner', N'Male', '1985-08-11', N'0945678901', N'258 Cách Mạng Tháng 8, Biên Hòa', '', 0, NULL),
(N'Dương Thị Uyên', N'duong.thi.uyen@gmail.com', N'hashedpassword14', N'customer', N'Female', '1998-12-05', N'0956789012', N'369 An Dương Vương, Mỹ Tho', '', 0, NULL),
(N'Trịnh Minh Vũ', N'trinh.minh.vu@gmail.com', N'hashedpassword15', N'customer', N'Male', '1991-05-23', N'0967890123', N'482 Nguyễn Văn Linh, Rạch Giá', '', 0, NULL),
(N'Nguyen Tan Dat', 'tandatbtqb@gmail.com', '1f28a586d5c3af781e15c49fc8cc1b8721a8508f32f8dc4264197e4908fef2b8', 'customer', 'Male', '1980-01-01', '0901234567', '123 Admin St, HCMC', '/uploads/user_avatar/dat.jpeg', 0, GETDATE());

-- select * from Users
--select * from users;
--adminEventWeb@support.com: admin123@
--organizer@ticketbox.vn: eventowner123
--music_events@hcmc.com: eventowner321
--sports_events@hcmc.com: testpasswords
--customer1@ticketbox.vn: customer123##

-- Insert into Genres
INSERT INTO Genres (GenreName, Description)
VALUES
(N'Theater and Art', N'Theater performances and art shows'),
(N'Music', N'Music concerts and performances'),
(N'Sport', N'Sporting events'),
(N'Nhạc Pop', N'Nhạc Pop hiện đại'),
(N'Rock', N'Nhạc Rock và Metal'),
(N'Hài kịch', N'Chương trình hài kịch'),
(N'Thể thao', N'Các sự kiện thể thao'),
(N'Hội nghị', N'Hội nghị và seminar'),
('Others', 'Miscellaneous events');

-- select * from Genres;


select * from Events
--delete from Events
--DBCC CHECKIDENT ('Events', RESEED, 0);
-- Insert into Events


INSERT INTO Events (Name, Description, PhysicalLocation, StartTime, EndTime, TotalTicketCount, IsApproved, Status, GenreID, OwnerID, ImageURL, HasSeatingChart, IsDeleted, CreatedAt, UpdatedAt)
VALUES
(N'HỘI THẢO AI VÀ CHUYỂN ĐỔI SỐ', 'A seminar on AI and digital transformation', 'Ho Chi Minh City', '2025-08-12 09:00:00', '2025-08-14 12:00:00', 150, 1, 'completed', 4, 2, 'hoi_thao_ai_va_chuyen_doi_so.jpg', 0, 0, '2025-05-15 08:00:00', '2025-06-12 12:00:00'),
(N'CHẠY BỘ GÂY QUỸ VÌ TRẺ EM', 'Charity run for children', 'Thao Dien Park', '2025-09-06 06:00:00', '2025-09-08 09:00:00', 300, 1, 'completed', 3, 4, 'giaichaybo.jpg', 0, 0, '2025-05-10 06:00:00', '2025-06-08 09:00:00'),
(N'LỄ HỘI TRÀ VIỆT 2025', 'Vietnamese Tea Cultural Festival', 'Le Van Tam Park', '2025-08-16 10:00:00', '2025-08-16 15:00:00', 250, 1, 'completed', 4, 2, 'lehoitraviet.webp', 0, 0, '2025-05-18 08:30:00', '2025-06-16 15:00:00'),
(N'Workshop Lather for Health - Bọt xà bông, Bọt sức khoẻ', 'Mental wellness workshop for young people', 'Bach Dang Center', '2025-09-05 13:00:00', '2025-09-05 16:00:00', 80, 1, 'completed', 4, 2, 'Workshop-Lather-for-Health-Bot-xa-bong-Bot-suc-khoe.png', 0, 0, '2025-05-08 09:00:00', '2025-06-05 16:00:00'),
(N'GALA VĂN NGHỆ SINH VIÊN 2025', 'University student music and performance night', 'Hoa Binh Theater', '2025-09-09 18:00:00', '2025-09-09 21:00:00', 200, 1, 'completed', 1, 2, 'UEH.png', 0, 0, '2025-05-12 10:00:00', '2025-06-09 21:00:00'),
(N'HỘI NGHỊ CÔNG NGHỆ BLOCKCHAIN VIỆT NAM', 'National blockchain technology summit', 'Riverside Palace', '2025-08-13 09:00:00', '2025-08-13 17:00:00', 180, 1, 'completed', 4, 2, 'blockchain.jpg', 0, 0, '2025-05-14 11:00:00', '2025-06-13 17:00:00'),
(N'Nhà Hát Kịch IDECAF: 12 Bà Mụ', 'A captivating theater performance', 'Ho Chi Minh City', '2025-08-25 12:30:00', '2025-08-25 14:30:00', 200, 1, 'active', 1, 2, '12bamu.jpg', 1, 0, '2025-06-01 09:00:00', '2025-06-01 09:00:00'),
(N'The Island And The Bay', 'A scenic cultural event', 'Ho Chi Minh City', '2025-09-27 07:00:00', '2025-09-27 09:00:00', 200, 1, 'active', 1, 2, 'theIsland.jpeg', 0, 0, '2025-06-02 10:00:00', '2025-06-02 10:00:00'),
(N'Địa Đạo Củ Chi : Trăng Chiến Khu', 'Historical reenactment', 'Ho Chi Minh City', '2025-08-28 11:00:00', '2025-08-28 13:00:00', 200, 1, 'active', 4, 2, 'diadaocuchi.jpg',0, 0, '2025-06-03 11:00:00', '2025-06-03 11:00:00'),
(N'SÂN KHẤU THIÊN ĐĂNG: XÓM VỊT TRỜI', 'A vibrant theater show', 'Ho Chi Minh City', '2025-09-29 12:30:00', '2025-09-29 14:30:00', 200, 1, 'active', 1, 2, 'xomvittroi.jpg', 0, 0, '2025-06-04 12:00:00', '2025-06-04 12:00:00'),
(N'NGÀY AN LÀNH - khoá tu 1 ngày cuối tuần', 'A peaceful retreat', 'Ho Chi Minh City', '2025-011-30 01:30:00', '2025-011-30 03:30:00', 200, 1, 'active', 4, 2, 'khoatunganngay.jpg', 0, 0, '2025-06-05 13:00:00', '2025-06-05 13:00:00'),
(N'[Dốc Mộng Mơ] Hãy Để Anh Đi - Quốc Thiên & Bùi Công Nam', 'Music concert with popular artists', 'Ho Chi Minh City', '2025-09-01 12:30:00', '2025-09-01 14:30:00', 200, 1, 'active', 2, 3, 'haydeanhdi.jpg', 1, 0, '2025-06-06 14:00:00', '2025-06-06 14:00:00'),
(N'ISAAC WITH LOVE - FANMEETING IN HO CHI MINH', 'Fan meeting with Isaac', 'Ho Chi Minh City', '2025-10-02 10:00:00', '2025-10-02 12:00:00', 200, 1, 'active', 4, 2, 'issacevent.jpg', 0, 0, '2025-06-07 15:00:00', '2025-06-07 15:00:00'),
(N'LULULOLA SHOW HƯƠNG TRÀM | MỘT NỬA SỰ THẬT', 'Hương Tràm live performance', 'Ho Chi Minh City', '2025-11-03 10:30:00', '2025-11-03 12:30:00', 200, 1, 'active', 2, 3, 'lulula.jpeg', 1, 0, '2025-06-08 16:00:00', '2025-06-08 16:00:00'),
(N'LỄ HỘI ẨM THỰC ẤN ĐỘ - INDIAN FOOD FESTIVAL AT BENARAS', 'Indian cultural food festival', 'Ho Chi Minh City', '2025-12-04 11:00:00', '2025-12-04 13:00:00', 200, 1, 'active', 4, 2, 'amthucando.jpg', 0, 0, '2025-06-09 17:00:00', '2025-06-09 17:00:00'),
(N'[CONCERT] ANH TRAI VƯỢT NGÀN CHÔNG GAI DAY5, DAY6', 'Popular music concert', 'Ho Chi Minh City', '2025-08-05 11:00:00', '2025-08-05 13:00:00', 200, 1, 'active', 2, 3, 'antraivuotchonggai.jpg', 0, 0, '2025-06-10 18:00:00', '2025-06-10 18:00:00'),
(N'SAXOPHONE FESTIVAL - SMOKE & SILK', 'Jazz saxophone event', 'Ho Chi Minh City', '2025-08-06 12:00:00', '2025-08-06 14:00:00', 200, 1, 'active', 1, 2, 'smok&silk.jpeg', 0, 0, '2025-06-11 19:00:00', '2025-06-11 19:00:00'),
(N'Lion Championship 23 - 2025', 'MMA championship', 'Ho Chi Minh City', '2025-08-07 12:00:00', '2025-08-07 14:00:00', 200, 1, 'active', 3, 4, 'lionchampion.jpg', 0, 0, '2025-06-12 20:00:00', '2025-06-12 20:00:00'),
(N'VBA 2025 - Saigon Heat vs CT Catfish', 'Basketball league match', 'Ho Chi Minh City', '2025-09-08 12:30:00', '2025-09-08 14:30:00', 200, 1, 'active', 3, 4, 'saigonchampion.jpg', 0, 0, '2025-06-13 21:00:00', '2025-06-13 21:00:00'),
(N'Vở cải lương "CÂU THƠ YÊN NGỰA"', 'Traditional Vietnamese opera', 'Ho Chi Minh City', '2025-09-09 13:00:00', '2025-09-09 15:00:00', 200, 1, 'active', 1, 2, 'cauthoyenngua.jpg', 0, 0, '2025-06-14 22:00:00', '2025-06-14 22:00:00'),
(N'[Viện pháp HCM] CONCERT LUIZA', 'Classical music concert', 'Ho Chi Minh City', '2025-10-10 13:00:00', '2025-10-10 15:00:00', 200, 1, 'active', 1, 2, 'luiza.jpeg', 0, 0, '2025-06-15 23:00:00', '2025-06-15 23:00:00'),
(N'HBAshow: Lê Hiếu - Bạch Công Khanh "Bài Tình Ca Cho Em"', 'Romantic music show', 'Ho Chi Minh City', '2025-10-11 13:00:00', '2025-10-11 15:00:00', 200, 1, 'active', 2, 3, 'bachcongkhanh.jpeg', 0, 0, '2025-06-16 09:00:00', '2025-06-16 09:00:00'),
(N'Vở cải lương "Sấm vang dòng Như Nguyệt"', 'Historical Vietnamese opera', 'Ho Chi Minh City', '2025-08-12 13:00:00', '2025-08-12 15:00:00', 200, 1, 'active', 1, 2, 'samvangdongnhunguyet.jpg', 0, 0, '2025-06-17 10:00:00', '2025-06-17 10:00:00'),
(N'THE BEST OF POP - ROCK - MOVIE MUSIC & FASHION RHYTHM', 'Pop and rock music event', 'Ho Chi Minh City', '2025-09-13 13:00:00', '2025-09-13 15:00:00', 200, 1, 'active', 1, 2, 'thebestpop&rok.jpeg', 0, 0, '2025-06-18 11:00:00', '2025-06-18 11:00:00'),
(N'autoFEST@HCMC [Music Party & Merchandise]', 'Music and automotive merchandise event', 'Ho Chi Minh City', '2025-09-14 02:00:00', '2025-09-14 04:00:00', 200, 1, 'active', 2, 3, 'musicparty.jpg', 0, 0, '2025-06-19 12:00:00', '2025-06-19 12:00:00'),
(N'Automotive Mobility Solutions Conference', 'Industry conference and workshop', 'Ho Chi Minh City', '2025-08-15 03:00:00', '2025-08-15 05:00:00', 200, 1, 'active', 4, 2, 'automotive.jpeg', 0, 0, '2025-06-20 13:00:00', '2025-06-20 13:00:00');




INSERT INTO TicketInfo (TicketName, TicketDescription, Category, Price, SalesStartTime, SalesEndTime, EventID, MaxQuantityPerOrder, IsActive, CreatedAt, UpdatedAt)
VALUES
(N'Standard Ticket - 12 Bà Mụ', N'Regular seating', N'Standard', 15000, '2025-08-20 00:00:00', '2025-08-24 12:00:00', 7, 10, 1, '2025-06-01 09:00:00', '2025-06-01 09:00:00'),
(N'VIP Ticket - The Island And The Bay', N'Premium seating', N'VIP', 20000, '2025-06-01 00:00:00', '2025-09-25 23:59:59', 8, 10, 1, '2025-06-02 10:00:00', '2025-06-02 10:00:00'),
(N'Standard Ticket - Địa Đạo Củ Chi', N'General admission', N'Standard', 12000, '2025-06-01 00:00:00', '2025-06-28 10:30:00', 9, 10, 1, '2025-06-03 11:00:00', '2025-06-03 11:00:00'),
(N'Premium Ticket - Xóm Vịt Trời', N'Enhanced experience', N'Premium', 18000, '2025-06-01 00:00:00', '2025-06-29 12:00:00', 10, 10, 1, '2025-06-04 12:00:00', '2025-06-04 12:00:00'),
(N'General Admission - Ngày An Lành', N'Open seating', N'General Admission', 100000, '2025-06-01 00:00:00', '2025-06-30 01:00:00', 11, 10, 1, '2025-06-05 13:00:00', '2025-06-05 13:00:00'),
(N'VIP Ticket - Dốc Mộng Mơ', N'Premium concert ticket', N'VIP', 250000, '2025-06-01 00:00:00', '2025-07-01 12:00:00', 12, 10, 1, '2025-06-06 14:00:00', '2025-06-06 14:00:00'),
(N'Meet & Greet - Isaac Fanmeeting', N'Includes meet and greet', N'Meet & Greet', 300000, '2025-06-01 00:00:00', '2025-07-02 09:30:00', 13, 5, 1, '2025-06-07 15:00:00', '2025-06-07 15:00:00'),
(N'Premium Ticket - Hương Tràm Show', N'Premium concert ticket', N'Premium', 280000, '2025-06-01 00:00:00', '2025-07-03 10:00:00', 14, 10, 1, '2025-06-08 16:00:00', '2025-06-08 16:00:00'),
(N'General Admission - Indian Food Festival', N'Entry to food festival', N'General Admission', 80000, '2025-06-01 00:00:00', '2025-07-04 10:30:00', 15, 10, 1, '2025-06-09 17:00:00', '2025-06-09 17:00:00'),
(N'VIP Ticket - Anh Trai Concert', N'VIP concert experience', N'VIP', 350000, '2025-06-01 00:00:00', '2025-07-05 10:30:00', 16, 10, 1, '2025-06-10 18:00:00', '2025-06-10 18:00:00'),
(N'Standard Ticket - Saxophone Festival', N'General admission', N'Standard', 160000, '2025-06-01 00:00:00', '2025-07-06 11:30:00', 17, 10, 1, '2025-06-11 19:00:00', '2025-06-11 19:00:00'),
(N'Ringside Ticket - Lion Championship', N'Premium ringside seats', N'Premium', 400000, '2025-06-01 00:00:00', '2025-07-07 11:30:00', 18, 8, 1, '2025-06-12 20:00:00', '2025-06-12 20:00:00'),
(N'Courtside Ticket - VBA Saigon Heat', N'Courtside basketball seats', N'VIP', 300000, '2025-06-01 00:00:00', '2025-07-08 12:00:00', 19, 6, 1, '2025-06-13 21:00:00', '2025-06-13 21:00:00'),
(N'Standard Ticket - Câu Thơ Yên Ngựa', N'Traditional opera seating', N'Standard', 130000, '2025-06-01 00:00:00', '2025-07-09 12:30:00', 20, 10, 1, '2025-06-14 22:00:00', '2025-06-14 22:00:00'),
(N'Premium Ticket - Luiza Concert', N'Classical music concert', N'Premium', 220000, '2025-06-01 00:00:00', '2025-07-10 12:30:00', 21, 10, 1, '2025-06-15 23:00:00', '2025-06-15 23:00:00'),
(N'Premium Ticket - Lê Hiếu & Bạch Công Khanh', N'Premium romantic show', N'Premium', 260000, '2025-06-01 00:00:00', '2025-07-11 12:30:00', 22, 10, 1, '2025-06-16 09:00:00', '2025-06-16 09:00:00'),
(N'Standard Ticket - Sấm Vang Như Nguyệt', N'Traditional opera', N'Standard', 140000, '2025-06-01 00:00:00', '2025-07-12 12:30:00', 23, 10, 1, '2025-06-17 10:00:00', '2025-06-17 10:00:00'),
(N'VIP Ticket - Pop Rock Music', N'VIP experience', N'VIP', 320000, '2025-06-01 00:00:00', '2025-07-13 12:30:00', 24, 8, 1, '2025-06-18 11:00:00', '2025-06-18 11:00:00'),
(N'General Admission - autoFEST HCMC', N'Music party admission', N'General Admission', 180000, '2025-06-01 00:00:00', '2025-07-14 01:30:00', 25, 10, 1, '2025-06-19 12:00:00', '2025-06-19 12:00:00'),
(N'Professional Pass - Automotive Conference', N'Industry conference access', N'Professional', 250000, '2025-06-01 00:00:00', '2025-07-15 02:30:00', 26, 5, 1, '2025-06-20 13:00:00', '2025-06-20 13:00:00');


-- delete from TicketInventory
-- DBCC CHECKIDENT ('TicketInventory', RESEED, 0);
-- select * from TicketInfo
INSERT INTO TicketInventory (TicketInfoID, TotalQuantity, SoldQuantity, ReservedQuantity, LastUpdated)
VALUES
(1, 200, 2, 0, '2025-08-20 00:00:00'),
(2, 200, 1, 0, '2025-06-01 00:00:00'),
(3, 200, 1, 0, '2025-06-01 00:00:00'),
(4, 200, 0, 0, '2025-06-01 00:00:00'),
(5, 200, 1, 0, '2025-06-01 00:00:00'),
(6, 200, 1, 0, '2025-06-01 00:00:00'),
(7, 200, 2, 0, '2025-06-01 00:00:00'),
(8, 200, 2, 0, '2025-06-01 00:00:00'),
(9, 200, 2, 0, '2025-06-01 00:00:00'),
(10, 200, 1, 0, '2025-06-01 00:00:00'),
(11, 200, 0, 0, '2025-06-01 00:00:00'),
(12, 200, 0, 0, '2025-06-01 00:00:00'),
(13, 200, 0, 0, '2025-06-01 00:00:00'),
(14, 200, 0, 0, '2025-06-01 00:00:00'),
(15, 200, 0, 0, '2025-06-01 00:00:00'),
(16, 200, 0, 0, '2025-06-01 00:00:00'),
(17, 200, 0, 0, '2025-06-01 00:00:00'),
(18, 200, 0, 0, '2025-06-01 00:00:00'),
(19, 200, 0, 0, '2025-06-01 00:00:00'),
(20, 200, 0, 0, '2025-06-01 00:00:00');

-- select * from TicketInventory


-- select * from Ticket
-- delete from Ticket
-- DBCC CHECKIDENT ('Ticket', RESEED, 0);
-- Insert into Ticket
INSERT INTO Ticket (TicketInfoID, TicketCode, Status, SeatID, CreatedAt, UpdatedAt)
VALUES
(1, 'TKT000000012025', 'sold', NULL, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(1, 'TKT000000022025', 'sold', NULL, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(2, 'TKT000000032025', 'sold', NULL, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(3, 'TKT000000042025', 'sold', NULL, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(4, 'TKT000000142025', 'sold', NULL, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(4, 'TKT000000152025', 'sold', NULL, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(5, 'TKT000000052025', 'sold', NULL, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(6, 'TKT000000062025', 'sold', NULL, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(7, 'TKT000000072025', 'sold', NULL, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(7, 'TKT000000082025', 'sold', NULL, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(8, 'TKT000000092025', 'sold', NULL, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(8, 'TKT000000102025', 'sold', NULL, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(9, 'TKT000000112025', 'sold', NULL, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(9, 'TKT000000122025', 'sold', NULL, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(10, 'TKT000000132025', 'sold', NULL, '2025-06-20 14:00:00', '2025-06-20 14:00:00');

--select * from Ticket

-- Insert into PaymentMethod
INSERT INTO PaymentMethod (MethodName, PromotionCode, Description, IsActive)
VALUES
('Credit Card', 'CREDIT5', '5% off for first-time users - Pay with Visa, MasterCard, or Amex', 1),
('VNPay', 'VNPAY0', 'Free transaction fee - Pay with VNPay mobile app', 1),
('Payos', 'EWALLET0', 'Free transaction fee - Pay with mobile apps like Momo', 1);

-- select * from PaymentMethod
-- select * from Events
INSERT INTO Orders (OrderNumber, UserID, TotalQuantity, SubtotalAmount, DiscountAmount, TotalAmount, PaymentStatus, OrderStatus, PaymentMethodID, ContactPhone, ContactEmail, Notes, CreatedAt, UpdatedAt)
VALUES
('ORD00000001', 5, 2, 300000, 0, 300000, 'paid', 'delivered', 1, '0945678901', 'customer1@ticketbox.vn', 'Deliver via email', '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
('ORD00000002', 5, 2, 530000, 0, 530000, 'paid', 'delivered', 2, '0945678901', 'customer1@ticketbox.vn', 'Deliver via email', '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
('ORD00000003', 5, 2, 220000, 0, 220000, 'pending', 'created', 3, '0945678901', 'customer1@ticketbox.vn', 'Deliver via email', '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
('ORD00000004', 5, 2, 600000, 0, 600000, 'paid', 'delivered', 1, '0945678901', 'customer1@ticketbox.vn', 'Deliver via email', '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
('ORD00000005', 5, 1, 200000, 0, 200000, 'failed', 'cancelled', 2, '0945678901', 'customer1@ticketbox.vn', 'Deliver via email', '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
('ORD00000006', 5, 1, 280000, 0, 280000, 'paid', 'delivered', 3, '0945678901', 'customer1@ticketbox.vn', 'Deliver via email', '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
('ORD00000007', 5, 1, 350000, 0, 350000, 'pending', 'created', 1, '0945678901', 'customer1@ticketbox.vn', 'Deliver via email', '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
('ORD00000008', 14, 2, 2000000, 0, 2000000, 'paid', 'delivered', 1, '0945678903', 'pham.thuy.dung@gmail.com', 'Deliver via email', '2025-06-28 10:00:00', '2025-06-28 10:00:00'),
('ORD00000009', 17, 5, 5000000, 500000, 450000, 'paid', 'delivered', 1, '0945678923', 'mai.thi.quynh@gmail.com', 'Deliver via email', '2025-06-28 12:00:00', '2025-06-28 12:00:00'),
('ORD00000010', 18, 3, 3000000, 0, 3000000, 'paid', 'delivered', 1, '0945678912', 'chu.thi.suong@gmail.com', 'Deliver via email', '2025-06-27 15:00:00', '2025-06-27 15:00:00'),
('ORD00000011', 15, 10, 10000000, 1000000, 9000000, 'paid', 'delivered', 2, '0945678888', 'dang.thi.lan@gmail.com', 'Deliver via email', '2025-06-27 18:00:00', '2025-06-27 18:00:00'),
('ORD00000012', 11, 1, 1500000, 0, 1500000, 'paid', 'delivered', 1, '123456789', 'chu.thi.suong@gmail.com', 'Deliver via email', '2025-06-26 09:00:00', '2025-06-26 09:00:00'),
('ORD00000013', 12, 20, 20000000, 2000000, 180000, 'paid', 'delivered', 1, '0945678123', 'trinh.minh.vu@gmail.com', 'Deliver via email', '2025-06-25 14:00:00', '2025-06-25 14:00:00'),
('ORD00000014', 11, 4, 4000000, 400000, 3600000, 'paid', 'delivered', 1, '0945678122', 'tran.thi.binh@gmail.com', 'Deliver via email', '2025-06-24 11:00:00', '2025-06-24 11:00:00'),
('ORD00000015', 6, 15, 15000000, 0, 15000000, 'paid', 'cancelled', 2, '09456789312', 'bui.van.minh@gmail.com', 'Deliver via email', '2025-06-23 16:00:00', '2025-06-23 16:00:00'),
('ORD00000016', 6, 8, 8000000, 800000, 720000, 'paid', 'cancelled', 1, '0945678321', 'mai.thi.quynh@gmail.com', 'Deliver via email', '2025-06-22 13:00:00', '2025-06-22 13:00:00'),
('ORD00000017', 7, 25, 25000000, 2500000, 22500000, 'paid', 'cancelled', 2, '0945678111', 'trinh.minh.vu@gmail.com', 'Deliver via email', '2025-06-21 17:00:00', '2025-06-21 17:00:00');
 
--  select * from orders

-- Insert into OrderItems
INSERT INTO OrderItems (OrderID, TicketInfoID, EventID, TicketID, UnitPrice, Quantity, TotalPrice, AssignedAt, CreatedAt)
VALUES
(1, 1, 1, 1, 150000, 1, 150000, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(1, 1, 1, 2, 150000, 1, 150000, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(2, 6, 6, 6, 250000, 1, 250000, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(2, 8, 8, 9, 280000, 1, 280000, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(3, 3, 3, 4, 120000, 1, 120000, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(3, 5, 5, 5, 100000, 1, 100000, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(4, 7, 7, 7, 300000, 1, 300000, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(2, 7, 7, 8, 300000, 1, 300000, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(6, 8, 8, 10, 280000, 1, 280000, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(7, 10, 10, 13, 350000, 1, 350000, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(8, 3, 3, 3, 120000, 1, 120000, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(9, 9, 9, 11, 80000, 1, 80000, '2025-06-20 14:00:00', '2025-06-20 14:00:00'),
(10, 9, 9, 12, 80000, 1, 80000, '2025-06-20 14:00:00', '2025-06-20 14:00:00');

-- Insert into Promotions 
INSERT INTO Promotions (PromotionName, PromotionCode, Description, PromotionType, StartTime, EndTime, EventID, DiscountPercentage, DiscountAmount, MinOrderAmount, MaxDiscountAmount, MaxUsageCount, CurrentUsageCount, IsActive, CreatedBy, CreatedAt, UpdatedAt)
VALUES
(N'Summer Sale', N'SUMMER25', N'25% off for summer events', N'percentage', '2025-07-01 00:00:00', '2025-07-03 11:00:00', 15, 25.00, NULL, 500000, 100000, 100, 0, 1, 1, '2025-06-28 09:00:00', '2025-06-29 09:00:00'),
(N'Early Bird', N'EARLY10', N'10% off for early bookings', N'percentage', '2025-07-01 00:00:00', '2025-07-07 12:30:00', 19, 10.00, NULL, 200000, 50000, 50, 0, 1, 2, '2025-06-01 09:00:00', '2025-06-01 09:00:00'),
(N'Concert Discount', N'CONCERT50K', N'50,000 VND off for concerts', N'fixed_amount', '2025-07-01 00:00:00', '2025-07-09 10:00:00', 20, NULL, 50000, 300000, 50000, 200, 0, 1, 3, '2025-06-01 09:00:00', '2025-06-01 09:00:00'),
(N'Theater Discount', N'THEATER20', N'20% off for theater tickets', N'percentage', '2025-08-20 00:00:00', '2025-08-24 12:00:00', 7, 20.00, NULL, 300000, 60000, 100, 0, 1, 1, '2025-06-28 09:00:00', '2025-06-28 09:00:00'),
(N'Island Special', N'ISLAND30K', N'30,000 VND off for cultural event', N'fixed_amount', '2025-06-01 00:00:00', '2025-09-25 23:59:59', 8, NULL, 30000, 200000, 30000, 150, 0, 1, 2, '2025-06-01 09:00:00', '2025-06-01 09:00:00'),
(N'Concert Flash Sale', N'CONCERT15', N'15% off for Anh Trai concert', N'percentage', '2025-06-01 00:00:00', '2025-07-05 10:30:00', 16, 15.00, NULL, 400000, 75000, 200, 0, 1, 3, '2025-06-01 09:00:00', '2025-06-01 09:00:00');

-- Insert into Feedback
INSERT INTO Feedback (UserID, EventID, OrderID, Rating, Content, IsApproved, CreatedAt, UpdatedAt)
VALUES
(5, 1, 1, 5, 'Absolutely fantastic theater performance! The actors were brilliant and the story was captivating.', 1, '2025-06-20 15:00:00', '2025-06-20 15:00:00'),
(5, 6, 2, 4, 'Great concert with amazing vocals. The venue was perfect and the atmosphere was incredible.', 1, '2025-06-20 15:00:00', '2025-06-20 15:00:00'),
(5, 3, 3, 4, 'Very educational and moving experience. Well worth the visit to learn about history.', 1, '2025-06-20 15:00:00', '2025-06-20 15:00:00'),
(5, 7, 4, 5, 'Isaac was amazing! The fanmeeting was well organized and he was so kind to all fans.', 1, '2025-06-20 15:00:00', '2025-06-20 15:00:00'),
(5, 8, 6, 3, 'Good show but the sound system had some issues. Hương Tràm sang beautifully though.', 0, '2025-06-20 15:00:00', '2025-06-20 15:00:00');

-- Insert into Report
INSERT INTO Report (ReporterID, EventID, Description, AdminID, IsResolved, ResolvedAt, CreatedAt, UpdatedAt)
VALUES
(5, 8, 'Sound system issues during the concert', 1, 0, NULL, '2025-06-20 16:00:00', '2025-06-20 16:00:00'),
(5, 6, 'Late start time reported', 1, 1, '2025-06-20 16:30:00', '2025-06-20 16:00:00', '2025-06-20 16:30:00');


-- Insert into Notifications 
INSERT INTO Notifications (UserID, Title, Content, NotificationType, RelatedID, IsRead, ReadAt, Priority, CreatedAt, ExpiresAt)
VALUES
(5, 'Order Confirmation', 'Your order ORD00000001 has been confirmed.', 'order', 1, 1, '2025-06-20 14:10:00', 'high', '2025-06-20 14:00:00', '2025-07-20 14:00:00'),
(5, 'New Message', 'You have a new message about 12 Bà Mụ.', 'message', 1, 0, NULL, 'normal', '2025-06-20 14:10:00', '2025-07-20 14:00:00'),
(6, 'Order Confirmation', 'Your order ORD00000002 has been confirmed.', 'order', 2, 1, '2025-06-20 14:20:00', 'high', '2025-06-20 14:00:00', '2025-07-20 14:00:00'),
(6, 'New Message', 'You have a new message about concert seating.', 'message', 2, 0, NULL, 'normal', '2025-06-20 14:25:00', '2025-07-20 14:00:00'),
(7, 'Order Confirmation', 'Your order ORD00000003 has been confirmed.', 'order', 3, 1, '2025-06-20 14:30:00', 'high', '2025-06-20 14:00:00', '2025-07-20 14:00:00'),
(10, 'Order Confirmation', 'Your order ORD00000004 has been confirmed.', 'order', 4, 1, '2025-06-20 14:40:00', 'high', '2025-06-20 14:00:00', '2025-07-20 14:00:00'),
(10, 'New Message', 'You have a new message about Hương Tràm concert.', 'message', 4, 0, NULL, 'normal', '2025-06-20 15:00:00', '2025-07-20 15:00:00');

select * from Events where status = 'active'
-- Insert into AuditLog
INSERT INTO AuditLog (TableName, RecordID, Action, OldValues, NewValues, ChangedColumns, UserID, UserAgent, CreatedAt)
VALUES
('Users', 5, 'UPDATE', '{"LastLoginAt": null}', '{"LastLoginAt": "2025-06-20 14:00:00"}', 'LastLoginAt', 1, 'Mozilla/5.0', '2025-06-20 14:00:00'),
('Orders', 1, 'INSERT', NULL, '{"OrderID": 1, "OrderNumber": "ORD00000001", "UserID": 5}', NULL, 5, 'Mozilla/5.0', '2025-06-20 14:00:00'),
('Messages', 1, 'INSERT', NULL, '{"MessageID": 1, "ConversationID": 1, "SenderID": 5}', NULL, 5, 'Mozilla/5.0', '2025-06-20 14:00:00');

-- Insert into Refunds
INSERT INTO Refunds (OrderID, OrderItemID, UserID, RefundAmount, RefundReason, RefundStatus, PaymentMethodID, RefundRequestDate, CreatedAt, UpdatedAt)
VALUES
(8, 8, 14, 150000, 'Change of plans', 'pending', 2, '2025-06-20 15:00:00', '2025-06-20 15:00:00', '2025-06-20 15:00:00');

UPDATE Users
SET CreatedAt = CASE
    WHEN Id BETWEEN 1 AND 13 THEN 
        CASE Id
            WHEN 1 THEN '2025-03-15 09:00:00'  -- Start of 3-month window
            WHEN 2 THEN '2025-03-25 14:30:00'
            WHEN 3 THEN '2025-04-05 11:15:00'
            WHEN 4 THEN '2025-04-15 16:45:00'
            WHEN 5 THEN '2025-05-01 08:20:00'
            WHEN 6 THEN '2025-05-10 13:50:00'
            WHEN 7 THEN '2025-05-20 10:30:00'
            WHEN 8 THEN '2025-06-01 15:15:00'
            WHEN 9 THEN '2025-06-05 12:00:00'
            WHEN 10 THEN '2025-06-10 09:30:00'
            WHEN 11 THEN '2025-06-12 14:00:00'
            WHEN 12 THEN '2025-06-14 11:45:00'
            WHEN 13 THEN '2025-06-15 05:31:00'  -- Current time
        END
    ELSE 
        CASE Id
            WHEN 14 THEN '2024-07-01 08:00:00'
            WHEN 15 THEN '2024-08-15 13:30:00'
            WHEN 16 THEN '2024-09-20 10:15:00'
            WHEN 17 THEN '2024-10-10 15:45:00'
            WHEN 18 THEN '2024-11-05 09:20:00'
            WHEN 19 THEN '2024-11-25 14:50:00'
            WHEN 20 THEN '2024-12-10 11:30:00'
            WHEN 21 THEN '2024-12-20 16:15:00'
            WHEN 22 THEN '2025-01-05 08:40:00'
            WHEN 23 THEN '2025-01-20 13:10:00'
            WHEN 24 THEN '2025-02-01 10:25:00'
            WHEN 25 THEN '2025-02-28 15:00:00'
        END
END
WHERE Id BETWEEN 1 AND 25;

UPDATE Users
SET LastLoginAt = CASE Id
    -- New Users (CreatedAt >= 2025-03-15, IDs 1–13)
    WHEN 1 THEN '2025-04-01 08:15:22'  -- Peak (4 logins in April)
    WHEN 2 THEN '2025-04-05 14:30:47'
    WHEN 3 THEN '2025-04-10 11:45:19'
    WHEN 4 THEN '2025-04-15 17:20:33'
    WHEN 5 THEN '2025-05-01 09:10:28'  -- Medium (3 logins in May)
    WHEN 6 THEN '2025-05-10 15:55:41'
    WHEN 7 THEN '2025-05-20 12:25:16'
    WHEN 8 THEN '2025-06-01 10:35:29'  -- Trough (1 login in June)
    WHEN 9 THEN '2025-03-01 16:50:37'  -- Trough (1 login in March)
    WHEN 10 THEN '2025-02-01 13:15:44' -- Trough (1 login in February, spillover)
    WHEN 11 THEN '2025-01-01 19:30:21' -- Trough (1 login in January)
    WHEN 12 THEN '2024-12-01 07:45:13' -- Trough (1 login in December, spillover)
    WHEN 13 THEN '2024-11-01 14:20:35' -- Trough (1 login in November)
    -- Old Users (CreatedAt < 2025-03-15, IDs 14–25)
    WHEN 14 THEN '2024-08-01 09:20:35' -- Peak (4 logins in August)
    WHEN 15 THEN '2024-08-05 16:10:48'
    WHEN 16 THEN '2024-08-10 14:25:27'
    WHEN 17 THEN '2024-08-15 20:15:39'
    WHEN 18 THEN '2024-10-01 11:30:22' -- Peak (4 logins in October)
    WHEN 19 THEN '2024-10-05 17:45:51'
    WHEN 20 THEN '2024-10-10 08:55:14'
    WHEN 21 THEN '2024-10-15 15:40:28'
    WHEN 22 THEN '2024-12-01 12:20:33' -- Medium (3 logins in December)
    WHEN 23 THEN '2024-12-05 10:35:46'
    WHEN 24 THEN '2024-12-10 18:25:19'
    WHEN 25 THEN '2024-07-01 13:50:42' -- Trough (1 login in July)
    WHEN 26 THEN '2024-09-01 10:15:00' -- Trough (1 login in September)
    ELSE LastLoginAt
END
WHERE Id BETWEEN 1 AND 25;

-- Update all qualifying events to 'pending'
UPDATE e
SET Status = 'pending',
    UpdatedAt = GETDATE()
FROM Events e
JOIN TicketInfo ti ON e.EventID = ti.EventID
JOIN TicketInventory tinv ON ti.TicketInfoID = tinv.TicketInfoID
WHERE e.Status = 'active'
  AND e.IsDeleted = 0
  AND tinv.SoldQuantity = 0;

  update Events set status = 'active' where Name = N'SÂN KHẤU THIÊN ĐĂNG: XÓM VỊT TRỜI'

SELECT c.ConversationID, c.CustomerID, c.EventOwnerID, c.EventID, c.Subject, c.Status,
                 c.LastMessageAt, c.CreatedBy, c.CreatedAt, c.UpdatedAt, e.Name AS EventName, u.Username AS CustomerName
                 FROM Conversations c 
                 LEFT JOIN Events e ON c.EventID = e.EventID 
                 LEFT JOIN Users u ON c.CustomerID = u.Id 
                 WHERE c.EventOwnerID = 2 AND e.Status = 'active'

-- select * from OrderItems


