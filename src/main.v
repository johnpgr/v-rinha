module main

import picoev
import pessoas.controllers
import pessoas.services
import db.pg
import os

const (
	port = os.getenv('PORT').int()
)

fn main() {
	// TODO: Make a dependency injection container
	db := pg.connect(
		host: 'localhost'
		port: 5432
		user: 'dev'
		password: 'dev'
		dbname: 'rinha'
	)!

	pessoa_service := &services.PessoaService{
		db: &db
	}

	pessoa_controller := &controllers.PessoaController{
		pessoa_service: pessoa_service
	}

	app := &App{
		pessoas_controller: pessoa_controller
	}

	mut server := picoev.new(
		port: port
		cb: app.callback
	)

	println('Server listening on port: ${port}')
	server.serve()
}
