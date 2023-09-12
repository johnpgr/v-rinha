module main

import picohttpparser
import net.http
import net.urllib
import time
import pessoas.controllers
import utils

pub struct App {
	pessoas_controller &controllers.PessoaController [required]
}

[inline]
pub fn (app &App) handler(req picohttpparser.Request) &utils.Response {
	pessoas_path := req.path.starts_with('/pessoas')

	if req.method == 'GET' {
		if req.path == '/pessoas' {
			return &utils.Response{
				status_code: http.Status.bad_request
			}
		}
		if pessoas_path {
			url := urllib.parse(req.path) or { urllib.URL{} }
			if term := url.query().get('t') {
				return app.pessoas_controller.handle_get_pessoa_by_termo(term)
			}

			id := url.path.split('/').last()
			if !id.is_blank() {
				return app.pessoas_controller.handle_get_pessoa_by_id(id)
			}
		}
		if req.path == '/contagem-pessoas' {
			return app.pessoas_controller.handle_contagem_pessoas()
		}
	}

	if req.method == 'POST' && pessoas_path {
		return app.pessoas_controller.handle_create_pessoa(req.body)
	}

	return &utils.Response{}
}

pub fn (app App) callback(_ voidptr, req picohttpparser.Request, mut res picohttpparser.Response) {
	start := time.new_stopwatch()

	response := app.handler(req)

	duration := start.elapsed().milliseconds()
	if duration > 1000 {
		println('request took: ${duration}')
	}

	res.write_string('HTTP/1.1 ${int(response.status_code)} ${response.status_code.str()}\r\n')

	for key, value in response.headers {
		res.header(key, value)
	}

	res.body(response.body)
	res.end()
}
