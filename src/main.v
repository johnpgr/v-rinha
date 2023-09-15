module main

import os
import vweb
import pessoas { PessoasController }

const (
	port = if os.getenv('PORT').int() == 0 {
		9999
	} else {
		os.getenv('PORT').int()
	}
)

fn main() {
	pool := vweb.database_pool(handler: create_connection)
	app := &App{
		db_handle: pool
		controllers: [
			vweb.controller('/pessoas', &PessoasController{
				db_handle: pool
			}),
		]
	}

	vweb.run(app, port)
}
