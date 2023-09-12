module services

import pessoas.models { Pessoa }
import db.pg

pub struct PessoaService {
	db pg.DB [required]
}

[inline]
pub fn (s PessoaService) pessoas_count() int {
	return sql s.db {
		select count from Pessoa
	} or { return 0 }
}

[inline]
pub fn (s PessoaService) save_pessoa(p Pessoa) ! {
	sql s.db {
		insert p into Pessoa
	} or { return err }
}

[inline]
pub fn (s PessoaService) find_pessoa_by_id(id string) ?Pessoa {
	pessoas := sql s.db {
		select from Pessoa where id == id limit 1
	} or { []Pessoa{} }

	if pessoas.len == 0 {
		return none
	}
	return pessoas.first()
}

[inline]
pub fn (s PessoaService) find_pessoa_by_apelido(apelido string) ?Pessoa {
	pessoas := sql s.db {
		select from Pessoa where apelido == apelido limit 1
	} or { []Pessoa{} }

	if pessoas.len == 0 {
		return none
	}

	return pessoas.first()
}

[inline]
pub fn (s PessoaService) find_pessoas_by_termo(termo string) []Pessoa {
	p := sql s.db {
		select from Pessoa where search like '%${termo}%'
	} or { []Pessoa{} }

	return p
}
