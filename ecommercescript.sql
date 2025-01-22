-- ecomerce
drop database ecommerce;
create database ecommerce;
use ecommerce;
show databases;
show tables;
use information_schema;
desc referential_constraints;
select * from referential_constraints where constraint_schema = 'ecommerce';
-- tabela clientes

create table clients(  idClients INT PRIMARY KEY AUTO_INCREMENT,
						registrationtype ENUM('PJ', 'PF'),
						Physical_Person_idPhysical_Person INT,
						Legal_Entity_idLegal_Entity INT,
  FOREIGN KEY (Physical_Person_idPhysical_Person) REFERENCES Physical_Person(idPhysical_Person),
  FOREIGN KEY (Legal_Entity_idLegal_Entity) REFERENCES Legal_Entity(idLegal_Entity)
);

-- Tabela Pessoa_Fisica
CREATE TABLE Physical_Person
 (
    idPhysical_Person INT AUTO_INCREMENT PRIMARY KEY,
    CompleteName VARCHAR(45) NOT NULL,
    CPF char(11) NOT NULL,
    Address VARCHAR(45),
	Date_of_birth date
);

-- Tabela Pessoa_Juridica
CREATE TABLE Legal_Entity (
    idLegal_Entity INT AUTO_INCREMENT PRIMARY KEY,
    social_reason VARCHAR(45) unique NOT NULL,
    CNPJ int(14) unique ,
    address VARCHAR(45)
);
					
-- Tabela Produto  

CREATE TABLE Product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname varchar(10) not null,
    Category ENUM('Eletronicos','Estetica e beleza','Brinquedos','Alimentos','Moveis') not null,
    availability ENUM('Aguardando entrega','Disponivel','Em falta') NOT NULL,
    assessment float default 0,
	size varchar(10)
    );

-- Tabela Disponibiliza_Produto
CREATE TABLE Makes_Product_Available (
    Supplier_idSupplier INT,
    Product_idProduct INT,
    PRIMARY KEY (Supplier_idSupplier, Product_idProduct),
    FOREIGN KEY (Supplier_idSupplier) REFERENCES Supplier(idSupplier) ON DELETE CASCADE,
    FOREIGN KEY (Product_idProduct) REFERENCES Product(idProduct) ON DELETE CASCADE
);

-- Tabela Estoque
CREATE TABLE stock (
    idstock INT AUTO_INCREMENT PRIMARY KEY,
    stockLocation VARCHAR(45) NOT NULL,
    quantity int default 0
);

-- Tabela Produto_Estoque
CREATE TABLE Product_Stock (
    Product_idProduct INT,
    stock_idstock INT,
    quantity INT NOT NULL,
    PRIMARY KEY (Product_idProduct, stock_idstock),
    FOREIGN KEY (Product_idProduct) REFERENCES Product(idProduct) ON DELETE CASCADE,
    FOREIGN KEY (stock_idstock) REFERENCES stock(idstock) ON DELETE CASCADE
);

-- Tabela Terceiro_Fornecedor
CREATE TABLE Third_Supplier (
    idThird_Supplier INT AUTO_INCREMENT PRIMARY KEY,
    social_reason VARCHAR(45) NOT NULL,
    Locate VARCHAR(45),
    CNPJ char(14) NOT NULL
);

-- Tabela Fornecedores_Terceirizados
CREATE TABLE ThirdPartySuppliers (
    Third_Supplier_idThird_Supplier INT,
    Product_idProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (Third_Supplier_idThird_Supplier, Product_idProduct),
    FOREIGN KEY (Third_Supplier_idThird_Supplier) REFERENCES Third_Supplier(idThird_Supplier) ON DELETE CASCADE,
    FOREIGN KEY (Product_idProduct) REFERENCES Product(idProduct) ON DELETE CASCADE
);


-- Tabela Pedido
CREATE TABLE orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient int,
    OrderStatus enum('Cancelado', 'Confirmado','Em processamento') default 'Em processamento',
    OrderDescription VARCHAR(255),
    sendvalue float default 10,
    paymentCash boolean default false,
    constraint fk_orders_clients foreign key (idOrderClient) references clients(idClients) ON update CASCADE on delete set null);
    
    desc orders;
    
    -- tabela fornecedor
    
create table supplier(
						idSupplier int auto_increment primary key,
                        SocialName varchar(255) not null,
                        CNPJ char(14) not null,
                        contact char(11) not null,
                        constraint unique_supplier unique (CNPJ) 
                        );
                        

-- Tabela Relacao_Produto_Por_Pedido
CREATE TABLE Product_Per_Order_Relationship (
    Order_idOrder INT,
    Product_idProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (Order_idOrder, Product_idProduct),
    FOREIGN KEY (Order_idOrder) REFERENCES Orders(idOrder) ON DELETE CASCADE,
    FOREIGN KEY (Product_idProduct) REFERENCES Product(idProduct) ON DELETE CASCADE
);

-- Tabela Entrega
CREATE TABLE Delivery (
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    Tracking_Code VARCHAR(45),
    Shipping_Date DATE,
	Estimated_Delivery_Date DATE,
    Delivery_Date DATE,
    Orders_idOrder INT,
    Orders_Clients_idClients INT,
    Status ENUM('Pendente', 'Em transporte', 'Entregue') NOT NULL,
    FOREIGN KEY (Orders_idOrder) REFERENCES Orders(idOrder) ON DELETE CASCADE,
    FOREIGN KEY (Orders_Clients_idClients) REFERENCES Clients(idClients) ON DELETE CASCADE
);

-- Tabela Pagamento
CREATE TABLE Payments (
    idPayments INT AUTO_INCREMENT PRIMARY KEY,
    typepayments ENUM('Cartao', 'Boleto', 'Pix') NOT NULL,
    limitAvailable float, 
    Orders_idOrder INT,
    Orders_Clients_idClients INT,
    FOREIGN KEY (Orders_idOrder) REFERENCES Orders(idOrder) ON DELETE CASCADE,
    FOREIGN KEY (Orders_Clients_idClients) REFERENCES Clients(idClients) ON DELETE CASCADE
);

-- Tabela Cartao
CREATE TABLE Card (
    idCard INT AUTO_INCREMENT PRIMARY KEY,
    Card_Validity_Date DATE NOT NULL,
    Card_Type VARCHAR(45) NOT NULL,
    Card_Number VARCHAR(45) NOT NULL,
    Total_Value DECIMAL(10, 2) NOT NULL,
    Payments_idPayments INT,
    FOREIGN KEY (Payments_idPayments) REFERENCES Payments(idPayments) ON DELETE CASCADE
);

-- Tabela Boleto
CREATE TABLE Ticket (
    idTicket INT AUTO_INCREMENT PRIMARY KEY,
    Total_Value DECIMAL(10, 2) NOT NULL,
    Installment INT,
    Due_Date DATE NOT NULL,
    Payments_idPayments INT,
    FOREIGN KEY (Payments_idPayments) REFERENCES Payments(idPayments) ON DELETE CASCADE
);

-- Tabela Pix
CREATE TABLE Pix (
    idPix INT AUTO_INCREMENT PRIMARY KEY,
    Total_Value DECIMAL(10, 2) NOT NULL,
    Key_Pix VARCHAR(45) NOT NULL,
    Payments_idPayments INT,
    FOREIGN KEY (Payments_idPayments) REFERENCES Payments(idPayments) ON DELETE CASCADE
);
