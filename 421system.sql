-- Backup Dir ����
CREATE OR Replace Directory mdBackup7 as 'C:\orabackup';
GRANT READ,Write On Directory mdBackup7 To scott;