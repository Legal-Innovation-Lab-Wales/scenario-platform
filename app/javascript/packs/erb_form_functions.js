
$('#add_variable').on('click', add_variable_input);
$('#remove_variable').on('click', remove_variable_input);

function add_variable_input() {
    var new_var_no = parseInt($('#total_vars').val()) + 1;
    var new_input = "<tr id='variable-" + new_var_no +
        "'><td><input multiple='multiple' type='text' name='scenario[variables][]' class='form-control'></td>" +
        "<td><input multiple='multiple' type='number' name='scenario[variable_initial_values][]' class='form-control'></td></tr>" ;

    $('#variables').append(new_input);

    $('#total_vars').val(new_var_no);

}

function remove_variable_input() {
    var last_var_no = $('#total_vars').val();

    if (last_var_no > 1) {
        $('#variable-' + last_var_no).remove();
        $('#total_vars').val(last_var_no - 1);
    }

}

function get_variables() {
    return [...document.getElementsByName('scenario[variables][]')].map(variable => variable.value)
}

function get_values() {
    return [...document.getElementsByName('scenario[variable_initial_values][]')].map(value => value.value)
}

const initial_variables = get_variables()
const initial_values = get_values()

$("#scenario-form").submit(function(e) {
    e.preventDefault();

    if ((initial_variables.length > 0 || initial_values.length > 0) &&
        (initial_variables !== get_variables() || initial_values !==  get_values())) {
        console.log('Initial variables and/or values have changed')
    }

    this.submit()
});