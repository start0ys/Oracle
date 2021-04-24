SELECT studno , name, deptno FROM student WHERE grade ='1';

DESC student;

SELECT name, grade,weight,deptno FROM student WHERE weight >=70 or grade = '1';

select studno ,name,weight , deptno from student where deptno != 101;

select studno ,name from stud_heavy
union
select studno ,name from stud_101;


select studno ,name from stud_heavy
union all
select studno ,name from stud_101;

select * from stud_heavy;
select * from stud_101;

select studno ,name from stud_heavy
INTERSECT
select studno ,name from stud_101;


select studno ,name from stud_heavy
MINUS
select studno ,name from stud_101;







