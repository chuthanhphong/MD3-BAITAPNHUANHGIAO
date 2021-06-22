use quanlysinhvien;
/* Hiển thị số lượng sinh viên ở từng nơi */
select address, count(studentid) as 'Số lượng học viên' 
from student group by Address;

/* tính điểm trung bình các môn học của mỗi học viên */
select S.studentid,S.studentname, avg(mark)
from student S join mark M on S.StudentID=M.StudentID
group by S.StudentId, S.StudentName


/* hiển thị những bạn học viên có điểm trung bình các môn  học lớn hơn 15 */
select S.studentID, S.studentname,avg(mark)
from student S join mark M on S.studentID = M.StudentID 
group by S.StudentId,StudentName
having avg(Mark)>15;

/* hiển thị thông tin các học viên có điểm trung bình lớn nhất */
select S.studentID, S.studentname,Avg(mark)
from Student S join Mark M on S.StudentID = M.StudentID
group by S.studentID , S.studentName
having avg(mark) >= All(Select avg(mark) from mark group by mark.StudentID);
