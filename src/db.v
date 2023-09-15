module main

import db.pg

fn create_connection() pg.DB {
	return pg.connect(
		user: 'dev'
		port: 5432
		host: 'localhost'
		password: 'dev'
		dbname: 'rinha'
	) or { panic('failed to open db connection') }
}
