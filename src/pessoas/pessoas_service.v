module main

fn (mut app App) pessoas_count() int {
	mut db := create_connection()
	defer {
		db.close()
	}

	return sql db {
		select count from Pessoa
	} or { return 0 }
}

fn (mut app App) save_pessoa(p Pessoa) ! {
	mut db := create_connection()
	defer {
		db.close()
	}

	sql db {
		insert p into Pessoa
	} or { return err }
}

fn (mut app App) find_pessoa_by_id(id string) ?Pessoa {
	mut db := create_connection()
	defer {
		db.close()
	}

	pessoas := sql db {
		select from Pessoa where id == id limit 1
	} or { []Pessoa{} }

	if pessoas.len == 0 {
		return none
	}
	return pessoas.first()
}

fn (mut app App) find_pessoa_by_apelido(apelido string) ?Pessoa {
	mut db := create_connection()
	defer {
		db.close()
	}

	pessoas := sql db {
		select from Pessoa where apelido == apelido limit 1
	} or { []Pessoa{} }

	if pessoas.len == 0 {
		return none
	}

	return pessoas.first()
}

fn (mut app App) find_pessoas_by_termo(termo string) []Pessoa {
	mut db := create_connection()
	defer {
		db.close()
	}

	return sql db {
		select from Pessoa where search like '%${termo}%'
	} or { return []Pessoa{} }
}
