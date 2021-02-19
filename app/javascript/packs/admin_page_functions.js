const name = document.querySelector('#organisation input')
let org_name = name.value
const icon = document.querySelector('#organisation i')

function toggleName(disabled) {
  name.disabled = disabled
  icon.classList.remove(disabled ? 'fa-check-square' : 'fa-edit')
  icon.classList.add(disabled ? 'fa-edit' : 'fa-check-square')

  if (disabled) {
    name.classList.remove('is-invalid')
    name.blur()
  } else {
    name.value = ''
    name.focus()
  }
}

function updateOrgName() {
  if (name.value !== org_name) {
    fetch(`/admin/organisation?name=${encodeURIComponent(name.value)}`, {
      method: 'put'
    }).then(response => {
      if (response.ok) {
        org_name = name.value
        toggleName(true)
      } else {
        name.classList.add('is-invalid')
      }
    })
  } else {
    toggleName(true)
  }
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

const requested_users = document.querySelector('#requested-users')

if (requested_users) {
  const main_checkbox = requested_users.querySelector('#main-checkbox');
  const user_checkboxes = requested_users.querySelectorAll('.user-checkbox');

  main_checkbox.addEventListener('change', () => {
    user_checkboxes.forEach(checkbox => {
      checkbox.checked = main_checkbox.checked
    })
  })

  const approve_btn = requested_users.querySelector('button#approve')

  approve_btn.addEventListener('click', () => {
    const approved_users = []

    user_checkboxes.forEach(checkbox => {
      if (checkbox.checked) {
        approved_users.push(parseInt(checkbox.closest('tr').querySelector('.hidden').innerText))
      }
    })

    if (approved_users.length > 0) {
      const updates = []

      approved_users.forEach(user => {
        updates.push(fetch(`/admin/users/${user}/approve`, {method: 'put'}))
      })

      Promise.all(updates).then(values => {
        values.forEach(value => {
          if (value.ok) location.reload()
        })
      })
    }
  })
}

const admin_markers = document.querySelectorAll('i.admin-marker')

admin_markers.forEach(marker => {
  marker.addEventListener('click', () => {
    const user = parseInt(marker.closest('tr').querySelector('.hidden').innerText)

    fetch(`/admin/users/${user}/admin`, {
      method: 'put'
    }).then(response => {
      if (response.ok) location.reload()
    })
  })
})