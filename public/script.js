function showMessage(type) {
  const msg = document.getElementById('message');
  msg.classList.remove('hidden');
  msg.textContent = `Vous avez sélectionné : ${type} (simulation)`;
}

// Démarrage du serveur uniquement si on ne sommes pas en mode test
if (require.main === module) {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
}