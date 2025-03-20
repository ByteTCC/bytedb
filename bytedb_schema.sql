-- aviso: banco feito para MySQL, não compatível com MariaDB ou SQL Server!
-- copie e cole no PHPMyAdmin e rode o código

CREATE DATABASE IF NOT EXISTS bd_Byte;

USE bd_Byte;

-- mudei "password" pra "password_" com underline já que "password" é palavra reservada
-- adicionei o "isAdmin" pra diferenciar se o usuário é ou não administrador
CREATE TABLE IF NOT EXISTS tb_user (
  idUser INT UNSIGNED not null AUTO_INCREMENT,
  userName varchar(300) NOT NULL,
  email varchar(300) NOT NULL,
  password_ varchar(300) NOT NULL,
  userPhoto varchar(300),
  profileImg varchar(300),
  vocation varchar(300),
  bio varchar (300),
  isAdmin boolean,
  PRIMARY KEY (idUser)
);

CREATE TABLE IF NOT EXISTS post (
  id_post INT UNSIGNED NOT NULL AUTO_INCREMENT,
  postTitle varchar(300) NOT NULL,
  postText varchar(3000) NOT NULL,
  postPhoto varchar(300) NOT NULL,
  postDescription varchar(512) NOT NULL,
  postCode varchar(3000) NOT NULL,
  fk_idUser INT UNSIGNED not null,
  FOREIGN KEY (fk_idUser) REFERENCES tb_user(idUser),
  PRIMARY KEY (id_post)
);

-- essa tabela irá ser as tecnologias que cada post terá, só que em forma de tags, primeiro a tabela de tag representará um id (obrigatório pra todas as tabelas) e depois um post_tag que relaciona os posts com mais de uma tag, assim um post tendo mais de uma tag.

CREATE TABLE IF NOT EXISTS tag (
  id_tag INT UNSIGNED NOT NULL AUTO_INCREMENT,
  tagName varchar (50), 
  -- cada tag terá um nome, por exemplo "Java", "JavaScript", "Python" e etc, cada uma dessas pode ser adicionada ao sistema por um insert, obviamente cada tag terá um id numérico pra representar
  PRIMARY KEY (id_tag)
);

-- relação entre post e tag

CREATE TABLE IF NOT EXISTS post_tag (
 id_post_tag INT UNSIGNED NOT NULL AUTO_INCREMENT,
 fk_tagName INT UNSIGNED NOT NULL,
 fk_id_post INT UNSIGNED NOT NULL,
 PRIMARY KEY (id_post_tag),
 FOREIGN KEY (fk_tagName) REFERENCES tag(id_tag),
 FOREIGN KEY (fk_id_post) REFERENCES post(id_post)
);

-- modificações que fiz na tabela likes:
-- primeiro, eu adicionei o id do usuário que deu o like para a contabilização ser feita como chave estrangeira
-- segundo, eu coloquei o id do post como chave estrangeira
-- terceiro, eu removi o quantLikeComent pois a contabilização é calculada pelo select usando COUNT

CREATE TABLE IF NOT EXISTS likes (
  idLike INT UNSIGNED NOT NULL AUTO_INCREMENT,
  fk_likePost INT UNSIGNED NOT NULL,
  fk_idUser INT UNSIGNED NOT NULL,
--  quantLikeComent INT UNSIGNED NOT NULL, -- esse campo foi removido pois a quantidade de like irá ser calculada no próprio SELECT DO SQL com o COUNT ou semelhante.
  PRIMARY KEY (idLike),
  FOREIGN KEY (fk_likePost) REFERENCES post(id_post),
  FOREIGN KEY (fk_idUser) REFERENCES tb_user(idUser)
);

-- modificações que fiz na tabela comentários:
-- eu coloquei o foreign key de post e usuário, pois cada comentário é feito por um usuário direcionado à um post

CREATE TABLE IF NOT EXISTS comentarios (
  id_comentario INT UNSIGNED NOT NULL AUTO_INCREMENT,
  fk_idUser INT UNSIGNED NOT NULL,
  fk_id_post INT UNSIGNED NOT NULL,
  textComent varchar(3000) NOT NULL,
  imageComent varchar(300) NOT NULL,
  codeComent varchar(3000) NOT NULL,
  PRIMARY KEY (id_comentario),
  FOREIGN KEY (fk_id_post) REFERENCES post(id_post),
  FOREIGN KEY (fk_idUser) REFERENCES tb_user(idUser)
);

-- STORED PROCEDURES para as ações do backend:
-- (os underlines a mais são pra diferenciar o nome das colunas das variáveis dos procedures)

-- criação de usuário
DELIMITER @@
CREATE PROCEDURE sp_CriarUsuario(
  IN username VARCHAR(300),
  IN email_ VARCHAR(300),
  IN password__ VARCHAR(300)
)
BEGIN
  INSERT INTO tb_user (userName, email, password_)
  VALUES (username, email_, password__);
END @@
DELIMITER ;
-- exemplo
-- CALL sp_CriarUsuario('João', 'joao@email.com', '12345678');

-- adicionar/mudar foto de PERFIL de usuário já existente:
DELIMITER @@
CREATE PROCEDURE sp_mudarFotoPerfil(
  IN id INT UNSIGNED,
  IN foto_perfil VARCHAR(300)
)
BEGIN
  UPDATE tb_user
  SET profileImg = foto_perfil
  WHERE idUser = id;
END @@
DELIMITER ;

-- adicionar foto de usuário já existente:
DELIMITER @@
CREATE PROCEDURE sp_mudarFotoUsuario(
  IN id INT UNSIGNED,
  IN userPhoto_ VARCHAR(300)
)
BEGIN
  UPDATE tb_user
  SET userPhoto = userPhoto_
  WHERE idUser = id;
END @@
DELIMITER ;

-- adicionar bio de usuário já existente:
DELIMITER @@
CREATE PROCEDURE sp_mudarBio(
  IN id INT UNSIGNED,
  IN bio_ VARCHAR(300)
)
BEGIN
  UPDATE tb_user
  SET bio = bio_
  WHERE idUser = id;
END @@
DELIMITER ;

-- criar posts:
DELIMITER @@
CREATE PROCEDURE sp_adicionarPost(
  IN title VARCHAR(300),
  IN text_ VARCHAR(3000),
  IN photo VARCHAR(300),
  IN description_ VARCHAR(500),
  IN code VARCHAR(3000),
  IN idUser INT UNSIGNED
)
BEGIN
  INSERT INTO post (postTitle, postText, postPhoto, postDescription, postCode, fk_idUser)
  VALUES (title, text_, photo, description_, code, idUser);
END @@
DELIMITER ;

-- adicionar tags aos posts:
DELIMITER @@
CREATE PROCEDURE sp_adicionarTagsPost(
  IN idPost INT UNSIGNED,
  IN idTag INT UNSIGNED
)
BEGIN
  INSERT INTO post_tag (fk_post_tag, fk_tagName)
  VALUES (idPost, idTag);
END @@
DELIMITER ;

-- adicionar as tags na tabela de tags:
DELIMITER @@
CREATE PROCEDURE sp_adicionarTags(
  IN tag_name varchar (50)
)
BEGIN
  INSERT INTO tag (tagName)
  VALUES (tag_name);
END @@
DELIMITER ;

-- dar like nos posts:
DELIMITER @@
CREATE PROCEDURE sp_darLike(
  IN idPost INT UNSIGNED,
  IN idUser INT UNSIGNED
)
BEGIN
  INSERT INTO likes (fk_likePost, fk_idUser)
  VALUES (idPost, idUser);
END @@
DELIMITER ;

-- remover o like dos posts:
DELIMITER @@
CREATE PROCEDURE sp_removerLike(
  IN idPost INT UNSIGNED,
  IN idUser INT UNSIGNED
)
BEGIN
  DELETE FROM likes
  WHERE fk_likePost = idPost AND fk_idUser = idUser;
END @@
DELIMITER ;

-- remover post (função para o usuário remover seu próprio post):
DELIMITER @@
CREATE PROCEDURE sp_removerPostUser(
  IN idPost INT UNSIGNED,
  IN idUser INT UNSIGNED
)
BEGIN
  DELETE FROM post
  WHERE id_post = idPost AND fk_idUser = idUser;
END @@
DELIMITER ;

-- remover post (funçao pra admin que pode remover qualquer post):
DELIMITER @@
CREATE PROCEDURE sp_removerPostAdmin(
  IN idPost INT UNSIGNED,
  IN idAdmin INT UNSIGNED
)
BEGIN
  -- remove APENAS SE isAdmin foi verdadeiro:
  IF (SELECT isAdmin FROM tb_user WHERE idUser = idAdmin) = TRUE THEN
    DELETE FROM post
    WHERE id_post = idPost;
  END IF;
END @@
DELIMITER ;

-- remover comentário (função para o usuário remover seu próprio comentário):
DELIMITER @@
CREATE PROCEDURE sp_removerComentarioUser(
  IN idComentario INT UNSIGNED,
  IN idUser INT UNSIGNED
)
BEGIN
  DELETE FROM comentarios
  WHERE id_comentario = idComentario AND fk_idUser = idUser;
END @@
DELIMITER ;

-- remover comentário  (funçao pra admin que pode remover qualquer comentário):
DELIMITER @@
CREATE PROCEDURE sp_removerComentarioAdmin(
  IN idComentario INT UNSIGNED,
  IN idUser INT UNSIGNED
)
BEGIN
  -- remove APENAS SE isAdmin foi verdadeiro:
    IF (SELECT isAdmin FROM tb_user WHERE idUser = idUser) = TRUE THEN
    DELETE FROM comentarios
    WHERE id_comentario = idComentario;
  END IF;
END @@
DELIMITER ;

-- editar post:
DELIMITER @@
CREATE PROCEDURE sp_editarPost(
  IN idPost INT UNSIGNED,
  IN title VARCHAR(300),
  IN text_ VARCHAR(300),
  IN photo VARCHAR(300),
  IN description_ VARCHAR(300),
  IN code VARCHAR(300),
  IN idUser INT UNSIGNED
)
BEGIN
  UPDATE post
  SET postTitle = title, postText = text_, postPhoto = photo, postDescription = description_, postCode = code
  WHERE id_post = idPost AND fk_idUser = idUser;
END @@
DELIMITER ;

-- editar comentário:
DELIMITER @@
CREATE PROCEDURE sp_editarComentario(
  IN idComentario INT UNSIGNED,
  IN text_ VARCHAR(300),
  IN photo VARCHAR(300),
  IN code VARCHAR(300),
  IN idUser INT UNSIGNED
)
BEGIN
  UPDATE comentarios
  SET textComent = text_, imageComent = photo, codeComent = code
  WHERE id_comentario = idComentario AND fk_idUser = idUser;
END @@
DELIMITER ;

-- mostrar numeros de likes de post:
DELIMITER @@
CREATE PROCEDURE sp_mostrarLikesPost(
  IN idPost INT UNSIGNED
)
BEGIN
  SELECT COUNT(*) AS quantLikes
  FROM likes
  WHERE fk_likePost = idPost;
END @@
DELIMITER ;

-- listar posts COM TAGS de acordo com pesquisa de titulo, descrição ou código:
DELIMITER @@
CREATE PROCEDURE sp_listarPostsPorPesquisa(
  IN pesquisa VARCHAR(300)
)
BEGIN
  SELECT * FROM post
  WHERE postTitle LIKE CONCAT('%', pesquisa, '%') OR postDescription LIKE CONCAT('%', pesquisa, '%') OR postCode LIKE CONCAT('%', pesquisa, '%')
  ORDER BY id_post;
END @@
DELIMITER ;

-- listar posts com varias tags e retornar as tags em uma unica coluna com JSON:
-- além disso também será retornado o usuário com id, nome e foto
-- e os primeiros 100 digitos do post
-- IMPORTANTE: essa parte eu fiz com IA porque ficou muito complexo pra mim
-- exemplo de uso:
-- CALL ListarPostsPorTagsConcat("'Python','JavaScript'");
DELIMITER @@
CREATE PROCEDURE sp_ListarPostsPorTags(IN tags VARCHAR(255))
BEGIN
    DECLARE sql_query TEXT;
    
    SET sql_query = 'SELECT 
         p.postTitle AS titulo, 
         SUBSTRING(p.postText, 1, 100) AS resumo, 
         u.userName AS nome_usuario, 
         u.idUser AS id_usuario, 
         u.userPhoto AS foto_usuario, 
         p.postPhoto AS foto_post, 
         JSON_ARRAYAGG(t.tagName) AS tags
    FROM post p
    JOIN tb_user u ON p.fk_idUser = u.idUser
    JOIN post_tag pt ON p.id_post = pt.fk_id_post
    JOIN tag t ON pt.fk_tagName = t.id_tag
    WHERE t.tagName IN (';
    
    SET sql_query = CONCAT(sql_query, tags, ') GROUP BY p.id_post');
    
    PREPARE stmt FROM sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END @@
DELIMITER ;

-- listar post com tags, porém considerando o conteudo textual delas:
-- IMPORTANTE: essa parte eu fiz com IA porque ficou muito complexo pra mim
-- exemplo de uso:
-- CALL ListarPostsPorTagsOuConteudoConcat("'Python','JavaScript'", "programação");
DELIMITER @@
CREATE PROCEDURE sp_ListarPostsPorTagsEConteudo(
    IN tags VARCHAR(255),
    IN searchTerm VARCHAR(255)
)
BEGIN
    DECLARE sql_query TEXT;
    
    SET sql_query = 'SELECT 
         p.postTitle AS titulo, 
         SUBSTRING(p.postText, 1, 100) AS resumo, 
         u.userName AS nome_usuario, 
         u.idUser AS id_usuario, 
         u.userPhoto AS foto_usuario, 
         p.postPhoto AS foto_post, 
         JSON_ARRAYAGG(t.tagName) AS tags
    FROM post p
    JOIN tb_user u ON p.fk_idUser = u.idUser
    JOIN post_tag pt ON p.id_post = pt.fk_id_post
    JOIN tag t ON pt.fk_tagName = t.id_tag
    WHERE (t.tagName IN (';
    
    SET sql_query = CONCAT(sql_query, tags, ') OR (p.postTitle LIKE ''%', searchTerm, '%'' OR p.postText LIKE ''%', searchTerm, '%'')) GROUP BY p.id_post');
    
    PREPARE stmt FROM sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END @@
DELIMITER ;



-- listar usuários:
DELIMITER @@
CREATE PROCEDURE sp_listarUsuarios()
BEGIN
  SELECT * FROM tb_user ORDER BY idUser;
END @@
DELIMITER ;

-- listar usuários porém com um numero X de limite de usuários a serem listados:
DELIMITER @@
CREATE PROCEDURE sp_listarUsuariosLimit(IN limit_ INT UNSIGNED)
BEGIN
  SELECT * FROM tb_user ORDER BY idUser LIMIT limit_;
END @@
DELIMITER ;

-- listar usuários conforme o username deles:
DELIMITER @@
CREATE PROCEDURE sp_listarUsuariosPorNome(IN nome VARCHAR(300))
BEGIN
  SELECT * FROM tb_user WHERE userName LIKE CONCAT(nome, '%');
END @@
DELIMITER ;

-- remover usuário, seus posts, seus comentários e seus likes (apenas admins podem):
DELIMITER @@
CREATE PROCEDURE sp_removerUsuario(
  IN idUserRemover INT UNSIGNED,
  IN idUserAdmin INT UNSIGNED
)
BEGIN
  IF (SELECT isAdmin FROM tb_user WHERE idUser = idUserAdmin) = TRUE THEN
    -- deletar os likes:
    DELETE FROM likes
    WHERE fk_idUser = idUserRemover;

    -- deletar os posts
    DELETE FROM post
    WHERE fk_idUser = idUserRemover;

    -- deletar os comentários:
    DELETE FROM comentarios
    WHERE fk_idUser = idUserRemover;

    -- por fim deletar o usuário
    DELETE FROM tb_user
    WHERE idUser = idUserRemover;
    
  END IF;
END @@
DELIMITER ;

-- remover permissão de admin de usuário:
DELIMITER @@
CREATE PROCEDURE sp_removerPermissaoAdmin(
  IN idUser INT UNSIGNED
)
BEGIN
  UPDATE tb_user
  SET isAdmin = FALSE
  WHERE idUser = idUser;
END @@
DELIMITER ;

-- dar permissão de admin de usuário:
DELIMITER @@
CREATE PROCEDURE sp_darPermissaoAdmin(
  IN idUser INT UNSIGNED
)
BEGIN
  UPDATE tb_user
  SET isAdmin = TRUE
  WHERE idUser = idUser;
END @@
DELIMITER ;

-- verificar se usuário é admin, se sim retornar TRUE, senão retornar FALSE:
DELIMITER @@
CREATE PROCEDURE sp_verificarAdmin(
  IN idUser INT UNSIGNED
)
BEGIN
  SELECT isAdmin FROM tb_user WHERE idUser = idUser;
END @@
DELIMITER ;

-- retornar lista de tags com id e nome da tag:
DELIMITER @@
CREATE PROCEDURE sp_listarTags()
BEGIN
  SELECT id_tag, tag_name FROM tag;
END @@
DELIMITER ;

-- ter acesso ao id de um usuário com base em seu username:
DELIMITER @@
CREATE PROCEDURE sp_obterIdUsuarioPorNome(IN nome VARCHAR(300))
BEGIN
  SELECT idUser FROM tb_user WHERE userName = nome;
END @@
DELIMITER ;

-- retornar um post com base em seu id, retorando o id do usuário que postou, o username, a foto do usuário, a foto do post, o titulo, o texto, a descrição, o código, o número de likes e o número de comentários:
DELIMITER @@
CREATE PROCEDURE sp_obterPostPorId(IN idPost INT UNSIGNED)
BEGIN
  SELECT
    p.id_post AS id_post,
    p.postTitle AS postTitle,
    p.postText AS postText,
    p.postPhoto AS postPhoto,
    p.postDescription AS postDescription,
    p.postCode AS postCode,
    u.idUser AS idUser,
    u.userName AS userName,
    u.userPhoto AS userPhoto,
    (SELECT COUNT(*) FROM likes WHERE fk_likePost = p.id_post) AS quantLikes,
    (SELECT COUNT(*) FROM comentarios WHERE fk_id_post = p.id_post) AS quantComentarios
  FROM post p
  JOIN tb_user u ON p.fk_idUser = u.idUser
  WHERE p.id_post = idPost;
END @@
DELIMITER ;

-- retornar comentários de um post com base em seu id:
DELIMITER @@
CREATE PROCEDURE sp_obterComentariosPorIdPost(IN idPost INT UNSIGNED)
BEGIN
  SELECT
    c.id_comentario AS id_comentario,
    c.textComent AS textComent,
    c.imageComent AS imageComent,
    c.codeComent AS codeComent,
    u.idUser AS idUser,
    u.userName AS userName,
    u.userPhoto AS userPhoto
  FROM comentarios c
  JOIN tb_user u ON c.fk_idUser = u.idUser
  WHERE c.fk_id_post = idPost;
END @@
DELIMITER ;

-- obter quantidade limitada de comentários de um post com base em seu id:
DELIMITER @@
CREATE PROCEDURE sp_obterComentariosPorIdPostLimit(IN idPost INT UNSIGNED, IN limit_ INT UNSIGNED)
BEGIN
  SELECT
    c.id_comentario AS id_comentario,
    c.textComent AS textComent,
    c.imageComent AS imageComent,
    c.codeComent AS codeComent,
    u.idUser AS idUser,
    u.userName AS userName,
    u.userPhoto AS userPhoto
  FROM comentarios c
  JOIN tb_user u ON c.fk_idUser = u.idUser
  WHERE c.fk_id_post = idPost
  LIMIT limit_;
END @@
DELIMITER ;

-- procedure para a inserção de dados para testar o banco de dados, testar TODAS as procedures, adicionando usuários de teste, posts de teste, likes, comentários, permissão admin em alguns usuários, etc:
DELIMITER @@
CREATE PROCEDURE sp_testarBanco()
BEGIN
  -- adicionar usuários:
  CALL sp_CriarUsuario('joao', 'joao@email.com', '12345678');
  CALL sp_CriarUsuario('pedro', 'pedro@email.com', '12345678');
  CALL sp_CriarUsuario('paulo', 'paulo@email.com', '12345678');
  CALL sp_CriarUsuario('Maria', 'maria@email.com', '12345678');
  CALL sp_CriarUsuario('Ana', 'ana@email.com', '12345678');

  -- adicionar permição de admin a alguns usuários:
  CALL sp_darPermissaoAdmin((SELECT idUser FROM tb_user WHERE userName = 'joao'));
  CALL sp_darPermissaoAdmin((SELECT idUser FROM tb_user WHERE userName = 'pedro'));

  -- adicionar posts:
  CALL sp_adicionarPost(
    'Introdução ao JavaScript', 
    'JavaScript é uma das linguagens de programação mais populares para o desenvolvimento web. Com ela, é possível criar sites Interativos e dinâmicos, além de ser amplamente utilizado tanto no front-end quanto no back-end com Node.js. Sua flexibilidade e compatibilidade com diferentes navegadores tornam-na indispensável no desenvolvimento moderno.',
    'javascript.png',
    'Este post apresenta uma Introdução ao JavaScript, destacando sua importância no desenvolvimento de sites e aplicativos web Interativos.',
    'console.log("Hello, JavaScript!");',
    (SELECT idUser FROM tb_user WHERE userName = 'joao')
  );
  CALL sp_adicionarPost(
    'Java: A Linguagem de Programação Clássica', 
    'Java é uma das linguagens de programação mais utilizadas no mundo, conhecida por sua robustez e portabilidade. Utilizada principalmente em sistemas corporativos, aplicações móveis (Android) e sistemas em grande escala, ela é uma escolha sólida para desenvolvedores que buscam criar soluções de alto desempenho.',
    'java.png',
    'Este post explora a linguagem Java, seus principais usos e as razões pelas quais ela permanece uma das mais populares no desenvolvimento de software.',
    'public class Main {
      public static void main(String[] args) {
          System.out.prINT UNSIGNEDln("Hello, Java!");
      }
    }',
    (SELECT idUser FROM tb_user WHERE userName = 'joao')
  );

  CALL sp_adicionarPost(
    'Java: Orientação a Objetos', 
    'A programação orientada a objetos (OOP) é um dos pilares do Java. Conceitos como classes, objetos, herança e polimorfismo são fundamentais para criar aplicações eficientes e de fácil manutenção. Java utiliza esses conceitos para estruturar código de forma modular e reutilizável.',
    'java_oop.png',
    'Este post explora o conceito de orientação a objetos em Java e como ele pode ser usado para criar código mais modular e reutilizável.',
    'class Car {
      String model;
      public Car(String model) {
          this.model = model;
      }
    }',
    (SELECT idUser FROM tb_user WHERE userName = 'maria')
  );

  CALL sp_adicionarPost(
    'Frameworks Java: Spring e Hibernate', 
    'Java é conhecido por suas poderosas ferramentas e frameworks. O Spring Framework facilita o desenvolvimento de aplicações empresariais, enquanto o Hibernate é usado para simplificar o mapeamento objeto-relacional. Juntos, eles permitem que desenvolvedores criem soluções escaláveis e de alto desempenho.',
    'java_spring_hibernate.png',
    'Este post aborda os frameworks Java mais populares, Spring e Hibernate, e como eles ajudam a simplificar o desenvolvimento de aplicações corporativas.',
    'public class Application {
      public static void main(String[] args) {
          @@ Exemplo de uso do Spring Boot
      }
    }',
    (SELECT idUser FROM tb_user WHERE userName = 'maria')
  );

  CALL sp_adicionarPost(
    'TypeScript: A Evolução do JavaScript', 
    'TypeScript é um superconjunto de JavaScript que adiciona tipagem estática à linguagem, permitindo que o desenvolvedor escreva código mais seguro e com menos erros. Ideal para projetos grandes, TypeScript oferece melhor escalabilidade e manutenção em comparação com JavaScript.',
    'typescript.png',
    'Este post explora as vantagens do TypeScript sobre JavaScript e como ele pode melhorar a segurança e a escalabilidade do código.',
    'let message: string = "Hello, TypeScript!";',
    (SELECT idUser FROM tb_user WHERE userName = 'pedro')
  );
  CALL sp_adicionarPost(
    'Combinando TypeScript com React', 
    'O uso de TypeScript com React é uma prática recomendada para garantir que os componentes sejam tipados corretamente, facilitando a manutenção do código e a detecção de erros em tempo de desenvolvimento. Com TypeScript, é possível criar INT UNSIGNEDerfaces e tipos para as props e states dos componentes React.',
    'typescript_react.png',
    'Este post mostra como usar TypeScript com React para criar componentes mais seguros e robustos.',
    'import React, { useState } from "react"; 
    const MyComponent: React.FC = () => {
        const [message, setMessage] = useState<string>("Hello, React with TypeScript!");
        return <div>{message}</div>;
    }',
    (SELECT idUser FROM tb_user WHERE userName = 'ana')
  );
  CALL sp_adicionarPost(
    'Mercado de Trabalho para Programadores', 
    'O mercado de trabalho para programadores está em constante crescimento, com uma alta demanda por profissionais qualificados. As habilidades em linguagens como Python, Java, JavaScript e TypeScript são altamente valorizadas, especialmente com a ascensão de novas tecnologias e a transformação digital das empresas.',
    'mercado_trabalho_programadores.png',
    'Este post discute as tendências do mercado de trabalho para programadores e como as habilidades em tecnologias emergentes estão em alta demanda.',
    'prINT UNSIGNED("O mercado de trabalho está em crescimento para programadores!")',
    (SELECT idUser FROM tb_user WHERE userName = 'paulo')
  );

  CALL sp_adicionarPost(
    'PHP: A Linguagem de Servidores Web', 
    'PHP continua sendo uma das linguagens mais populares para desenvolvimento web. Com uma enorme base de código legado e frameworks poderosos como Laravel, PHP é uma escolha sólida para aplicações web rápidas e escaláveis.',
    'php.png',
    'Este post explora como o PHP continua sendo relevante para o desenvolvimento de sites e aplicações web.',
    '<?php echo "Hello, PHP!"; ?>',
    (SELECT idUser FROM tb_user WHERE userName = 'pedro')
  );

  CALL sp_adicionarPost(
    'PHP e MySQL: A Dupla Dinâmica', 
    'PHP e MySQL formam uma combinação poderosa para o desenvolvimento de aplicações web dinâmicas. Juntos, eles permitem que desenvolvedores criem sites INT UNSIGNEDerativos e conectados a bancos de dados de forma eficiente.',
    'php_mysql.png',
    'Este post explora como combinar PHP e MySQL para criar aplicações web INT UNSIGNEDerativas e com armazenamento de dados eficiente.',
    '$conn = new mysqli("localhost", "username", "password", "database");',
    (SELECT idUser FROM tb_user WHERE userName = 'ana')
  );

  CALL sp_adicionarPost(
    'PHP Frameworks: Laravel e Symfony', 
    'Laravel e Symfony são dois dos frameworks PHP mais populares. Ambos oferecem recursos avançados para desenvolvimento web, como roteamento, segurança e gerenciamento de dependências, facilitando o desenvolvimento de aplicações robustas.',
    'php_frameworks.png',
    'Este post apresenta os principais frameworks PHP, Laravel e Symfony, e como eles ajudam a otimizar o desenvolvimento de aplicações web.',
    'composer create-project --prefer-dist laravel/laravel my-app',
    (SELECT idUser FROM tb_user WHERE userName = 'maria')
  );
  CALL sp_adicionarPost(
    'As Principais Tecnologias para Programadores', 
    'As tecnologias que mais impactam o mercado de trabalho para programadores incluem frameworks como React, Angular, e Vue.js para o front-end, além de ferramentas de DevOps como Docker, Jenkins, e CI/CD. Conhecer essas tecnologias pode abrir portas para ótimas oportunidades.',
    'principais_tecnologias.png',
    'Este post destaca as principais tecnologias que estão em alta no mercado de trabalho para programadores e desenvolvedores.',
    'import React from "react"; // exemplo de uso de tecnologia em alta',
    (SELECT idUser FROM tb_user WHERE userName = 'paulo')
  );

  -- adicionar likes conforme o id do post:
  CALL sp_darLike(1, (SELECT idUser FROM tb_user WHERE userName = 'joao'));
  CALL sp_darLike(1, (SELECT idUser FROM tb_user WHERE userName = 'pedro'));
  CALL sp_darLike(1, (SELECT idUser FROM tb_user WHERE userName = 'paulo'));
  CALL sp_darLike(2, (SELECT idUser FROM tb_user WHERE userName = 'joao'));
  CALL sp_darLike(2, (SELECT idUser FROM tb_user WHERE userName = 'pedro'));
  CALL sp_darLike(2, (SELECT idUser FROM tb_user WHERE userName = 'paulo'));

  -- adicionar tags:
  CALL sp_adicionarTags('Java');
  CALL sp_adicionarPost('JavaScript');
  CALL sp_adicionarTags('React');

  -- adicionar tags ao post:
  CALL sp_adicionarTagPost(1, 2);
  CALL sp_adicionarTagPost(1, 2);
  CALL sp_adicionarTagPost(2, 1);


  -- obter informações do post:
  -- CALL sp_obterPostPorId(1);
  -- CALL sp_obterPostPorId(2);
  -- CALL sp_obterPostPorId(3);
  -- CALL sp_obterPostPorId(4);
  -- CALL sp_obterPostPorId(5);
  -- CALL sp_obterPostPorId(6);
  -- CALL sp_obterPostPorId(7);
  -- CALL sp_obterPostPorId(8);
  -- CALL sp_obterPostPorId(9);
  -- CALL sp_obterPostPorId(10);
  -- CALL sp_obterPostPorId(11);
  -- CALL sp_obterPostPorId(12);

  -- -- obter posts por tags:
  -- CALL sp_obterPostsPorTags('java');
  -- -- obter posts por tags com limite:
  -- CALL sp_obterPostsPorTagsLimit('java', 2);
END @@
DELIMITER ;