

## 存储函数
## 语法
DELIMITER $
CREATE FUNCTION 函数名称(参数列表)
RETURNS 返回值类型
BEGIN
	SQL 编程语句;
	RETURN 结果;
END $
DELIMITER ; 

## 案例

/*
	定义一个存储函数，获取学生表中成绩大于95分的学生数量
*/

DELIMITER $
CREATE FUNCTION fun_01()
RETURNS INT
BEGIN 
	-- 定义一个变量保存数量
	DECLARE mycount INT ;
	
	-- 查询成绩大于95分的学生数量
	SELECT COUNT(*) INTO mycount FROM student WHERE score > 95;
	
	-- 返回结果
	RETURN mycount;

END $
DELIMITER ; 



## 调用存储函数
SELECT 存储函数名称(实际参数);
SELECT fun_01();

## 删除存储函数
DROP FUNCTION IF EXISTS 函数名称;
DROP FUNCTION IF EXISTS fun_01;



SELECT * FROM mysql.func WHERE db = 'function_procedure';
