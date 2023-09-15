module main

import vweb

['/pessoas'; post]
fn (mut app App) handle_create_pessoa() vweb.Result {
	pessoa := pessoa_from_json(app.req.data) or {
		app.set_status(400, '')
		return app.text('')
	}

	if _ := app.find_pessoa_by_apelido(pessoa.apelido) {
		app.set_status(422, '')
		return app.text('')
	}

	app.save_pessoa(pessoa) or {
		app.set_status(422, '')
		return app.text('')
	}

	app.add_header('Location', '/pessoas/${pessoa.id}')
	app.set_status(201, '')
	return app.text('')
}

['/pessoas/:id'; get]
fn (mut app App) handle_get_pessoa_by_id(id string) vweb.Result {
	pessoa := app.find_pessoa_by_id(id) or { return app.not_found() }

	return app.json(pessoa)
}

['/pessoas'; get]
fn (mut app App) handle_get_pessoa_by_termo() vweb.Result {
	termo := app.query['t']

	if termo.is_blank() {
		app.set_status(400, '')
		return app.text('')
	}

	pessoas := app.find_pessoas_by_termo(termo)

	return app.json(pessoas)
}

['/contagem-pessoas'; get]
fn (mut app App) handle_contagem_pessoas() vweb.Result {
	count := app.pessoas_count()

	return app.text(count.str())
}
