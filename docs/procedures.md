## Procedures

### Procedures de criação de registros no banco de dados (INSERT):
| Nome da procedure | Descrição | Dados de entrada |
| ----------------- | --------- | ---------------- |
| sp_CriarUsuario | Cria um novo usuário | username, email, password_ |
| sp_adicionarPost | Cria um novo post | titile, text_, photo, description_, code, idUser |
| sp_adicionarTagsPost | Cria uma tag existente a um post | idPost, idTag |
| sp_adicionarTags | Cria uma nova tag | tagName |
| sp_adicionarLike | Cria um novo like | idPost, idUser |

### Procedures de modificação de registros no banco de dados (UPDATE):
| Nome da procedure | Descrição | Dados de entrada |
| ----------------- | --------- | ---------------- |
| sp_mudarFotoPerfil | Modifica a foto de perfil de um usuário (banner) | id, foto_perfil |
| sp_mudarFotoUsuario | Modifica a foto de perfil de um usuário | id, userPhoto_ |
| sp_mudarBio | Modifica a bio de um usuário | id, bio_ |
|

### Procedures de consulta de registros no banco de dados (SELECT):

### Procedures de exclusão de registros no banco de dados (DELETE):
