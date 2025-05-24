// routes/users.js

import express from 'express'
import jwt from 'jsonwebtoken'
import User from '../models/User.js'

const router = express.Router()

// LOGIN
// POST /api/users/login
router.post('/login', async (req, res) => {
    
    try {
        
        const { email, password } = req.body

        // find user by email
        const user = await User.findOne({ email })

        if (!user) {
            return res.status(401).json({ error: 'E-Mail oder Passwort ungültig' })
        }

        
        // compare password
        const isMatch = await user.comparePassword(password)

        if (!isMatch) {
            return res.status(401).json({ error: 'E-Mail oder Passwort ungültig' })
        }


        // create token
        const token = jwt.sign(

            {
                id: user._id,
                username: user.username,
                role: user.role
            },

            process.env.JWT_SECRET,
            { expiresIn: '7d' }

        )


        // send token to client
        res.json({ 

            message: 'Login erfolgreich',
            token: token
        
        })




    } catch (error) {
        
        console.error(error)
        res.status(500).json({ error: 'Serverfehler beim Login'})

    }

})

// REGISTRATION
// POST /api/users/register
router.post('/register', async (req, res) => {
    
    try {
        
        const { username, email, password } = req.body

        const userExists = await User.findOne({ email })

        if (userExists) {
            return res.status(400).json({ message: 'Benutzer existiert bereits' })
        }

        const user = new User({ username, email, password })
        await user.save()

        res.status(201).json({

            _id: user._id,
            username: user.username,
            email: user.email
            

        })

    } catch (error) {
        
        console.error(error)
        res.status(500).json({ message: 'Fehler bei der Registrierung' })

    }

})

export default router