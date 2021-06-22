use quanlysinhvien;
/* hiển thị credit cao nhất */
select *, max(credit) from subject;

select *
from subject, mark
where subject.subID = mark.subID
and mark = (select max(mark.mark) from mark);