module controllers

import net.http
import pessoas.services { PessoaService }
import pessoas.models { pessoa_from_json }
import utils { Response }

pub struct PessoaController {
	pessoa_service PessoaService [required]
}

[inline]
pub fn (c PessoaController) handle_create_pessoa(data string) &Response {
	pessoa := pessoa_from_json(data) or {
		return &Response{
			status_code: http.Status.bad_request
		}
	}

	if _ := c.pessoa_service.find_pessoa_by_apelido(pessoa.apelido) {
		return &Response{
			status_code: http.Status.unprocessable_entity
		}
	}

	c.pessoa_service.save_pessoa(pessoa) or {
		return &Response{
			status_code: http.Status.unprocessable_entity
		}
	}

	return &Response{
		status_code: http.Status.created
		headers: {
			'Location': '/pessoas/${pessoa.id}'
		}
	}
}

[inline]
pub fn (c PessoaController) handle_get_pessoa_by_id(id string) &Response {
	pessoa := c.pessoa_service.find_pessoa_by_id(id) or { return &Response{} }

	return &Response{
		status_code: http.Status.ok
		headers: {
			'Content-Type': 'application/json'
		}
		body: pessoa.to_json()
	}
}

[inline]
pub fn (c PessoaController) handle_get_pessoa_by_termo(termo string) &Response {
	if termo.is_blank() {
		return &Response{
			status_code: http.Status.bad_request
		}
	}

	pessoas := c.pessoa_service.find_pessoas_by_termo(termo)

	return &Response{
		status_code: http.Status.ok
		headers: {
			'Content-Type': 'application/json'
		}
		body: pessoas.to_json()
	}
}

[inline]
pub fn (c PessoaController) handle_contagem_pessoas() &Response {
	count := c.pessoa_service.pessoas_count()

	return &Response{
		status_code: http.Status.ok
		body: count.str()
	}
}
