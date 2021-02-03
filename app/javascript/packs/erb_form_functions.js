
$('#add_variable').on('click', add_variable_input);
$('#remove_variable').on('click', remove_variable_input);

function add_variable_input() {
    var new_var_no = parseInt($('#total_vars').val()) + 1;
    var new_input = "<tr id='variable-" + new_var_no +
        "'><td><input multiple='multiple' type='text' name='quiz[variables][]'></td>" +
        "<td><input multiple='multiple' type='text' name='quiz[variable_initial_values][]'></td></tr>" ;

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
