window.addEventListener('DOMContentLoaded', () => {
  const alerts = document.querySelectorAll('div.alert');

  alerts.forEach(alert => {
    setTimeout(() => {
      alert.remove();
    }, 5000)
  })
})