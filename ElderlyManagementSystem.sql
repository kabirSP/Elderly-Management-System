CREATE TABLE AGENCY(Branchid NUMBER NOT NULL PRIMARY KEY,AContact NUMBER UNIQUE,Branchname VARCHAR(30),City VARCHAR(20),Zipcode NUMBER);
CREATE TABLE EMPLOYERS(Essn VARCHAR(15) NOT NULL PRIMARY KEY,Salary NUMBER NOT NULL CHECK(Salary>1000),EMPContact NUMBER UNIQUE, EMPName VARCHAR(20),City VARCHAR(20),Zipcode NUMBER,Branchid NUMBER NOT NULL,FOREIGN KEY(Branchid) REFERENCES AGENCY(Branchid) ON DELETE CASCADE)
CREATE TABLE ELDERS(Custid NUMBER NOT NULL PRIMARY KEY,ELDName VARCHAR(15),Age NUMBER,Gender varchar(1),ELDContact NUMBER UNIQUE,Branchid NUMBER NOT NULL,Ssn VARCHAR(15),FOREIGN KEY(Branchid) REFERENCES AGENCY(Branchid) ON DELETE CASCADE,CONSTRAINT EMPCONS FOREIGN KEY(Ssn) REFERENCES EMPLOYERS(Essn) ON DELETE SET NULL)
CREATE TABLE HEALTHRECORD(Recid NUMBER NOT NULL PRIMARY KEY,Allergy VARCHAR(50),Dietaryreq VARCHAR(50),Insurance VARCHAR(40),Emergencycontact NUMBER,Bloodgroup VARCHAR(5),Custid NUMBER,FOREIGN KEY(Custid) REFERENCES ELDERS(Custid) ON DELETE CASCADE) ;
CREATE TABLE SERVICES(Careno NUMBER NOT NULL PRIMARY KEY,Cost NUMBER CHECK(Cost>2000),Carename VARCHAR(50));
CREATE TABLE DELIVERS(Branchid NUMBER NOT NULL,Careno NUMBER NOT NULL,PRIMARY KEY(Branchid,Careno),FOREIGN KEY(Branchid) REFERENCES AGENCY(Branchid) ON DELETE CASCADE ,FOREIGN KEY(Careno) REFERENCES SERVICES(Careno) ON DELETE CASCADE);
CREATE TABLE SERVICERECORD(Careno NUMBER NOT NULL,Custid NUMBER NOT NULL ,Recid NUMBER UNIQUE,Serviceduration VARCHAR(20),Cost NUMBER,Carename VARCHAR(50),PRIMARY KEY(Careno,Custid),FOREIGN KEY(Careno) REFERENCES SERVICES(Careno) ON DELETE CASCADE);
CREATE TABLE CONTACTPERSON(Custid NUMBER NOT NULL PRIMARY KEY,CPName VARCHAR(50),CPPhone NUMBER,Relation VARCHAR(50),CPSalary number ,FOREIGN KEY(Custid) references elders(custid) on delete set null);



select * from CONTACTPERSON
select * from AGENCY
SELECT * FROM EMPLOYERS
SELECT * FROM ELDERS
SELECT * FROM HEALTHRECORD
SELECT * FROM SERVICES
SELECT * FROM DELIVERS
SELECT * FROM SERVICERECORD



INSERT INTO AGENCY VALUES(1,21432123,'Sukh Dham Old Age Home','Ludhiana',756432);
INSERT INTO AGENCY VALUES(2,21432432,'Shanti Nivas Old Age Home','Amritsar',7521432);
INSERT INTO AGENCY VALUES(3,21343432,'Prem Niwas Old Age Home','Patiala',7521412);
INSERT INTO AGENCY VALUES(4,2142232,'Chandigarh Seva Dham ','Chandigarh',7567432);



INSERT INTO EMPLOYERS VALUES('SSN01078654321',10000,213345432,'Abay','Ludhiana',756432,1);
INSERT INTO EMPLOYERS VALUES('SSN017878654321',20000,2156345432,'Sunny','Chandigarh',756132,1);
INSERT INTO EMPLOYERS VALUES('SSN10786543215',50000,213345132,'Shaam','Ambala',786432,2);
INSERT INTO EMPLOYERS VALUES('SSN01578654321',15000,2133454892,'Rosey','Panipat',758732,2);
INSERT INTO EMPLOYERS VALUES('SSN01078604321',8000,2143345432,'Charlie','Gurugram',762432,3);
INSERT INTO EMPLOYERS VALUES('SSN01078659021',18000,213345732,'Maria','Amritsar',757832,3);
INSERT INTO EMPLOYERS VALUES('SSN01074554321',19000,2453345432,'Rohan','Moga',756467,4);
INSERT INTO EMPLOYERS VALUES('SSN03128811321',14000,213212432,'Guntaas','Faridabad',756472,4);


 
INSERT INTO ELDERS(Custid,ELDName,Age,Gender,ELDContact,Branchid) VALUES(1,'Japjeet',78,'M',213321456,1);
INSERT INTO ELDERS(Custid,ELDName,Age,Gender,ELDContact,Branchid) VALUES(2,'Anuj',70,'M',223321456,2);
INSERT INTO ELDERS(Custid,ELDName,Age,Gender,ELDContact,Branchid) VALUES(3,'Manya',80,'F',215321456,3);
INSERT INTO ELDERS(Custid,ELDName,Age,Gender,ELDContact,Branchid) VALUES(4,'Ishneet',90,'F',224521456,4);



INSERT INTO HEALTHRECORD VALUES(1,'Pollen','LOW CHOLESTROL FOOD','ABC CORPORATION',21113344222,'A+',1);
INSERT INTO HEALTHRECORD VALUES(2,'Peanut Allergy','VEGETARIAN','KMN CORPORATION',21112144222,'B+',2);
INSERT INTO HEALTHRECORD VALUES(3,'Egg Allergy','FOOD WITH NO EGG','XYZ CORPORATION',21113344222,'A+',3);
INSERT INTO HEALTHRECORD VALUES(4,'Fish Allergy','NO FISH ITEMS','PWQ CORPORATION',21113344222,'A+',4);

INSERT INTO SERVICES VALUES(1,8000,'Alzheimer’s care');
INSERT INTO SERVICES VALUES(2,4000,'Stroke patients care');
INSERT INTO SERVICES VALUES(3,5000,'Day care');
INSERT INTO SERVICES VALUES(4,10000,'Cancer care');

INSERT INTO DELIVERS VALUES(1,1);
INSERT INTO DELIVERS VALUES(1,2);
INSERT INTO DELIVERS VALUES(2,3);
INSERT INTO DELIVERS VALUES(2,4);
INSERT INTO DELIVERS VALUES(3,1);
INSERT INTO DELIVERS VALUES(3,3);
INSERT INTO DELIVERS VALUES(4,2);
INSERT INTO DELIVERS VALUES(4,4);



INSERT INTO CONTACTPERSON VALUES(1,'Rohan',213321123,'SON',5000);
INSERT INTO CONTACTPERSON VALUES(2,'Sony',212321123,'GRANDSON',10000);
INSERT INTO CONTACTPERSON VALUES(3,'Jony',211321123,'SON',3000);
INSERT INTO CONTACTPERSON VALUES(4,'Riya',215321123,'DAUGHTER',4500);

--This procedure will displays agency branches along with care given , cost associated with the care which have been popluated from three tables where the carenumber is given as input
--PROCEDURE 1
set serveroutput on 
CREATE OR REPLACE PROCEDURE branchcare(carenum IN SERVICES.Careno%TYPE) IS
bid AGENCY.Branchid%TYPE;
branchname AGENCY.Branchname%TYPE;
carenumber DELIVERS.Careno%TYPE;
carename SERVICES.Carename%TYPE;
cost SERVICES.Cost%TYPE;
careno SERVICES.Careno%TYPE;
CURSOR resultcare IS
SELECT A.Branchid,A.Branchname,D.Careno,S.Carename,S.Cost,S.Careno FROM AGENCY A INNER JOIN DELIVERS D ON A.Branchid=D.Branchid INNER JOIN SERVICES S ON D.Careno=S.Careno;
BEGIN
OPEN resultcare;
LOOP
FETCH resultcare INTO bid,branchname,carenumber,carename,cost,careno;
EXIT WHEN (resultcare%NOTFOUND);
if careno=carenum THEN
dbms_output.put_line(bid||' '||branchname||' '||carenumber||' '||carename||cost);
--else
--dbms_output.put_line('no such service');
END IF;
END LOOP;
CLOSE resultcare;
END;
DECLARE
a number :=&enter_careno;
BEGIN
branchcare(a);
end;

set serveroutput on
--EXECUTE BRANCHCARE(4);

--A sequence generator used to generate automatic record id while inserting into servicerecord table
CREATE SEQUENCE seq_person
MINVALUE 1
START WITH 1
INCREMENT BY 1
CACHE 10

-- A stored procedure to insert record into Servicerecord when details like duration,customer id and careno is given. Sequence generator is used to populate unique Record id.
--PROCEDURE 2
set serveroutput on
CREATE OR REPLACE PROCEDURE insertservice(duration IN SERVICERECORD.Serviceduration%TYPE,cusid IN SERVICERECORD.Custid%TYPE,careno IN SERVICES.Careno%TYPE) IS
totalcost NUMBER;
carenumber number := careno;
cost SERVICES.Cost%TYPE;
carename SERVICES.Carename%TYPE;
CURSOR selserv is
SELECT Cost,Carename FROM SERVICES WHERE Careno=carenumber;
BEGIN
OPEN selserv;
FETCH selserv INTO cost,carename;
totalcost := cost*duration;
INSERT INTO SERVICERECORD VALUES(careno,cusid,seq_person.nextval,duration,totalcost,carename);
dbms_output.put_line('total cost of service is: '|| totalcost);
CLOSE selserv;
END;
DECLARE
dur number;
BEGIN
insertservice(5 ,3 ,4);
end;
set serveroutput on;
--EXECUTE INSERTSERVICE(2,2,1);


--procedure to get contact person for emergency!!!!!!!!!!!  PROCEDURE 3

CREATE OR REPLACE PROCEDURE EMERGENCY_NUMBER(a IN ELDERS.Custid%TYPE) IS 
    v_CPName CONTACTPERSON.CPName%TYPE;
    v_CPPhone CONTACTPERSON.CPPhone%TYPE;
    v_Relation CONTACTPERSON.Relation%TYPE;
BEGIN
    
    SELECT CPName, CPPhone, Relation 
    INTO v_CPName, v_CPPhone, v_Relation 
    FROM CONTACTPERSON 
    WHERE Custid = a;

  
    dbms_output.put_line('Contact person for elder with Custid ' || a || ':');
    dbms_output.put_line('Name: ' || v_CPName);
    dbms_output.put_line('Phone: ' || v_CPPhone);
    dbms_output.put_line('Relation: ' || v_Relation);

end;
BEGIN
    EMERGENCY_NUMBER(3);
END;

--LOAN PROCEDURE(FINAL)!!!!!!!!!  PROCEDURE 4
CREATE OR REPLACE PROCEDURE CheckForLoan(elderId IN ELDERS.Custid%TYPE, serviceId IN SERVICES.Careno%TYPE) IS
    v_ServiceCost SERVICES.Cost%TYPE;
    v_ContactPersonSalary CONTACTPERSON.CPSalary%TYPE;
BEGIN
   
    SELECT Cost INTO v_ServiceCost FROM SERVICES WHERE Careno = serviceId;

    
    SELECT CPSalary INTO v_ContactPersonSalary
    FROM CONTACTPERSON
    WHERE Custid = elderId;

    
    IF v_ServiceCost > v_ContactPersonSalary THEN
        dbms_output.put_line('The cost of the service is higher than the contact person''s salary.');
    ELSE
        dbms_output.put_line('The cost of the service is within the contact person''s salary range.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Data not found. Please check if the elder ID or service ID exists, or if there is a contact person associated with the elder.');
    WHEN OTHERS THEN
        dbms_output.put_line('An error occurred: ' || SQLERRM);
END CheckForLoan;
/
BEGIN
    CheckForLoan( 3, 3); 
end;


--TRIGGER 1
CREATE OR REPLACE TRIGGER careupdate
BEFORE UPDATE ON SERVICERECORD
FOR EACH ROW
BEGIN
    IF :OLD.Carename <> :NEW.Carename THEN
        :NEW.Carename := :NEW.Carename; 
    END IF;
    dbms_output.put_line('your data in the table has been changed BEWARE!!!!');
END careupdate;
--how this trigger is fired
update servicerecord
set Carename='new cancer'
where careno=4;


--Trigger 2
CREATE OR REPLACE TRIGGER NoLoanNeededTrigger
AFTER UPDATE OF CPSalary ON CONTACTPERSON
FOR EACH ROW
DECLARE
    v_ServiceCost SERVICES.Cost%TYPE;
BEGIN
    
    SELECT s.Cost INTO v_ServiceCost
    FROM SERVICES s
    JOIN SERVICERECORD sr ON s.Careno = sr.Careno
    WHERE sr.Custid = :NEW.Custid;

    
    IF :NEW.CPSalary > v_ServiceCost THEN
        dbms_output.put_line('No need for a loan. Contact persons new salary is sufficient');
    else 
        dbms_output.put_line('you still broke.');

    END IF;
END;

UPDATE CONTACTPERSON
SET CPSalary = 6000
WHERE Custid = 3; 


--trigger that didnot run but can be presented  TRIGGER 3!!!!
CREATE OR REPLACE TRIGGER update_total_cost
AFTER UPDATE OF Serviceduration ON SERVICERECORD
FOR EACH ROW
DECLARE
    v_Cost SERVICES.Cost%TYPE;
BEGIN
    SELECT Cost INTO v_Cost FROM SERVICES WHERE Careno = :NEW.Careno;
    :NEW.totalcost := :NEW.duration * v_Cost;
END;