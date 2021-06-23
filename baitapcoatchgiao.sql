use demo2006;
-- 6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 19/6/2006 và ngày 20/6/2006.
select * from `order` where time between '2006-06-19' and '2006-06-20';

-- 7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 6/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).

select `order`.time, orderdetail.orderId,sum(product.price*orderdetail.quantity ) as total
from `order`,product,orderdetail
where product.id =orderdetail.productId and  month(time)= 6 and year(time) = 2007
GROUP BY `order`.id
order by  total desc ;

-- 8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 19/06/2007.

select customerId,customer.name,`order`.time from customer,`order`where customer.id = `order`.customerId and `order`.time = '2006-07-19' ;

-- 10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.

select p.id,p.name
from product p, `order` o, orderdetail od, customer c
where p.id=od.productid and o.customerid=c.id and od.orderid=o.id and c.name = 'Nguyễn Văn A' and month(o.time)=10 and year(o.time)=2006;

-- 11. Tìm các số hóa đơn đã mua sản phẩm “Máy giặt” hoặc “Tủ lạnh”.

select o.id,o.time from `order` o,product p,orderdetail od where p.id=od.productid and o.id=od.orderid and p.name in ('Máy giặt','Tủ lạnh');
select o.id,p.name from `order` o join orderdetail od on o.id = od.orderId
join product p on od.productId = p.id
where p.name = 'Máy giặt'
or p.name like 'Tủ lạnh'
;
-- 12. Tìm các số hóa đơn đã mua sản phẩm “Máy giặt” hoặc “Tủ lạnh”, mỗi sản phẩm mua với số lượng từ 10 đến 20.

select o.id,o.time from `order` o,product p,orderdetail od where p.id=od.productid and o.id=od.orderid and p.name in ('Máy giặt','Tủ lạnh') and
                                                                 p.quantity between 10 and 20;;


-- 13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm “Máy giặt” và “Tủ lạnh”, mỗi sản phẩm mua với số lượng từ 10 đến 20.

create view maygiat as
select o.id, p.name, o.time
from demo2006.order o
         join orderdetail od on o.id=od.orderid
         join product p on od.productid=p.id
where p.name like '%Máy giặt%'  and od.quantity between 10 and 20;

create view tulanh as
select o.id, p.name, o.time
from demo2006.order o
         join orderdetail od on o.id=od.orderid
         join product p on od.productid=p.id
where p.name like '%Tủ lạnh%'  and od.quantity between 10 and 20;

select v1.id,v1.time  from maygiat v1 join tulanh v2 on v1.id = v2.id;


-- 15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được.

select product.Id,product.name from product where product.id not in (select productId from orderdetail);
select product.Id,product.name
from product
where id not in (select productId from orderdetail);

-- 16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.

select product.Id,product.name from product
where id not in (SELECT orderdetail.productID from orderdetail,`order`
where orderdetail.productId = product.id
  and year(`order`.time) =2006);


-- 17. In ra danh sách các sản phẩm (MASP,TENSP) có giá >300 sản xuất bán được trong năm 2006.

select product.id,name
from product
where price >300 and product.id in (select od.productId
                            from orderdetail od,`order` o
where o.id=od.orderid and year(o.time)=2006);

-- 18. Tìm số hóa đơn đã mua tất cả các sản phẩm có giá >200.



select orderId
from product,orderdetail
where product.id = orderdetail.productId
group by orderdetail.orderId
having min(product.price) > 200;

-- 19. Tìm số hóa đơn trong năm 2006 đã mua tất cả các sản phẩm có giá <300.


select orderId
from product,orderdetail,`order`
where product.id = orderdetail.productId and YEAR(time)=2006
group by orderdetail.orderId
having max(product.price) < 300;

-- 21. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.

select count(id) as anotherproduct
from product
where id  in (select od.productId from orderdetail od,`order` o where o.id=od.orderid and year(o.time)=2006);


-- 22. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?

create view total as
    select o.id,sum(p.price*od.quantity) as total,o.time
from product p, `order` o, orderdetail od
where p.id = od.productId and o.id = od.orderId
group by o.id;
select max(total),min(total) from total;

-- 23. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?

select avg(total) from total where year(total.time)=2006;

-- 24. Tính doanh thu bán hàng trong năm 2006.

select sum(total) as tongdoanhthu from total where
year(total.time)=2006;

-- 25. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.

select o.id ,Max(total.total) as giatricaonhat from total,`order` o
where year(total.time)=2006;

-- 26. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.


select c.id,c.name
from customer c,`order` o
where o.customerid=c.id
  and o.id =(
    select id from total where total >= all(select total from total where year(time)=2006));
    



-- 27. In ra danh sách 3 khách hàng (MAKH, HOTEN) mua nhiều hàng nhất (tính theo số lượng).

select c.id,c.name,sum(quantity) as tongsohang from customer c join `order` o on c.id = o.customerId
join orderdetail o2 on o.id = o2.orderId where o.id = o2.orderId  group by c.id
order by tongsohang desc limit 3 ;

-- 28. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
-- không biết làm ghi lại đáp án của Coatch;

create view top3p as
select price
from product
group by price order by price desc limit 3;
select * from top3p;
use demo2006;
select *
from product
where price in
      (select * from top3p);
set @top3 =  (SELECT price
              FROM product
              GROUP BY price
              ORDER BY price DESC
              LIMIT 3,1);
set @top1 =  (SELECT price
              FROM product
              GROUP BY price
              ORDER BY price DESC
              LIMIT 1);
select * from product where price <= @top1 and price >= @top3;

-- 29. In ra danh sách các sản phẩm (MASP, TENSP) có tên bắt đầu bằng chữ M, có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).

select * from product where price <=@top1 and price >=@top3 and product.name like 'M%';

-- 32. Tính tổng số sản phẩm giá <300.
-- tổng tất cả các sản phẩm :
select product.price, sum(quantity) as tongsanpham
from product  where price < 300;
-- Tổng từng loại sản phẩm
select count(id) as tongcacloai from product where price <300;

-- 33. Tính tổng số sản phẩm theo từng giá.

-- Tổng tất cả sản phẩm
select product.name, sum(quantity) as tongsanpham
from product group by price;

-- Tổng từng sản phẩm theo giá
select product.price , product.name, count(product.quantity) as tongcacsanpham
from product group by price;

-- 34. Tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm bắt đầu bằng chữ M.

create view sanphamchuM as
    select id,name,price from product where name like 'M%';
select  Max(price) as max , Min(price) as min,avg(price) as avg from sanphamchuM ;

-- 35. Tính doanh thu bán hàng mỗi ngày.
select day(time) as day ,MONTH(time) as mouth,YEAR(time),sum(total) as total from total group by time;

-- 36. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.

select od.productId,sum(od.quantity) as soluongban
from orderdetail od join `order` o on o.id = od.orderId
where month(o.time)=10 and year(o.time) = 2006
group by od.productId;

-- 37. Tính doanh thu bán hàng của từng tháng trong năm 2006.

select MONTH(time) as mounth, year(time) as year ,sum((price*product.quantity)) ,time
from `order`,product ,orderdetail where product.id = orderdetail.productId and
`order`.id = orderdetail.orderId and year(time)=2006 group by MONTH(time);

-- 38. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.

select o.id from `order`o ,orderdetail od
where o.id=od.orderId group by od.orderId
having count(od.productId) >=4;

-- 39. Tìm hóa đơn có mua 3 sản phẩm có giá <300 (3 sản phẩm khác nhau).

select o.id from `order` o,orderdetail od,product p
where o.id = od.orderId and p.price < 300  group by od.orderId
having count(od.productId)>=3;

select od.orderid, count(od.productid)
from orderdetail od
join product p on p.id=od.productid
where p.price<300
group by od.orderid 
having count(od.productid)>=3;

-- 40. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.

create view soluonghoadon as
    select c.id,c.name,count(o.id) as soluong
from customer c,`order` o where c.id = o.customerId
group by c.id;

select id,name from customer where id in
(select id from soluonghoadon where soluong =
                                    (select  max((soluong)) from  soluonghoadon));
-- 41. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất?

select month(total.time) from total where total =
                                          (select min(total) from total);

-- 42. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006

create view Soluongnam2006 as
select Sum(od.quantity) as tongsoluongsanpham,p.id,p.name
from product p join orderdetail od on p.id = od.productId
join `order` o on o.id = od.orderId where YEAR(time)=2006 group by od.productId;
select Soluongnam2006.id,Soluongnam2006.name  from Soluongnam2006
where tongsoluongsanpham = (select min(tongsoluongsanpham) from soluongnam2006);



-- 45. Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.

create view Khachhang as
    select c.name,c.id,COUNT(o.id) as tongsohoadon from customer c,`order` o
where c.id = o.customerId group by o.customerId;

create view DoanhsoKhachhang as
    select c.name,c.id,Sum(od.quantity*p.price) as tongsotien
from customer c join `order` o on c.id = o.customerId
    join orderdetail od on o.id = od.orderId
join product p  on p.id = od.productId group by c.id order by tongsotien desc limit 10;

select id,name,Khachhang.tongsohoadon from Khachhang where tongsohoadon = (select MAX(tongsohoadon) from khachhang);

