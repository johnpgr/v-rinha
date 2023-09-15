module pessoas

import vweb
import db.pg

pub struct PessoasController {
	vweb.Context
	db_handle vweb.DatabasePool[pg.DB] [required]
mut:
	db pg.DB
}

['/contagem'; get]
fn (mut c PessoasController) handle_contagem_pessoas() vweb.Result {
	count := c.pessoas_count()

	return c.text(count.str())
}

['/'; post]
fn (mut c PessoasController) handle_create_pessoa() vweb.Result {
	pessoa := pessoa_from_json(c.req.data) or {
		c.set_status(400, '')
		return c.text('')
	}

	if _ := c.find_pessoa_by_apelido(pessoa.apelido) {
		c.set_status(422, '')
		return c.text('')
	}

	c.save_pessoa(pessoa) or {
		c.set_status(422, '')
		return c.text('')
	}

	c.add_header('Location', '/pessoas/${pessoa.id}')
	c.set_status(201, '')
	return c.text('')
}

['/:id'; get]
fn (mut c PessoasController) handle_get_pessoa_by_id(id string) vweb.Result {
	pessoa := c.find_pessoa_by_id(id) or {
		c.set_status(404, '')
		return c.text('')
	}

	return c.json(pessoa)
}

['/'; get]
fn (mut c PessoasController) handle_get_pessoa_by_termo() vweb.Result {
	termo := c.query['t']

	if termo.is_blank() {
		c.set_status(400, '')
		return c.text('')
	}

	pessoas := c.find_pessoas_by_termo(termo)

	return c.json(pessoas)
}
