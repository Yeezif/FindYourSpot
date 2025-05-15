// routes/comments.js

import express from 'express'
import Comment from '../models/Comment.js'
import verifyToken from '../middleware/verifyToken.js'
import isOwnerOrAdmin from '../middleware/isOwnerorAdmin.js'

const router = express.Router()



// GET /api/spots/:spotId/comments - Alle Kommentare für einen Spot abrufen
router.get('/:spotId/comments', async (req, res) => {

    try {
        
        const comments = await Comment.find({ spot: req.params.spotId }).populate('createdBy', 'username email').populate('spot', 'title')
        res.json(comments)

    } catch (error) {
        
        res.status(500).json({ message: 'Fehler beim Abrufen der Kommentare' })

    }
    
})



// POST /api/spots/:spotId/comments - Kommentar für einen Spot erstellen
router.post('/:spotId/comments', verifyToken, async (req, res) => {
    
    try {
        
        const { text } = req.body
        const newComment = new Comment({
            text,
            createdBy: req.user._id,
            spot: req.params.spotId
        })

        await newComment.save()
        await Spot.findByIdAndUpdate(req.params.spotId, { $push: { comments: newComment._id } })
        res.status(201).json(newComment)

    } catch (error) {
        
        res.status(400).json({ message: 'Fehler beim Erstellen des Kommentars' })

    }

})



// PUT /api/comments/:commentId - Kommentar bearbeiten
router.put('/:commentId', verifyToken, isOwnerOrAdmin, async (req, res) => {
    
    try {
        
        const { text } = req.body

        // find comment by id
        const comment = await Comment.findById(req.params.commentId)

        if (!comment) {
            return res.status(404).json({ message: 'Kommentar nicht gefunden' })
        }

        // update comment
        comment.text = text || comment.text
        await comment.save()

        res.status(200).json(comment)

    } catch (error) {
        
        console.error(error)
        res.status(500).json({ message: 'Fehler beim Bearbeiten des Kommentars' })

    }

})



// DELETE /api/comments/:commentId - Kommentar löschen
router.delete('/:commentId', verifyToken, isOwnerOrAdmin, async (req, res) => {

    try {
        
        const comment = await Comment.findById(req.params.commentId)

        if (!comment) {
            return res.status(404).json({ message: 'Kommentar nicht gefunden '})
        }

        if (comment.createdBy.toString() !== req.user._id.toString()) {
            return res.status(403).json({ message: 'Nicht berechtigt, diesen Kommentar zu löschen'})
        }

        await comment.remove()
        res.status(200).json({ message: 'Kommentar gelöscht' })

    } catch (error) {
        
        res.status(500).json({ message: 'Fehler beim Löschen des Kommentars' })

    }
    
})



export default router