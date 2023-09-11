module main

[table: 'pessoas']
pub struct Pessoa {
	id      string [default: 'gen_random_uuid()'; primary; sql_type: 'uuid']
	nome    string [required; sql_type: 'varchar(100)']
	apelido string [required; sql_type: 'varchar(32)'; unique]
	stack   string [sql_type: 'varchar(1024)']
}
