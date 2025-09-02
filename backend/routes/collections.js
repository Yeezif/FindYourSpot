// routes/collections.js

import express from 'express';
import verifyToken from '../middleware/verifyToken.js';

import Collection from '../models/Collection.js';
import isCollectionOwnerOrAdmin from '../middleware/isCollectionOwnerOrAdmin.js';

const router = express.Router();



// CREATE COLLECTION

// POST /api/collections
router.post('/', verifyToken, async (req, res) => {

    try {
        
        const userId = req.user._id;
        const newCollection = new Collection({
            ...req.body,
            createdBy: userId,
        });

        await newCollection.save();
        res.status(201).json(newCollection);

    } catch (error) {
        
        console.error(error);
        res.status(500).json({ error: 'Server error' });

    }

});



// GET ALL COLLECTIONS OF LOGGIN IN USER

// GET /api/collections
router.get('/', verifyToken, async (req, res) => {
    
    try {
        
        const collections = await Collection.find({ createdBy: req.user._id });
        res.json(collections);

    } catch (error) {

        console.error(error);
        res.status(500).json({ error: 'Server error' });

    }

});



// GET ALL COLLECTIONS OF USER BY ID

// GET /api/users/:userId/collections
// related code in /routes/users.js



// GET COLLECTION BY ID

// GET /api/collections/:collectionId
router.get('/:collectionId', verifyToken, async (req, res) => {

    try {
        
        const { collectionId } = req.params;
        const collection = await Collection.findById(collectionId)
                            .populate('spots')
                            .populate('createdBy', 'username');

        if (!collection) {
            return res.status(404).json({ error: 'Collection not found' });
        }

        res.json(collection);

    } catch (error) {
        
        console.error(error);
        res.status(500).json({ error: 'Server error' });

    }
    
});



// ADD SPOT TO COLLECTION

// PUT /api/collections/:collectionId
router.put('/:collectionId', verifyToken, isCollectionOwnerOrAdmin, async (req, res) => {

    try {
        
        const { collectionId } = req.params;
        const { spotId } = req.body;

        const collection = await Collection.findById(collectionId);

        if (!collection) {
            return res.status(404).json({ error: 'Collection not found' });
        }

        if (!collection.spots.includes(spotId)) {
            collection.spots.push(spotId);

            await collection.save();
            return res.json(collection);
        }
        res.status(409).json({ error: 'Spot already in collection' });        

    } catch (error) {
     
        console.error(error);
        res.status(500).json({ error: 'Server error' });

    }

});



// DELETE COLLECTION

// DELETE /api/collections/:collectionId
router.delete('/:collectionId', verifyToken, isCollectionOwnerOrAdmin, async (req, res) => {

    try {
        
        const { collectionId } = req.params;
        
        const collection = await Collection.findById(collectionId);
        if (!collection) {
            return res.status(404).json({ error: 'Collection not found' });
        }

        await collection.deleteOne();
        res.json({ message: 'Collection deleted successfully' });

    } catch (error) {
        
        console.error(error);
        res.status(500).json({ error: 'Server error' });

    }

});



// DELETE SPOT FROM COLLECTION

// DELETE /api/collections/:collectionId/spots/:spotId
router.delete('/:collectionId/spots/:spotId', verifyToken, isCollectionOwnerOrAdmin, async (req, res) => {

    try {
        
        const { collectionId, spotId } = req.params;

        const collection = await Collection.findById(collectionId);
        if (!collection) {
            return res.status(404).json({ error: 'Collection not found' });
        }

        if (!collection.spots.includes(spotId)) {
            return res.status(409).json({ error: 'Spot not in collection' });
        }
        collection.spots.pull(spotId);

        await collection.save();
        res.json(collection);

    } catch (error) {
        
        console.error(error);
        res.status(500).json({ error: 'Server error' });

    }

});