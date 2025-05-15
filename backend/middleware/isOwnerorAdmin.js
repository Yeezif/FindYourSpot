// middleware/isOwnerOrAdmin.js

import Spot from '../models/Spot.js'

const isOwnerOrAdmin = async (req, res, next) => {
    
    try {
        
        const spot = await Spot.findById(req.params.id)

        if (!spot) {
            return res.status(404).json({ message: 'Spot nicht gefunden' })
        }

        if (spot.createdBy.toString() !== req.user._id.toString() && req.user.role !== 'admin') {
            return res.status(403).json({ message: 'Zugriff verweigert' })
        }

        next()

    } catch (error) {
        
        console.error(error)
        res.status(500).json({ message: 'Serverfehler bei Rechteprüfung' })

    }

}

export default isOwnerOrAdmin