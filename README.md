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

- [*] Adicionar tabelas principais
- [] Adicionar procedures
- [] Converter procedures de Select em [views](https://dev.mysql.com/doc/refman/8.4/en/view-syntax.html)
- [] Adicionar procedure de teste para inserir, apagar e consultar dados.
- [] Adicionar script para teste de banco de dados.

### O que fazer antes de usar?

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