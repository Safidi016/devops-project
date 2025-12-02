function showMessage(type) {
  const msg = document.getElementById('message');
  msg.classList.remove('hidden');
  msg.textContent = `Vous avez sélectionné : ${type} (simulation)`;
}

