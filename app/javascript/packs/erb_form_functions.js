$('#add_variable').on('click', () => {
  $('#variables').append(
    `<tr>
      <td>
        <input multiple='multiple' type='text' name='scenario[variables][]' class='form-control'>
      </td>
      <td>
        <input multiple='multiple' type='number' name='scenario[variable_initial_values][]' class='form-control'>
      </td>
      <td>
        <button type="button" class="btn btn-sm btn-danger remove_variable">Remove</button>
      </td>
    </tr>`
  )

  $('.remove_variable').on('click', e => e.target.closest('tr').remove())
})
$('.remove_variable').on('click', e => e.target.closest('tr').remove())

function get_variables() {
  return JSON.stringify([...document.getElementsByName('scenario[variables][]')].map(variable => variable.value))
}

function get_values() {
  return JSON.stringify([...document.getElementsByName('scenario[variables][]')].map(variable => variable.value))
}

const initial_variables = get_variables()
const initial_values = get_values()

$("#scenario_form").submit(function(e) {
  e.preventDefault();

  const attempt_count = parseInt($('#attempt_count').val())

  if (attempt_count > 0 && (initial_variables !== get_variables() || initial_values !== get_values())) {
    if (confirm(`Warning! You are changing the variables for a scenario that has past attempts.\r\n
Changing these variables will not affect the scores of these past attempts but it will affect the score for all future attempts.\r\n
If you are aware of this outcome and happy to proceed click OK below.`)) {
      this.submit()
    } else {
      return false
    }
  } else {
    this.submit()
  }
})