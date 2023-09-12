module services

import pessoas.models
import db.pg

pub struct PessoaService {
	db &pg.DB [required]
}

[inline]
pub fn (ps &PessoaService) pessoas_count() int {
	return sql ps.db {
		select count from models.Pessoa
	} or { return 0 }
}

[inline]
pub fn (ps &PessoaService) save_pessoa(p models.Pessoa) ! {
	sql ps.db {
		insert p into models.Pessoa
	} or { return error('Error saving pessoa') }
}

[inline]
pub fn (ps &PessoaService) find_pessoa_by_id(id string) ?models.Pessoa {
	pessoas := sql ps.db {
		select from models.Pessoa where id == id limit 1
	} or { []models.Pessoa{} }

	if pessoas.len == 0 {
		return none
	}
	return pessoas.first()
}

[inline]
pub fn (ps &PessoaService) find_pessoas_by_termo(termo string) []models.Pessoa {
	p := sql ps.db {
		select from models.Pessoa where busca_trgm like '%${termo}%'
	} or { []models.Pessoa{} }

	return p
}
