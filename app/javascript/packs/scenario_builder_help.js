document.querySelectorAll('.question_help_button').forEach(item => {
    item.addEventListener('click', () => {
        document.getElementById((item.id.replace('_help_button', ''))).classList.toggle('help')
    })
})