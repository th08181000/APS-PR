select * from prodstd;
select * from material;
select * from vendor;
select * from salesorder;
select * from lot;
select * from recipe;
select * from mat_order;
select * from mat_delivery;

-- 테이블 정리
--
drop table prodstd1;
create table prodstd1 as
select *
from prodstd;

alter table prodstd1
drop column 제품BOM차수;

select * from prodstd1;

--
drop table material1;
create table material1 as
select *
from material;

alter table material1
drop column `원자재투입중량(기준치중량/소수점둘째자리),`,
drop column `투입비율(%/품목번호별합은100%),`,
drop column 투입원재료적요;

select * from material1;

--
drop table vendor1;
create table vendor1 as
select 거래처코드, 거래처명, 거래처부서명, 대표자명, 사업자번호, 전화번호
from vendor;

select * from vendor1;

--
drop table salesorder1; 
create table salesorder1 as
select *
from salesorder
order by 제품코드, 수주예정일자;

alter table salesorder1
drop column 긴급여부, 
drop column 비고;

select * from salesorder1;

--
drop table lot1;
create table lot1 as
select *
from lot;

alter table lot1
drop column 작업지시및주문비고사항2,
drop column 비고;

select * from lot1

--
drop table recipe1;
create table recipe1 as
select *
from recipe;

alter table recipe1
drop column 비고;

select * from recipe1;

--
drop table mat_order1;
create table mat_order1 as
select * from mat_order;

alter table mat_order1 
drop column 비고;

select * from mat_order1;

--
drop table mat_delivery1;
create table mat_delivery1 as
select 발주번호, 납품일자, 납품수량
from mat_delivery;

select * from mat_delivery1;

--
select * from prodstd1;
select * from material1;
select * from vendor1;
select * from salesorder1;
select * from lot1;
select * from recipe1;
select * from mat_order1;
select * from mat_delivery1;
--

select *
from recipe1
where 생산작업요청일자 = '2021-03-17'
order by 제품코드, 생산작업요청일자, 원자재투입순번;

-- 원자재

select mo.발주번호, mo.`발주구분(계획, 추가)`, mo.원자재코드, m.원자재명, mo.거래처코드, mo.발주수량, mo.발주단가, mo.발주예정일자,
	mo.발주일자, mo.입고예정일자, mo.입고일자, mo.입고수량, mo.회계일자, mo.입고완료여부, mo.발주서전송구분, mo.발주서출력횟수
from material1 m
join mat_order1 mo on m.원자재코드 = mo.원자재코드;

-- recipe

select *
from prodstd1
where 제품코드 = 'PCA021027605';

select *
from recipe1
where 제품코드 = 'PCA021027605'
order by 생산작업요청일자, 제품코드, 제품BOM차수, 원자재투입순번;

select *
from lot1
where 제품코드 = 'PCA021027605';

select *
from salesorder1
where 제품코드 = 'PCA021027605';


--
drop table recipe_prot;
create table recipe_prot as
select r.*, l.작업지시및주문비고사항1 as 생산작업지시순번, l.`작업지시구분(D:내수/E:수출)` as 작업지시구분
from recipe1 r
join lot1 l on r.제품코드 = l.제품코드 and r.lot번호 = l.LOT번호 
order by r.제품코드, r.제품BOM차수, r.원자재투입순번;

select *
from recipe_prot
where 제품코드 = 'PCA021027605';

select s.수주번호, s.거래처코드, r.*
from recipe_prot r
join salesorder1 s on r.제품코드 = s.제품코드 and r.생산작업요청일자 = s.수주일자
having r.제품코드 = 'PCA021027605'
order by r.제품코드, r.제품BOM차수, r.원자재투입순번;

select distinct r.제품코드, r.LOT번호, r.생산작업요청일자 , l.생산작업요청일자
from recipe1 r 
join lot1 l on r.제품코드 = l.제품코드 and r.lot번호 = l.LOT번호
having r.생산작업요청일자 != l.생산작업요청일자;

--거래처

select count(*) from vendor1;
select count(*) from salesorder1;
select * from recipe1;

drop table customer;
create table customer as
select v.거래처코드, v.거래처명, s.수주번호, s.제품코드 , s.수주예정일자 , s.수주일자 , s.납기예정일자, s.납기일자 , s.수주량,
	row_number() over (partition by s.제품코드 order by s.수주번호, s.수주일자) as num
from vendor1 v
join salesorder1 s on v.거래처코드 = s.거래처코드 
order by s.제품코드, s.수주예정일자  ;

select * from customer;

select * 
from customer
where 제품코드 = 'PEMA073050413';

select * 
from recipe2
where 제품코드 = 'PEMA073050413';

select *
from recipe1
order by 제품코드, 생산작업요청일자;

drop table recipe2;
create table recipe2 as
select 제품코드, LOT번호 , 분할순번, 생산작업요청일자, 제품BOM차수, round(sum(round(투입지시중량, 2))) as 수주량,
	row_number() over (partition by 제품코드 order by LOT번호, 생산작업요청일자) as num
from recipe1
group by 제품코드, LOT번호 , 생산작업요청일자, 제품BOM차수, 분할순번
order by 제품코드, 생산작업요청일자;

select * from recipe2;

select * 
from recipe2
order by 제품코드, 생산작업요청일자;

select count(*)
from customer c
join recipe2 r on c.제품코드 = r.제품코드 and c.num = r.num and c.수주번호 = r.lot번호
order by c.제품코드, c.수주예정일자;

SELECT *
FROM customer c 
LEFT join recipe2 r on c.제품코드 = r.제품코드  and c.num = r.num and c.num = r.num and c.수주번호 = r.lot번호
UNION
SELECT *
FROM customer c 
RIGHT join recipe2 r on c.제품코드 = r.제품코드  and c.num = r.num and c.num = r.num and c.수주번호 = r.lot번호
WHERE c.제품코드 IS NULL;

drop table customer tomer_recipe;
create table customer_recipe as
select c.거래처코드, c.거래처명 , c.수주번호 , c.제품코드 , c.수주예정일자, c.수주일자 , c.납기예정일자 , c.납기일자 , 
	r.LOT번호, r.제품bom차수, r.생산작업요청일자, c.수주량 as 수주량c , r.수주량 as 수주량r 
from customer c
join recipe2 r on c.제품코드 = r.제품코드 and c.num = r.num and c.수주번호 = r.lot번호
order by c.제품코드, c.수주예정일자;

select * from customer_recipe;


--수주와 발주

select 
	nvl(sum(case when 생산작업요청일자 between '2021-02-15' and '2021-02-21' then 투입지시중량 end), 0) + 877035 as 발주1,
	nvl(sum(case when 생산작업요청일자 between '2021-02-15' and '2021-02-21' then 투입지시중량 end), 0) + 877035
	- sum(case when 생산작업요청일자 between '2021-02-21' and '2021-02-28' then 투입지시중량 end) as 발주2,
	nvl(sum(case when 생산작업요청일자 between '2021-02-15' and '2021-02-21' then 투입지시중량 end), 0) + 877035
	- sum(case when 생산작업요청일자 between '2021-02-21' and '2021-02-28' then 투입지시중량 end) + 826683
	- sum(case when 생산작업요청일자 between '2021-02-28' and '2021-03-08' then 투입지시중량 end)as 발주2
from recipe1
where 원자재명 = '사용수';

--발주 원자재 확인
select count(*)
from mat_order1 m
join material v on m.원자재코드 = v.원자재코드 ;

select * from prodstd1 where 제품코드 = 'PEMASRE200';
select * from material1 where 원자재코드 = 'SR47093';
select count(*) from mat_order;
select * from recipe1 where 원자재코드 = 'SR35211';

select *
FROM mat_order1 mo 
LEFT join material1 m on mo.원자재코드 = m.원자재코드  
UNION
SELECT *
FROM mat_order1 mo 
righT join material1 m on mo.원자재코드 = m.원자재코드;

select distinct 원자재코드, 원자재명, 원자재탱크번호
from recipe1
order by 원자재코드, 원자재탱크번호 ;

select *
FROM mat_order1 mo 
left join material1 m on mo.원자재코드 = m.원자재코드

-- 레시피
select * from recipe1;
select * from material1;

    
SELECT
    CONCAT(SUBSTRING(제품코드, 1, 5), DENSE_RANK() over (order by 제품코드, 제품bom차수)) as 레시피코드,
    제품코드,
    제품bom차수,
    원자재투입순번,
    원자재코드,
    원자재명,
    투입지시중량,
    투입지시비율
from recipe1
ORDER by 제품코드, 제품bom차수, 원자재투입순번;

drop table r;
create table r as
SELECT
    CONCAT(SUBSTRING(제품코드, 1, 5), DENSE_RANK() over (order by 제품코드)) as 레시피코드,
    제품코드,
    제품bom차수,
    원자재투입순번,
    원자재코드,
    원자재명,
    투입지시중량,
    투입지시비율
from recipe1
ORDER by 제품코드, 제품bom차수, 원자재투입순번;

select * from r;

drop table r1;
create table r1 as
select r.*, ROW_NUMBER() OVER (PARTITION BY 레시피코드, 제품코드, 원자재코드 ORDER BY 투입지시비율 DESC) as rn
from r
ORDER by 제품코드, 제품bom차수, 원자재투입순번;

select * from r1;

drop table r2;
create table r2 as
select 레시피코드, 제품코드, 제품bom차수, 원자재투입순번, 원자재코드, 원자재명, 투입지시중량, round(투입지시비율, 2) as 투입지시비율,
	case 
		when substr(원자재명, 1, 11) in 
			('PEMA-HR1000', 'PEMA-HR1500', 'PEMA-SR2000', 'PEMA-SR3000', 'PEMA-SR5000', 'PEMA-PR2000', 'PEMA-SP1000') or 
			substr(원자재명, 1, 10) in ('PEMA-500FR', 'PEMA-SN400') or 
			substr(원자재명, 1, 7) = 'CSA5000'
			then '제품' else '0' end as 제품여부 
from r1
where rn = 1 
ORDER by 제품코드, 제품bom차수, 원자재투입순번;

-- SELECT
--     CASE WHEN row_number() over (partition by 제품코드, 제품bom차수 order by 원자재투입순번) = 1
--         THEN CONCAT(SUBSTRING(제품코드, 1, 2), row_number() over (order by 제품코드, 제품bom차수, 원자재투입순번))
--         ELSE NULL
--     END as 레시피코드,
--     제품코드,
--     제품bom차수,
--     원자재투입순번,
--     원자재코드,
--     원자재명,
--     투입지시중량,
--     투입지시비율
-- FROM
--     recipe1
-- ORDER BY
--     제품코드, 제품bom차수, 원자재투입순번;

select REGEXP_REPLACE(원자재명, '\\([^)]*\\)', '') AS 결과열
from r1
where rn = 1

select count(*) from recipe1;

select count(*)
from recipe1 r
join prodstd1 p on r.제품코드 = p.제품코드
ORDER by r.제품코드, r.제품bom차수, r.원자재투입순번;

drop table re;
create table re as
select
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(replace(replace(SUBSTRING_INDEX(SUBSTRING_INDEX(REGEXP_REPLACE(REGEXP_REPLACE
	(제품명, '[가-힣]+', ''), '\\..*', ''), '/', 1), '-', 2), 'PR1000_', 'PR1000'), 'ARE-580FXP', 'ARE-580FX'), 'PEMA-PR10001', 'PEMA-PR1000'),
	'PEMA-HR1000F', 'PEMA-HR1000'), 'PEMA-HR1000OPC', 'PEMA-HR1000'), 'PEMA-HR1000S', 'PEMA-HR1000'), 'PEMA-HR1000TYPE', 'PEMA-HR1000'),
	'PEMA-HR1500F', 'PEMA-HR1500'), 'PEMA-PCM2000B', 'PEMA-PCM2000'), 'PEMA-PCR3000E', 'PEMA-PCR3000'), 'PEMA-PCR3000N', 'PEMA-PCR3000') as 제품명,
    제품코드,
    LOT번호,
    제품bom차수,
    원자재투입순번,
    원자재코드,
    원자재명,
    투입지시중량,
    round(투입지시비율, 2) as 투입지시비율
FROM (
    SELECT
        REGEXP_REPLACE(p.제품명, '\\(.*\\)', '') AS 제품명,
        r.제품코드,
        r.LOT번호, 
        r.제품bom차수,
        r.원자재투입순번,
        r.원자재코드,
        r.원자재명,
        r.투입지시중량,
        r.투입지시비율
    FROM recipe1 r
    JOIN prodstd1 p ON r.제품코드 = p.제품코드
) AS subquery
ORDER BY 제품코드, 제품bom차수, 원자재투입순번;

-- drop table re;
-- create table re as
-- select
-- 	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(replace(replace(SUBSTRING_INDEX(SUBSTRING_INDEX(REGEXP_REPLACE(REGEXP_REPLACE
-- 		(제품명, '[가-힣]+', ''), '\\..*', ''), '/', 1), '-', 2), 'PR1000_', 'PR1000'), 'ARE-580FXP', 'ARE-580FX'),'PEMA-SR3000F', 'PEMA-SR3000'),
-- 		'PEMA-HR1000F', 'PEMA-HR1000'), 'PEMA-PCR3000E', 'PEMA-PCR3000'), 'PEMA-PCR3000N', 'PEMA-PCR3000'),
-- 		'PEMA-SR5000F', 'PEMA-SR5000'), 'PEMA-HR1000OPC', 'PEMA-HR1000'), 'PEMA-SR2000A', 'PEMA-SR2000'), 'CSA5000F', 'CSA5000'),
-- 		'PEMA-HR1000TYPE', 'PEMA-HR1000'), 'PEMA-HR1000S', 'PEMA-HR1000'), 'PEMA-PCM2000B', 'PEMA-PCM2000'),
-- 		'PEMA-HR1500F', 'PEMA-HR1500'), 'PEMA-PR10001', 'PEMA-PR1000') as 제품명,
--     제품코드,
--     제품bom차수,
--     원자재투입순번,
--     원자재코드,
--     원자재명,
--     투입지시중량,
--     투입지시비율
-- FROM (
--     SELECT
--         REGEXP_REPLACE(p.제품명, '\\(.*\\)', '') AS 제품명,
--         r.제품코드,
--         r.제품bom차수,
--         r.원자재투입순번,
--         r.원자재코드,
--         r.원자재명,
--         r.투입지시중량,
--         r.투입지시비율
--     FROM recipe1 r
--     JOIN prodstd1 p ON r.제품코드 = p.제품코드
-- ) AS subquery
-- ORDER BY 제품코드, 제품bom차수, 원자재투입순번;

select distinct 제품명 from re order by 제품명;

drop table re1;
create table re1 as
select r.*, ROW_NUMBER() OVER (PARTITION BY 제품명, 제품코드, 원자재코드 ORDER BY 투입지시비율 DESC) as rn
from re r
ORDER by 제품명, 제품코드, 제품bom차수, 원자재투입순번;

select * from re1;

drop table re2;
create table re2 as
select 제품명, LOT번호, 제품코드, 제품bom차수, 원자재투입순번, 원자재코드, 원자재명, round(투입지시중량, 2) as 투입지시중량, round(투입지시비율, 2) as 투입지시비율,
	case 
		when substr(원자재명, 1, 11) in 
			('PEMA-HR1000', 'PEMA-HR1500', 'PEMA-SR2000', 'PEMA-SR3000', 'PEMA-SR5000', 'PEMA-PR2000', 'PEMA-SP1000') or 
			substr(원자재명, 1, 10) in ('PEMA-500FR', 'PEMA-SN400') or 
			substr(원자재명, 1, 7) = 'CSA5000'
			then '제품' else '0' end as 제품여부 
from re1
where rn = 1 
ORDER by 제품명, 제품bom차수, 원자재투입순번;

select * from re2;

select 제품코드, sum(투입지시비율) as 투입지시총비율 
from re2
group by 제품코드
order by 제품코드;

SELECT
    t2.레시피코드,
    t2.제품코드,
    t2.제품bom차수,
    t2.원자재투입순번,
    t2.원자재코드,
    t2.원자재명,
    t2.투입지시중량,
    t2.투입지시비율
FROM (
    SELECT
        t1.*,
        ROW_NUMBER() OVER (PARTITION BY t1.레시피코드, t1.제품코드, t1.원자재코드 ORDER BY t1.투입지시비율 DESC) AS rn
    FROM (
        SELECT
            CONCAT(SUBSTRING(제품코드, 1, 5), DENSE_RANK() OVER (ORDER BY 제품코드)) AS 레시피코드,
            제품코드,
            제품bom차수,
            원자재투입순번,
            원자재코드,
            원자재명,
            투입지시중량,
            투입지시비율
        FROM recipe1
    ) t1
) t2
WHERE t2.rn = 1
ORDER BY t2.제품코드, t2.제품bom차수, t2.원자재투입순번;

select * from r2;

select *
from r2
where substr(원자재명, 1, 3) = 'SRE';

drop table r2_per;
create table r2_per as
select 레시피코드, 제품코드, sum(투입지시비율) as 투입지시총비율 
from r2
group by 레시피코드, 제품코드
order by 제품코드;

select * from r2_per order by 투입지시총비율 desc;

select *
from re2
order by 제품코드, 원자재투입순번;

drop table re3;
create table re3 as
select r.*
from re2 r
order by  r.제품코드, r.원자재투입순번;

select * from r2 order by 제품코드;
select * from re3 order by 제품명;

select * from re3 where 제품코드 = 'PEMA553048200' order by 제품bom차수;
select * from re3 where 제품코드 = 'PEMA553048200' and 수주일자 = '2021-04-08' order by 수주일자, 제품bom차수;
select * from re3 order by 수주일자, 제품코드, 원자재투입순번;

select * from r2 where 제품코드 = 'PEMA013122400';
select count(*) from r2;
select count(*) from re3;

select 제품명, 제품코드, lot번호, 
	case when substr(lot번호, 3, 1) = '2' then SUBSTRING(REGEXP_REPLACE(lot번호, '[^0-9]+', ''), 1, 6) 
	else case when substr(lot번호, 5, 1) = '2' then SUBSTRING(REGEXP_REPLACE(lot번호, '[^0-9]+', ''), 2, 6) end end as 날짜,
	sum(투입지시비율) as 총비율
from re3
group by 제품명, 제품코드
order by 총비율 desc;

-- 레시피 리셋

select * from re2 where 제품코드 = 'PCA021027605';
select * from prodstd1;
select * from salesorder1 ;
select distinct 제품코드 from recipe1;
select * from dataset;

select distinct r.제품코드, d.prodid
from recipe1 r 
left join dataset d on r.제품코드 = d.PRODID; 

select count(distinct 제품코드) from recipe1 where 생산작업요청일자 = '2021-02-22' order by 제품코드;

select *
from dataset
union
select 수주번호, 납기일자,  
from salesorder1 
where 제품코드 in('PCA021027605', 'PCA031024602',
'PEMA003039101',
'PEMA013000210',
'PEMA013002500',
'PEMA013002700',
'PEMA013004500',
'PEMA013004501',
'PEMA013005900',
'PEMA013007300',
'PEMA013010100',
'PEMA013010900',
'PEMA013012300',
'PEMA013012600',
'PEMA013013010',
'PEMA013013100',
'PEMA013015800',
'PEMA013015900',
'PEMA013017200',
'PEMA013017400',
'PEMA013017800',
'PEMA013019100',
'PEMA013019701',
'PEMA013019702',
'PEMA013020100',
'PEMA013070800',
'PEMA013117700',
'PEMA023098200')

select count(*) from salesorder1 s ;
select count(*) from dataset where SOLDDATE >= '2021-02-24';

select distinct s.제품코드, d.prodid
from salesorder1 s
left join dataset d on s.제품코드  = d.PRODID ;


select * from dataset where SOLDDATE = '2021-02-24' order by SOLDDATE, PRODID ;

select * from recipe1 where 제품코드 = 'PCA021027605' order by 제품코드;
select * from dataset where ORDERID  like 'PEMA210223' order by SOLDDATE  ;

select d.PRODNAME as 제품명, r.*
from recipe1 r
join dataset d on r.제품코드 = d.PRODID and r.LOT번호  like substr(d.orderid, 1, 10) 
ORDER by 제품명, r.제품bom차수, r.원자재투입순번; 

-- 2년치

select distinct PRODNAME  from dataset order by PRODNAME ;
select * from vendor1 order by 거래처명, 거래처코드;

select d.PRODID , d.SOLDDATE , s.제품코드 , s.수주일자 
from dataset d
left join salesorder1 s on d.PRODID = s.제품코드 and  d.SOLDDATE = s.수주일자 
having d.solddate >= '2021-02-22';

select d.PRODID , d.SOLDDATE , s.제품코드 , s.수주일자 
from dataset d
right join salesorder1 s on d.PRODID = s.제품코드 and  d.SOLDDATE = s.수주일자 
having d.solddate >= '2021-02-22';

-- 인벤토리

drop table inv;
create table inv as
select distinct `원자재코드(품목번호)` as 원자재코드, `원자재명(품목명)` as 원자재명
from material1
order by 원자재코드;

alter table inv
add 재고중량 float default 0;

alter table inv
drop column 재고중량;

insert into inv (재고중량)
values (0);

delete from inv 
where 재고중량 = 0;

select * from inv;

select * from prodstd2;