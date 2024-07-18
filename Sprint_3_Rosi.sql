show tables;
show columns from transaction;
# Nivel 1 
# Ejercicio 1
-- Creamos la tabla "credit_card" --
CREATE TABLE IF NOT EXISTS credit_card (
	id varchar(15) NOT NULL PRIMARY KEY,
    iban VARCHAR(50) NOT NULL,
    pan VARCHAR (30) NOT NULL,
    pin INT	NOT NULL,
    cvv INT NOT NULL,
    expiring_date VARCHAR (15) NOT NULL
);
SELECT * FROM credit_card;
show columns from transaction;

-- ModifiCO la tabla 'transaction' para añadir una relación de 1:N con la tabla 'credit_card' --
ALTER TABLE transaction
ADD FOREIGN KEY FK_tarjeta_transaccion(credit_card_id) REFERENCES credit_card(id);

# Ejercicio 2
-- Cambio del registro del usuario con ID CcU-2938 --
UPDATE credit_card SET iban = 'R323456312213576817699999' where id = 'CcU-2938';

-- Mostrar que el cambio se ha realizado --
SELECT ROW_COUNT() INTO @filas_afectadas;

SELECT iban, id FROM credit_card
WHERE id = 'CcU-2938';

# Ejercicio 3
-- Insertamos un nuevo registro en la tabla transaction --
# Primero comprobamos si existen los registros relacionados con una FK en las tablas de dimensiones.
SELECT * FROM credit_card WHERE id = 'CcU-9999';
SELECT id FROM company WHERE id = 'b-9999';

# Como no existen las claves foráneas en las tablas con la relación, 
# debemos insertar primero estos registros en las tablas de dimensiones.
INSERT INTO company (id) VALUES ( 'b-9999' );
UPDATE company SET company_name = 'Unluxe', phone = '34 600 325 017', email = 'unluxe@dmail', country = 'Spain'
WHERE id = 'b-9999'; 
INSERT INTO credit_card (id, iban, pan, pin, cvv, expiring_date) 
VALUES ( 'CcU-9999', 'ES45 4567 8900 1234 4567', '5424465566898765', '5342', '265', '12/29/22');

# Ahora podemos insertar el nuevo registro de transacción.
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined) 
VALUES ( '108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', '111.11', '0');

SELECT * FROM transaction
WHERE company_id = 'b-9999';

 # Ejercicio 4
 -- Eliminar la columna 'pan' de la tabla 'credit_card'
ALTER TABLE credit_card DROP COLUMN pan;
SELECT * FROM credit_card;

# Nivel 2
# Ejercicio 1
# Elimina de la taula transaction 
# el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades.
SELECT * 
FROM transaction 
WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";

DELETE FROM transaction 
WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";

SELECT * 
FROM transaction 
WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";

show indexes from transaction;

# Ejercicio 2
# Crear una vista, llamada VistaMarketing, con los siguientes datos:
# Nombre de la compañía, tlf de contacto, país y media de compras realizadas

CREATE VIEW VistaMarketing AS
SELECT company_name AS nombreCompania, phone AS tlfcontacto, country AS pais, round(AVG(amount),2) AS PromedioCompras
FROM company
JOIN transaction
ON transaction.company_id = company.id
WHERE declined = 0
GROUP BY nombreCompania, tlfcontacto, pais
ORDER BY PromedioCompras DESC;

SELECT * FROM vistamarketing;

# Ejercicio 3
# Filtra la vista VistaMarketing y muestra las compañías que residen en Alemania
SELECT * FROM vistamarketing
WHERE pais = 'Germany';

# Nivel 3
# Ejercicio 1
-- Eliminar la columna "website" de la tabla "company" --
ALTER TABLE company DROP COLUMN website;
SELECT * FROM company;

-- Cambiar los tipos de datos de algunos campos en la tabla "credit_card"
ALTER TABLE credit_card CHANGE pin pin VARCHAR(4) NOT NULL;
ALTER TABLE credit_card CHANGE id id VARCHAR(20) NOT NULL;
ALTER TABLE credit_card CHANGE expiring_date expiring_date VARCHAR(10) NOT NULL;
show columns from credit_card;

-- Crear una nueva columna en la tabla "credit_card" llamada "fecha_actual" de tipo DATE --
ALTER TABLE credit_card ADD fecha_actual DATE;
show columns from credit_card;

-- Comprobar que se han introducido los datos en la tabla "user"
show columns from user; 
SELECT * FROM user;

-- Cambiar el nombre de la tabla "user" por "data_user"
RENAME TABLE user TO data_user;
show tables;

-- Cambiar el nombre de la columna "email" por "personal_email" --
ALTER TABLE data_user CHANGE email personal_email VARCHAR(150);
show columns from data_user;

# Ejercicio 2
-- Crear una vista llamada "InformeTecnico" --

CREATE VIEW InformeTecnico AS
SELECT transaction.id AS IdTransaccion, transaction.amount AS Cantidad, 
data_user.name AS NombreUsuario, data_user.surname AS ApellidoUsuario, 
credit_card.iban AS IBAN, company.company_name AS NombreCompania
FROM company
JOIN transaction
ON transaction.company_id = company.id
JOIN data_user
ON transaction.user_id = data_user.id
JOIN credit_card
ON transaction.credit_card_id = credit_card.id
ORDER BY IdTransaccion DESC;

SELECT * FROM Informetecnico;

show columns from transaction;
