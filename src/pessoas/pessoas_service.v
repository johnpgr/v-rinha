module pessoas

fn (mut c PessoasController) pessoas_count() int {
	return sql c.db {
		select count from Pessoa
	} or { return 0 }
}

fn (mut c PessoasController) save_pessoa(p Pessoa) ! {
	sql c.db {
		insert p into Pessoa
	} or { return err }
}

fn (mut c PessoasController) find_pessoa_by_id(id string) ?Pessoa {
	pessoas := sql c.db {
		select from Pessoa where id == id limit 1
	} or { []Pessoa{} }

	if pessoas.len == 0 {
		return none
	}
	return pessoas.first()
}

fn (mut c PessoasController) find_pessoa_by_apelido(apelido string) ?Pessoa {
	pessoas := sql c.db {
		select from Pessoa where apelido == apelido limit 1
	} or { []Pessoa{} }

	if pessoas.len == 0 {
		return none
	}

	return pessoas.first()
}

fn (mut c PessoasController) find_pessoas_by_termo(termo string) []Pessoa {
	return sql c.db {
		select from Pessoa where search like '%${termo}%'
	} or { return []Pessoa{} }
}
