# bytedb - SQL Scheme for Byte Social Plataform

Banco de dados SQL para a plataforma Byte.

Para MySQL

### Conteúdo

- Arquivo SQL
  - Criação do banco de dados
  - Criação das tabelas
  - Procedures
- Documentação do banco de dados em markdown

### Todo:

- [x] Adicionar tabelas principais
- [x] Adicionar procedures
- [x] Adicionar documentação atualizada de procedures e tabelas

### O que fazer caso o PHPMyAdmin dar um erro ao tentar inserir o SQL?

#### modifique os seguintes valores do php.ini:

```ini
max_input_time = 600
memory_limit = 512M
post_max_size = 512M
```
#### my.ini do /mysql/bin/:
```
max_allowed_packet = 512M
```