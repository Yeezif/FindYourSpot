// routes/spots.js

import express from 'express'
import Spot from '../models/Spot.js'
import verifyToken from '../middleware/verifyToken.js'
import isAdmin from '../middleware/isAdmin.js'
import isOwnerOrAdmin from '../middleware/isOwnerorAdmin.js'
// import { verify } from 'jsonwebtoken'
import { validateFields } from '../middleware/validateFields.js'
import upload from '../middleware/upload.js'

const router = express.Router()

// GET /api/spots → alle Spots holen
router.get('/', async (req, res) => {
    try {
        const spots = await Spot.find()
        res.json(spots)
    } catch (error) {
        res.status(500).json({ error: 'Fehler beim Laden der Spots' })
    }
})


// POST /api/spots → neuen Spot erstellen
router.post('/', verifyToken, validateFields(['title', 'location']), async (req, res) => {

// console.log('📦 Request-Body:', req.body) ---- für debugging

    try {
        const { title, description, location } = req.body
        const newSpot = new Spot({
            title,
            description,
            location,
            createdBy: req.user._id
        })

        await newSpot.save()
        res.status(201).json(newSpot)
    } catch (err) {
        console.error(err)
        res.status(400).json({ error: 'Fehler beim Erstellen des Spots' })
    }
})


// GET /api/spots/:id → Spot mit bestimmter ID holen
router.get('/:id', async (req, res) => {
    try {
        const spot = await Spot.findById(req.params.id)

        if (!spot) {
            return res.status(404).json({ error: 'Spot nicht gefunden' })
        }

        res.json(spot)
    } catch (err) {
        res.status(500).json({ error: 'Fehler beim Abrufen des Spots' })
    }
})


// DELETE /api/spots/:id - Spot löschen
router.delete('/:id', verifyToken, isOwnerOrAdmin, async (req, res) => {
  
    try {
      
        const spot = await Spot.findById(req.params.id)

        if (!spot) {
            return res.status(404).json({ message: 'Spot nicht gefunden' })
        }

        if (spot) {
            await Spot.findByIdAndDelete(req.params.id)
            return res.status(200).json({ message: 'Spot erfolgreich gelöscht' })
        }

    } catch (error) {
      
        res.status(500).json({ message: 'Fehler beim Löschen des Spots' })

    }

})


// PUT /api/spots/:id - Spot bearbeiten
router.put('/:id', verifyToken, isOwnerOrAdmin, validateFields(['title', 'location']), async (req, res) => {
  
    try {
      
        const spot = await Spot.findById(req.params.id)

        if (!spot) {
            return res.status(404).json({ message: 'Spot nicht gefunden' })
        }

        // update spot
        const updatedSpot = await Spot.findByIdAndUpdate(

            req.params.id,
            { $set: req.body },
            { new: true }

        )

        res.status(200).json(updatedSpot)

    } catch (error) {
      
        console.log(error)
        res.status(500).json({ message: 'Fehler beim Aktualisieren des Spots' })

    }

})


// UPVOTES / DOWNVOTES


// PUT /api/spots/:spotId/upvote - Spot upvoten
router.put('/:spotId/upvote', verifyToken, async (req, res) => {

    try {
        
        const spot = await Spot.findById(req.params.spotId)

        if (!spot) {
            return res.status(404).json({ message: 'Spot nicht gefunden' })
        }

        // if downvoted, push to upvoted array
        // if upvoted, remove from upvoted array
        // if unvoted, push to upvoted array
        if (spot.downvotes.includes(req.user._id)) {

            spot.downvotes = spot.downvotes.filter(userId => userId.toString() !== req.user._id.toString())
            spot.upvotes.push(req.user._id)

        } else if (spot.upvotes.includes(req.user._id)) {

            spot.upvotes = spot.upvotes.filter(userId => userId.toString() !== req.user._id.toString())
        
        } else {

            spot.upvotes.push(req.user._id)

        }

        // Spot Rating from 0 to 1
        spot.rating = spot.upvotes.length / (spot.upvotes.length + spot.downvotes.length)   

        await spot.save()

        res.status(200).json(spot)        

    } catch (error) {
        
        console.error(error)
        res.status(500).json({ message: 'Fehler beim Upvoten des Spots' })

    }

})



// PUT /api/spots/:spotId/downvote - Spot downvoten
router.put('/:spotId/downvote', verifyToken, async (req, res) => {

    try {
        
        const spot = await Spot.findById(req.params.spotId)

        if (!spot) {
            res.status(404).json({ message: 'Spot nicht gefunden' })
        }

        if (spot.upvotes.includes(req.user._id)) {
            
            spot.upvotes = spot.upvotes.filter(userId => userId.toString() !== req.user._id.toString())
            spot.downvotes.push(req.user._id)

        } else if (spot.downvotes.includes(req.user._id)) {
            
            spot.downvotes = spot.downvotes.filter(userId => userId.toString() !== req.user._id.toString())

        } else {

            spot.downvotes.push(req.user._id)

        }

        // Spot Rating from 0 to 1
        spot.rating = spot.upvotes.length / (spot.upvotes.length + spot.downvotes.length)

        await spot.save()

        res.status(200).json(spot)

    } catch (error) {
        
        console.error(error)
        res.status(500).json({ message: 'Fehler beim downvoten des Spots' })

    }
    
})


// PICTURE UPLOAD


// POST /api/spots/:id/images - Bild hochladen
router.post('/:id/images', verifyToken, upload.array('images', 5), async (req, res) => {

    try {
        
        const spot = await Spot.findById(req.params.id)

        if (!spot) {
            res.status(404).json({ message: 'Spot nicht gefunden'})
        }

        if (!req.files || req.files.length === 0) {
            return res.status(400).json({ message: 'Kein Bild zum Hochladen angegeben' })            
        }

        // Bilder zu Cloudinary hochladen und URLs sammeln
        const imageUrls = []

        for (const file of req.files) {

            const result = await cloudinary.uploader.upload(file.path, {
                folder: 'spots_images'
            })

            imageUrls.push(result.secure_url)

        }
        

        // Bild zur Spot-Datenbank hinzufügen
        spot.images.push(...imageUrls)
        await spot.save()

        res.status(201).json(spot)

    } catch (error) {
        
        console.error(error)
        res.status(500).json({ message: 'Fehler beim Hochladen des Bildes' })

    }

})


export default router
