use ecommerce;

-- 1. **Quantos pedidos foram feitos por cada cliente?**  
   SELECT c.idClients, COUNT(o.idOrder) AS Total_Pedidos
   FROM clients c
   LEFT JOIN orders o ON c.idClients = o.idOrderClient
   GROUP BY c.idClients;


-- 2. **Algum vendedor também é fornecedor?**  
      SELECT s.idSupplier, s.SocialName, ts.idThird_Supplier
   FROM supplier s
   INNER JOIN Third_Supplier ts ON s.CNPJ = ts.CNPJ;
   

-- 3. **Relação de produtos, fornecedores e estoques:**  
      SELECT p.idProduct, p.Pname, s.SocialName, st.stockLocation, ps.quantity AS Stock_Quantity
   FROM Product p
   INNER JOIN Makes_Product_Available mpa ON p.idProduct = mpa.Product_idProduct
   INNER JOIN supplier s ON mpa.Supplier_idSupplier = s.idSupplier
   INNER JOIN Product_Stock ps ON p.idProduct = ps.Product_idProduct
   INNER JOIN stock st ON ps.stock_idstock = st.idstock;
   
   
-- 4. **Relação de nomes dos fornecedores e nomes dos produtos fornecidos:**  
  
   SELECT s.SocialName AS Fornecedor, p.Pname AS Produto
   FROM supplier s
   INNER JOIN Makes_Product_Available mpa ON s.idSupplier = mpa.Supplier_idSupplier
   INNER JOIN Product p ON mpa.Product_idProduct = p.idProduct;
   

-- 5. **Quais produtos estão em falta ou aguardando entrega?**  
   SELECT idProduct, Pname, availability
   FROM Product
   WHERE availability IN ('Em falta', 'Aguardando entrega');
   

-- 6. **Qual o valor total de vendas por cliente?**  
   SELECT c.idClients, SUM(o.sendvalue) AS Total_Vendas
   FROM orders o
   INNER JOIN clients c ON o.idOrderClient = c.idClients
   GROUP BY c.idClients;
   

-- 7. **Pedidos entregues e a data de entrega:**  
   SELECT d.idDelivery, d.Tracking_Code, d.Delivery_Date, o.idOrder, c.idClients
   FROM Delivery d
   INNER JOIN orders o ON d.Orders_idOrder = o.idOrder
   INNER JOIN clients c ON d.Orders_Clients_idClients = c.idClients
   WHERE d.Status = 'Entregue';
   

