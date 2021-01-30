
$('#add_variable').on('click', add_variable_input);
$('#remove_variable').on('click', remove_variable_input);

function add_variable_input() {
    var new_var_no = parseInt($('#total_vars').val()) + 1;
    var new_var_input = "<span id='variable-" + new_var_no +
        "'><input multiple='multiple' type='text' name='quiz[variables][]'></span>";
    $('#variables').append(new_var_input);
    $('#total_vars').val(new_var_no);

    var new_val_no = parseInt($('#total_vals').val()) + 1;
    var new_val_input = "<span id='initial_value-" + new_val_no +
        "'><input multiple='multiple' type='text' name='quiz[variable_initial_values][]'></span>";
    $('#initial_values').append(new_val_input);
    $('#total_vals').val(new_val_no);
}

function remove_variable_input() {
    var last_var_no = $('#total_vars').val();

    if (last_var_no > 1) {
        $('#variable-' + last_var_no).remove();
        $('#total_vars').val(last_var_no - 1);
    }

    var last_val_no = $('#total_vals').val();

    if (last_val_no > 1) {
        $('#initial_value-' + last_val_no).remove();
        $('#total_vals').val(last_val_no - 1);
    }
}
