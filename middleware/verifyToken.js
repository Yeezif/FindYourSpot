// middleware/verifyToken.js

import jwt from'jsonwebtoken'
import User from '../models/User.js'

const verifyToken = async (req, res, next) => {

    try {    
        const token = req.header('Authorization')?.split(' ')[1]

        if (!token) {
            return res.status(401).json({ message: 'Kein Token, Zugriff verweigert' })
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET)
        const user = await User.findById(decoded.id)

        if (!user) {
            return res.status(404).json({ message: 'Benutzer nicht gefunden'})
        }

        req.user = user
        next()
    
    } catch (error) {

        console.error(error)
        res.status(401).json({ message: 'Ungültiges Token' })

    }

}

export default verifyToken