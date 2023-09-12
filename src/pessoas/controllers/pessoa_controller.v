module controllers

import net.http
import pessoas.services
import pessoas.models
import utils

pub struct PessoaController {
	pessoa_service &services.PessoaService [required]
}

[inline]
pub fn (pc &PessoaController) handle_create_pessoa(data string) &utils.Response {
	pessoa := models.pessoa_from_json(data) or {
		return &utils.Response{
			status_code: http.Status.bad_request
		}
	}

	pc.pessoa_service.save_pessoa(pessoa) or {
		return &utils.Response{
			status_code: http.Status.unprocessable_entity
		}
	}

	return &utils.Response{
		status_code: http.Status.created
		headers: {
			'Location': '/pessoas/${pessoa.id}'
		}
	}
}

[inline]
pub fn (pc &PessoaController) handle_get_pessoa_by_id(id string) &utils.Response {
	pessoa := pc.pessoa_service.find_pessoa_by_id(id) or { return &utils.Response{} }

	return &utils.Response{
		status_code: http.Status.ok
		headers: {
			'Content-Type': 'application/json'
		}
		body: pessoa.to_json()
	}
}

[inline]
pub fn (pc &PessoaController) handle_get_pessoa_by_termo(termo string) &utils.Response {
	if termo.is_blank() {
		return &utils.Response{
			status_code: http.Status.bad_request
		}
	}

	pessoas := pc.pessoa_service.find_pessoas_by_termo(termo)

	return &utils.Response{
		status_code: http.Status.ok
		headers: {
			'Content-Type': 'application/json'
		}
		body: pessoas.to_json()
	}
}

[inline]
pub fn (pc &PessoaController) handle_contagem_pessoas() &utils.Response {
	count := pc.pessoa_service.pessoas_count()

	return &utils.Response{
		status_code: http.Status.ok
		body: count.str()
	}
}
