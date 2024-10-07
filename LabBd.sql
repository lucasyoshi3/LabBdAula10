CREATE DATABASE LabBd

CREATE TABLE Curso (
    Codigo INT PRIMARY KEY,
    Nome VARCHAR(100),
    Duracao INT
);

INSERT INTO Curso (Codigo, Nome, Duracao) VALUES
(48, 'Análise e Desenvolvimento de Sistemas', 2880),
(51, 'Logistica', 2880),
(67, 'Polímeros', 2880),
(73, 'Comércio Exterior', 2600),
(94, 'Gestão Empresarial', 2600);

CREATE TABLE Disciplinas (
    Codigo VARCHAR(10) PRIMARY KEY,
    Nome VARCHAR(100),
    Carga_Horaria INT
);

INSERT INTO Disciplinas (Codigo, Nome, Carga_Horaria) VALUES
('ALG001', 'Algoritmos', 80),
('ADM001', 'Administração', 80),
('LHW010', 'Laboratório de Hardware', 40),
('LPO001', 'Pesquisa Operacional', 80),
('FIS003', 'Física I', 80),
('FIS007', 'Físico Química', 80),
('CMX001', 'Comércio Exterior', 80),
('MKT002', 'Fundamentos de Marketing', 80),
('INF001', 'Informática', 40),
('ASI001', 'Sistemas de Informação', 80);

CREATE TABLE Disciplina_Curso (
    Codigo_Disciplina VARCHAR(10),
    Codigo_Curso INT,
    PRIMARY KEY (Codigo_Disciplina, Codigo_Curso),
    FOREIGN KEY (Codigo_Disciplina) REFERENCES Disciplinas(Codigo),
    FOREIGN KEY (Codigo_Curso) REFERENCES Curso(Codigo)
);

INSERT INTO Disciplina_Curso (Codigo_Disciplina, Codigo_Curso) VALUES
('ALG001', 48),
('ADM001', 48),
('ADM001', 51),
('ADM001', 73),
('ADM001', 94),
('LHW010', 48),
('LPO001', 51),
('FIS003', 67),
('FIS007', 67),
('CMX001', 51),
('CMX001', 73),
('MKT002', 51),
('MKT002', 94),
('INF001', 51),
('INF001', 73),
('ASI001', 48),
('ASI001', 94);


CREATE FUNCTION fn_disciplina(@codigo INT)
RETURNS @tabela TABLE(
	Codigo_Disciplina			INT,
	Nome_Disciplina				VARCHAR(100),
	Carga_Horaria_Disciplina	INT,
	Nome_Curso					VARCHAR(100)
)
AS
BEGIN
	DECLARE @nome VARCHAR(100)

	DECLARE @carga INT
	
	DECLARE @nomec VARCHAR(100)

	DECLARE @cod_disc INT
	DECLARE @cod_cur INT
	
	DECLARE c CURSOR FOR SELECT Codigo_Curso, Codigo_Disciplina FROM Disciplina_Curso
	OPEN c
	FETCH NEXT FROM c INTO @cod_cur, @cod_disc 
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		IF (@cod_cur = @codigo)
		BEGIN
			SET @nome = (SELECT Nome FROM Disciplinas AS d
				JOIN Disciplina_Curso AS dc ON dc.Codigo_Disciplina = d.Codigo
				JOIN Curso AS c ON @codigo = dc.Codigo_Curso)

			SET @carga = (SELECT Carga_Horaria FROM Disciplinas AS d 
				JOIN Disciplina_Curso AS dc ON dc.Codigo_Disciplina = d.Codigo
				JOIN Curso AS c ON @codigo = dc.Codigo_Curso
				WHERE c.Codigo = @codigo)

			SET @nomec = (SELECT Nome FROM Curso WHERE Codigo = @codigo)
			
			INSERT INTO @tabela VALUES(@cod_disc,@nome, @carga, @nomec)
		END
		FETCH NEXT FROM c INTO @cod_cur, @cod_disc
	END
	CLOSE c
	DEALLOCATE c
	RETURN
END

SELECT * FROM fn_disciplina(51)