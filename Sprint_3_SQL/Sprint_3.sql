# SPRINT 3

# NIVEL 1

/* Exercici 1:

La teva tasca és dissenyar i crear una taula anomenada "credit_card" 
que emmagatzemi detalls crucials sobre les targetes de crèdit. 
La nova taula ha de ser capaç d'identificar de manera única cada 
targeta i establir una relació adequada amb les altres dues taules 
("transaction" i "company"). Després de crear la taula serà necessari 
que ingressis la informació del document denominat "dades_introduir_credit".
Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.*/


# -------------------Solución:

/* Proceso:
1) Crear estructura de tabla
2) Cargar datos
3) Crear relación con la tabla de hechos*/


USE transactions;
CREATE TABLE credit_card(
	id VARCHAR(10) NOT NULL PRIMARY KEY,
    iban VARCHAR(255) NOT NULL,
    pan VARCHAR(255),
    pin INT,
    cvv SMALLINT,
    expiring_date VARCHAR(255)
    
);

/*Creo una foreing key en la tabla de hechos (transaction) 
con referencia a la primary key (id) de la nueva tabla (credit_card)*/

ALTER TABLE transaction
	ADD FOREIGN KEY fk_ccid(credit_card_id)
	REFERENCES credit_card (id);


/*Permite ver la caracteristicas con las que se creó la tabla,
aquí puedo observar las relaciónes entre tablas (FK y PK)*/

SHOW CREATE TABLE transaction;


#Descripción del diagrama:

/*En la base de datos, se cuenta con una tabla de hechos
'transaction' la cual cuenta con dos dimensiones 
para realizar analisis, 'company' la cual contiene datos 
especificos de cada compañia y la otra dimensión 
'credit_card' la cual contiene todos los datos una tarjeta
de credito. En este sentido creé un relación de 1:n
entre 'transaction' y 'credit_card' debido a que una tarjeta
de credito puede realizar varias transaciones, pero una transacción
pertenece a una tarjeta de credito*/ 





# -------------------Otros aprendizajes:

/*Una practica para la creación de tablas es crear todos los valores en VARCHAR 
proceder a importar la base de datos y posteriomente
ajustar las caracteristicas de cada fila de la tabla a medida que se 
van estudiando los datos, lo anterior  con el objetivo de ganar
velocidad en la ejecución de una tarea.*/

#Algunos comandos para modificar la tabla creada

#Permite cambiar el nombre de una columna
ALTER TABLE credit_card
RENAME COLUMN pam TO pan;

ALTER TABLE credit_card
RENAME COLUMN expiring_data TO expiring_date;

#Permite modificar el tipo de dato que se va a ingresar en un columna
ALTER TABLE credit_card
MODIFY pan VARCHAR(255);

ALTER TABLE credit_card
MODIFY expiring_date VARCHAR(255);

#Permite agregar una nueva columna a la estructura de la tabla

ALTER TABLE credit_card
ADD COLUMN pan VARCHAR(250);


/*Proceso para eliminar una Tabla con una foreing key creada 
(aunque se eliminen los datos, no se puede eliminar la tabla
hasta eliminar la forening key primero)

Error Code: 3730. Cannot drop table 'credit_card' referenced by a foreign key 
constraint 'transaction_ibfk_2' on table 'transaction'.

MySQL te está impidiendo eliminar la tabla 'credit_card' porque
la restricción de clave externa en la tabla 'transaction' 
todavía está haciendo referencia a ella.

Solución:

1) Desactiva la revisión de restricciones de clave externa temporalmente
SET foreign_key_checks = 0;

2) Elimina la restricción de clave externa
ALTER TABLE transaction DROP FOREIGN KEY transaction_ibfk;

3) Elimina la tabla
DROP TABLE credit_card;

4) Vuelve a activar la revisión de restricciones de clave externa
SET foreign_key_checks = 1;*/



/*Cargar data con codigo:

El código de error 1290 en MySQL indica que el servidor MySQL está 
configurado con la opción --secure-file-priv, lo que limita la 
ubicación desde la cual se pueden cargar o exportar archivos.
Esta opción se utiliza por razones de seguridad para prevenir 
accesos no autorizados a archivos en el sistema.

Para resolver este problema, tienes algunas opciones:
Cambiar la configuración de --secure-file-priv: Puedes modificar 
la configuración del servidor MySQL para permitir la ejecución de 
esta declaración. Esto puede requerir cambios en el archivo de 
configuración de MySQL (generalmente my.cnf o my.ini). Sin embargo, 
ten en cuenta que hacer esto puede tener implicaciones de seguridad,
por lo que debes considerar cuidadosamente los riesgos asociados.
Usar una ubicación permitida: Si solo necesitas exportar o importar 
archivos para los cuales la ubicación está permitida por la configuración 
de --secure-file-priv, puedes mover tus archivos a una de esas ubicaciones 
antes de ejecutar la declaración.

Utilizar otras formas de importar o exportar datos: Si no puedes 
cambiar la configuración de --secure-file-priv o mover tus archivos 
a ubicaciones permitidas, podrías considerar otras opciones para importar 
o exportar datos, como utilizar comandos de carga y descarga de datos 
en MySQL o herramientas externas.*/

LOAD DATA
INFILE 'D:/DIEGO/Desktop/BOOTCAMP/ESPECIALIDAD ANALISIS DE DATOS
/MySQL/Tarea S3/Base S3/datos_introducir_credit.sql'
INTO TABLE credit_card
FIELDS TERMINATED BY "," 
ENCLOSED BY "'"
LINES TERMINATED BY ";"
IGNORE 1 ROWS;


/*Exercici 2:

El departament de Recursos Humans ha identificat un error en el 
número de compte de l'usuari amb ID CcU-2938. La informació que 
ha de mostrar-se per a aquest registre és: R323456312213576817699999. 
Recorda mostrar que el canvi es va realitzar.*/

UPDATE credit_card
SET iban = R323456312213576817699999
WHERE id = 'CcU-2938';

SELECT id, iban
FROM credit_card
WHERE id = 'CcU-2938';

/*Exercici 3
En la taula "transaction" ingressa un nou usuari amb la següent informació:

Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
credit_card_id	CcU-9999
company_id	b-9999
user_id	9999
lat	829.999
longitude	-117.999
amount	111.11
declined	0*/

SHOW CREATE TABLE company;

INSERT INTO company (id)
VALUE('b-9999');

SHOW CREATE TABLE credit_card;

ALTER TABLE credit_card
MODIFY iban VARCHAR(255) DEFAULT NULL;

SHOW CREATE TABLE credit_card;

INSERT INTO credit_card(id)
VALUE('CcU-9999');

INSERT INTO transaction ( id, credit_card_id, company_id, 
						user_id, lat, longitude, 
						amount, declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 
		9999, 829.999, -117.999, 111.11, 0);
        
SELECT * 
FROM transaction
WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';
        

/*Exercici 4.

Des de recursos humans et sol·liciten eliminar la columna 
"pan" de la taula credit_*card. Recorda mostrar 
el canvi realitzat.*/


ALTER TABLE credit_card
DROP COLUMN pan;

SELECT * FROM credit_card;
SHOW COLUMNS FROM credit_card;


#Nivel 2

/*Exercici 1
Elimina de la taula transaction el registre amb 
ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades.*/


DELETE FROM transaction
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

SELECT *
FROM transaction
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

/*Exercici 2
La secció de màrqueting desitja tenir accés a informació 
específica per a realitzar anàlisi i estratègies efectives. 
S'ha sol·licitat crear una vista que proporcioni detalls clau 
sobre les companyies i les seves transaccions. Serà necessària 
que creïs una vista anomenada VistaMarketing que contingui 
la següent informació: Nom de la companyia. Telèfon de contacte. 
País de residència. Mitjana de compra realitzat per cada companyia. 
Presenta la vista creada, ordenant les dades 
de major a menor mitjana de compra.*/

/*Será necesario que crees una vista llamada VistaMarketing 
que contenga la siguiente información: Nombre de la compañía. 
Teléfono de contacto. País de residencia. Media de compra realizada 
por cada compañía. Presenta la vista creada, ordenando los datos 
de mayor a menor media de compra.*/


/* Una vez creada una vista puedo eliminiarla 
utilizando la siguiente sentencia 

DROP VIEW VistaMarketing;

o tambien puedo modificarla utilizando la siguiente sentencia
y modificando previamente lo necesito cambiar

ALTER VIEW VistaMarketing AS
SELECT company_name, phone, country, AVG(amount) AVG_Amount
FROM company c
INNER JOIN transaction t
ON c.id = t.company_id
GROUP BY company_name, phone, country
ORDER BY AVG_Amount DESC;*/


CREATE VIEW VistaMarketing AS
SELECT company_name, phone, country, ROUND(AVG(amount),2) AVG_Amount
FROM company c
INNER JOIN transaction t
ON c.id = t.company_id
GROUP BY company_name, phone, country
ORDER BY AVG_Amount DESC;

SELECT *
FROM VistaMarketing;

/*Exercici 3

Filtra la vista VistaMarketing per a mostrar només 
les companyies que tenen el seu país de 
residència en "Germany"*/

SELECT *
FROM VistaMarketing
WHERE country = 'Germany';


#Nivel 3





/*Exercici 2
L'empresa també et sol·licita crear una vista anomenada "InformeTecnico" que contingui la següent informació:

ID de la transacció
Nom de l'usuari/ària
Cognom de l'usuari/ària
IBAN de la targeta de crèdit usada.
Nom de la companyia de la transacció realitzada.


Assegura't d'incloure informació rellevant de totes dues taules i utilitza àlies per a canviar de nom columnes segons sigui necessari.
Mostra els resultats de la vista, ordena els resultats de manera descendent en funció de la variable ID de transaction.*/


CREATE VIEW InformeTecnico AS
SELECT 	transaction.id AS Id_Transaction,
		user.name AS Name_User,
		user.country AS User_Country,
		company.company_name AS Company,
        company.country AS Country_Company,
        company.website AS Web,
        credit_card.iban AS iban,
        transaction.amount AS Amount,
        transaction.declined AS Declined
        
FROM transaction
JOIN user 
ON transaction.user_id = user.id
JOIN credit_card 
ON transaction.credit_card_id = credit_card.id
JOIN company 
ON transaction.company_id = company.id
ORDER BY Id_Transaction DESC;

SELECT * FROM InformeTecnico;


-- ------------------------------------ CORRECCIONES

# NIVEL 1 Ejercicio 1:

# Modifico el tipo de dato para los campos pin y cvv de la tabla credit_card a VARCHAR(255) para que acepte numeros como 007, 008, 009.

USE transactions;

ALTER TABLE credit_card
MODIFY pin VARCHAR(255);

ALTER TABLE credit_card
MODIFY cvv VARCHAR(255);


# Nivel 2 Ejercicio 2: Modifico la VIEW 'VistaMarketing' presentando el promedio 'AVG_Amout' solo con dos decimales

CREATE VIEW VistaMarketing AS
SELECT company_name, phone, country, declined, ROUND(AVG(amount),2) AVG_Amount
FROM company c
INNER JOIN transaction t
ON c.id = t.company_id
GROUP BY company_name, phone, country, declined;

DROP VIEW VistaMarketing;

SELECT *
FROM VistaMarketing
WHERE declined = 0
ORDER BY AVG_Amount DESC;

/*Nivel 3 Ejercicio 1: La próxima semana tendrás una nueva reunión con los gerentes de marketing. 
Un compañero de tu equipo realizó modificaciones en la base de datos, pero no recuerda cómo las realizó. 
Te pide que le ayudes a dejar los comandos ejecutados para obtener el siguiente diagrama:*/

# CORRIJO LA RELACIÓN DE CARDINALIDAD para obtener lo siguiente transaction N - 1 user

-- Elimino la restricción de clave externa existente en tabla user hacia transaction
-- debido a que esto hace que la cardinalidad sea transaction 1- N user

ALTER TABLE user DROP FOREIGN KEY user_ibfk_1;

-- Agrego la FK de transaction N a user 1

ALTER TABLE transaction
	ADD FOREIGN KEY fk_user(user_id)
	REFERENCES user (id); 
    
/* Al intentar agregar la FK en la tabla de hechos para lograr la relación
de cardinalidad me encuentro que el codigo genera el Error Code: 1452. 
Cannot add or update a child row: a foreign key constraint fails 
(`transactions`.`#sql-15d4_44`, CONSTRAINT `transaction_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`))

Este error indica que hay una restricción de clave externa en la tabla transactions, la cual está relacionada 
con la columna user_id, y esta restricción está fallando porque estás tratando de agregar o 
actualizar una fila en la tabla transactions con un valor en la columna user_id que no existe en la tabla user.

Debido a que en el Nivel 1 Ejercicio 3 incluí en la tabla transacción al usuario 9999, se debe incluir
tambien en la tabla user para que existan los mismos datos en la FK y PK que estoy asociando 
por tal motivo procedo a incluir al usuario 9999 en user*/
    

INSERT INTO user (id)
VALUE('9999');

-- Agrego la FK en la tabla de hechos para lograr la cardinalidad espera: transaction N  user 1 

ALTER TABLE transaction
	ADD FOREIGN KEY fk_user(user_id)
	REFERENCES user (id); -- Ejecuto nuevamente el codigo y efectivamente logro generar la 
							-- CONSTRAINT `transaction_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
							-- para lograr la cardinalidad correcta entre transaction - user (N-1) y la verifico 
                            -- graficamente en el EER Diagram.

# APLICO LAS MODIFICACIONES NECESARIAS PARA OBTENER EL MODELO ESPERADO

-- Cambio el nombre de la tabla user por data_user

ALTER TABLE user RENAME TO data_user;  -- Al revisar la estructura de la tabla de hechos transaction con SHOW CREATE TABLE transaction
										-- se puede observar que MySQL hace el cambio del nombre en la restricción de clave foranea automaticamente
                                        -- si se cambia el nombre de la tabla con ALTER TABLE user RENAME TO data_user;
                                        
-- cambio el nombre del campo email por personal_email en la tabla renombrada como data_user


/*  ALTER TABLE nombre_tabla CHANGE nombre_columna_antiguo nombre_columna_nuevo tipo_de_datos;  
codigo para cambiar el nombre a un campo de una tabla*/

ALTER TABLE data_user CHANGE email personal_email VARCHAR(150);

-- en la tabla company eliminar el campo website

/*codigo para eliminar un campo de una tabla
ALTER TABLE nombre_tabla DROP COLUMN nombre_columna;*/

ALTER TABLE company DROP COLUMN website;

-- en la tabla credit_card agregar el campo fecha_actual con tipo de dato DATE

/*codigo para agregar un campo con tipo de dato definido en una tabla
ALTER TABLE nombre_tabla ADD nombre_columna DATE;*/

ALTER TABLE credit_card ADD fecha_actual DATE;


-- En la tabla credit_card Y company modifico el tipo de datos de los siguiente campos

/*
id VARCHAR(20)
iban VARCHAR(50)
pin VARCHAR(4)
cvv INT
expiring_date VARCHAR(10)*

y en la tabla company id VARCHAR(15)*/

ALTER TABLE credit_card
MODIFY id VARCHAR(20);

ALTER TABLE credit_card
MODIFY iban VARCHAR(50);

ALTER TABLE credit_card
MODIFY pin VARCHAR(4);

ALTER TABLE credit_card
MODIFY cvv INT;

ALTER TABLE credit_card
MODIFY expiring_date VARCHAR(10);


/*Modifico company(id): En este caso como id de company es la PK y hace referencia 
a la FK de la talba de hechos se requiere eliminar la restricción existente la tabla de hechos
realizar el cambio del tipo de dato en la dimensión y finalmente agregar la restricción nuevamente */

-- Elimino la restricción de clave foreanea existente 

ALTER TABLE transaction DROP FOREIGN KEY transaction_ibfk_1;

-- Modifico el tipo de dato en la PK de la dimensión company

ALTER TABLE company
MODIFY id VARCHAR(15);

-- Creo nuevamente la restrición de clave foranea

ALTER TABLE transaction 
ADD CONSTRAINT transaction_ibfk_1 
FOREIGN KEY (company_id) REFERENCES company(id);

# Nivel 3 Ejercicio 2:

DROP VIEW InformeTecnico;

CREATE VIEW InformeTecnico AS 
SELECT t.id AS Id_Transaction,
	d_u.name AS Name_User,
    d_u.surname AS Surname_User,
    c_c.iban AS IBAN,
    c.company_name AS Company
FROM transaction t
JOIN data_user d_u ON t.user_id = d_u.id
JOIN credit_card c_c ON t.credit_card_id = c_c.id
JOIN company c ON t.company_id = c.id;

SELECT * 
FROM InformeTecnico
ORDER BY Id_Transaction DESC;
