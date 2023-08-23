select * from dataset;
select * from prodstd1;

select distinct 제품명 from prodstd1;

drop table lackdata;
create table lackdata as
select s.수주번호, s.납기일자, s.거래처코드, s.제품코드, p.제품명,
	REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(p.제품명, '\\([^\\)]+\\)', ''), '[가-힣]', ''), '[^X0-9]$', '') as PRODNAME,
	case 
		when REGEXP_REPLACE(REGEXP_REPLACE(p.제품명, '[^(가-힣)]+', ''), '\\(.*', '') = '청주금성' then '청주'
		when REGEXP_REPLACE(REGEXP_REPLACE(p.제품명, '[^(가-힣)]+', ''), '\\(.*', '') = '현림수로용' then '현림'
		when (REGEXP_REPLACE(REGEXP_REPLACE(p.제품명, '[^(가-힣)]+', ''), '\\(.*', '') != '청주금성' or 
			REGEXP_REPLACE(REGEXP_REPLACE(p.제품명, '[^(가-힣)]+', ''), '\\(.*', '') != '현림수로용') and 
			REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(p.제품명, '\\([^\\)]+\\)', ''), '[가-힣]', ''), '[^X0-9]$', '') != 'ARE-580FX'
			then REGEXP_REPLACE(REGEXP_REPLACE(p.제품명, '[^(가-힣)]+', ''), '\\(.*', '')
		when REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(p.제품명, '\\([^\\)]+\\)', ''), '[가-힣]', ''), '[^X0-9]$', '') = 'ARE-580FX' 
			then '크로아티아'
	end as SITEBUSNAME,
	case 
		when REGEXP_REPLACE(REGEXP_REPLACE(p.제품명, '.*\\(', ''), '[^가-힣]+', '') = '청주금성' then '금성'
		when REGEXP_REPLACE(REGEXP_REPLACE(p.제품명, '.*\\(', ''), '[^가-힣]+', '') = '현림수로용' then '수로용'
		when REGEXP_REPLACE(REGEXP_REPLACE(p.제품명, '.*\\(', ''), '[^가-힣]+', '') != '청주금성' or
			REGEXP_REPLACE(REGEXP_REPLACE(p.제품명, '.*\\(', ''), '[^가-힣]+', '') != '현림수로용' then 
			REGEXP_REPLACE(REGEXP_REPLACE(p.제품명, '.*\\(', ''), '[^가-힣]+', '')
	end as region
from salesorder1 s 
join prodstd1 p on s.제품코드 = p.제품코드 
where s.제품코드 in(
	'PCA021027605', 
	'PCA031024602',
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
	'PEMA023098200');
	
select * from lackdata;

drop table dataset1;
create table dataset1 as
select * from dataset;

select * from dataset1 where SOLDDATE >= '2021-04-01';


insert into dataset1 (ORDERID, SOLDDATE, CUSTID, PRODID, PRODNAME, SITEBUSNAME, REGION)
select 수주번호, 납기일자, 거래처코드, 제품코드, prodname, sitebusname, region
from lackdata; 

select count(*) from dataset1;
select count(*) from dataset1 where solddate >= '2021-02-24';
select count(*) from salesorder1;

select s.제품코드, d.PRODID 
from salesorder1 s 
left join dataset1 d on s.제품코드 = d.PRODID 
having s.제품코드 is null;

--
select * from dataset1;
select * from prodstd1;

drop table semi_data;
create table semi_data as
select distinct prodid, prodname, SITEBUSNAME , REGION 
from dataset1
order by PRODID;

select *
from semi_data 

select prodid from semi_data
group by prodid
having count(*) > 1;

drop table prodstd2;
create table prodstd2 as
select *
from prodstd1
order by 제품코드;

select * from prodstd2;

drop table prodstd3;
create table prodstd3 as
select p.*, d.PRODNAME, d.sitebusname, d.region
from prodstd2 p
left join semi_data d on p.제품코드 = d.PRODID 
order by p.제품코드;

select * from prodstd3;

drop table new_re;
create table new_re as
select r.*, ROW_NUMBER() OVER (PARTITION BY 제품명, 제품코드, 원자재코드 ORDER BY 투입지시비율 DESC) as rn
from (select
		제품명,
	    제품코드,
	    LOT번호,
	    제품bom차수,
	    원자재투입순번,
	    원자재코드,
	    원자재명,
	    투입지시중량,
	    round(투입지시비율, 2) as 투입지시비율,
	    sitebusname,
	    region
	FROM (
	    SELECT
	        p.prodname as 제품명,
	        r.제품코드,
	        r.LOT번호, 
	        r.제품bom차수,
	        r.원자재투입순번,
	        r.원자재코드,
	        r.원자재명,
	        r.투입지시중량,
	        r.투입지시비율,
	        p.sitebusname,
	        p.region
	    FROM recipe1 r
	    JOIN prodstd3 p ON r.제품코드 = p.제품코드 
		) AS subquery) as r
ORDER BY 제품코드, 제품bom차수, 원자재투입순번;

select * from new_re;

select count(*) from recipe1;
select count(*) from re1;
select count(*) from new_re ;

drop table new_re1;
create table new_re1 as
select 제품명, 제품코드, LOT번호, 제품bom차수, 원자재투입순번, 원자재코드, 원자재명, round(투입지시중량, 2) as 투입지시중량, round(투입지시비율, 2) as 투입지시비율,
	sitebusname, region, 
	 case 
		when regexp_replace(regexp_replace(원자재명, '[가-힣]+', ''),'\\(.*', '') in (select PRODNAME from prodstd3)
			then '제품' else '0' end as 제품여부 
from new_re
where rn = 1 
ORDER by 제품명, 제품bom차수, 원자재투입순번;

select * from new_re1;

select count(*) from new_re1;
select count(*) from re2;

select distinct r.원자재명, r.제품코드 ,regexp_replace(regexp_replace(r.원자재명, '[가-힣]+', ''),'\\(.*', '') 
from new_re1 r
join prodstd3 p on r.제품명 = p.PRODNAME and r.제품코드 = p.제품코드 
where regexp_replace(regexp_replace(r.원자재명, '[가-힣]+', ''),'\\(.*', '') in (select PRODNAME from prodstd3)
order by 원자재명; 

select count(제품여부)
from new_re1 
where 제품여부 = '제품';

select 제품명, 제품코드, sum(투입지시비율) as 투입지시총비율 
from new_re1
group by 제품코드
order by 투입지시총비율 desc;

drop table new_re2;
create table new_re2 as
select 제품명, 원자재코드, round(sum(sum(투입지시중량)) over (partition by 제품명), 2) as 총중량, 원자재명, round(sum(투입지시중량), 2) as 투입지시중량, 
	round(sum(투입지시중량) / (sum(sum(투입지시중량)) over (partition by 제품명)), 6) as 비율
from new_re
group by 제품명, 원자재코드, 원자재명;

select * from new_re2;

select 제품명, sum(비율)
from new_re2
group by 제품명;