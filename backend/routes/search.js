import express from 'express';
import Spot from '../models/Spot.js';
import fetch from 'node-fetch';

const router = express.Router();

// spotsearch
router.get('/', async (req, res) => {
    
    const q = req.query.q;
    
    if (!q) return res.status(400).json({ error: 'Fehlender Suchbegriff' });

    try {

        const spots = await Spot.find({
            name: { $regex: q, $options: 'i' }
        }).limit(10);

    } catch (err) {
        
        res.status(500).json({ error: 'Fehler bei der Suche' });

    }

});


// adresssearch
router.get('/geo', async (req, res) => {

    const q = req.query.q;

    if (!q) return res.status(400).json({ error: 'Fehlender Suchbegriff' });

    try {
        
        const response = await fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(q)}`);
        const data = await response.json();
        res.json(data);

    } catch (err) {
        
        res.status(500).json({ error: 'Fehler bei der Geosuche'});

    }

});


export default router;