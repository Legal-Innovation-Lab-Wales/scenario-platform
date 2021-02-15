window.addEventListener('DOMContentLoaded', () => {
  const alerts = document.querySelectorAll('section.alert');

  alerts.forEach(alert => {
    setTimeout(() => {
      alert.remove();
    }, 5000)
  })
})