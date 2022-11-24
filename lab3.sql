-- Database: test

-- DROP DATABASE IF EXISTS test;



create table if not exists AspNetUsers
(
    Id                   serial
        constraint PK_AspNetUsers
            primary key ,
    Adress               TEXT    not null,
    UserName             TEXT,
    NormalizedUserName   TEXT,
    Email                TEXT,
    NormalizedEmail      TEXT,
    EmailConfirmed       INTEGER not null,
    PasswordHash         TEXT,
    SecurityStamp        TEXT,
    ConcurrencyStamp     TEXT,
    PhoneNumber          TEXT,
    PhoneNumberConfirmed INTEGER not null,
    TwoFactorEnabled     INTEGER not null,
    LockoutEnd           TEXT,
    LockoutEnabled       INTEGER not null,
    AccessFailedCount    INTEGER not null
);





create table if not exists AspNetRoles
(
    Id               serial
        constraint PK_AspNetRoles
            primary key ,
    Name             TEXT,
    NormalizedName   TEXT,
    ConcurrencyStamp TEXT
);

create table if not exists AspNetUserRoles
(
    UserId INTEGER not null
        constraint FK_AspNetUserRoles_AspNetUsers_UserId
            references AspNetUsers
            on delete cascade,
    RoleId INTEGER not null
        constraint FK_AspNetUserRoles_AspNetRoles_RoleId
            references AspNetRoles
            on delete cascade,
    constraint PK_AspNetUserRoles
        primary key (UserId, RoleId)
);

create table if not exists Orders
(
    Id         serial
        constraint PK_Orders
            primary key ,
    UserId     INTEGER           not null
        constraint FK_Orders_AspNetUsers_UserId
            references AspNetUsers
            on delete cascade,
    OrderState INTEGER default 0 not null
);


create table if not exists Photos
(
    Id       serial
        constraint PK_Photos
            primary key ,
    Url      TEXT    not null,
    PublicId TEXT    not null
);

create table if not exists Topings
(
    Id   serial
        constraint PK_Topings
            primary key,
    Name TEXT    not null
);


create table if not exists Pizzas
(
    Id          serial
        constraint PK_Pizzas
            primary key ,
    Name        TEXT    not null,
    Ingredients TEXT    not null,
    Cost        INTEGER not null,
    Weight      INTEGER not null,
    PhotoId     INTEGER not null
        constraint FK_Pizzas_Photos_PhotoId
            references Photos
            on delete cascade,
    State       INTEGER not null
);

create table if not exists PizzaOrders
(
    Id      serial
        constraint PK_PizzaOrders
            primary key ,
    PizzaId INTEGER           not null
        constraint FK_PizzaOrders_Pizzas_PizzaId
            references Pizzas
            on delete cascade,
    OrderId INTEGER           not null
        constraint FK_PizzaOrders_Orders_OrderId
            references Orders
            on delete cascade,
    State   INTEGER default 0 not null
);



create table if not exists TopingOrders
(
    Id          serial
        constraint PK_TopingOrders
            primary key ,
    TopingId     INTEGER not null
        constraint FK_TopingOrders_Topings_TopingId
            references Topings
            on delete cascade,
    Counter      INTEGER not null,
    PizzaOrderId INTEGER not null
        constraint FK_TopingOrders_PizzaOrders_PizzaOrderId
            references PizzaOrders
            on delete cascade
);
















