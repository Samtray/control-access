/*  GET OWNERS CARD */
DROP FUNCTION IF EXISTS GET_CARD_DETAIL;
DELIMITER //
CREATE FUNCTION GET_CARD_DETAIL (
	IN_NUMBER VARCHAR(20)
) RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE VL_EMPLOYEE INT DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN 
		SET VL_EMPLOYEE = NULL;
    END;
	
    SELECT EMPLOYEE_ID 
    INTO VL_EMPLOYEE 
    FROM CARD C 
    WHERE C.NUMBER = IN_NUMBER;
    
    RETURN VL_EMPLOYEE;
END //
DELIMITER ;

/*######################### SET EMPLOYEE ##############################*/
DROP PROCEDURE IF EXISTS SET_EMPLOYEE;
DELIMITER // 
CREATE PROCEDURE SET_EMPLOYEE (
	IN IN_EMPLOYEE INT,
	IN IN_NAME VARCHAR(50),
    IN IN_LAST_NAME VARCHAR(50),
    IN IN_POSITION INT,
    IN IN_SHIFT INT,
    /*IN IN_IMG VARCHAR(1000),*/
    IN IN_USER VARCHAR(50),
    OUT OUT_RESULT VARCHAR(500)
) BEGIN 
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @SQL_STATUS = RETURNED_SQLSTATE, @ERR_MSG = MESSAGE_TEXT;    
		SET OUT_RESULT := CONCAT('ERROR -> ON [SET_EMPLOYEE] ',  @SQL_STATUS, ' - ', @ERR_MSG);
	END;
    
    SET OUT_RESULT = 'OK';
    
    IF IN_EMPLOYEE IS NOT NULL THEN 
		UPDATE EMPLOYEE SET
			FIRST_NAME = IN_NAME,
            LAST_NAME = IN_LAST_NAME,
            STATUS = 'ENABLED',
            UPDATED_ON = NOW(),
            UPDATED_BY = IN_USER,
            POSITION_ID = IN_POSITION,
            SHIFT = IN_SHIFT
            /*,IMG_URL = IN_IMG*/
		WHERE EMPLOYEE_ID = IN_EMPLOYEE;
	ELSE
		INSERT INTO EMPLOYEE (
			EMPLOYEE_ID,
			FIRST_NAME,
            LAST_NAME,
            STATUS,
            CREATED_ON,
            CREATED_BY ,
            POSITION_ID,
            SHIFT
            /*,IMG_URL*/
        ) VALUES (
			IN_EMPLOYEE,
			IN_NAME,
            IN_LAST_NAME,
			'ENABLED',
            NOW(),
            IN_USER,
			IN_POSITION,
            IN_SHIFT
            /*,IN_IMG*/
        );
    END IF;
END //
DELIMITER ;

/* TESTING PROCEDURE  
	SET @RESULT = '';
	CALL SET_EMPLOYEE(
			NULL,
			'TONATIUH',
			'LOPEZ RAMIREZ',
			NULL,
			NULL,
			'API_TEST',
			@RESULT
	);
	SELECT @RESULT;
*/
    
/*######################### SET DEPARTAMENT ##############################*/
DROP PROCEDURE IF EXISTS SET_DEPARTAMENT;
DELIMITER //
CREATE PROCEDURE SET_DEPARTAMENT (
	IN IN_DEPTO INT,
    IN IN_NAME VARCHAR(50),
    IN IN_CODE VARCHAR(20),
    IN IN_USER VARCHAR(40),
    OUT OUT_RESULT VARCHAR(500)
) BEGIN
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @SQL_STATUS = RETURNED_SQLSTATE, @ERR_MSG = MESSAGE_TEXT;    
		SET OUT_RESULT := CONCAT('ERROR -> ON [SET_DEPARTAMENT] ',  @SQL_STATUS, ' - ', @ERR_MSG);
	END;
    
    SET OUT_RESULT = 'OK';
    
    IF IN_DEPTO IS NOT NULL THEN 
		UPDATE DEPARTAMENT SET
			NAME = IN_NAME,
            CODE = IN_CODE,
            STATUS = 'ENABLED',
            UPDATED_ON = NOW(),
            UPDATED_BY = IN_USER
		WHERE DEPARTAMENT_ID = IN_DEPTO;
	ELSE
		INSERT INTO DEPARTAMENT (
			DEPARTAMENT_ID,
			NAME,
            CODE,
            STATUS,
            CREATED_ON,
            CREATED_BY 
		) VALUES (
			IN_DEPTO,
			IN_NAME,
            IN_CODE,
			'ENABLED',
            NOW(),
            IN_USER
        );
    END IF;
END //
DELIMITER ;

/* TESTING PROCEDURE  
	SET @RESULT = '';
	CALL SET_DEPARTAMENT(
		NULL,
		'DEPTO 1',
		'D1',
		'API_TEST',
		@RESULT
	);
	SELECT @RESULT;
*/

SET @RESULT = '';
CALL SET_DEPARTAMENT(
	1,
	'DEPTO 1',
	'D1',
	'API_TEST',
	@RESULT
);
SELECT @RESULT;

/*######################### SET JOB ##############################*/
DROP PROCEDURE IF EXISTS SET_JOB;
DELIMITER // 
CREATE PROCEDURE SET_JOB (
	IN IN_JOB INT,
	IN IN_NAME VARCHAR(50),
    IN IN_DESCRIPTION TEXT,
    IN IN_USER VARCHAR(50),
    OUT OUT_RESULT VARCHAR(500)
) BEGIN 
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @SQL_STATUS = RETURNED_SQLSTATE, @ERR_MSG = MESSAGE_TEXT;    
		SET OUT_RESULT := CONCAT('ERROR -> ON [SET_JOB] ',  @SQL_STATUS, ' - ', @ERR_MSG);
	END;
    
    SET OUT_RESULT = 'OK';
    
    IF IN_JOB IS NOT NULL THEN 
		UPDATE JOB SET
			NAME = IN_NAME,
            DESCRIPTION = IN_DESCRIPTION,
            STATUS = 'ENABLED',
            UPDATED_ON = NOW(),
            UPDATED_BY = IN_USER
		WHERE JOB_ID = IN_JOB;
	ELSE
		INSERT INTO JOB (
			JOB_ID,
			NAME,
            DESCRIPTION,
            STATUS,
            CREATED_ON,
            CREATED_BY
        ) VALUES (
			IN_JOB,
			IN_NAME,
            IN_DESCRIPTION,
			'ENABLED',
            NOW(),
            IN_USER
        );
    END IF;
END //
DELIMITER ;

/* TESTING PROCEDURE  
	SET @RESULT = '';
	CALL SET_JOB(
		NULL,
		'JOB',
		'TEST JOB',
		'API_TEST',
		@RESULT
	);
	SELECT @RESULT;
*/

/*######################### SET CARD ##############################*/
DROP PROCEDURE IF EXISTS SET_CARD;
DELIMITER // 
CREATE PROCEDURE SET_CARD (
	IN IN_CARD_ID INT,
	IN IN_NUMBER VARCHAR(20),
    IN IN_EMPLOYEE INT,
    IN IN_USER VARCHAR(50),
    OUT OUT_RESULT VARCHAR(500)
) BEGIN 
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @SQL_STATUS = RETURNED_SQLSTATE, @ERR_MSG = MESSAGE_TEXT;    
		SET OUT_RESULT := CONCAT('ERROR -> ON [SET_CARD] ',  @SQL_STATUS, ' - ', @ERR_MSG);
	END;
    
    SET OUT_RESULT = 'OK';
    
    IF IN_CARD_ID IS NOT NULL THEN 
		UPDATE CARD SET
			NUMBER = IN_NUMBER,
            EMPLOYEE_ID = IN_EMPLOYEE,
            STATUS = 'ENABLED',
            UPDATED_ON = NOW(),
            UPDATED_BY = IN_USER
		WHERE CARD_ID = IN_CARD_ID;
	ELSE
		INSERT INTO CARD (
			CARD_ID,
            NUMBER,
            EMPLOYEE_ID,
            STATUS,
            CREATED_ON,
            CREATED_BY
        ) VALUES (
			IN_CARD_ID,
			IN_NUMBER,
            IN_EMPLOYEE,
			'ENABLED',
            NOW(),
            IN_USER
        );
    END IF;
END //
DELIMITER ;

/* TESTING PROCEDURE  
	SET @RESULT = '';
	CALL SET_CARD(
		NULL,
		'12345',
		1,
		'API_TEST',
		@RESULT
	);
	SELECT @RESULT;
*/

/*######################### SET CARD_CHECK ##############################*/
DROP PROCEDURE IF EXISTS SET_CARD_CHECK;
DELIMITER // 
CREATE PROCEDURE SET_CARD_CHECK (
	IN IN_NUMBER VARCHAR(20),
    IN IN_USER VARCHAR(50),
    OUT OUT_RESULT VARCHAR(500)
) BEGIN 
	DECLARE VL_EMPLOYEE INT DEFAULT GET_CARD_DETAIL(IN_NUMBER);
	DECLARE VL_CARD INT;
	DECLARE VL_DT DATETIME DEFAULT NOW();
    -- DECLARE CUR_SHIFT CURSOR FOR SELECT VL_EMPLOYEE;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @SQL_STATUS = RETURNED_SQLSTATE, @ERR_MSG = MESSAGE_TEXT;    
		SET OUT_RESULT := CONCAT('ERROR -> ON [SET_CARD_CHECK] ',  @SQL_STATUS, ' - ', @ERR_MSG);
	END;
	SET OUT_RESULT = 'OK';
	SELECT CARD_ID INTO VL_CARD FROM CARD C WHERE C.EMPLOYEE_ID = VL_EMPLOYEE;	

	INSERT INTO CARD_CHECK 
	(
		EMPLOYEE_ID,
		TIME_EXP,
		CHECK_DT,
		TYPE,
		CARD_ID,
		STATUS,
		CREATED_ON,
		CREATED_BY
	) VALUES (
		VL_EMPLOYEE,
		DATE_FORMAT(VL_DT, '%H%i%s'),
		VL_DT,
		'IN', -- PROVISIONAL
		VL_CARD,
		'ENABLED',
		NOW(),
		IN_USER
	);        
END //
DELIMITER ;

/* TESTING PROCEDURE  
	SET @RESULT = '';
	CALL SET_CARD_CHECK(		
		'12345',		
		'API_TEST',
		@RESULT
	);
	SELECT @RESULT;
*/

/*#########################  SET_ACCESS_EMPLOYEE #########################*/
DROP PROCEDURE IF EXISTS SET_ACCESS_EMPLOYEE;
DELIMITER //
CREATE PROCEDURE SET_ACCESS_EMPLOYEE (
	IN IN_EMPLOYEE INT,
    IN IN_ACCESS INT,
    IN IN_STATUS VARCHAR(30),
	OUT OUT_RESULT VARCHAR(500)
) BEGIN 
	DECLARE VL_EXISTS INT DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @SQL_STATUS = RETURNED_SQLSTATE, @ERR_MSG = MESSAGE_TEXT;    
		SET OUT_RESULT := CONCAT('ERROR -> ON [SET_ACCESS_EMPLOYEE] ',  @SQL_STATUS, ' - ', @ERR_MSG);
	END;
	SET OUT_RESULT = 'OK';
	
	UPDATE EMPLOYEE_ACCESS_LEVEL SET
		STATUS = IN_STATUS
	WHERE	
		EMPLOYEE_ID = IN_EMPLOYEE
	AND ACCESS_LEVEL_ID = IN_ACCESS;
    
    IF ROW_COUNT() = 0 THEN 
		INSERT INTO EMPLOYEE_ACCESS_LEVEL VALUES (
			IN_EMPLOYEE,
            IN_ACCESS,
            IN_STATUS
        );
	END IF;					  
END //
DELIMITER ;

/* TESTING PROCEDURE
	SET @RESULT = '';
	CALL SET_ACCESS_EMPLOYEE(		
		'1',		
		'1',
        'DISABLED',
		@RESULT
	);
	SELECT @RESULT;
*/	

/*#########################  SET_DOWN_EMPLOYEE #########################*/
DROP PROCEDURE IF EXISTS SET_DOWN_EMPLOYEE;
DELIMITER //
CREATE PROCEDURE SET_DOWN_EMPLOYEE(
	IN IN_EMPLOYEE INT,    
    IN IN_USER VARCHAR(40),
	OUT OUT_RESULT VARCHAR(500)
) BEGIN 	
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @SQL_STATUS = RETURNED_SQLSTATE, @ERR_MSG = MESSAGE_TEXT;    
		SET OUT_RESULT := CONCAT('ERROR -> ON [SET_DOWN_EMPLOYEE] ',  @SQL_STATUS, ' - ', @ERR_MSG);
	END;		
    SET OUT_RESULT = 'OK';
    
	UPDATE EMPLOYEE 
	SET 
		STATUS = 'DISABLED',
		UPDATED_BY = IN_USER,
		UPDATED_ON = NOW()
	WHERE
		EMPLOYEE_ID = IN_EMPLOYEE;			
END //
DELIMITER ;

/* TESTING PROCEDURE
	SET @RESULT = '';
	CALL SET_DOWN_EMPLOYEE(		
		'1',				
        'API_TEST',
		@RESULT
	);
	SELECT @RESULT;
*/	

/*#########################  SET_DOWN_CARD #########################*/
DROP PROCEDURE IF EXISTS SET_DOWN_CARD;
DELIMITER //
CREATE PROCEDURE SET_DOWN_CARD(
	IN IN_CARD_ID INT,    
    IN IN_USER VARCHAR(40),
	OUT OUT_RESULT VARCHAR(500)
) BEGIN 	
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
		GET DIAGNOSTICS CONDITION 1 @SQL_STATUS = RETURNED_SQLSTATE, @ERR_MSG = MESSAGE_TEXT;    
		SET OUT_RESULT := CONCAT('ERROR -> ON [SET_DOWN_DOWN] ',  @SQL_STATUS, ' - ', @ERR_MSG);
	END;
    SET OUT_RESULT = 'OK';
    
	UPDATE CARD 
	SET 
		STATUS = 'DISABLED',
        EMPLOYEE_ID = NULL,
		UPDATED_BY = IN_USER,
		UPDATED_ON = NOW()
	WHERE
		CARD_ID = IN_CARD_ID;        
END //
DELIMITER ;

/* TESTING PROCEDURE
	SET @RESULT = '';
	CALL SET_DOWN_CARD(		
		1,				
        'API_TEST',
		@RESULT
	);
	SELECT @RESULT;
*/

