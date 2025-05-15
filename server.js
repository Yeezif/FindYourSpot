import express from 'express'
import dotenv from 'dotenv'
import connectDB from './config/db.js'
import spotRoutes from './routes/spots.js'
import userRoutes from './routes/users.js'
import commentRoutes from './routes/comments.js'

// Umgebungsvariablen laden
dotenv.config()

// Express-Anwendung erstellen
const app = express()

// Middleware
app.use(express.json())

// Verbindung zu MongoDB herstellen
connectDB()

// Routen hinzufügen
app.use('/api/users', userRoutes)
app.use('/api/spots', spotRoutes)
app.use('/api/comments', commentRoutes)

// Standard Route
app.get('/', (req, res) => {
  res.send('API läuft!')
})

// Server starten auf Port 5000
app.listen(5000, () => {
  console.log('🚀 Server läuft auf http://localhost:5000')
})
