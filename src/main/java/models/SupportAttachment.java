package models;

import java.sql.Date;
import java.sql.Timestamp;

public class SupportAttachment {
    private int attachmentId;
    private int supportId;
    private String fileName;
    private String originalFileName;
    private String filePath;
    private String fileType;
    private long fileSize;
    private Date uploadDate;
    private Timestamp uploadTimestamp;

    public SupportAttachment() {
    }

    public SupportAttachment(int supportId, String fileName, String originalFileName, 
                           String filePath, String fileType, long fileSize) {
        this.supportId = supportId;
        this.fileName = fileName;
        this.originalFileName = originalFileName;
        this.filePath = filePath;
        this.fileType = fileType;
        this.fileSize = fileSize;
        this.uploadDate = new Date(System.currentTimeMillis());
        this.uploadTimestamp = new Timestamp(System.currentTimeMillis());
    }

    public SupportAttachment(int attachmentId, int supportId, String fileName, 
                           String originalFileName, String filePath, String fileType, 
                           long fileSize, Date uploadDate, Timestamp uploadTimestamp) {
        this.attachmentId = attachmentId;
        this.supportId = supportId;
        this.fileName = fileName;
        this.originalFileName = originalFileName;
        this.filePath = filePath;
        this.fileType = fileType;
        this.fileSize = fileSize;
        this.uploadDate = uploadDate;
        this.uploadTimestamp = uploadTimestamp;
    }

    // Getters and Setters
    public int getAttachmentId() {
        return attachmentId;
    }

    public void setAttachmentId(int attachmentId) {
        this.attachmentId = attachmentId;
    }

    public int getSupportId() {
        return supportId;
    }

    public void setSupportId(int supportId) {
        this.supportId = supportId;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getOriginalFileName() {
        return originalFileName;
    }

    public void setOriginalFileName(String originalFileName) {
        this.originalFileName = originalFileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public long getFileSize() {
        return fileSize;
    }

    public void setFileSize(long fileSize) {
        this.fileSize = fileSize;
    }

    public Date getUploadDate() {
        return uploadDate;
    }

    public void setUploadDate(Date uploadDate) {
        this.uploadDate = uploadDate;
    }

    public Timestamp getUploadTimestamp() {
        return uploadTimestamp;
    }

    public void setUploadTimestamp(Timestamp uploadTimestamp) {
        this.uploadTimestamp = uploadTimestamp;
    }

    // Utility methods
    public String getFileExtension() {
        if (originalFileName != null && originalFileName.contains(".")) {
            return originalFileName.substring(originalFileName.lastIndexOf(".") + 1).toLowerCase();
        }
        return "";
    }

    public String getIconClass() {
        String extension = getFileExtension();
        switch (extension) {
            case "jpg":
            case "jpeg":
            case "png":
            case "gif":
            case "bmp":
                return "fas fa-image";
            case "pdf":
                return "fas fa-file-pdf";
            case "doc":
            case "docx":
                return "fas fa-file-word";
            case "txt":
                return "fas fa-file-alt";
            case "zip":
            case "rar":
                return "fas fa-file-archive";
            case "exe":
                return "fas fa-cog";
            default:
                return "fas fa-file";
        }
    }

    public String getFormattedFileSize() {
        if (fileSize < 1024) {
            return fileSize + " B";
        } else if (fileSize < 1024 * 1024) {
            return String.format("%.1f KB", fileSize / 1024.0);
        } else if (fileSize < 1024 * 1024 * 1024) {
            return String.format("%.1f MB", fileSize / (1024.0 * 1024.0));
        } else {
            return String.format("%.1f GB", fileSize / (1024.0 * 1024.0 * 1024.0));
        }
    }

    public String getFormattedUploadDate() {
        if (uploadTimestamp != null) {
            return SupportItem.timestampToString(uploadTimestamp);
        }
        return uploadDate != null ? SupportItem.dateToString(uploadDate) : "N/A";
    }

    @Override
    public String toString() {
        return "SupportAttachment{" +
                "attachmentId=" + attachmentId +
                ", supportId=" + supportId +
                ", fileName='" + fileName + '\'' +
                ", originalFileName='" + originalFileName + '\'' +
                ", fileType='" + fileType + '\'' +
                ", fileSize=" + fileSize +
                '}';
    }
} 