module pessoas

fn (mut c PessoasController) pessoas_count() int {
	return sql c.db {
		select count from Pessoa
	} or { return 0 }
}

fn (mut c PessoasController) save_pessoa(pessoa Pessoa) !string {
	res := c.db.exec_param_many('INSERT INTO pessoas(nome, apelido, nascimento, stack) VALUES ($1, $2, $3, $4) RETURNING id',
		[pessoa.nome, pessoa.apelido, pessoa.nascimento, pessoa.stack])!

	return res[0].vals[0]
}

fn (mut c PessoasController) find_pessoa_by_id(id string) ?Pessoa {
	pessoa_list := sql c.db {
		select from Pessoa where id == id limit 1
	} or { []Pessoa{} }

	if pessoa_list.len == 0 {
		return none
	}

	return pessoa_list.first()
}

fn (mut c PessoasController) find_pessoa_by_apelido(_apelido string) ?Pessoa {
	pessoa_list := sql c.db {
		select from Pessoa where apelido == _apelido limit 1
	} or { []Pessoa{} }

	if pessoa_list.len == 0 {
		return none
	}

	return pessoa_list.first()
}

fn (mut c PessoasController) find_pessoas_by_termo(termo string) []Pessoa {
	mut pessoa_list := []Pessoa{}

	res := c.db.exec_param("SELECT * FROM pessoas p WHERE p.search LIKE '%$1%' LIMIT 50",
		termo) or { return pessoa_list }

	for row in res {
		pessoa_list << Pessoa{
			id: row.vals[0]
			nome: row.vals[1]
			apelido: row.vals[2]
			nascimento: row.vals[3]
			stack: row.vals[4]
		}
	}

	return pessoa_list
}
