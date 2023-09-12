module utils

import net.http

pub struct Response {
pub:
	status_code http.Status = http.Status.not_found
	headers     map[string]string
	body        string
}
