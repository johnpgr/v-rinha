module main

import database

pub fn (mut app AppContext) create_pessoa(p Pessoa) ! {
	defer {
		app.db.close()
	}
	sql app.db {
		insert p into Pessoa
	} or { return error('Error inserting pessoa. ${err}') }
}

pub fn (mut app AppContext) get_pessoa_by_id(id string) ?Pessoa {
	defer {
		app.db.close()
	}
	pessoas := sql app.db {
		select from Pessoa where id == id
	} or { return none }
	return pessoas[0]
}
