import mongoose from 'mongoose'

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI)
    console.log('✅ MongoDB verbunden')
  } catch (err) {
    console.error('❌ DB-Verbindung fehlgeschlagen:', err)
    process.exit(1)
  }
}

export default connectDB