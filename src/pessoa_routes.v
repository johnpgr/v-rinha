module main

import json
import vweb

['/pessoas'; post]
pub fn (mut app AppContext) handle_create_pessoa() vweb.Result {
	body := json.decode(Pessoa, app.req.data) or {
		app.set_status(400, '')
		return app.text('')
	}
	app.create_pessoa(body) or {
		app.set_status(422, '')
		return app.text('')
	}
	return app.text('')
}

['/pessoas/:id'; get]
pub fn (mut app AppContext) handle_get_pessoa_by_id(id string) vweb.Result {
	res := app.get_pessoa_by_id(id) or { return app.not_found() }
	return app.json(res)
}
