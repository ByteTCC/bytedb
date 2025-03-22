## Procedures

### Procedures de criação de registros no banco de dados (INSERT):
| Nome da procedure | Descrição | Dados de entrada | Completo/Funcionando? |
| ----------------- | --------- | ---------------- | --------------------- |
| sp_CriarUsuario | Cria um novo usuário | username, email, password_ | Sim |
| sp_adicionarPost | Cria um novo post | titile, text_, photo, description_, code, idUser | Sim |
| sp_adicionarTagsPost | Cria uma tag existente a um post | idPost, idTag | Sim |
| sp_adicionarTags | Cria uma nova tag | tagName | Sim |
| sp_darLike | Cria um novo like | idPost, idUser | Sim |

### Procedures de modificação de registros no banco de dados (UPDATE):
| Nome da procedure | Descrição | Dados de entrada | Completo/Funcionando? |
| ----------------- | --------- | ---------------- | --------------------- |
| sp_mudarFotoPerfil | Modifica a foto de perfil de um usuário (banner) | id, foto_perfil | Sim |
| sp_mudarFotoUsuario | Modifica a foto de perfil de um usuário | id, userPhoto_ | Sim |
| sp_mudarBio | Modifica a bio de um usuário | id, bio_ | Sim |
| sp_editarPost | Edita um post | idPost, title, text_, photo, description_, code, idUser | Sim |
| sp_editarComentario | Edita um comentário | idComentario, text_, photo_, code, idUser | Sim |

### Procedures de consulta de registros no banco de dados (SELECT):
| Nome da procedure | Descrição | Dados de entrada | Completo/Funcionando? |
| ----------------- | --------- | ---------------- | --------------------- |
| sp_mostrarLikesPost | Mostra os likes de um post | idPost | Sim |

### Procedures de exclusão de registros no banco de dados (DELETE):
| Nome da procedure | Descrição | Dados de entrada | Completo/Funcionando? |
| ----------------- | --------- | ---------------- | --------------------- |
| sp_removerLike | Remove um like | idPost, idUser | Sim |
| sp_removerPostUser | Remove um post (usuário apagando posts próprios) | idPost, idUser | Sim |
| sp_removerPostAdmin | Remove um post (admin apagando qualquer post) | idPost, idAdmin | Sim |
| sp_removerComentarioUser | Remove um comentário (usuário apagando comentários próprios) | idComentario, idUser | Sim |
| sp_removerComentarioAdmin | Remove um comentário (admin apagando qualquer comentário) | idComentario, idAdmin | Sim |
