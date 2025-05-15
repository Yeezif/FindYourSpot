// models/User.js

import mongoose from 'mongoose'
import bcrypt from 'bcrypt'

const userSchema = new mongoose.Schema({

    username: {
        type: String,
        required: true,
        unique: true
    },

    email: {
        type: String,
        required: true,
        unique: true,
        lowercase: true
    },

    password: {
        type: String,
        required: true
    },

    role: {
        type: String,
        enum: ['user', 'admin'],
        default: 'user',
    },

    createdAt: {
        type: Date,
        default: Date.now
    }

})

// Password Hash before save
userSchema.pre('save', async function (next) {

    if (!this.isModified('password')) return (next)
    this.password = await bcrypt.hash(this.password, 10)
    next()
    
})

// password comparison
userSchema.methods.comparePassword = function (candidatePassword) {

    return bcrypt.compare(candidatePassword, this.password)

}

const User = mongoose.model('User', userSchema)

export default User