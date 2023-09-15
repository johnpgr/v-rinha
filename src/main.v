module main

import os
import vweb
import pessoas{ PessoasController }

const (
	port = if os.getenv('PORT').int() == 0 {
		9999
	} else {
		os.getenv('PORT').int()
	}
)

fn main() {
	pool := vweb.database_pool(handler: create_connection, nr_workers: 20)

	vweb.run_at(&App{
		db_handle: pool
		controllers: [
			vweb.controller('/pessoas', &PessoasController{
				db_handle: pool
			})
		]
	},
		nr_workers: 6
		family: .ip
		port: port
		host: '0.0.0.0'
	)!
}
