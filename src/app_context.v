module main

import vweb
import db.pg

struct AppContext {
	vweb.Context
mut:
	db pg.DB
}

pub fn (app &AppContext) before_request() {
	println('[Vweb] ${app.req.method} ${app.req.url}')
}
