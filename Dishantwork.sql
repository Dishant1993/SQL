use orders;

show tables;

/* 7. Write a query to display carton id, (len*width*height) as carton_vol and 
identify the optimum carton (carton with the least volume whose volume is greater than the total 
volume of all items (len * width * height * product_quantity))
for a given order whose order id is 10006, 
Assume all items of an order are packed into one single carton (box). */

    select carton_id, (len*width*height) as carton_vol from carton
    where (len*width*height) >=
    (
      select sum(len*width*height*product_quantity)                 -- sub query is used with an aggregation function to perform math operation
      from order_items oi inner join product p						-- inner join is used to fetch data from multiple tables carton,order_items and product
      on oi.product_id = p.product_id
      where order_id = 10006
    )
    order by carton_vol limit 1;
    
 /*   8. Write a query to display details (customer id,customer fullname,order id,product quantity) of customers who bought more than ten (i.e. total order qty)
    products with credit card or Net banking as the mode of payment per shipped order. (6 ROWS) */
   
   select oc.customer_id,
    concat(oc.customer_fname,' ',oc.customer_lname) as fullname,       -- concat is used to join cust fname and lname into fullname column
		   oh.order_id, sum(oi.product_quantity) as tot_qty
    from online_customer oc inner join order_header oh
    on oc.customer_id = oh.customer_id
    and oh.order_status = 'Shipped'
    inner join order_items oi
    on oh.order_id = oi.order_id
    group by oc.customer_id, fullname, oh.order_id
    having tot_qty > 10;
    
  /* 9. Write a query to display the order_id, customer id 
   and cutomer full name of customers starting with the alphabet "A" 
   along with (product_quantity) as total quantity of products shipped for order ids > 10030. */
   
   select oc.customer_id, oh.order_id,
    concat(oc.customer_fname,' ',oc.customer_lname) as fullname,
    sum(oi.product_quantity) as tot_qty
    from online_customer oc inner join order_header oh on oc.customer_id = oh.customer_id
    and oh.order_status = 'Shipped' inner join order_items oi on oh.order_id = oi.order_id
    where oh.order_id > 10060 group by oc.customer_id, fullname;
    
   /* 10. Write a query to display product class description ,total quantity (sum(product_quantity),
    Total value (product_quantity * product price) and show which class of products have been shipped highest(Quantity)
    to countries outside India other than USA? Also show the total value of those items. */
    
    select product_class_desc, sum(oi.product_quantity_avail) as total_qty,
							   sum(oi.product_quantity*p.product_price) as total_value
    from address a inner join online_customer oc on oc.address_id = a.address_id
				   inner join order_header oh on oc.customer_id = oh.customer_id
                   inner join order_items o on oh.order_id = oi.order_id
                   inner join product p on oi.product_id = p.product_id
                   inner join product_class pc on p.product_class_code = pc.product_class_code
    where a.country!='India' And a.country!='USA' And order_status ='shipped'
    group by product_class_desc order by total_qty desc limit 1;
    