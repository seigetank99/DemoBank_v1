DROP database if exists demobank;

create database demobank;

use demobank;

CREATE TABLE users(
	user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email varchar(255) not null unique,
    password VARCHAR(255) not null,
    token varchar(255) null,
    code int null,
    verified int default 0, 
    verified_at datetime,
    created_at timestamp,
    updated_at timestamp default now()
);

Create table accounts(
	account_id INT not null auto_increment primary key ,
	user_id int, 
    account_number varchar(255) not null, 
    account_name varchar(50) not null,
    account_type varchar(50) not null,
    balance decimal(18, 2) default 0.00,
    created_at timestamp,
    updated_at timestamp default now(),
    foreign key(user_id) references users(user_id) on delete cascade
);
    
create table transaction_history(
	transaction_id int not null auto_increment primary key,
    account_id int, 
    transaction_type varchar(50) not null,
    amount decimal(18,2),
    source varchar(50) null,
    status varchar(50) null, 
    reason_code varchar(100) null,
    created_at timestamp,
	foreign key(account_id) references accounts(account_id) on delete cascade
);    

create table payments(
	payment_id int not null auto_increment primary key,
    account_id int, 
    beneficiary varchar(50) null,
    beneficiary_acc_no varchar(255) null,
    amount decimal(18, 2) null,
    reference_no varchar(100) null,
    status varchar(100) null, 
    reason_code varchar(100) null,
    created_at timestamp,
	foreign key(account_id) references accounts(account_id) on delete cascade
    );
    
create view v_transaction_history
as
select
    t.transaction_id,
    a.account_id,
    u.user_id,
    t.transaction_type,
    t.amount,
    t.source,
    t.status,
    t.reason_code,
    t.created_at
from
    transaction_history as t
INNER JOIN 
    accounts as a
on
	t.account_id = a.account_id
inner join 
	users as u 
on 
	a.user_id=u.user_id;
    
create view v_payments
as
select 
	p.payment_id,
    a.account_id,
    u.user_id,
    p.beneficiary,
    beneficiary_acc_no,
    p.amount,
    p.status,
    p.reference_no,
    p.reason_code,
    p.created_at
from
	payments as p
inner join
	accounts as a 
on 
	p.account_id = a.account_id
inner join 
	users as u 
on 
a.user_id = u.user_id;
    
    