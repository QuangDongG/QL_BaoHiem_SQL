CREATE OR ALTER FUNCTION fn_TinhTuoi (@NgaySinh DATE)
RETURNS INT
AS
BEGIN
    IF @NgaySinh IS NULL OR @NgaySinh > GETDATE()
        RETURN NULL;

    RETURN DATEDIFF(YEAR, @NgaySinh, GETDATE()) -
           CASE
               WHEN MONTH(@NgaySinh) > MONTH(GETDATE()) OR
                    (MONTH(@NgaySinh) = MONTH(GETDATE()) AND DAY(@NgaySinh) > DAY(GETDATE()))
               THEN 1
               ELSE 0
           END;
END;
GO

--Test fn_TinhTuoi
DECLARE @NgaySinhTest1 DATE = '1990-10-27';
DECLARE @NgaySinhTest2 DATE = GETDATE(); -- Sinh ngày hôm nay
DECLARE @NgaySinhTest3 DATE = DATEADD(YEAR, 1, GETDATE()); -- Ngày sinh tương lai (không hợp lệ)
DECLARE @NgaySinhTest4 DATE = NULL; -- NULL
SELECT dbo.fn_TinhTuoi(@NgaySinhTest1) AS TuoiKH1;
SELECT dbo.fn_TinhTuoi(@NgaySinhTest2) AS TuoiKH2;
SELECT dbo.fn_TinhTuoi(@NgaySinhTest3) AS TuoiKH3_Invalid;
SELECT dbo.fn_TinhTuoi(@NgaySinhTest4) AS TuoiKH4_Null;
GO