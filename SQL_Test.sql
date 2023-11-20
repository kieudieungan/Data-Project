SELECT * FROM d4e46.sale;
/*Câu 1 Lấy thông tin về Mã đơn hàng, mã sản phẩm, mã khách hàng, số lượng sản
phẩm của những dòng dữ liệu thỏa điều kiện Ship Mode là Standard Class*/
select `Order ID`, `Product ID`, `Customer ID`, `Quantity`
from sale
where `Ship Mode` = 'Standard Class'

/*Câu 2 Lấy thông tin về những mã đơn hàng của những dòng dữ liệu thỏa mãn điều
kiện sản phẩm (Product ID) thuộc nhóm category là Office Supplies và có quantity > 3*/
select `Product ID`
from sale
where `Category` = 'Office Supplies' and `Quantity` > 3

/*Câu 3 Thống kê số lượng mã đơn hàng, số lượng các loại sản phẩm (product ID),
tổng doanh thu và tổng lợi nhuận theo từng Category, sắp xếp theo thứ tự giảm dần của
doanh thu */
select Category, count(distinct `Order ID`) as `Total Order`, count(distinct `Product ID`) as `Total Product`, 
				sum(Sales) as Sales, sum(Profit) as Profit
from sale
group by Category
order by Sales DESC

/*Câu 4 Với mỗi loại Ship mode, lấy ra thông tin khách hàng (Customer ID), số lượng
đơn hàng sao cho có số lượng đơn hàng theo hình thức Ship mode đó là nhiều nhất.*/
#lấy ra thông tin khách hàng và tổng đơn hàng của kh đó theo từng ship mode
#lấy ra thông tin số đơn hàng nhiều nhất theo từng Ship mode
#tìm khách hàng có số đơn hàng nhiều nhất theo từng Ship mode

with A as (
select `Ship Mode`, `Customer ID`, count(distinct`Order ID`) as `Total Order`
from sale
group by `Ship Mode`, `Customer ID`
),
B as(
select `Ship Mode`, max(`Total Order`) as `Max Order`
from A
group by `Ship Mode`
)
select B.`Ship Mode`, A.`Customer ID`, `Max Order`
from B join A on B.`Ship Mode` = A.`Ship Mode`
where `Max Order` = `Total Order` 

/*Câu 5 Viết 1 câu query trả về 1 table với điều kiện như sau: với mỗi dòng dữ liệu, thêm
1 column có tên là totalSaleBefore: Tổng số doanh thu của các đơn hàng mà trước đó
customer đó thực hiện (Bao gồm cả đơn hàng hiện tại). Những đơn hàng trước đó chính là
những đơn hàng có Order Date <= Ngày của đơn hàng đang xét*/
#tạo một bảng tạm A tính tổng doanh thu của mỗi đơn hàng của mỗi khách hàng
#kết hợp bảng A và bảng sale,  lấy các dòng dl mà order date của sale >= order date của A và gán giá trị TotalSales của A 
#cho totalSaleBefore của sale

WITH A AS (
  SELECT `Order ID`, `Order Date`, `Customer ID`, sum(Sales) as TotalSales
  FROM sale 
  group by `Order ID`, `Order Date`, `Customer ID`
)
select sale.`Order ID`, sale.`Order Date`, sale.`Customer ID`, sum(sale.Sales) as totalSalesThisOrder, sum(TotalSales) as totalSaleBefore
from sale
join A on sale.`Customer ID` = A.`Customer ID`
where sale.`Order Date` >= A.`Order Date`
group by sale.`Order ID`, sale.`Order Date`, sale.`Customer ID`