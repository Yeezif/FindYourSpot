// models/Collection.js

import mongoose from 'mongoose';

const collectionSchema = new mongoose.Schema({

    title: {
        type: String,
        required: true
    },

    description: {
        type: String,
    },

    spots: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Spot',
        addedAt: {
            type: Date,
            default: Date.now,
        }
    }],

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