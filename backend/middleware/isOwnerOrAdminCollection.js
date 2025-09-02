// middleware/isOwnerOrAdminCollection.js

import Collection from '../models/Collection.js';

const isOwnerOrAdminCollection = async (req, res, next) => {

    try {
        
        const collection = await Collection.findById(req.params.collectionId);

        if (!collection) {
            return res.status(404).json({ error: 'Collection not found' });
        }

        if (collection.createdBy.toString() !== req.user._id.toString() && req.user.role !== 'admin') {
            return res.status(403).json({ message: 'not authorized' });
        }

        next();

    } catch (error) {
        
        console.error(error);
        res.status(500).json({ error: 'Server error' });

    }

}

export default isOwnerOrAdminCollection;