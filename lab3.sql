-- Database: test

-- DROP DATABASE IF EXISTS test;



create table "AspNetUsers"
(
     "Id"                   serial
        constraint PK_AspNetUsers
            primary key ,
    "Adress"               TEXT    not null,
    "UserName"             TEXT,
    "NormalizedUserName"   TEXT,
    "Email"                TEXT,
    "NormalizedEmail"      TEXT,
    "EmailConfirmed"       BOOL not null,
    "PasswordHash"         TEXT,
    "SecurityStamp"        TEXT,
    "ConcurrencyStamp"     TEXT,
    "PhoneNumber"          TEXT,
    "PhoneNumberConfirmed" BOOL not null,
    "TwoFactorEnabled"     BOOL not null,
    "LockoutEnd"           TEXT,
    "LockoutEnabled"       BOOL not null,
    "AccessFailedCount"    INTEGER not null
);

create index "EmailIndex"
    on "AspNetUsers" ("NormalizedEmail");

create unique index "UserNameIndex"
    on "AspNetUsers" ("NormalizedUserName");




create table if not exists "AspNetRoles"
(
    "Id"               serial
        constraint PK_AspNetRoles
            primary key ,
    "Name"             TEXT,
    "NormalizedName"   TEXT,
    "ConcurrencyStamp" TEXT
);
create unique index "RoleNameIndex"
    on "AspNetRoles" ("NormalizedName");
    
    

create table if not exists "AspNetUserRoles"
(
    "UserId" INTEGER not null
        constraint FK_AspNetUserRoles_AspNetUsers_UserId
            references "AspNetUsers"
            on delete cascade,
    "RoleId" INTEGER not null
        constraint FK_AspNetUserRoles_AspNetRoles_RoleId
            references "AspNetRoles"
            on delete cascade,
    constraint PK_AspNetUserRoles
        primary key ("UserId", "RoleId")
);

create index "IX_AspNetUserRoles_RoleId"
    on "AspNetUserRoles" ("RoleId");

create table if not exists "Orders"
(
    "Id"         serial
        constraint PK_Orders
            primary key ,
    "UserId"     INTEGER           not null
        constraint FK_Orders_AspNetUsers_UserId
            references "AspNetUsers"
            on delete cascade,
    "OrderState" INTEGER default 0 not null
);

create index "IX_Orders_UserId"
    on "Orders" ("UserId");
    
create table if not exists "Photos"
(
    "Id"       serial
        constraint PK_Photos
            primary key ,
    "Url"      TEXT    not null,
    "PublicId" TEXT    not null
);

create table if not exists "Topings"
(
    "Id"   serial
        constraint PK_Topings
            primary key,
    "Name" TEXT    not null
);

create table if not exists "Pizzas"
(
    "Id"          serial
        constraint PK_Pizzas
            primary key ,
    "Name"        TEXT    not null,
    "Ingredients" TEXT    not null,
    "Cost"        INTEGER not null,
    "Weight"      INTEGER not null,
    "PhotoId"     INTEGER not null
        constraint FK_Pizzas_Photos_PhotoId
            references "Photos"
            on delete cascade,
    "State"       INTEGER not null
);

create index "IX_Pizzas_PhotoId"
    on "Pizzas" ("PhotoId");


create table if not exists "PizzaOrders"
(
    "Id"      serial
        constraint PK_PizzaOrders
            primary key ,
    "PizzaId" INTEGER           not null
        constraint FK_PizzaOrders_Pizzas_PizzaId
            references "Pizzas"
            on delete cascade,
    "OrderId" INTEGER           not null
        constraint FK_PizzaOrders_Orders_OrderId
            references "Orders"
            on delete cascade,
    "State"   INTEGER default 0 not null
);

create index "IX_PizzaOrders_OrderId"
    on "PizzaOrders" ("OrderId");

create index "IX_PizzaOrders_PizzaId"
    on "PizzaOrders" ("PizzaId");

create table if not exists "TopingOrders"
(
    "Id"          serial
        constraint PK_TopingOrders
            primary key ,
    "TopingId"     INTEGER not null
        constraint FK_TopingOrders_Topings_TopingId
            references "Topings"
            on delete cascade,
    "Counter"      INTEGER not null,
    "PizzaOrderId" INTEGER not null
        constraint FK_TopingOrders_PizzaOrders_PizzaOrderId
            references "PizzaOrders"
            on delete cascade
);

create index "IX_TopingOrders_PizzaOrderId"
    on "TopingOrders" ("PizzaOrderId");

create index "IX_TopingOrders_TopingId"
    on "TopingOrders" ("TopingId");




create table if not exists "LogsTypes"(
   "Id" serial constraint PK_LogsTypes primary key,
    "Name" TEXT
);

create table if not exists "Logs"(
	"Id" serial primary key,
	"LogTypeId" integer REFERENCES "LogsTypes",
	"Message" TEXT
);

create or replace function insertInfoLog()
    returns trigger
    language plpgsql
    as
   $$
   begin
        insert into "Logs"
        values (DEFAULT, (select logs."Id" from "LogsTypes" as logs where logs."Name" = 'INFO'),new."Id" || TG_ARGV[0] );
    return new;
   end;
   $$
   ;
create or replace trigger userCreated
after insert on "AspNetUsers"
for each row
execute function insertInfoLog(' user was created succesfully');

create or replace trigger orderCreated
after insert on "Orders"
for each row
execute function insertInfoLog(' order was created succesfully');

create or replace trigger pizzaAdded
after insert on "Pizzas"
for each row
execute function insertInfoLog(' pizza was added succesfully');

create or replace trigger topingAdded
after insert on "Topings"
for each row
execute function insertInfoLog(' toping was created succesfully');













