select * from dataset where prodname = 'AE';
select * from dataset1;
select * from lstm;

select distinct prodname from dataset1 order by PRODNAME ;
select distinct prodname from lstm order by PRODNAME ;

select count(*) from dataset;
select count(*) from dataset1;
select count(*) from lstm;

select * from dataset1 where prodname = 'ARE-580FX';
select * from lstm where prodname = 'ARE-580FX';

drop table lstm_prot;
create table lstm_prot as
select distinct (substr(solddate, 1, 7)) as 달, substr(SOLDDATE, 1, 10) as solddate , PRODNAME , 미분양주택현황, 국내건설수주액, 국내기성액
from lstm
order by 달;

select * from lstm_prot;

drop table lstm_prot1;
create table lstm_prot1 as
select d.SOLDDATE, d.prodname, d.weekday,
	round(avg(d.D_DAY_2_TEM) over (ORDER BY DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY)), 2) as tem_avg, 
	round(avg(d.d_day_2_hum) over (ORDER BY DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY)), 2) as hum_avg,
	sum(d.ORDER_QUANT) as ORDER_QUANT, 
	sum(d.SOLD_QUANT) as SOLD_QUANT,
	l.미분양주택현황,
	l.국내건설수주액,
	l.국내기성액,
	sum(l.국내건설수주액)  as 총국내건설수주액,
	sum(l.국내기성액)  as 총국내기성액,
	DENSE_RANK() OVER (ORDER BY DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY)) as rn,
	DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY) AS week
from dataset d
join lstm_prot l on d.SOLDDATE = l.solddate and d.PRODNAME  = l.prodname
group by d.prodname, l.미분양주택현황, l.국내건설수주액,l.국내기성액, d.weekday, week
order by d.SOLDDATE , d.PRODNAME ;

select * from lstm_prot1;
select count(*) from lstm_prot1;

SELECT
    d.SOLDDATE,
    d.prodname,
    d.weekday,
    ROUND(AVG(d.D_DAY_2_TEM) OVER (ORDER BY d.SOLDDATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS tem_avg,
    ROUND(AVG(d.d_day_2_hum) OVER (ORDER BY d.SOLDDATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS hum_avg,
    SUM(d.ORDER_QUANT) AS ORDER_QUANT,
    SUM(d.SOLD_QUANT) AS SOLD_QUANT,
    l.미분양주택현황,
    l.국내건설수주액,
    l.국내기성액,
    SUM(l.국내건설수주액) AS 총국내건설수주액,
    SUM(l.국내기성액) AS 총국내기성액
FROM dataset d
JOIN lstm_prot l ON d.SOLDDATE = l.solddate AND d.PRODNAME = l.prodname
GROUP BY d.SOLDDATE, d.prodname, d.weekday, l.미분양주택현황, l.국내건설수주액, l.국내기성액
ORDER BY d.SOLDDATE, d.prodname;

select distinct prodname from dataset order by PRODNAME;

drop table lstm_prot2;
create table lstm_prot2 as
select 
	d.SOLDDATE, 
	CASE WHEN d.prodname = 'AE' THEN 1 ELSE 0 END AS AE,
    CASE WHEN d.prodname = 'CSA4000' THEN 1 ELSE 0 END AS CSA4000,
    CASE WHEN d.prodname = 'CSA4000(PCA)' THEN 1 ELSE 0 END AS CSA4000_PCA,
    CASE WHEN d.prodname = 'CSA5000' THEN 1 ELSE 0 END AS CSA5000,
    CASE WHEN d.prodname = 'PEMA-500FR' THEN 1 ELSE 0 END AS PEMA_500FR,
    CASE WHEN d.prodname = 'PEMA-580FX' THEN 1 ELSE 0 END AS PEMA_580FX,
    CASE WHEN d.prodname = 'PEMA-CR1000' THEN 1 ELSE 0 END AS PEMA_CR1000,
    CASE WHEN d.prodname = 'PEMA-CSA5000' THEN 1 ELSE 0 END AS PEMA_CSA5000,
    CASE WHEN d.prodname = 'PEMA-HR1000' THEN 1 ELSE 0 END AS PEMA_HR1000,
    CASE WHEN d.prodname = 'PEMA-HR1000S' THEN 1 ELSE 0 END AS PEMA_HR1000S,
    CASE WHEN d.prodname = 'PEMA-HR1500' THEN 1 ELSE 0 END AS PEMA_HR1500,
    CASE WHEN d.prodname = 'PEMA-PCM2000' THEN 1 ELSE 0 END AS PEMA_PCM2000,
    CASE WHEN d.prodname = 'PEMA-PCM2000B' THEN 1 ELSE 0 END AS PEMA_PCM2000B,
    CASE WHEN d.prodname = 'PEMA-PCR3000E' THEN 1 ELSE 0 END AS PEMA_PCR3000E,
    CASE WHEN d.prodname = 'PEMA-PCR3000N' THEN 1 ELSE 0 END AS PEMA_PCR3000N,
    CASE WHEN d.prodname = 'PEMA-PR1000' THEN 1 ELSE 0 END AS PEMA_PR1000,
    CASE WHEN d.prodname = 'PEMA-PR2000' THEN 1 ELSE 0 END AS PEMA_PR2000,
    CASE WHEN d.prodname = 'PEMA-SN400' THEN 1 ELSE 0 END AS PEMA_SN400,
    CASE WHEN d.prodname = 'PEMA-SP1000' THEN 1 ELSE 0 END AS PEMA_SP1000,
    CASE WHEN d.prodname = 'PEMA-SPR' THEN 1 ELSE 0 END AS PEMA_SPR,
    CASE WHEN d.prodname = 'PEMA-SR2000' THEN 1 ELSE 0 END AS PEMA_SR2000,
    CASE WHEN d.prodname = 'PEMA-SR2000A' THEN 1 ELSE 0 END AS PEMA_SR2000A,
    CASE WHEN d.prodname = 'PEMA-SR3000F' THEN 1 ELSE 0 END AS PEMA_SR3000F,
    CASE WHEN d.prodname = 'PEMA-SR5000F' THEN 1 ELSE 0 END AS PEMA_SR5000F,
    CASE WHEN d.prodname = 'PR1000' THEN 1 ELSE 0 END AS PR1000,
    CASE WHEN d.prodname = 'SRE-110' THEN 1 ELSE 0 END AS SRE_110,
    CASE WHEN d.prodname = 'SRE-200' THEN 1 ELSE 0 END AS SRE_200,
	d.weekday,
	round(avg(d.D_DAY_2_TEM) over (ORDER BY DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY)), 2) as tem_avg, 
	round(avg(d.d_day_2_hum) over (ORDER BY DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY)), 2) as hum_avg,
	sum(d.ORDER_QUANT) as ORDER_QUANT, 
	sum(d.SOLD_QUANT) as SOLD_QUANT,
	l.미분양주택현황,
	l.국내건설수주액,
	l.국내기성액,
	sum(l.국내건설수주액)  as 총국내건설수주액,
	sum(l.국내기성액)  as 총국내기성액,
	DENSE_RANK() OVER (ORDER BY DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY)) as rn,
	DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY) AS week
from dataset d
join lstm_prot l on d.SOLDDATE = l.solddate and d.PRODNAME  = l.prodname
group by d.prodname, l.미분양주택현황, l.국내건설수주액,l.국내기성액, d.weekday, week
order by d.SOLDDATE , d.PRODNAME ;

select * from lstm_prot2;

drop table lstm_prot3;
create table lstm_prot3 as
select 
	DENSE_RANK() OVER (order by substr(d.SOLDDATE, 1, 7)) as rn2,
	DENSE_RANK() OVER (ORDER BY DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY)) as rn,
	DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY) AS week, 
	d.prodname, 
	round(avg(d.D_DAY_2_TEM) over (ORDER BY DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY)), 2) as tem_avg, 
	round(avg(d.d_day_2_hum) over (ORDER BY DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY)), 2) as hum_avg,
	sum(d.ORDER_QUANT) as ORDER_QUANT, 
	sum(d.SOLD_QUANT) as SOLD_QUANT,
	case 
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2018-11' 
		then '60122'  
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2018-12' 
		then '58838'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-01' 
		then '59162'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-02' 
		then '59614'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-03' 
		then '62147'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-04' 
		then '62041'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-05' 
		then '62741'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-06' 
		then '63705'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-07' 
		then '62529'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-08' 
		then '62385'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-09' 
		then '60062'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-10' 
		then '56098'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-11' 
		then '53561'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-12' 
		then '47797'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-01' 
		then '43268'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-02' 
		then '39456'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-03' 
		then '38304'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-04' 
		then '36629'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-05' 
		then '33894'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-06' 
		then '29262'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-07' 
		then '28883'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-08' 
		then '28831'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-09' 
		then '28309'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-10' 
		then '26703'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-11' 
		then '23620'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-12' 
		then '19005'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2021-01' 
		then '17130'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2021-02' 
		then '15786'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2021-03' 
		then '15270'
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2021-04' 
		then '15798'
		else 0
	end as 미분양주택현황,
	case 
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2018-11' 
		then 11924951  
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2018-12' 
		then 21742503
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-01' 
		then 9354316
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-02' 
		then 7769343
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-03' 
		then 16252241
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-04' 
		then 12669551
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-05' 
		then 10025314
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-06' 
		then 11286381
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-07' 
		then 8176838
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-08' 
		then 8400443
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-09' 
		then 14366040
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-10' 
		then 15256861
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-11' 
		then 13752803
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-12' 
		then 26932542
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-01' 
		then 10102160
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-02' 
		then 10780581
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-03' 
		then 12168031
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-04' 
		then 8620626
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-05' 
		then 13766761
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-06' 
		then 20616667
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-07' 
		then 14376152
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-08' 
		then 12679833
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-09' 
		then 15474662
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-10' 
		then 14002749
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-11' 
		then 18059105
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-12' 
		then 29218726
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2021-01' 
		then 12915638
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2021-02' 
		then 12230562
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2021-03' 
		then 16652501
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2021-04' 
		then 17774868
		else 0
	end as 국내건설수주액,
	case 
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2018-11' 
		then 11419899  
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2018-12' 
		then 13836199
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-01' 
		then 10473761
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-02' 
		then 9346282
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-03' 
		then 11885399
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-04' 
		then 11532995
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-05' 
		then 11769196
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-06' 
		then 13290092
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-07' 
		then 11111789
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-08' 
		then 11074985
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-09' 
		then 10846175
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-10' 
		then 11424313
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-11' 
		then 11582021
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2019-12' 
		then 14974433
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-01' 
		then 10089997
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-02' 
		then 10078824
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-03' 
		then 12480302
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-04' 
		then 11349314
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-05' 
		then 11232028
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-06' 
		then 13068203
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-07' 
		then 11049793
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-08' 
		then 10116690
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-09' 
		then 11557750
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-10' 
		then 10589025
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-11' 
		then 11979692
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2020-12' 
		then 14921666
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2021-01' 
		then 9457803
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2021-02' 
		then 9404361
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2021-03' 
		then 12145097
		when substr(DATE_SUB(d.SOLDDATE, INTERVAL (DAYOFWEEK(d.SOLDDATE) + 5) % 7 DAY), 1, 7) = '2021-04' 
		then 11514860
		else 0
	end as 국내기성액
from dataset d
join lstm_prot l on d.SOLDDATE = l.solddate and d.PRODNAME  = l.prodname
group by d.prodname, l.미분양주택현황, l.국내건설수주액,l.국내기성액, week
order by rn2, rn, week , d.PRODNAME ;

select * from lstm_prot3;

select *, sum(order_quant), sum(sold_quant)
from lstm_prot3
group by rn2, rn, prodname
order by rn2, rn, prodname;

select distinct 미분양주택현황, 국내건설수주액, 국내기성액 from lstm;

drop table lstm_prot0;
create table lstm_prot0 as
select 
	DENSE_RANK() OVER (order by substr(SOLDDATE, 1, 7)) as rn2,
	rn, solddate, week, prodname, tem_avg , hum_avg , ORDER_QUANT, SOLD_QUANT,  
	미분양주택현황, 국내건설수주액, 국내기성액
from lstm_prot1
order by rn, SOLDDATE ,rn2, prodname;

select * from lstm_prot0;

select rn2, rn, substr(solddate, 1, 7) as soldmonth, prodname, sum(order_quant) as order_quant2, sum(sold_quant) as sold_quant2
from lstm_prot0
group by substr(solddate, 1, 7), prodname
order by rn, prodname;

select l.rn2, l.rn, substr(l.solddate, 1, 7) as soldmonth, l.week, l.prodname, l.tem_avg , l.hum_avg , l.ORDER_QUANT, l.SOLD_QUANT,
	l2.order_quant2, l2.sold_quant2,
	l.미분양주택현황, l.국내건설수주액, l.국내기성액
from lstm_prot0 l
join (select rn2, rn, substr(solddate, 1, 7) as soldmonth, prodname, 
	sum(order_quant) as order_quant2, sum(sold_quant) as sold_quant2
	from lstm_prot0
	group by rn2, rn, prodname) l2 on l.rn2 = l2.rn2 and l.rn = l2.rn and soldmonth = l2.soldmonth and l.prodname = l2.prodname
group by l.rn2, l.rn, l.prodname 
order by l.rn2, l.rn, l.prodname;