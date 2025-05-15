const express = require('express')
const dotenv = require('dotenv')
const mongoose = require('mongoose');

const { connectDB } = require('./config/db')
// import spotRoutes from './routes/spots.js'
// import userRoutes from './routes/users.js'
// import commentRoutes from './routes/comments.js'

// Umgebungsvariablen laden
dotenv.config()

// Express-Anwendung erstellen
const app = express()

async function main() {
  // // Middleware
  // app.use(express.json())

  // Verbindung zu MongoDB herstellen
  await connectDB()

  const db = mongoose.connection;
  db.on('error', console.error.bind(console, 'MongoDB-Verbindungsfehler:'));
  db.once('open', () => {
    console.log('MongoDB verbunden');
  });

  // Modell ohne festes Schema
  const TestModel = mongoose.model('test', new mongoose.Schema({}, { strict: false }));

  // Route: Alle Dokumente abrufen
  app.get('', async (req, res) => {
    const collections = await mongoose.connection.db.listCollections().toArray();
    // console.log("test")
    res.json(collections);
    // try {
    //   const daten = await TestModel.find(); // Alle Einträge aus 'test' Collection
    //   console.log(daten)
    //   res.json(daten);
    // } catch (err) {
    //   console.error('Fehler beim Abrufen der Daten:', err);
    //   res.status(500).json({ error: 'Interner Serverfehler' });
    // }
  });


  // // Routen hinzufügen
  // app.use('/api/users', userRoutes)
  // app.use('/api/spots', spotRoutes)
  // app.use('/api/comments', commentRoutes)

  // Server starten auf Port 5000
  app.listen(3000, () => {
    console.log('🚀 Server läuft auf http://localhost:3000')
  })
}

main()


