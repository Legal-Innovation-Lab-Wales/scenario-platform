const name = document.querySelector('#organisation input')
let org_name = name.value
const icon = document.querySelector('#organisation i')

function toggleName(disabled) {
  name.disabled = disabled
  icon.classList.remove(disabled ? 'fa-check-square' : 'fa-edit')
  icon.classList.add(disabled ? 'fa-edit' : 'fa-check-square')
}

function updateOrgName() {
  fetch(`/admin/organisation?name=${encodeURIComponent(name.value)}`, {
    method: 'put'
  }).then(response => {
    if (response.ok) {
      name.classList.remove('is-invalid')
      org_name = name.value
      toggleName(true)
    } else {
      name.classList.add('is-invalid')
    }
  })
}

icon.addEventListener('click', () => !name.disabled ? updateOrgName() : toggleName(false));

name.addEventListener('keyup', e => {
  if (e.key === 'Enter') {
    updateOrgName()
  } else if (e.key === 'Escape') {
    name.value = org_name
    toggleName(true)
  }
})