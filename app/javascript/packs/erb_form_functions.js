const table = document.getElementById('variables')
const form = document.getElementById('scenario_form')
const add_btn = document.getElementById('add_variable')
const attempt_count = document.getElementById('attempt_count')
const initial_variables = get_variables()
const initial_values = get_values()
const warning_message = `Warning! You are changing the variables for a scenario that has past attempts.\r\n
Changing these variables will not affect the scores of these past attempts but it will affect the score for all future attempts.\r\n
If you are aware of this outcome and happy to proceed click OK below.`

function get_variables() {
  return JSON.stringify([...document.getElementsByName('scenario[variables][]')].map(variable => variable.value))
}

function get_values() {
  return JSON.stringify([...document.getElementsByName('scenario[variables][]')].map(variable => variable.value))
}

function add_remove_listener() {
  document.querySelectorAll('.remove_variable').forEach(
      remove_btn => remove_btn.addEventListener('click', e => e.target.closest('tr').remove()))
}

add_btn.addEventListener('click', () => {
  const new_row = table.insertRow(-1), variable = new_row.insertCell(0),
        variable_initial_value = new_row.insertCell(1), remove_btn = new_row.insertCell(2)

  variable.innerHTML = `<input multiple='multiple' type='text' name='scenario[variables][]' class='form-control'>`
  variable_initial_value.innerHTML = `<input multiple='multiple' type='number' name='scenario[variable_initial_values][]' class='form-control'>`
  remove_btn.innerHTML = `<button type="button" class="btn btn-sm btn-danger remove_variable">Remove</button>`

  add_remove_listener()
})

form.addEventListener('submit', e => {
  if (parseInt(attempt_count.value) > 0 && (initial_variables !== get_variables() || initial_values !== get_values())) {
    if (!confirm(warning_message)) {
      e.preventDefault()
      return false
    }
  }

  return true
})

add_remove_listener()
