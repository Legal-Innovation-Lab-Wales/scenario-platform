const table = document.getElementById('variables')
const scenario_form = document.getElementById('scenario_form')
const add_btn = document.getElementById('add_variable')
const attempt_count = document.getElementById('attempt_count')
const initial_variables = get_variables()
const initial_values = get_values()
const warning_message = `Warning! You are changing the variables for a scenario that has past attempts.\r\n
Changing these variables will not affect the scores of these past attempts but it will affect the score for all future attempts.\r\n
If you are aware of this outcome and happy to proceed click OK below.`

const end_scenario_button = document.getElementById('end_scenario_button')
const next_question_order_container = document.getElementById('next_question_order_container')
const end_scenario_answer = `<div id="end_scenario_answer"><input value="-1" type="hidden" name="answer[next_question_order]" id="answer_next_question_order"></div>`
const next_question_order = `<div class="field mb-3" id="next_question_order"><label class="form-label" for="answer_next_question_order">Next question order</label><input class="form-control" type="number" name="answer[next_question_order]" id="answer_next_question_order"></div>`

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

if (add_btn !== null) {
    add_btn.addEventListener('click', () => {
        const new_row = table.insertRow(-1), variable = new_row.insertCell(0),
            variable_initial_value = new_row.insertCell(1), remove_btn = new_row.insertCell(2)

        variable.innerHTML = `<input multiple='multiple' type='text' name='scenario[variables][]' class='form-control'>`
        variable_initial_value.innerHTML = `<input multiple='multiple' type='number' name='scenario[variable_initial_values][]' class='form-control'>`
        remove_btn.innerHTML = `<button type="button" class="btn btn-sm btn-danger remove_variable">Remove</button>`

        add_remove_listener()
    })
}

if (scenario_form !== null) {
    scenario_form.addEventListener('submit', e => {
        if (parseInt(attempt_count.value) > 0 && (initial_variables !== get_variables() || initial_values !== get_values())) {
            if (!confirm(warning_message)) {
                e.preventDefault()
                return false
            }
        }

        return true
    })
}

if (end_scenario_button !== null) {
    if (document.getElementById('answer_next_question_order').value === "-1") {
        // remove #next_question_order
        document.getElementById('next_question_order').remove()
        // add #end_scenario_answer
        document.getElementById('next_question_order_container').insertAdjacentHTML('beforebegin', end_scenario_answer)
        // button styling
        end_scenario_button.classList.remove('btn-sm', 'btn-outline-warning')
        end_scenario_button.classList.add('btn-warning')
        document.getElementById('end_of_quiz_icon').innerHTML = `<i class="fas fa-check"></i>`
    }
    end_scenario_button.addEventListener('click', () => {
        if (document.getElementById('next_question_order') !== null) {
            // remove #next_question_order
            document.getElementById('next_question_order').remove()
            // add #end_scenario_answer
            document.getElementById('next_question_order_container').insertAdjacentHTML('beforebegin', end_scenario_answer)
            // button styling
            end_scenario_button.classList.remove('btn-sm', 'btn-outline-warning')
            end_scenario_button.classList.add('btn-warning')
            document.getElementById('end_of_quiz_icon').innerHTML = `<i class="fas fa-check"></i>`
        }
        else if (document.getElementById('end_scenario_answer') !== null) {
            // add #next_question_order
            document.getElementById('end_scenario_answer').remove()
            // remove #end_scenario_answer
            document.getElementById('next_question_order_container').insertAdjacentHTML('beforebegin', next_question_order )
            // button styling
            end_scenario_button.classList.remove('btn-warning')
            end_scenario_button.classList.add('btn-sm', 'btn-outline-warning')
            document.getElementById('end_of_quiz_icon').innerHTML = `<i class="fas fa-times"></i>`
        }
    })
}

add_remove_listener()
