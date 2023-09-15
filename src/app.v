module main

import vweb
import db.pg

struct App {
	vweb.Context
	vweb.Controller
	db_handle vweb.DatabasePool[pg.DB] [required]
mut:
	db pg.DB
}

