-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

Set echo on
Set feedback on 

Spool C:\Oracle\sql\setup1.txt

Create table customer_t
(cust#  number(3,0) NOT NULL,
Custname  varchar2(12),
Shippingaddress  varchar2(15),
Citystate  varchar2(15),
Zipcode  number(5,0),
Phone#  varchar2(15),
Constraint customer_pk PRIMARY KEY(cust#));

Create table warehouse_t
(whcode  number(6,0) NOT NULL,
Address varchar(15),
Citystate  varchar2(15),
Zipcode  number(5,0),
Phone#  varchar2(15),
Constraint warehouse_pk PRIMARY KEY(whcode));

Create table item_t
(item#   varchar2(6) NOT NULL,
Itemdescription    varchar2(15),
Unitprice   decimal(5,2),
Constraint item_pk PRIMARY KEY(item#));

Create table inventory_t
(item#  varchar2(6) NOT NULL,
Whcode   number(6,0) NOT NULL,
Inventorylevel   decimal(5,2),
Constraint inventory_pk PRIMARY KEY(item#,whcode), 
Constraint inventory_fk1 FOREIGN KEY(item#) REFERENCES item_t(item#),
Constraint inventory_fk2 FOREIGN KEY(whcode) REFERENCES warehouse_t(whcode));


Create table order_t
(order#   number(4,0) NOT NULL,
Orderdate  date default sysdate,
Cust#   number(3,0) NOT NULL,
Item#   varchar2(6) NOT NULL,
Quantityordered  number(4,0),
Amountordered  number(8,2),
Whcode  number(6,0) NOT NULL,
Shippingdate  varchar2(12),
Status varchar2(8),
Constraint order_pk PRIMARY KEY(order#),
Constraint order_fk1 FOREIGN KEY(cust#) REFERENCES customer_t(cust#),
Constraint order_fk2 FOREIGN KEY(item#) REFERENCES item_t(item#),
Constraint order_fk3 FOREIGN KEY(whcode) REFERENCES warehouse_t(whcode));

Commit;

Create sequence ordr_seq;

Create or replace trigger order_bir
Before insert on order_t
For each row
When (new.order# is null)
Begin 
Select order_seq.NEXTVAL
Into  :new.order#
From dual;
End;
/

Insert into customer_t values(101,'Davis,Ally','555 Circle blvd','Los Angeles,CA',90740,'222-585-6623');

Insert into customer_t values(102,'Jones,Sara','3200 Rock dr','Phoneix,AZ',33405,'123-456-7890');

Insert into customer_t values(103,'Garcia,Jack','415 Rancho ln','Old City,NM',87101,'323-888-5546');

Insert into customer_t values(104,'Butler,Ryan','392 Flower dr','Macon,GA',31201,'717-545-9000');

Insert into customer_t values(105,'Smith,JD','656 Crystal ln','Dover,DE',19901,'878-333-4433');

Insert into item_t values('V001','Vase',25.00);
Insert into item_t values('B001','Book Ends',15.50);
Insert into item_t values('B002','Bookshelf',45.25);
Insert into item_t values('T001','Throw Blanket',35.50);
Insert into item_t values('C001','Candlestick',10.15);

column unitprice heading 'UNITPRICE' format $9,999.99;

Insert into warehouse_t values(2201,'666 little dr','Phoneix,AZ',33405,'818-222-2288');

Insert into warehouse_t values(2202,'32 west blvd','Los Angeles,CA',90740,'555-555-5555');

Insert into warehouse_t values(2203,'88 long st','Atlanta,GA',31010,'717-222-2222');

Insert into warehouse_t values(2204,'909 seal st','Dover,DE',19901,'878-999-0909');

Insert into warehouse_t values(2205,'100 main st','Boulder,CO',30230,'123-444-4444');

Insert into inventory_t values('V001',2201,500);

Insert into inventory_t values('V001',2202,60);

Insert into inventory_t values('V001',2203,40);

Insert into inventory_t values('V001',2204,22);

Insert into inventory_t values('B001',2201,50);

Insert into inventory_t values('B001',2202,50);

Insert into inventory_t values('B001',2203,15);

Insert into inventory_t values('B001',2204,65);

Insert into inventory_t values('B002',2202,300);

Insert into inventory_t values('B002',2203,400);

Insert into inventory_t values('B002',2204,20);

Insert into inventory_t values('T001',2201,500);

Insert into inventory_t values('T001',2202,50);

Insert into inventory_t values('T001',2203,350);

Insert into inventory_t values('T001',2204,550);

Insert into inventory_t values('C001',2202,650);

Insert into inventory_t values('C001',2203,45);

Insert into inventory_t values('C001',2204,650);

Insert into inventory_t values('C001',2205,60);

Commit;

Insert into order_t(order#,orderdate,cust#,item#,quantityordered,amountordered,whcode,status)
values(order_seq.NEXTVAL,DATE '2020-02-05',101,'V001',1,25.00,2202,'OPEN');

Insert into order_t(order#,orderdate,cust#,item#,quantityordered,amountordered,whcode,status)
values(order_seq.NEXTVAL,default,101,'T001',3,106.50,2202,'OPEN');

Insert into order_t(order#,orderdate,cust#,item#,quantityordered,amountordered,whcode,status)
values(order_seq.NEXTVAL,DATE '2020-04-04',102,'V001',5,125,2201,'OPEN');

Insert into order_t(order#,orderdate,cust#,item#,quantityordered,amountordered,whcode,status)
values(order_seq.NEXTVAL,DATE '2020-03-12',103,'B001',8,124,2201,'OPEN');

Insert into order_t(order#,orderdate,cust#,item#,quantityordered,amountordered,whcode,status)
values(order_seq.NEXTVAL,DATE '2020-05-03',104,'B001',6,150,2203,'OPEN');

Insert into order_t(order#,orderdate,cust#,item#,quantityordered,amountordered,whcode,status)
values(order_seq.NEXTVAL,DATE '2020-04-04',105,'V001',30,120,2201,'OPEN');

column amountordered heading 'AMOUNTORDERED' format $9,999.99;
set linesize 120;

Commit;

spool off; 


