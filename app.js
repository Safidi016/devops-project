const express = require('express');
const path = require('path');
const app = express();

const promClient = require('prom-client');
const register = new promClient.Registry();



// Servir les fichiers statiques
app.use(express.static(path.join(__dirname, 'public')));

// Health check
app.get('/health', (req, res) => res.send('OK'));

module.exports = app;

// Démarrage du serveur uniquement si on ne sommes pas en mode test
if (require.main === module) {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
}



// Métriques par défaut
promClient.collectDefaultMetrics({ register });

// Route /metrics
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});