// models/Collection.js

import mongoose from 'mongoose';

// helper spot schema
const spotRefSchema = new mongoose.Schema({

    spot: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Spot',
        required: true
    },

    addedAt: {
        type: Date,
        default: Date.now,
    },

});


// collection schema
const collectionSchema = new mongoose.Schema({

    title: {
        type: String,
        required: true
    },

    description: {
        type: String,
    },

    spots: [spotRefSchema],

    createdBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },

    createdAt: {
        type: Date,
        default: Date.now,
    },

});

export default mongoose.model('Collection', collectionSchema);